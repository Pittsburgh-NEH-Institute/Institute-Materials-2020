# Building the reading view feature: model

## Goals
- output in model namespace
- include any relevant auxiliary data
- prepare to write the view (using `typeswitch`)

### Housekeeping

1. Declare namespaces.

```
(: =====
Declare namespaces
===== :)
declare namespace tei="http://www.tei-c.org/ns/1.0";
declare namespace m="http://www.obdurodon.org/model";

declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:method "xml";
declare option output:indent "no";
```

2. Retrieve controller parameters.

```
(: =====
Retrieve controller parameters
Default path to data is xmldb:exist:///db/apps/pr-app/data/hoax_xml
===== :)
declare variable $exist:root as xs:string := request:get-parameter("exist:root", "xmldb:exist:///db/apps");
declare variable $exist:controller as xs:string := request:get-parameter("exist:controller", "/06-controller");
declare variable $path-to-data as xs:string := $exist:root || $exist:controller || '/data/hoax_xml//';
```

3. Retrieve query parameters

```
(: =====
Retrieve query parameters
===== :)
(: === for testing purposes, let's declare another variable that passes a string as an ID, without having to worry about request:get-parameter()

declare variable $id as xs:string? := request:get-parameter('id', ());
=== :)

declare variable $id as xs:string? := 'GH-19CUK-18381104';

(: === from eXist-db book by Priscilla Walmsley, pg 55
"request:get-parameter() is an extension function from the request extension module 
(see “The request Extension Module” on page 209) that returns the value of a 
parameter passed in the URL (or of a control in an HTML form−driven request). The second parameter, which in this example is the empty sequence (), can be used to pass a default value."

```

4. Retrieve auxiliary data

```
(: ====
Retrieve auxiliary data
==== :)
declare variable $gazetteer := doc($exist:root || $exist:controller || '/data/aux_xml/places.xml');
declare variable $pros := doc($exist:root || $exist:controller || '/data/aux_xml/persons.xml');
```

### IDs - why do it this way?

5. Retrieve article (usually from a link clicked by the user!) using the ID

```
(: ====
Retrieve article using $id
=== :)
declare variable $article as element(tei:TEI)? := 
    collection($path-to-data)//id($id);
```

eXist-db automatically indexes any `xml:id` values like the ones on our data's root TEI elements. We can access them using `id()`, which is also written as `fn:id()`, as a path step. Rather than calling the `@xml:id = "$id"` value as a predicate (in pseudocode "only give me the article where the `$id` value assigned by `request:get-parameter()` is equal to the one on the article), we can use the `id()` function to call on that indexed ID to locate the article. This is faster (it's indexed, and doesn't need to do that comparison, instead we're just navigating the XML tree) and it also prepares us to pass the current context into `ft:query()` as well.

### Add `$article` and execute query

```
$article

```

We could stop there, but let's add some more helpful information.

## Adding the model namespace

It is perfectly acceptable for us to pass through the TEI as the model. TEI already is a model of your data-- an encoding of the information you really care about-- so we can all agree that TEI is able to shapeshift a bit here, as both data and model. Aside from being easier, we also know that a lot of TEI-encoded information is already presentational, so translating it to model and then translating it to a different kind of view can over-engineer the problem. `tei:emph` -> `m:emph` -> `html:emph` is a fine pipeline, but we're not meaningfully rearranging, interpreting, or adding to that information by changing it; so let's give ourselves a break and let TEI be both data and model.

We do have some information that we want to meaningfully rearrange, though, namely dates, titles, and places. Let's set up a root element for our output that will allow us to do that.

```
<m:result>
{$article}
</m:result>
```

What do we think we'll get? Is that good enough? What if someone types in an XML:ID that doesn't exist?

```
if ($article) then
    <m:result>
    {$article}
    </m:result>
else
    <m:no-result>
    None
    </m:no-result>
```

## What other information is essential to our reading view?
- a well-formatted publisher name and publication date
- the place references that are included in the gazetteer

Let's get the publisher name in there first!

```
if ($article) then
    let $pub-string as xs:string := $article//tei:sourceDesc//tei:publisher ! string(.)
    return
    <m:result>
    <m:publisher>{$pub-string}</m:publisher>
    $article
    </m:result>
else
    <m:no-result>
    None
    </m:no-result>
    
```

Where did we go wrong?

```
if ($article) then
    let $pub-string as xs:string := $article//tei:sourceDesc//tei:publisher ! string(.)
    return
    <m:result>
    <m:publisher>{$pub-string}</m:publisher>
    {$article}
    </m:result>
else
    <m:no-result>
    None
    </m:no-result>

```

Great! This article was published by John Bull, but for data reasons we removed any leading article-parts-of-speech and placed them in an @rend attribute in the source description, so we should test this for an article from The Times, like `GH-TIMES-18040106`. Let's use `string-join()` from pg. 289 of XQuery (Walmsley 289). It accepts as parameters a sequence of strings, one of which can be a separator, so we want to use `@rend`, a dot for the current context, and then a white space character in quotes as our separator string `' '`. If we just needed to append something to this (or if we wanted to format it as “Times, The”), I would use `concat()` or the handy `||` union operator. This is a matter of preference more than anything else.


```
if ($article) then
    let $pub-string as xs:string := $article//tei:sourceDesc//tei:publisher 
    	! string-join((@rend, .), ' ') 
    	=> normalize-space()
    return
    <m:result>
    <m:publisher>{$pub-string}</m:publisher>
    {$article}
    </m:result>
else
    <m:no-result>
    None
    </m:no-result>
```

Looks good! Before we start adding any more auxiliary information, though, I think we should re-evaluate our model. In my view, it doesn't make sense for the article to be last in the tree, since that's not what we're designating as “auxiliary”. I also think maybe we should be more clear about what is exactly auxiliary, so let's wrap those in their own parent element.

```
if ($article) then
    let $pub-string as xs:string := $article//tei:sourceDesc//tei:publisher ! string-join((@rend, .), ' ') => normalize-space()
    return
    <m:result>
    {$article}
        <m:aux>
            <m:publisher>{$pub-string}</m:publisher>
        </m:aux>
    </m:result>
else
    <m:no-result>
    None
    </m:no-result>

```

Next order of business is our date.

```
if ($article) then
    let $pub-string as xs:string := $article//tei:sourceDesc//tei:publisher 
        ! string-join((@rend, .), ' ') 
        => normalize-space()
    let $pub-date as xs:date := $article//tei:sourceDesc//tei:bibl/tei:date/@when
        ! xs:date(.)
                
    return
    <m:result>
    {$article}
        <m:aux>
            <m:publisher>{$pub-string}</m:publisher>
            <m:date>{$pub-date}</m:date>
        </m:aux>
    </m:result>
else
    <m:no-result>
    None
    </m:no-result>
```

That returns an ISO date, which is fine but not really what we want. We want human readable data. Does this transformation belong in the view? Maybe so! This depends on how strict you are being. I think it belongs in the model because we know and understand there is a meaningful difference between ISO date and non-ISO date. We want the non-ISO date, it's not in the data, so we need to transform it into the model. Don't overthink it. Remember that date problem from Cli

```
if ($article) then
    let $pub-string as xs:string := $article//tei:sourceDesc//tei:publisher 
        ! string-join((@rend, .), ' ') 
        => normalize-space()
    let $pub-date as xs:date := $article//tei:sourceDesc/descendant::tei:bibl/tei:date/@when
                ! xs:date(.)
                ! format-date(., '[MNn] [D], [Y]')
    return
    <m:result>
    {$article}
        <m:aux>
            <m:publisher>{$pub-string}</m:publisher>
            <m:date>{$pub-date}</m:date>
        </m:aux>
    </m:result>
else
    <m:no-result>
    None
    </m:no-result>
```

Why doesn't it work?

```
if ($article) then
    let $pub-string as xs:string := $article//tei:sourceDesc//tei:publisher 
        ! string-join((@rend, .), ' ') 
        => normalize-space()
    let $pub-date as xs:string := $article//tei:sourceDesc//tei:bibl/tei:date/@when
                ! xs:date(.)
                ! format-date(., '[MNn] [D], [Y]')
    return
    <m:result>
    {$article}
        <m:aux>
            <m:publisher>{$pub-string}</m:publisher>
            <m:date>{$pub-date}</m:date>
        </m:aux>
    </m:result>
else
    <m:no-result>
    None
    </m:no-result>

```

Fantastic work, let's move on and talk about getting those places.

## Finding places

Here's the first approach in pseudo code:

> Go find me all the places in my current article. Then, go compare that list to the big gazetteer list and return the ones that match.

This is mostly fine, but you run into issues when you find something in the current article that isn't in the gazetteer. That's a very real possibility in our data, because they're historical places that may represent an idea of a place, a place that you, the researcher, couldn't geolocate, etc.

Let's use this pseudo code pattern instead
> For each place in the gazetteer where the `@xml:id` equals one of the `placeName/@ref` elements in the current article, return the place information I care about.

This is a bit easier, but might not make as much sense to you on the surface in human language-- to put the advantage another way, we should filter down rather than reach down the tree several times over.

So like we said, we want to start by retrieving all the places.

```
if ($article) then
    let $pub-string as xs:string := $article//tei:sourceDesc//tei:publisher 
        ! string-join((@rend, .), ' ') 
        => normalize-space()
    let $pub-date as xs:string := $article//tei:sourceDesc//tei:bibl/tei:date/@when
                ! xs:date(.)
                ! format-date(., '[MNn] [D], [Y]')
    return
    <m:result>
    {$article}
        <m:aux>
            <m:publisher>{$pub-string}</m:publisher>
            <m:date>{$pub-date}</m:date>
            <m:places>
                {for $place in $gazetteer//tei:place
                    return <m:place/>}
            </m:places>
        </m:aux>
    </m:result>
else
    <m:no-result>
    None
    </m:no-result>
```

What is the syntax for filtering in XQuery and XPath?

```
<m:places>
    {for $place in $gazetteer//tei:place[@xml:id = $article//tei:placeName]
        return <m:place/>}
</m:places>
```

Doesn't work! Why not? We use `#` marks on the `@ref` attribute values that can be dereferenced to the gazetteer. This is helpful because we don't have to worry about matching anything by accident we're not actually looking for. We can use a nested predicate here! We use the `starts-with()` function (XQuery, pg 285) and `substring()`	 (XQuery, pg 287).

```
<m:places>
    {for $place in $gazetteer//tei:place
          [@xml:id = $article//tei:placeName[starts-with(@ref, '#')]/@ref 
          ! substring(., 2)]
          return <m:place/>}
</m:places>
```

Where do we end up? The full XQuery is below, with the placeholder variable removed. We're ready to begin constructing the view!


```
(: =====
Declare namespaces
===== :)
declare namespace tei="http://www.tei-c.org/ns/1.0";
declare namespace m="http://www.obdurodon.org/model";


declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:method "xml";
declare option output:indent "no";

(: =====
Retrieve controller parameters
Default path to data is xmldb:exist:///db/apps/pr-app/data/hoax_xml
===== :)
declare variable $exist:root as xs:string := request:get-parameter("exist:root", "xmldb:exist:///db/apps");
declare variable $exist:controller as xs:string := request:get-parameter("exist:controller", "/pr-app");
declare variable $path-to-data as xs:string := $exist:root || $exist:controller || '/data/hoax_xml//';

(: =====
Retrieve query parameters
===== :)

declare variable $id as xs:string? := request:get-parameter('id', ());


(: ====
Retrieve auxiliary data
==== :)
declare variable $gazetteer := doc($exist:root || $exist:controller || '/data/aux_xml/places.xml');
declare variable $pros := doc($exist:root || $exist:controller || '/data/aux_xml/persons.xml');

(: ====
Retrieve article using $id
=== :)
declare variable $article as element(tei:TEI)? := 
    collection($path-to-data)//id($id);

if ($article) then
    let $pub-string as xs:string := $article//tei:sourceDesc//tei:publisher 
        ! string-join((@rend, .), ' ') 
        => normalize-space()
    let $pub-date as xs:string := $article//tei:sourceDesc//tei:bibl/tei:date/@when
                ! xs:date(.)
                ! format-date(., '[MNn] [D], [Y]')
    return
    <m:result>
    {$article}
        <m:aux>
            <m:publisher>{$pub-string}</m:publisher>
            <m:date>{$pub-date}</m:date>
            <m:places>
                {for $place in $gazetteer//tei:place[@xml:id = 
                    $article//tei:placeName
                        [starts-with(@ref, '#')]/@ref 
                        ! substring(., 2)]
                    return
                        <m:place>
                            <m:name>{$place/tei:placeName ! string(.)}</m:name>
                            <m:type>{$place/@type ! string(.)}</m:type>
                            <m:geo>{$place/tei:location/tei:geo ! string(.)}</m:geo>
                        </m:place>}
            </m:places>
        </m:aux>
    </m:result>
else
    <m:no-result>
    None
    </m:no-result>

```








