# Examine indexes and profiles in Monex
Day 04 Session 01 slot 02

## Walkthrough of Monex.
1. Open [Monex](http://localhost:8080/exist/apps/monex/index.html)
2. Monitoring
3. Profiling (also more later)
4. Indexes

## Query 1: Wew will use the query from day 3.
```xquery
xquery version "3.1";

(: 
 : Building on day 02 we go forward with the model to produce a title listing
 :
 :)

declare namespace hoax = "http://obdurodon.org/hoax";
declare namespace hoax-model = "http://www.obdurodon.org/model";
declare namespace tei = "http://www.tei-c.org/ns/1.0";

declare variable $exist:root as xs:string := request:get-parameter("exist:root", "xmldb:exist:///db/apps");
declare variable $exist:controller as xs:string := request:get-parameter("exist:controller", "/pr-app");
declare variable $path-to-data as xs:string := $exist:root || $exist:controller || '/data';
(: Cf day 2
 : declare variable $path-to-data as xs:string := '/db/data'; 
 :)
declare variable $articles-coll := collection($path-to-data || '/hoax_xml');
declare variable $articles as element(tei:TEI)+ := $articles-coll/tei:TEI;

(:   :$articles//tei:titleStmt/tei:title ! fn:string(.) :)


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

## Query 2: Another query for reetrieving a specific article
```xquery
xquery version "3.1";

(: 
 : Building on day 02 and day 03 title listing we can also retrieve a specific article.
 :
 :)

declare namespace hoax = "http://obdurodon.org/hoax";
declare namespace hoax-model = "http://www.obdurodon.org/model";
declare namespace tei = "http://www.tei-c.org/ns/1.0";

declare variable $exist:root as xs:string := request:get-parameter("exist:root", "xmldb:exist:///db/apps");
declare variable $exist:controller as xs:string := request:get-parameter("exist:controller", "/pr-app");
declare variable $path-to-data as xs:string := $exist:root || $exist:controller || '/data';
(: Cf day 2
 : declare variable $path-to-data as xs:string := '/db/data'; 
 :)
declare variable $articles-coll := collection($path-to-data || '/hoax_xml');
declare variable $articles as element(tei:TEI)+ := $articles-coll/tei:TEI;


(:
 : get the values of query parameters
 :)
declare variable $id as xs:string? := request:get-parameter('id', "GH-BLNPS-18040106");
declare variable $term as xs:string? := request:get-parameter('term', ());

(: 
 : Locate auxiliary data
 :)
declare variable $places-doc := doc($path-to-data || '/aux_xml/places.xml');
declare variable $persons-doc := doc($path-to-data || '/aux_xml/persons.xml');

(:
 : Retrieve specific article using the id or none if failed
 :)
declare variable $article as element(tei:TEI)? := 
    $articles-coll//id($id)
    [ft:query(., $term, map{'fields':('word-count','formatted-publisher', 'formatted-date')})];

if ($article) then (: test for $article, not $id, because $id could be present but incorrect :)
    <hoax-model:result> 
        {$article => util:expand() (: $article is a full TEI document in tei namespace :) }
        <hoax-model:aux>
            <hoax-model:publisher>{ft:field($article, 'formatted-publisher')}</hoax-model:publisher>
            <hoax-model:date>{ft:field($article, 'formatted-date')}</hoax-model:date>
            <hoax-model:word-count>{ft:field($article, 'word-count')}</hoax-model:word-count>
            <hoax-model:ghost-references>{
                (: alphabetized distinct values of ghost references, with counts :)
                for $ghost-refs as xs:string* in ($article/descendant::tei:rs/@ref)[contains(., 'ghost')]
                group by $ref := $ghost-refs
                order by $ref
                return <hoax-model:ghost-reference>{concat($ref, ' (', count($ghost-refs), ')')}</hoax-model:ghost-reference>
            }</hoax-model:ghost-references>
            <hoax-model:places>{
                (: TODO: Create field to avoid having to navigate the leading hash :)
                for $place in $places-doc//tei:place
                    [@xml:id = $article//tei:placeName[starts-with(@ref, '#')]/@ref ! substring(., 2)]
                return (: hoax:get-place-info($place) :) ()
            }</hoax-model:places>
            <hoax-model:people>{
                for $person in $persons-doc//tei:person[@xml:id = 
                        $article//tei:persName/@ref[starts-with(., '#')] 
                        ! substring(., 2)]
                return (: hoax:get-person-info($person) :) ()
                }
            </hoax-model:people>
        </hoax-model:aux>
    </hoax-model:result>
else 
    <hoax-model:no-result>None</hoax-model:no-result>
```

## Step 3: Further exploration
