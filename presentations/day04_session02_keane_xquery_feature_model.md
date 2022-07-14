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
declare variable $places as element(tei:TEI)+ := $place-coll//tei:TEI;

```

Next, we want to write some output. We'll steal from titles.xql in this case too.

```
<hoax-model:places> 
{
    for $place in $places
    return
        <hoax-model:place>
        { 
            $place//tei:place/tei:placeName ! string(.)
        }
        </hoax-model:place>
}
</hoax-model:places>
```

What does the output look like?
```
<hoax-model:places xmlns:hoax-model="http://www.obdurodon.org/model">
    <hoax-model:place>London The Lord Mayor's Mansion House Hampstead Hampstead Ilford Kensington Peckham Acton Fulham North-end Chiswick-lane Kew Bow Street Magistrates Court Turnham Green Hammersmith Webb's Lane Brandenburgh House Margrave of Anspach's Starch Green Angel Lane Angel Public House the field adjacent Black-lion Lane Black-lion Lane Black Lion Pub alley between Beaver Lane and Black-lion Lane White Hart Public House Holborn St. Paul's Cathedral Fetter-lane St. Dunstan's-in-the-West Westminster Whitehall St. James's Park The Royal Cockpit St. James's Canal London-street, Dockhead Bermondsey Grange road United States of America Stone/Hayden Residence France Cock Lane St. Sepulchre Clerkenwell Pentonville French Colony Rhode Island New York Auburn Arcadia Bath Wolverton Station Holy Trinity Church Wolverton Churchyard London Bridge Gützkow Wolgast Usedom Strellin Dammbecke Hatton Garden Hatton Garden Police Station White Conduit House Islington Copenhagen House Cut-throat Lane Haggerstone Haggerstone Church Yard, St Marys Station-house at Robert Street Hull Anlaby-road (sic) Wellington Lane Cardross Drumhead Sale The Brooklands Sale Canal Altrincham</hoax-model:place>
    <hoax-model:place/>
</hoax-model:places>
```

### Where are we going wrong?
<details>
	<summary>Here's the fix:</summary>
	
```
declare variable $place-coll := doc($path-to-data || '/aux_xml/places.xml');
declare variable $places as element(tei:place)+ := $place-coll//tei:place;

<hoax-model:places> 
{
    for $place in $places
    return
        <hoax-model:place>
        { 
            $place/tei:placeName ! string(.)
        }
        </hoax-model:place>
}
</hoax-model:places>
```

What changed?
1. instead of looking at a collection, we're just looking at one document. So we want to use the doc() function instead of the collection() function.
2. We don't care about the whole TEI document, we just care about each place in it. Let's get those rather than getting TEI elements.
3. Now we can iterate over the sequence of place elements instead of trying to iterate on something like `listPlace`, of which there's only one.

</details>

### What should we add next?
Let's add the latitude and longitude!

<details>
  <summary>add geo</summary>

```
<hoax-model:places> 
{
    for $place in $places
    return
        <hoax-model:place>
            <hoax-model:name>
                {$place/tei:placeName ! string(.)}
            </hoax-model:name>
            <hoax-model:geo>
                {$place/tei:location/tei:geo ! string(.)}
            </hoax-model:geo>
        </hoax-model:place>
}
</hoax-model:places>
```

</details>

Looks excellent, but it's getting kind of hard to read, and harder to control the data. Let's put everything in `let` statements so we can do some datatyping and keep everything tidy.

<details>
	<summary>use let statements</summary>
	
```
<hoax-model:places> 
{
    for $place in $places
        let $name as xs:string* := $place/tei:placeName ! string(.)
        let $geo as xs:string* := $place/tei:location/tei:geo ! string(.)
    return
        <hoax-model:place>
            <hoax-model:name>
                {$name}
            </hoax-model:name>
            <hoax-model:geo>
                {$geo}
            </hoax-model:geo>
        </hoax-model:place>
}
</hoax-model:places>
```	
</details>

Okay! That's some good looking XQuery. Let's address the latitude and longitude separately and as numbers rather than strings.

<details>
	<summary>geo string surgery</summary>
	
```
<hoax-model:places> 
{
    for $place in $places
        let $name as xs:string* := $place/tei:placeName ! string(.)
        let $geo as element(tei:geo)? := $place/tei:location/tei:geo
        let $lat as xs:double := substring-before($geo, " ") ! number(.)
        let $long as xs:double := substring-after($geo, " ") ! number(.)
    return
        <hoax-model:place>
            <hoax-model:name>
                {$name}
            </hoax-model:name>
            <hoax-model:geo>
                <hoax-model:lat>{$lat}</hoax-model:lat>
                <hoax-model:long>{$long}</hoax-model:long>
                
            </hoax-model:geo>
        </hoax-model:place>
}
</hoax-model:places>
```	

</details>

Last thing we care about today: I don't care about places that don't have any geo information. This is because they're just parent elements of other places. How can we ensure we only return a result when there's a geo element present?

<details>
	<summary>filtering results</summary>


```
<hoax-model:places> 
{
    for $place in $places
        let $name as xs:string* := $place/tei:placeName ! string(.)
        let $geo as element(tei:geo)? := $place/tei:location/tei:geo
        let $lat as xs:double := substring-before($geo, " ") ! number(.)
        let $long as xs:double := substring-after($geo, " ") ! number(.)
        where $geo
    return
        <hoax-model:place>
            <hoax-model:name>
                {$name}
            </hoax-model:name>
            <hoax-model:geo>
                <hoax-model:lat>{$lat}</hoax-model:lat>
                <hoax-model:long>{$long}</hoax-model:long>
                
            </hoax-model:geo>
        </hoax-model:place>
}
</hoax-model:places>
```

</details>








