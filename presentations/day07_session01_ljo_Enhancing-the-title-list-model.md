# Enhancing the title list model
Day 07 Session 01 slot 01
 Hoax data.

## Step 1: Checkout week 2 day 2 (= day7) repo URLs
Choose the one for your method:
  * ssh-key: git@github.com:Pittsburgh-NEH-Institute/06-controller.git
  * personal access token: https://github.com/Pittsburgh-NEH-Institute/06-controller.git

### While in the terminal, show some shell variables
  * Show the home directory path:
 `echo $HOME`
  * Show which shell that is used:
`echo $SHELL`

## Adding more from the titleStmt
 * respStmt/name
 * respStmt/resp

### Wrap them in respStmt inside titleStmt element

## The code after enhancement 

```xquery
xquery version "3.1";
(:  
 : Enhancing the titles listing
 :  
 :)

(:
 : Declare namespaces
 :)
declare namespace m = "http://www.obdurodon.org/model";
declare namespace tei = "http://www.tei-c.org/ns/1.0";

(:
 : Declare variables for path-to-data
 :)
declare variable $exist:root as xs:string := 
    request:get-parameter("exist:root", "xmldb:exist:///db/apps");
declare variable $exist:controller as xs:string := 
    request:get-parameter("exist:controller", "/06-controller");
declare variable $path-to-data as xs:string := 
    $exist:root || $exist:controller || '/data';

(: 
 : Declare some more variables
<m:titles>{
                for $article in $articles 
                return
                <m:titleStmt>{
                        (<m:title>{ 
                                $article/descendant::tei:titleStmt/tei:title ! string()
                        }</m:title>,
                for $resp-name in $article/descendant::tei:titleStmt/tei:respStmt/tei:name 
                return <m:respStmt>
                                <m:resp-name>{ 
                                $resp-name ! string()
                                }</m:resp-name>
                                <m:resp-resp>{ 
                                $resp-name/preceding-sibling::tei:resp ! string()
                                }</m:resp-resp>
                        </m:respStmt>)
        }</m:titleStmt>
}</m:titles>
```
