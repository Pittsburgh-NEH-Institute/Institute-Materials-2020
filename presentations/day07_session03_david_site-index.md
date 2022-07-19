# Create a main page

We’ve configured the controller to load *index.xql* if no page is specified. At the moment it doesn’t create a proper main page, so let’s create 

## Create the model for the main page

Create *index.xql* inside *modules* and copy the following text into it:

```
xquery version "3.1";
(:===
Declare namespaces
==:)
declare namespace m="http://www.obdurodon.org/model";
(:===
Declare global variables to path
===:)
declare variable $exist:root as xs:string :=
    request:get-parameter("exist:root", "xmldb:exist:///db/apps");
declare variable $exist:controller as xs:string :=
    request:get-parameter("exist:controller", "/06-controller");

<m:modules>
    <m:module>titles</m:module>
    <m:module>persons</m:module>
    <m:module>places</m:module>
</m:modules>
```

## Create the view for the main page

Create *index-to-html.xql* inside *views* and paste the following into it:

```
xquery version "3.1";
declare namespace m="http://www.obdurodon.org/model";

declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:method "xhtml";
declare option output:media-type "application/xhtml+xml";
declare option output:omit-xml-declaration "no";
declare option output:html-version "5.0";
declare option output:indent "no";
declare option output:include-content-type "no";

declare variable $text := request:get-data(); (:this variable allows the pipeline to work:)

<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <title>Hoax</title>
    </head>
    <body>
        <h1>Things to do</h1>
        <ul>{
            for $item in $text/descendant::m:module
            return <li><a href="{$item}">{$item}</a></li>
        }</ul>
    </body>
</html>
```