#!/usr/bin/env python

import os, sys, cgi, argparse
from StringIO import StringIO
from subprocess import call
from tempfile import *
from shutil import *
from zipfile import *

from xym import xym
import pyang
from bottle import route, run, template, request, static_file, error
import json
import xml.etree.ElementTree as ET
import bottle


# requests.packages.urllib3.disable_warnings()

__author__ = 'sunseawq@gmail.com'
__copyright__ = "Copyright (c) 2015, Qin Wu, sunseawq@huawei.com"
__license__ = "New-style Windows 7"
__email__ = "bill.wu@huawei.com"
__version__ = "0.2.1"

# pyangcmd = '/usr/local/bin/pyang'
# yang_import_dir = '/opt/local/share/yang'

# pyangcmd = 'C:\\pyang-master\\bin\\pyang'
pyangcmd = 'pyang'
yang_import_dir = 'C:\\pyang-master\\modules\\ietf'

versions = {"pyang_version": __version__, "xym_version": __version__}

debug = False


def xml_indent(elem, level=0):
    i = "\n" + level * "  "
    if len(elem):
        if not elem.text or not elem.text.strip():
            elem.text = i + "  "
        for e in elem:
            xml_indent(e, level + 1)
        if not e.tail or not e.tail.strip():
            e.tail = i
    if level and (not elem.tail or not elem.tail.strip()):
        elem.tail = i
    return elem


def create_output(url):
    workdir = mkdtemp()
    results = {}

    result = StringIO()

    # Trickery to capture stderr from the xym tools for later use
    stderr_ = sys.stderr
    sys.stderr = result
    #url = "c:\\users\\hwx180~1\\appdata\\local\\temp\\tmpwh8emt\\draft-kumar-lime-yang-connectionless-oam-03.txt"

    extracted_models = xym.xym(source_id=url, dstdir=workdir, srcdir="", strict=True, strict_examples=False,
                               debug_level=0)
    sys.stderr = stderr_
    xym_stderr = result.getvalue()

    emsave = ""
    for em in extracted_models:
        pyang_stderr, pyang_output = validate_yangfile(em, workdir)
        pyOutput = cgi.escape(pyang_output)
        splitStr = ""
        if ("\n" in pyOutput):
            splitStr = "}\n&lt;"
        else:
            splitStr = "}&lt;"
        outputList = pyOutput.split(splitStr)

        jsonOutputTmp = outputList[0] + "}"
        outputJson = json.loads(jsonOutputTmp)
        jsonOutputTmp = json.dumps(outputJson, indent=2)

        xmlOutputTmp = "&lt;" + outputList[1]
        xmlOutputTmp = xmlOutputTmp.replace("&lt;", "<")
        xmlOutputTmp = xmlOutputTmp.replace("&gt;", ">")
        outputXmlET_tmp = ET.fromstring(xmlOutputTmp)
        outputXmlET = xml_indent(outputXmlET_tmp, 0)
        xmlOutputTmp = ET.tostring(outputXmlET)

        xmlOutputTmp = xmlOutputTmp.replace("<", "&lt;")
        xmlOutputTmp = xmlOutputTmp.replace(">", "&gt;")

        results[em] = {"pyang_stderr": cgi.escape(pyang_stderr),
                       "pyang_output": jsonOutputTmp,
                       "pyang_output1": xmlOutputTmp}

        emsave = em
    # "pyang_output": cgi.escape(pyang_output),
    # "pyang_output1":cgi.escape(pyang_output)


    rmtree(workdir)

    return results, emsave


def validate_yangfile(infilename, workdir):
    pyang_stderr = pyang_output = ""
    infile = os.path.join(workdir, infilename)
    #	print infile
    pyang_outfile = str(os.path.join(workdir, infilename) + '.out')
    #	print pyang_outfile
    pyang_resfile = str(os.path.join(workdir, infilename) + '.res')
    #	print pyang_resfile
    #	print pyangcmd
    #	print yang_import_dir


    resfp = open(pyang_resfile, 'w+')
    #	status = call(['pyang -p c:\pyang-master\modules\ietf -p c:\users\x00165508\appdata\local\temp\tmpxcokqn --ietf -f tree c:\users\x00165508\appdata\local\temp\tmpxcokqn\ietf-interfaces@2014-05-08.yang -o c:\users\x00165508\appdata\local\temp\tmpxcokqn\ietf-interface@2014-05-08.yang.out'], stderr = resfp)
    #	status = call([pyangcmd, '-p', yang_import_dir, '-p', workdir, '--ietf', '-f', 'tree', infile, '-o', pyang_outfile], stderr = resfp)
    #	totallist = [pyangcmd, '-p', yang_import_dir, '-p', workdir, '--ietf', '-f', 'tree', infile, '-o', pyang_outfile]
    #	totalcmd = str(pyangcmd + ' -p ' + yang_import_dir + ' -p ' + workdir + ' --ietf ' + ' -f ' + ' tree ' + infile + ' -o ' + pyang_outfile)
    # For json
    totalcmd = str(
        pyangcmd + ' -f ' + 'module-catalog ' + '--module-catalog-format=json ' + '-o ' + pyang_outfile + ' ' + infile)
    # For xml
    #	totalcmd = str(pyangcmd + ' -f ' + 'module-catalog ' + '--module-catalog-format=xml ' + '-o ' + pyang_outfile + ' ' + infile )
    #	print totalcmd

    os.system(totalcmd)
    #	print pyang_outfile

    if os.path.isfile(pyang_outfile):
        outfp = open(pyang_outfile, 'r')
        pyang_output = str(outfp.read())
    else:
        pass

    resfp.seek(0)

    for line in resfp.readlines():
        pyang_stderr += os.path.basename(line)

    return pyang_stderr, pyang_output

def zipfile_sortkey(file):
    filename = file["file"]
    name, ext = os.path.splitext(filename)
    return ext+name

def catalog_draft(uploadfile):
    results = {}
    savedfiles = []
    savedir = mkdtemp()
    #	print savedir

    # uploaded_file = request.files.get("data")
    #	filepath = os.path.join(savedir, uploaded_file.raw_filename)
    #	print uploaded_file
    #	print uploaded_file.raw_filename
    #	print filepath

    filepath = os.path.join(savedir, os.path.basename(uploadfile.raw_filename))
    print "filepath:\n"+filepath

    uploadfile.save(filepath)
    #	print filepath
    results, em = create_output(filepath)

    rmtree(savedir)

    return results[em]


@route('/')
@route('/validator')
def validator():
    return template('main', results={}, versions=versions)


@route('/draft-validator', method="POST")
def upload_draft():
    results = {}
    savedfiles = []
    savedir = mkdtemp()
    #	print savedir

    uploaded_file = request.files.get("data")
    print "uploaded_file:\n" + str(request.files.get("data"))
    #	filepath = os.path.join(savedir, uploaded_file.raw_filename)
    #	print uploaded_file
    #	print uploaded_file.raw_filename
    #	print filepath

    filepath = os.path.join(savedir, os.path.basename(uploaded_file.raw_filename))
    #	print filepath

    uploaded_file.save(filepath)
    #	print filepath
    results, em = create_output(filepath)

    rmtree(savedir)

    return template('main', results=results, versions=versions)


@route('/validator', method="POST")
def upload_file():
    results = {}
    savedfiles = []
    savedir = mkdtemp()

    uploaded_files = request.files.getlist("data")

    for file in uploaded_files:
        fname = file.filename
        name, ext = os.path.splitext(file.filename)

        if ext == ".yang":
            filepath = os.path.join(savedir, os.path.basename(file.raw_filename))
            file.save(filepath)
            savedfiles.append(file.raw_filename)
        if ext == ".zip":
            zipfilename = os.path.join(savedir, file.filename)
            file.save(zipfilename)
            zf = ZipFile(zipfilename, "r")
            zf.extractall(savedir)
            for filename in zf.namelist():
                savedfiles.append(filename)

    for file in savedfiles:
        name, ext = os.path.splitext(file)

        if ext == ".yang":
            pyang_stderr, pyang_output = validate_yangfile(file, savedir)
            #		    results[file] = { "pyang_stderr": pyang_stderr, "pyang_output": pyang_output }
            pyOutput = cgi.escape(pyang_output)
            splitStr = ""
            if ("\n" in pyOutput):
                splitStr = "}\n&lt;"
            else:
                splitStr = "}&lt;"
            outputList = pyOutput.split(splitStr)

            jsonOutputTmp = outputList[0] + "}"
            outputJson = json.loads(jsonOutputTmp)
            jsonOutputTmp = json.dumps(outputJson, indent=2)

            xmlOutputTmp = "&lt;" + outputList[1]
            xmlOutputTmp = xmlOutputTmp.replace("&lt;", "<")
            xmlOutputTmp = xmlOutputTmp.replace("&gt;", ">")
            outputXmlET_tmp = ET.fromstring(xmlOutputTmp)
            outputXmlET = xml_indent(outputXmlET_tmp, 0)
            xmlOutputTmp = ET.tostring(outputXmlET)

            xmlOutputTmp = xmlOutputTmp.replace("<", "&lt;")
            xmlOutputTmp = xmlOutputTmp.replace(">", "&gt;")

            results[file] = {"pyang_stderr": cgi.escape(pyang_stderr),
                             "pyang_output": jsonOutputTmp,
                             "pyang_output1": xmlOutputTmp}

        if ext == ".txt":
            filecontent = zf.read(file)
            # print "filecontent:\n"+filecontent
            strio = StringIO(filecontent)
            fileupload = bottle.FileUpload(strio, "data", file)
            draftResults = catalog_draft(fileupload)
            results[file] = draftResults

    #print "result[0]:\n" + str(results[0])
    # print cgi.escape(pyang_output)

    resultsArr = []
    for name, content in results.iteritems():
        obj = {"file":name,"content":content}
        resultsArr.append(obj)

    resultsArr.sort(key = zipfile_sortkey)

    # rmtree(savedir)
    return template('main', results=resultsArr, versions=versions)


@route('/api/rfc/<rfc>')
def json_validate_rfc(rfc):
    response = []
    url = 'https://tools.ietf.org/rfc/rfc{!s}.txt'.format(rfc)
    results, emsave = create_output(url)

    resultsArr = []
    for name, content in results.iteritems():
        obj = {"file":name,"content":content}
        resultsArr.append(obj)

    resultsArr.sort(key = zipfile_sortkey)
    #return results
    return template('main', results=resultsArr, versions=versions)


@route('/api/draft/<draft>')
def json_validate_draft(draft):
    response = []
    url = 'http://tools.ietf.org/id/{!s}'.format(draft)
    results = create_output(url)
    return results


@route('/rfc', method='GET')
def validate_rfc_param():
    rfc = request.query['number']
    url = 'https://tools.ietf.org/rfc/rfc{!s}.txt'.format(rfc)
    results = create_output(url)
    return template('result', results=results)


@route('/draft', method='GET')
def validate_rfc_param():
    draft = request.query['name']
    url = 'http://tools.ietf.org/id/{!s}'.format(draft)
    results = create_output(url)
    return template('result', results=results)


@route('/rfc/<rfc>')
def validate_rfc(rfc):
    response = []
    url = 'https://tools.ietf.org/rfc/rfc{!s}.txt'.format(rfc)
    results = create_output(url)
    print "RESULTS", results
    return template('result', results=results)


@route('/draft/<draft>')
def validate_draft(draft):
    response = []
    url = 'http://www.ietf.org/id/{!s}'.format(draft)
    results = create_output(url)
    print "RESULTS", results
    return template('result', results=results)


@route('/static/:path#.+#', name='static')
def static(path):
    return static_file(path, root='static')


@route('/rest')
def rest():
    return (template('rest'))


@route('/about')
def rest():
    return (template('about'))


@route('/versions')
def get_versions():
    return versions


@error(404)
def error404(error):
    return 'Nothing here, sorry.'


if __name__ == '__main__':
    port = 8080

    parser = argparse.ArgumentParser(description='A YANG Module Catalog information extracting web application.')
    parser.add_argument('-p', '--port', dest='port', type=int, help='Port to listen to (default is 8080)')
    parser.add_argument('-d', '--debug', help='Turn on debugging output', action="store_true")
    args = parser.parse_args()

    if args.port:
        port = args.port

    if args.debug:
        debug = True

    run(server='cherrypy', host='0.0.0.0', port=port)
