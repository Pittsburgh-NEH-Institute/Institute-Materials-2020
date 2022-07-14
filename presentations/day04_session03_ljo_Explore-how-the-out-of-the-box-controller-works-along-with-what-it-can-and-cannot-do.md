# Explore how the out-of-the-box controller works, along with what it can and cannot do
Day 04 Session 03 slot 02

## URL mapping using URL-rewriting 
1. you put the controller in the root of your app collection
2. A few sections in the controller.xql: step by step
3. How eXist Finds the Controller
The Controller Outputs XML in exist namespace
4. The controller-config.xml Configuration File

## Rule 1: you put the controller in the root of your app collection
And you name it `controller.xql`.


## A few sections in the controller.xql: step by step

### Some external (new term!) variables available to the controller 
```xquery
declare variable $exist:path external;
declare variable $exist:resource external;
declare variable $exist:controller external;
declare variable $exist:prefix external;
declare variable $exist:root external;

(: The most used ones: $exist:path external $exist:resource  $exist:controller :)

(: The start page :)
declare variable $index-page-url := "index";
```

### Utility function to get the extension of a filename

```xquery
declare function local:get-extension($filename as xs:string) as xs:string {
  let $name := replace($filename, ".*[/\\]([^/\\]+)$", "$1")
  return
   if(contains($name, ".")) then replace($name, ".*\.([^\.]+)$", "$1")
   else ""
};
```

### No resource specified? Go to the home page

By doing a redirect we are forcing the browser to perform a redirect. This means the request
will pass through the controller again.

```xquery
if($exist:resource eq "")then
<dispatch xmlns="http://exist.sourceforge.net/NS/exist">
  <redirect url="{$home-page-url}"/>
</dispatch>
```
### No extension? 
We assume it is an XQuery file and forward to it. By doing a forward, the browser will not be informed of the change and the user will still see an URL without an extension.

```xquery
else if (local:get-extension($exist:resource) eq "")then
<dispatch xmlns="http://exist.sourceforge.net/NS/exist">
  <forward url="{concat($exist:controller, $exist:path, ".xq")}"/>
</dispatch>

### Everything else is just passed through 

```xquery
else
<ignore xmlns="http://exist.sourceforge.net/NS/exist">
  <cache-control cache="yes"/>
</ignore>
```

*NB!* Regular expressions might be used for rewriting

### The dispatch 

```xquery
<dispatch xmlns="http://exist.sourceforge.net/NS/exist">
  <forward url = string
  servlet? = string
  absolute? = "yes" | "no"
  method? = "POST" | "GET" | "PUT" | "DELETE" >
  ( add-parameter | set-attribute | clear-attribute | set-header )*
  </forward>
</dispatch>
```

### A dispatch for MVC
```xquery
<dispatch xmlns="http://exist.sourceforge.net/NS/exist">
  <forward url="{concat($exist:controller, "/createmodel.xq")}"/>
  <view>
    (:transformation to html is different for different modules:)
    <forward url="{concat($exist:controller, '/views/', $exist:path, '-to-html.xql')}"/>
    <forward url="{concat($exist:controller, '/views/wrapper.xql')}"/>

    (: <forward servlet="XSLTServlet">
     <set-attribute name="xslt.stylesheet"
     value="{concat($exist:root, $exist:controller, "/xslt/view1.xslt")}"/>
    </forward> :)
  </view>
</dispatch>
```

## How eXist-db finds the controller

1. Exis-db's servlet app Jetty recognizes the eXist prefix `/exist` and passes control 
to the eXist-db main servlet.
2. The eXist-db main servlet sees a URL starting with `/apps`. 
    It tries to match this with an entry in `controller-config.xml`.
3. The value of its path attribute is used to try to locate a controller. 
   eXist-db will look for a controller in `xmldb:exist:///db/apps/controller.xql`.
4. If no match is found, it uses the rest of the URL to try to find the controller. It
starts at the most specific path and works backward until it finds a controller.

### Rule 2: controller-config.xml will bootstrap your controller 
The full controller config syntax: 
```xquery
The content of the controller-config.xml file must be in the http://exist.source
forge.net/NS/exist namespace. The format is:
<configuration xmlns="http://exist.sourceforge.net/NS/exist">
( forward | root )+
</configuration>
```
An example:
```xquery
<root pattern="/apps" path="xmldb:exist:///db/apps"/>
```
Or a server name match:
```xquery
<root server-name="dms.tei-exist.info" pattern=".*"
path="xmldb:exist:///db/myapp/"/>
```

## Further exploration
