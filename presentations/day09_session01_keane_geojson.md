# Making GEOJSON: Maps, arrays, and JSON

## Resources
[GEOJSON.io](https://geojson.io/#map=2/22.4/0.0)

## Definitions

### What's JSON?
JavaScript Object Notation

A way of defining objects in JavaScript.

JavaScript is a programming language that is often used for creating interactivity and movement on webpages. We won't be learning JavaScript as part of this institute, but we will be using a JavaScript library to draw geographic data points onto a map. More on that on Thursday.

### What are maps and arrays?

> A map is a collection of key/value pairs that can be constructed, manipulated, and queried in XQuery 3.1. Each key/value pair is known as an entry. Within a map, each key is unique and the order of the entries has no particular significance.
*XQuery, Second edition, Priscilla Walmsley, pg 369*

It looks like this:
```
map{
	"LDN": "London",
	"HMS": "Hammersmith",
	"PKM": "Peckham"
}
```

>An array is simply an ordered list of values. The values in an array are called its members, and they can be retrieved based on their position number.
*XQuery, Second edition, Priscilla Walmsley, pg 378*

It looks like this:
```
["London", "Hammersmith", "Peckham"]
```

These are both valid XQuery.

### What's GEOJSON?
A standardized way to encode geographic data in JSON. The format is widely used by web-based mapping tools. We want to use it when we use Mapbox later this week.

```
{
  "type": "FeatureCollection",
  "features": [
    {
      "type": "Feature",
      "properties": {},
      "geometry": {
        "type": "Point",
        "coordinates": [
          -82.265625,
          38.8225909761771
        ]
      }
    }
  ]
}
```

### A problem
We have our data in XML, and it's really difficult to transform something to JSON using XQuery by declaring variables and listing outputs for one significant reason: overlapping syntax. Doesn't GEOJSON kind of look like XQuery? In fact, isn't that GEOJSON set of maps and arrays *exactly* valid XQuery on its own?

Yes, so we have two functions that are going to help here. Let's use `xml-to-json()` and `json-to-xml()` (XQuery for Humanists, 278-279).

Start a new XQuery file and add some declarations that will be useful later on.


```
xquery version "3.1";

declare namespace output= "http://wwww.w3.org/2010/xslt-xquery-serialization";
declare namespace m= "http://www.obdurodon.org/model";
declare option output:media-type "application/json";
declare option output:indent "yes";

```







# Using the Mapbox JavaScript Library to render a map