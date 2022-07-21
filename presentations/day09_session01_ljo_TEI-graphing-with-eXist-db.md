# TEI Graphing with eXist-db 

Day 09 Session 01 slot 03

## Background
Initially created for the project *Dramawebben (The Swedish Drama Web)*. 

 * The project included a baselined corpus of TEI
drama annotated plays
 * Development of exploration and visualization
tools
 * Engaged a vibrant community
 * Educated students in TEI encoding and let them
be ambassadeurs spreading the word
 * Target disciplines within the humanities, such as
linguistics, literary and theater history, studies in
children’s culture, practical and theoretical
research in children’s theater, and arts tertiary
institutions.
 * For the parts relating to Dramawebben (The Swedish
Drama Web) I gratefully acknowledge financial
support from the Swedish Research Council (VR Dnr:
2011-6202).







## Overview
We combine parts of the TEI namesdates module, like
&lt;listPerson&gt; and &lt;listOrg&gt; with relations in
&lt;listRelation&gt; elements to create graphs of relations
between persons (cast and non-cast) and orgs or interaction
on stage (cast only) sociograms.






### Personal/organisational relations
 * Every &lt;person&gt; or &lt;org&gt; element can have zero
to many relations based on IDREF.

 * if "svg" (SVG) is used as output type we differentiate 
between persons and organisations in the graphs
by making the &lt;person&gt; nodes elliptic and the &lt;org&gt; ones
rectangular.

 * Similarily cast persons have a solid node outline while
non-cast persons have a dashed outline. This
is based on the @type attribute on the outmost 
ancestor &lt;listPerson&gt; elements. 

 * We have followed the default of three &lt;relation&gt;
@type values “personal”, “social”, and “other”.
These are represented by dashed, solid, and
dotted edges respectively.









### Sociograms
 * Sociograms are created dynamically and can
be created based on any criteria of what
constitutes interaction in your project.

 * These can also be weighted by giving a numeric
value to the @sortKey attribute of the &lt;relation&gt;
element.

 * Of course you can also create other types of
graphs based on dynamic data.











## Configuration parameters (a lot of them ...)
Configuration parameters can be given as a parameters element fragment, 
eg &lt;parameters&gt;&lt;param name='output' value='svg'/&gt;&lt;/parameters&gt;. 
The current parameters are the following with the default given as first value:

 * output: values 'svg', 'graphml', 'gexf'.
 * svg-width: (for svg output) 960 if less than 28 vertices, 
1200 if less than 56 vertices, 1600 if less than 83 vertices, and 2200 if more, integer value
 * svg-height: (for svg output) 600 if less than 28 vertices, 800 if less than 56 vertices,
 1000 if less than 83 vertices, and 1400 if more, integer value
 * svg-useedgeweight: true, boolean value, use weight on edges to make them thicker if true
 * svg-showedgelabels: true, boolean value, show edge labels if true
 * dashedstrokeorgs: false, boolean value, use dashed stroke for organisations if true
 * edgeshape: values 'line', 'bentline' ('bent'), 'box', 'cubiccurve' ('cubic'), 'loop',
 'orthogonal', 'quadcurve' ('quad'), 'simpleloop', 'wedge'.
 * layout: values 'frlayout' ('fr'), 'circlelayout' ('circle'), 'daglayout' ('dag'), 
'isomlayout' ('isom'), 'kklayout' ('kk'), 'springlayout' ('spring'), 'staticlayout' ('static')
 * maxiterations (for frlayout): 700, integer value
 * repulsionmultipier (for frlayout): 0.75, double value
 * attractionmultiplier (for frlayout): 0.75, double value
 *  maxiterations (for kklayout): 2000, integer value
 * adjustforgravity (for kklayout): true, boolean value
 * exchangevertices (for kklayout): true, boolean value
 * forcemultiplier (for springlayout): 1/3, double value
 * repulsionrange (for springlayout): 100, integer value
 * stretch (for springlayout): 0.7, double value
 * vertexlabelposition: values 'center', 'auto', 'east', 'north', 'northeast', 'northwest',
 'south', 'southeast', 'southwest', 'west'.
 * vertexlabelpositioner: values 'inside', 'outside'
 * vertexfillpaint: values 'white', 'gender' (female=ff7f97, male=6c9cd1, other=ffffff genders white),
 'age' (children=f9c05d, other=ffffff ages white), or any hexadecimal RGB colour value for all vertices.
 * removeunconnected: false, boolean value, remove unconnected group vertices from the graph if true
 * labeloffset: integer value.


## Query 1: Create an SVG graph over the relations
```xquery
xquery version "3.1";
import module namespace graphing="http://exist-db.org/xquery/tei-graphing";
declare namespace tei="http://www.tei-c.org/ns/1.0";
let $doc := doc("/db/data/dramawebben/StrindbergA_TillDamaskus/StrindbergA_TillDamaskus.xml")
(: doc("/db/data/dramawebben/HedbergF_Rospiggarna/HedbergF_Rospiggarna.xml") :)
return
graphing:relation-graph($doc//tei:listPerson[not(parent::tei:listPerson)], $doc//tei:listRelation,
                        <parameters><param name="output" value="svg"/></parameters>)
```

### Remember the basic shapes from yesterday?
 * Rectangle (rect)
 * Circle (circle)
 * Ellipse (ellipse)
 * Line (line)
 * Polyline (polyline)
 * Polygon (polygon)

Let us quickly look at one more (text):
```
<g fill="rgb(51,51,51)" text-rendering="optimizeLegibility" font-family="sans-serif" 
   transform="translate(299,266)" stroke="rgb(51,51,51)">
    <text x="0" xml:space="preserve" y="12" clip-path="url(#clipPath79)" 
                stroke="none">FruÖsterberg</text>
</g>
```







## Query 2: Create a graph over the relations, but in GraphML this time
```xquery
xquery version "3.1";
import module namespace graphing="http://exist-db.org/xquery/tei-graphing";
declare namespace tei="http://www.tei-c.org/ns/1.0";
let $doc := doc("/db/data/dramawebben/StrindbergA_TillDamaskus/StrindbergA_TillDamaskus.xml")
(: doc("/db/data/dramawebben/HedbergF_Rospiggarna/HedbergF_Rospiggarna.xml") :)
return
graphing:relation-graph($doc//tei:listPerson[not(parent::tei:listPerson)], $doc//tei:listRelation, 
                        <parameters><param name="output" value="graphml"/></parameters>)
```




## Query 3: Create a graph over the relations, but finally in gexf 
```xquery
xquery version "3.1";
import module namespace graphing="http://exist-db.org/xquery/tei-graphing";
declare namespace tei="http://www.tei-c.org/ns/1.0";
let $doc := doc("/db/data/dramawebben/StrindbergA_TillDamaskus/StrindbergA_TillDamaskus.xml")
(: doc("/db/data/dramawebben/HedbergF_Rospiggarna/HedbergF_Rospiggarna.xml") :)
return
graphing:relation-graph($doc//tei:listPerson[not(parent::tei:listPerson)], $doc//tei:listRelation, 
                        <parameters><param name="output" value="gexf"/></parameters>)
```

### The updated app
* Will support gexf 1.2 instead of gexf 1.2draft

## and finally a w3c and exist-db example to show it can do other graphs than from full TEI documents


![eXist-db related to W3C](./sources/exist-db-relations.svg)