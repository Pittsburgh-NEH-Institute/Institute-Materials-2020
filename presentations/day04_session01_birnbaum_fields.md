# Your first field

## Preliminary setup

1. Clone our starter repo from <https://github.com/Pittsburgh-NEH-Institute/01-data>.
2. Build the app with `ant`.
3. Install the app from the eXist-db package manager.
4. Launch eXide from the eXist-db dashboard.

## Copy *titles.xql* into the app (from below)

1. Use the eXide File → Manage menus to create a subdirectory called `modules` inside your app.
2. Click the “New XQuery” button in eXide to open a new XQuery window, copy and paste the `titles.xql` file below into it, and save it into the new `modules` subdirectory.

```
(:
 : Building on day 02 we go forward with the model to produce a title listing
 :
 :)

(:===
Declare namespaces
==:)
declare namespace hoax = "http://obdurodon.org/hoax";
declare namespace hoax-model = "http://www.obdurodon.org/model";
declare namespace tei = "http://www.tei-c.org/ns/1.0";

(:===
Declare global variables to path
===:)
declare variable $exist:root as xs:string :=
    request:get-parameter("exist:root", "xmldb:exist:///db/apps");
declare variable $exist:controller as xs:string :=
    request:get-parameter("exist:controller", "/01-data");
declare variable $path-to-data as xs:string :=
    $exist:root || $exist:controller || '/data';
(:===
Declare variable
===:)
declare variable $articles-coll := collection($path-to-data || '/hoax_xml');
declare variable $articles as element(tei:TEI)+ := $articles-coll/tei:TEI;

<hoax-model:titles>
{
    for $article in $articles
    return
        <hoax-model:title>{
            $article//tei:titleStmt/tei:title ! fn:string(.)
        }</hoax-model:title>
}</hoax-model:titles>
```

----

## Enhance *titles.xql* to return word count

1. For each article create a wrapper element (`<hoax-model:article>`) around the title.
2. Alongside the title create an element to hold the word count (`<hoax-model:word-count>`).
3. Populate the new element with code to count the words in the body of the document.

```
<hoax-model:titles>{
    for $article in $articles
    return
        <hoax-model:article>
            <hoax-model:title>{
                $article//tei:titleStmt/tei:title ! string(.)
            }</hoax-model:title>
            <hoax-model:word-count>{
                $article/descendant::tei:body 
                    ! tokenize(.) 
                    => count()
            }</hoax-model:word-count>
        </hoax-model:article>
}</hoax-model:titles>
```

## Inside eXide create and save an index

Copy the following code and save it in the root of your app with the filename `collection.xconf` (based on <http://exist-db.org/exist/apps/doc/lucene>):

```
<collection xmlns="http://exist-db.org/collection-config/1.0"
    xmlns:tei="http://www.tei-c.org/ns/1.0">
    <index xmlns:xs="http://www.w3.org/2001/XMLSchema">
        <!-- Configure lucene full text index -->
        <lucene>
            <analyzer class="org.apache.lucene.analysis.standard.StandardAnalyzer"/>
            <analyzer id="ws" class="org.apache.lucene.analysis.core.WhitespaceAnalyzer"/>
            <text qname="tei:TEI">
                <field
                    name="word-count"
                    expression="descendant::tei:body 
                        ! tokenize(.) 
                        => count()"/>
           </text>
        </lucene>
    </index>
</collection>
```

## Change the query to use the field


```
xquery version "3.1";
declare namespace hoax = "http://obdurodon.org/hoax";
declare namespace hoax-model = "http://www.obdurodon.org/model";
declare namespace tei = "http://www.tei-c.org/ns/1.0";

(:===
Declare global variables to path
===:)
declare variable $exist:root as xs:string :=
    request:get-parameter("exist:root", "xmldb:exist:///db/apps");
declare variable $exist:controller as xs:string :=
    request:get-parameter("exist:controller", "/01-data");
declare variable $path-to-data as xs:string :=
    $exist:root || $exist:controller || '/data';
(:===
Declare variable
===:)
declare variable $articles-coll := collection($path-to-data || '/hoax_xml');
declare variable $articles as element(tei:TEI)+ := 
    $articles-coll/tei:TEI[ft:query(., (), 
    map {
        "fields" : "word-count"
    }
)];

<hoax-model:titles>{
    for $article in $articles
    return
        <hoax-model:article>
            <hoax-model:title>{
                $article//tei:titleStmt/tei:title ! fn:string(.)
            }</hoax-model:title>
            <hoax-model:word-count>{
                ft:field($article, "word-count")
            }</hoax-model:word-count>
        </hoax-model:article>
}</hoax-model:titles>

```


