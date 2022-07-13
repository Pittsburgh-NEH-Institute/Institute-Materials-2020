# Building a title list with XQuery
Day 03 Session 03 slot 02
 Hoax data.

## Step 1: XQuery version declaration and initial comment

```xquery
xquery version "3.1";

(: 
 : Building on day 02 we go forward with the model to produce a title listing
 :
 :)

}
```

## Step 2: Declare the namespaces we know we need

1. Hoax namespace
2. Hoax model namespace
2. TEI namespace

```xquery
declare namespace hoax = "http://obdurodon.org/hoax";
declare namespace hoax-model = "http://www.obdurodon.org/model";
declare namespace tei = "http://www.tei-c.org/ns/1.0";
```

## Step 3:  Declare the variables we know we want
1. Get some parameters from the request (new term!) for building the `$path-to-data`, e.g. 
   `$exist:root` and `$exist:controller`
2. And the familiar from yesterday `$path-to-data`, `$articles-coll` and `$articles`

```xquery
declare variable $exist:root as xs:string := 
    request:get-parameter("exist:root", "xmldb:exist:///db/apps");
declare variable $exist:controller as xs:string := 
    request:get-parameter("exist:controller", "/pr-app");
declare variable $path-to-data as xs:string := 
    $exist:root || $exist:controller || '/data';
(: Cf day 2
 : declare variable $path-to-data as xs:string := '/db/data'; 
 :)
declare variable $articles-coll := collection($path-to-data || '/hoax_xml');
declare variable $articles as element(tei:TEI)+ := $articles-coll/tei:TEI;
```
## Step 4: Decide one or two things in our model

1. For the listing of titles, we call the framgment element `hoax-model:titles`
2. for the titles, we call the title elements `hoax-model:title`
3. Let us use a FLWOR to create this fragment in the Hoax model namespace
4. But, firstly, what is our data: With XPath take the `tei:title` in the `tei:titleStmt`

```xquery
            $articles//tei:titleStmt/tei:title ! fn:string(.)
```
## Step 5: The title 

`hoax-model:title`

```xquery
        <hoax-model:title>
        { 
            $article//tei:titleStmt/tei:title ! fn:string(.)
        }
        </hoax-model:title>
```
## Step 6: The full titles fragment 

`hoax-model:titles`

```xquery
<hoax-model:titles> 
{
    for $article in $articles 
    return
        <hoax-model:title>
        { 
            $article//tei:titleStmt/tei:title ! fn:string(.)
        }
        </hoax-model:title>
}
</hoax-model:titles>
```

## Step 7: The result of the query

Our title listing in the Hoax model nmamespace 

```xquery
<hoax-model:titles xmlns:hoax-model="http://www.obdurodon.org/model">
    <hoax-model:title>The Ghost of Hammersmith</hoax-model:title>
    <hoax-model:title>Police Column: Yesterday The Lord Mayor...</hoax-model:title>
    <hoax-model:title>A Ghost at Hull</hoax-model:title>
    <hoax-model:title>A Substantial Ghost Story</hoax-model:title>
    <hoax-model:title>Another Ghost!</hoax-model:title>
    <hoax-model:title>Another Ghost</hoax-model:title>
    <hoax-model:title>A Ghost Caught</hoax-model:title>
    <hoax-model:title>A Pomeranian Ghost</hoax-model:title>
    <hoax-model:title>The Ghost of the Cock Lane Ghost</hoax-model:title>
    <hoax-model:title>Another Stockwell Ghost Case</hoax-model:title>
    <hoax-model:title>Notwithstanding our repeated publications...</hoax-model:title>
    <hoax-model:title>The Ghost Laid</hoax-model:title>
    <hoax-model:title>The Bermondsey Ghost</hoax-model:title>
    <hoax-model:title>The New Hammersmith Ghost</hoax-model:title>
    <hoax-model:title>Nelson's Ghost</hoax-model:title>
    <hoax-model:title>Ghost Cut Ghost</hoax-model:title>
    <hoax-model:title>Not Dead, or No Ghost</hoax-model:title>
    <hoax-model:title>Hammersmith Ghost</hoax-model:title>
    <hoax-model:title>A Ghost</hoax-model:title>
    <hoax-model:title>A ghost, a bear, or a devil</hoax-model:title>
    <hoax-model:title>The New Hammersmith Ghost</hoax-model:title>
    <hoax-model:title>Science: A new Ghost</hoax-model:title>
    <hoax-model:title>Park Ghost</hoax-model:title>
    <hoax-model:title>Resuscitation of The Hammersmith Ghost</hoax-model:title>
    <hoax-model:title>The Ghost</hoax-model:title>
    <hoax-model:title>Thoughts On Seeing Ghosts</hoax-model:title>
    <hoax-model:title>
    The Hampstead Ghost? Legal Proceedings against the Police</hoax-model:title>
    <hoax-model:title>
    A Black Ghost on the London and Birmingham Railway</hoax-model:title>
    <hoax-model:title>
    Fears of a Ghost, and the Fatal Catastrophe</hoax-model:title>
    <hoax-model:title>A Ghost! A Ghost!</hoax-model:title>
    <hoax-model:title>The New Hammersmith Ghost</hoax-model:title>
    <hoax-model:title>All the world...</hoax-model:title>
    <hoax-model:title>Another Ghost Case: The Prestidigitateur</hoax-model:title>
    <hoax-model:title>Tom Paine's Ghost</hoax-model:title>
    <hoax-model:title>A Ghost</hoax-model:title>
    <hoax-model:title>Park Ghost</hoax-model:title>
</hoax-model:titles>
```

## Step 8: Rinse and repeat 

1. Are there restictions in the model or are we done?
2. Maybe change default ordering?

```xquery
<hoax-model:titles> 
{
    for $article in $articles
    let $title := $article//tei:titleStmt/tei:title ! fn:string(.)
    order by $title
    return
        <hoax-model:title>
        { 
            $title
        }
        </hoax-model:title>
}
</hoax-model:titles>
```
