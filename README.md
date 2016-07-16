# bottle-yang-catalog-extractor
Fetch YANG model Catalog information using REST

This application is written using the Bottle framework using a combination of xym to fetch and extract YANG modules from IETF specifications, and extend pyang plugin to support module catalog extraction and fetch the extracted module catalog information and use RESTful Web application to output module catalog information in either json format and xml format.

Tool  Features include:
   o Support extracting YANG model catalog information based on a individual draft uploaded
   
   o Support extracting YANG model catalog information based on a YANG module file uploaded
   
   o Support extracting YANG model catalog based on a set of YANG module files uploaded or a zip file which include a set   of YANG module files
   
   o Support extracting YANG model catalog information based on URL link to RFC number
   
   o Support extracting YANG model catalog information based on URL link to draft name.
   
Required Software Support:
   o Cherrypy: pythonic, object-oriented HTTP framework
   https://github.com/cherrypy/cherrypy
   
   o Bottle: Python Web Framework
     https://github.com/bottlepy/bottle
     
   o Xym: extracting YANG modules from files
     https://github.com/xym-tool/xym
   
   o  Simplejson: JSON Encoder and Decoder for Python
      https://github.com/simplejson/simplejson


