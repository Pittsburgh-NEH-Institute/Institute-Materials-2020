# Expanding the model

## Let's get a list of places in the hoax-model namespace

We copy our statements first. Recall that a *statement* does not evaluate to anything-- it sets information that we'll want to use later on when we write *expressions*:

```
xquery version "3.1";

(: 
 : By copying Leif-Jöran's module from yesterday (notice that we're saving these as modules now!), we can easily adapt and expand on existing code.
 :)

(:===
Declare namespaces
==:)
declare namespace hoax = "http://obdurodon.org/hoax";
declare namespace hoax-model = "http://www.obdurodon.org/model";
declare namespace tei = "http://www.tei-c.org/ns/1.0";
```

Next, we'll copy our variables that set the path to access data. Recall that these are freebies from eXist-db!
```
(:===
Declare global variables to path
===:)
declare variable $exist:root as xs:string := 
    request:get-parameter("exist:root", "xmldb:exist:///db/apps");
declare variable $exist:controller as xs:string := 
    request:get-parameter("exist:controller", "/pr-app");
declare variable $path-to-data as xs:string := 
    $exist:root || $exist:controller || '/data';
```

Now we can start to get the data we want to extract! That data is in `aux_xml/places.xml`, so let's define a variable that takes us there.
```
(:===
Declare variables to get place.xml
===:)
declare variable $place-coll := collection($path-to-data || '/aux_xml');
declare variable $places as element(tei:TEI)+ := $place-coll//tei:listPlace;

```







