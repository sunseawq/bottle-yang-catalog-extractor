<!DOCTYPE html>
<html lang="en">
<head>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="/static/css/pyangui.css">
  <title>YANG Module Catalog Extractor</title>
</head>
<body>
  <div class="container">
    <a href="https://github.com/sunseawq/bottle-yang-catalog-extractor"><img style="position: absolute; top: 0; right: 0; border: 0;" src="https://camo.githubusercontent.com/a6677b08c955af8400f44c6298f40e7d19cc5b2d/68747470733a2f2f73332e616d617a6f6e6177732e636f6d2f6769746875622f726962626f6e732f666f726b6d655f72696768745f677261795f3664366436642e706e67" alt="Fork me on GitHub" data-canonical-src="https://s3.amazonaws.com/github/ribbons/forkme_right_gray_6d6d6d.png"></a>
    <ul class="nav nav-pills">
      <li role="presentation"><a href="/">Home</a></li>
      <li role="presentation" class="active"><a href="/rest">REST API</a></li>
      <li role="presentation"><a href="/about">About</a></li>
    </ul>
    <h1>Fetch YANG model Catalog information using REST</h1>
    <p class="lead">The REST API described below allows you to perform the YANG module catalog fetch steps provided using Two HTTP Request Methods,POST and GET.</p>
    <p> The URLs below accepts GET/POST requests and return their payload in JSON with the with the <code>Content-Type</code> header set to <code>application/json</code>.</p>
	<p> The URLs below accepts GET/POST requests and return their payload in XML with the with the <code>Content-Type</code> header set to <code>application/xml</code>.</p>
    <dl>
      <dt><code>/api/rfc/&lt;rfc&gt;</code></dt>
      <dd>This URL allows you to fetch YANG module Catalog Information that are part of currently available IETF RFCs. Replace <code>&lt;rfc&gt;</code> with the <b>number</b> ot the RFC, e.g. <mark>7223</mark>.</dd>
      <dt><code>/api/draft/&lt;draft&gt;</code></dt>
      <dd>This URL allows you to fetch YANG module Catalog information that are part of currently published IETF drafts. Replace <code>&lt;draft&gt;</code> with the canonical <b>name</b> of the draft, e.g. <mark>draft-ietf-netmod-ip-cfg-14</mark>. Remove the version number at the end of the name to retrieve the most recent version published (e.g. <mark>draft-ietf-netmod-ip-cfg</mark>).</dd>
    </dl>
    <p>The response JSON or XML consists of a list of objects (one per extracted YANG modules) with the name of the extracted YANG module and the following content:
      <ul>
        <li>A <code>xym_stderr</code> object with the output of the xym extraction step</li>
        <li>A <code>pyang_stderr</code> object with the output of the pyang validation step</li>
        <li>A <code>pyang_output</code> object with the JSON format output of the pyang module catalog extraction step</li>
		<li>A <code>pyang_output1</code> object with the XML format output of the pyang module catalog extraction step</li>
      </ul>
    </p>
  </div>
</body>

