# Find all the TEI elements used / attribute values used / etc
Day 07 Session 04 slot 02->03
 Hoax data.

## Building on the previous known structure
We follow the pattern of adding a few new things to our already well known query structure.

### New 1: Declare default collation (for your information, for next steps)
```xquery
(: New declaration for the institute: :)
declare default collation "http://exist-db.org/collation?lang=sv-SE;strength=primary;decomposition=standard";
```

### New 2:  Optional second argument on how to do the comparison with distinct-values()
```xquery
(: Note the optional second argument on how to do the comparison :)
let $element-names-d := distinct-values($element-names, 
                        "http://www.w3.org/2005/xpath-functions/collation/codepoint")
```

## Alternative 0: Get all elements (most frequent = p)
```xquery
 let $elements := $articles/descendant-or-self::tei:*
```

## Alternative 1: Get all attributes (most frequent = @ref)
```xquery
(: for all attributes: :) 
let $elements := $articles/descendant-or-self::tei:*/attribute()
```

## Alternative 2: Get all line groups (count = 15)
```xquery
(: for all lg elements: :) 
let $elements := $articles/descendant-or-self::tei:lg
```

## List the elements in use in different ordering
```xquery
    (: (<doc-order>{$element-names-d}</doc-order>, 
        <alpha-order>{$alpha-sorted-names}</alpha-order> :) 
```

## The full code for elements and attributes, or line groups only

```xquery
xquery version "3.1";
(: 
 : elements, counting etc
 :  
 :)

(:
 : Declare namespaces
 :)
declare namespace m = "http://www.obdurodon.org/model";
declare namespace tei = "http://www.tei-c.org/ns/1.0";
declare namespace svg="http://www.w3.org/2000/svg";

(: New declaration for the institute: :)
declare default collation "http://exist-db.org/collation?lang=sv-SE;strength=primary;decomposition=standard";


(:
 : Declare variables
 :)
declare variable $exist:root as xs:string := 
    request:get-parameter("exist:root", "xmldb:exist:///db/apps");
declare variable $exist:controller as xs:string := 
    request:get-parameter("exist:controller", "/06-controller");
declare variable $path-to-data as xs:string := 
    $exist:root || $exist:controller || '/data';
(: 
 : Declare some more variables
 :)
declare variable $articles-coll := collection($path-to-data || '/hoax_xml');
declare variable $articles as element(tei:TEI)+ := $articles-coll/tei:TEI;
declare variable $aux-coll := collection($path-to-data || '/aux_xml');
declare variable $persons as element(tei:listPerson)+ := $aux-coll/tei:TEI//tei:listPerson;

(: for all attributes: let $elements := $articles/descendant-or-self::tei:*/attribute() :)
(: for all lg elements: let $elements := $articles/descendant-or-self::tei:lg :)
let $elements := $articles/descendant-or-self::tei:*
let $element-names := $elements/name()
(: Note the optional second argument on how to do the comparison :)
let $element-names-d := distinct-values($element-names, 
                        "http://www.w3.org/2005/xpath-functions/collation/codepoint")
(: Not the covention of anonymous variable, for only ordering, could just as well be   :)
let $alpha-sorted-names := for $_ in $element-names-d order by $_ return $_
return
    (: (<doc-order>{$element-names-d}</doc-order>, 
        <alpha-order>{$alpha-sorted-names}</alpha-order> :)
  <elements>{
    for $element in $element-names-d 
    let $count := count(index-of($element-names, $element))
    order by $count descending
    return 
      <element>
        <name>{$element}</name>
        <count>{$count}</count>
      </element>
  }</elements>
```