<!DOCTYPE html>
<html lang="en">
<head>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <!-- <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.3/jquery.min.js"></script> -->
  <script src="/static/js/jquery.min.js"></script>
  <script src="/static/js/jquery-ui.js"></script>
  <link rel="stylesheet" type="text/css" href="/static/js/jquery-ui.css">
  <link rel="stylesheet" type="text/css" href="/static/js/jquery.ui.tabs.css">
  
  <script type="text/javascript">
    $( document ).ready(function() {
      var rfc_number = 0;
      var draft_name = "";

      $( "#rfc_submit" ).click(function() {
        /*rfc_number = $( "#rfc_number" ).val();
        $.ajax({
            url: "/api/rfc/" + rfc_number,
        }).then(function(data, textStatus, jqXHR) {
          $( "#maincanvas" ).empty()
          $( '#maincanvas' ).append('<hr>');
          $( '#maincanvas' ).append('<p>Extracted ' + Object.keys(data).length + ' YANG module(s) Catalog Information</p>');          
          $( '#maincanvas' ).append('<ul>');
          for (var key in data) {
            sanitized = key.split("@")[0].replace(".", "_");
            $( '#maincanvas' ).append('<li><a href="#' + sanitized + '">' + key + '</a></li>');
          }
          $( '#maincanvas' ).append('</ul>');
          for (var key in data) {
            $( '#maincanvas' ).append('<hr>');
            sanitized = key.split("@")[0].replace(".", "_");
            $( '#maincanvas' ).append('<div id="' + sanitized + '"> <h2>' + key + '</h2>' +
                '<h3>Extraction</h3><pre class="xymstderr"/>' +
                '<h3>Validation</h3><pre class="stderr"/>' +
                '<h3>Output Module Catalog Information in both json and xml Format </h3><pre class="output"/>');
            $( '#' + sanitized + ' > pre.xymstderr' ).append(data[key].xym_stderr.length > 0 ? data[key].xym_stderr : "No warnings or errors");
            $( '#' + sanitized + ' > pre.stderr' ).append(data[key].pyang_stderr.length > 0 ? data[key].pyang_stderr : "No warnings or errors");
            $( '#' + sanitized + ' > pre.output' ).append(data[key].pyang_output.length > 0 ? data[key].pyang_output : "No output");
          }
        });
        return(false);*/

        $("#rfcform")[0].action = "/api/rfc/" + $("#rfc_number").val();
        //alert($("#rfc_number").val());
        $("#rfc_submit").submit();

      });

/*
      $( "#draft_submit" ).click(function() {
        draft_name = $( "#draft_name" ).val();
        $.ajax({
            url: "/api/draft/" + draft_name,
        }).then(function(data, textStatus, jqXHR) {
          $( "#maincanvas" ).empty()
          $( '#maincanvas' ).append('<hr>');
          $( '#maincanvas' ).append('<p>Extracted ' + Object.keys(data).length + ' YANG module(s)</p>');          
          $( '#maincanvas' ).append('<ul>');
          for (var key in data) {
            sanitized = key.split("@")[0].replace(".", "_");
            $( '#maincanvas' ).append('<li><a href="#' + sanitized + '">' + key + '</a></li>');
          }
          $( '#maincanvas' ).append('</ul>');
          for (var key in data) {
            $( '#maincanvas' ).append('<hr>');
            sanitized = key.split("@")[0].replace(".", "_");
            $( '#maincanvas' ).append('<div id="' + sanitized + '"> <h2>' + key + '</h2>' +
                '<h3>Extraction</h3><pre class="xymstderr"/>' +
                '<h3>Validation</h3><pre class="stderr"/>' +
                '<h3>Output Module Catalog Information in both json and xml Format </h3><pre class="output"/>');
            $( '#' + sanitized + ' > pre.xymstderr' ).append(data[key].xym_stderr.length > 0 ? data[key].xym_stderr : "No warnings or errors");
            $( '#' + sanitized + ' > pre.stderr' ).append(data[key].pyang_stderr.length > 0 ? data[key].pyang_stderr : "No warnings or errors");
            $( '#' + sanitized + ' > pre.output' ).append(data[key].pyang_output.length > 0 ? data[key].pyang_output : "No output");
          }
        });
        return(false);

      });
*/
	 
	  $(".ui-tabs").tabs();
	  
    });


	/*function browseFolder(path)
	{
	    try {
          var Message = "\u8bf7\u9009\u62e9\u6587\u4ef6\u5939";
          var Shell = new ActiveXObject("Shell.Application");
          var Folder = Shell.BrowseForFolder(0, Message, 64, 17);
          //var Folder = Shell.BrowseForFolder(0, Message, 0);
          if (Folder != null) {
             Folder = Folder.items();
             Folder = Folder.item();
             Folder = Folder.Path;
             if (Folder.charAt(Folder.length - 1) != "\\") {
                 Folder = Folder + "\\";
             }
             document.getElementById(path).value = Folder;
             return Folder;
          }
        }
        catch (e) {
          alert(e.message);
        }
    }*/

  </script>

  <link href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="/static/css/pyangui.css">
  <title>YANG Extractor and Validator</title>
</head>
<body>
  <div class="container">
  <a href="https://github.com/sunseawq/bottle-yang-catalog-extractor"><img style="position: absolute; top: 0; right: 0; border: 0;" src="https://camo.githubusercontent.com/a6677b08c955af8400f44c6298f40e7d19cc5b2d/68747470733a2f2f73332e616d617a6f6e6177732e636f6d2f6769746875622f726962626f6e732f666f726b6d655f72696768745f677261795f3664366436642e706e67" ></a>
      <ul class="nav nav-pills">
        <li role="presentation" class="active"><a href="/">Home</a></li>
        <li role="presentation"><a href="/rest">REST API</a></li>
        <li role="presentation"><a href="/about">About</a></li>
      </ul>
  <h1>Fetch YANG models Catalog in either JSON format or XML format </h1>
    <p class="lead" >The form below allows you to fetch YANG modules Catalog information in appropriate format by RFC number, by IETF draft name, or by uploading IETF drafts or YANG files.</p>

        <form name="uploadform" id="uploadform" action="/validator" method="post" enctype="multipart/form-data">
          <div class="form-group">
            <label for="data" class="info">Upload multiple YANG files or a zip archive</label>
            <div class="form-inline">
              <input type="file" id="data" name="data" class="form-control" multiple="multiple" accept="zip/zip"/>
              <button id="file_submit" class="btn btn-default">Catalog</button>
            </div>
          </div>
        </form>

<!--
        <form name="uploadform1" id="uploadform1" action="/validator/" method="post" enctype="multipart/form-data">
          <div class="form-group">
            <label for="data" class="info">Upload multiple YANG files or a zip archive</label>
            <div class="form-inline">
              <input type="text" id="data1" name="data" class="form-control" />
              <button id="file_submit1" class="btn btn-default" onclick="browseFolder('data1')">Catalog</button>
            </div>
          </div>
        </form> -->


    <!--    <form name="uploadid" id="uploadid" action="/draft-validator" method="post" enctype="multipart/form-data">
          <div class="form-group">
            <label for="data" class="info">Upload Internet Draft</label>
            <div class="form-inline">
              <input type="text" id="data1" name="data1" class="form-control" multiple="multiple" />
              <button id="file_submit1" class="btn btn-default" onclick="browseFolder('data1')">Catalog</button>
            </div>
          </div>
        </form>  -->

        <form name="rfcform" id="rfcform">
          <div class="form-group">
            <label for="rfc_number" class="info" >Fetch YANG Module Catalog Information based on  IETF RFC number</label>
            <div class="form-inline">
              <input  id="rfc_number" type="text" class="form-control" placeholder="RFC number, e.g. 7223" />
              <button id="rfc_submit" class="btn btn-default">Catalog</button>
            </div>
          </div>
        </form>

        <form name="draftform" id="draftform">
          <div class="form-group">
            <label for="draft_name" class="info">Fetch YANG Module Catalog information based on IETF Draft name</label>
            <div class="form-inline">
              <input  id="draft_name" type="text" class="form-control" placeholder="Draft name, e.g. draft-ietf-netmod-syslog-model" />
              <button id="draft_submit" class="btn btn-default">Catalog</button>
            </div>
          </div>
        </form>


<!--  -->

    <div id="maincanvas" />
      <hr>
  % if len(results) != 0:
      <p>Extracted {{len(results)}} YANG modules Catalog Information</p>
      <ul>
    % for obj in results:
      % name = obj["file"]
      % content = obj["content"]
        <li><a href="#{{name.split("@")[0].replace(".", "_")}}">{{name}}</a></li>
    % end
      </ul>
  %end

  % if len(results) != 0:
    % for obj in results:
      % name = obj["file"]
      % content = obj["content"]
      <div>
        <hr>
        <h2 id="{{name.split("@")[0].replace(".", "_")}}">{{name}}</h2>
        % if "xym_stderr" in content:
        <h3>Extraction</h3>
        <pre class="stderr">{{!content["xym_stderr"] if len(content["xym_stderr"]) != 0 else "No warnings or errors"}}</pre>
        % end
        <h3>Validation</h3>
        <pre class="stderr">{{!content["pyang_stderr"] if len(content["pyang_stderr"]) != 0 else "No warnings or errors"}}</pre>
        <h3>Output Module Catalog Information in both json and xml Format </h3>
        <!-- <pre class="output">{{!content["pyang_output"] if len(content["pyang_output"]) != 0 else "No warnings or errors"}}</pre>
		<pre class="output">{{!content["pyang_output1"] if len(content["pyang_output1"]) != 0 else "No warnings or errors"}}</pre> -->
		<div>
		 <div id="tabs" class="ui-tabs">
		  <ul class="ui-tabs-nav">
		    <li class="ui-helper-reset"><a href="#tabs-1">json</a></li>
			<li><a href="#tabs-2">xml</a></li>
		  </ul>
		  <div id="tabs-1">
		    <pre class="output">{{!content["pyang_output"] if len(content["pyang_output"]) != 0 else "No warnings or errors"}}</pre>
		  </div>
		  <div id="tabs-2">
		    <pre class="output">{{!content["pyang_output1"] if len(content["pyang_output1"]) != 0 else "No warnings or errors"}}</pre>
		  </div>
		 </div>
		</div>
		
      </div>
    % end 
  % end
    <small class="text-muted">xym version: {{versions["xym_version"]}}, pyang version: {{versions["pyang_version"]}}</small>
  </div>
</body>

