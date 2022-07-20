# Data Visualization
> "The majority of information graphics, for instance, are shaped by the disciplines from which they have sprung: statistics, empirical sciences,
and business. Can these graphic languages serve humanistic fields where interpretation, ambiguity, inference, and qualitative judgment take priority
over quantitative statements and presentations of “facts”?
Drucker, Johanna. *Graphesis: Visual Forms of Knowledge Production*. Harvard University Press, 2014.

## Discussion
- What kinds of visualizations have you already made from your data?
- What specific choices did you make? Think about moments of indecision or grey area.
- What about that visualization are you unable to describe with human language? (Tricky, I realize).
- How would you frame your question or inquiry to help guide your visualization decisions?

## Build the model
First, we create a new file in the 'modules' subdirectory.

### Housekeeping (Statements)
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
declare variable $exist:controller as xs:string := request:get-parameter("exist:controller", "/REPLACE");
declare variable $path-to-data as xs:string := $exist:root || $exist:controller || '/data/hoax_xml';
```

### Expressions
Great, we're going to keep the model for this very simple. We're interested in representing five pieces of information.
- Article title
- ID
- Publication date
- word count
- place count

We won't build the full model together, so I'm going to have you copy and paste the following code, I'm going to explain it, and then we'll move to working on view.

```
<m:articles>{
    for $article in collection($path-to-data)/tei:TEI
        let $title as xs:string := $article/descendant::tei:titleStmt/tei:title/string()
        let $date as xs:string := $article/descendant::tei:sourceDesc/descendant::tei:bibl/tei:date/@when 
                                    => string()
        let $id as xs:string := $article/@xml:id ! string()
        let $wc as xs:integer := tokenize($article//tei:body) => count()
        let $pc as xs:integer := $article//tei:body//tei:placeName 
                        => count()
    return    
        <m:article>
            <m:title>{$title}</m:title>
            <m:date>{$date}</m:date>
            <m:id>{$id}</m:id>
            <m:wc>{$wc}</m:wc>
            <m:pc>{$pc}</m:pc>
        </m:article>
}

</m:articles>
```

## Build the view: axes
First, we create a new file in the 'views' subdirectory.

### Housekeeping (Statements, but we'll come back to these later)
```
declare namespace html="http://www.w3.org/1999/xhtml";
declare namespace m="http://www.obdurodon.org/model";
declare namespace svg="http://www.w3.org/2000/svg";

declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:method "xml";
declare option output:indent "no";

declare variable $data as document-node() := request:get-data();
```

### Expressions
We confirm the controller is passing the data appropriately.
```
<html:section>
	<html:h2>Article word count and place count</html:h2>
	{data}
</html:section>
```

Next, we can start drawing SVG. We use some of the same concepts we did earlier, but I'm going to provide some hard numbers that will definitely work, even though we should calculate them with variables later on. In your Real Life, the trial and error of this might be more time consuming. Let's do draw the x-axis first.

```
<html:section>
<html:h2>Article length and place count</html:h2>
<svg:svg width="95%" viewBox="-100 -746 2150 796">
    <!-- draw x-axis -->
	<svg:line x1="0" 
       		y1="0" 
           	x2="1000" 
            	y2="0" 
            stroke="black"/>

</svg:svg>
</html:section>
```

That's not really a great way to draw an x-axis though, because we might need more or less space than that. If we're going to end up drawing one equal sized rectangle for each article, *how can we calculate the length of the x-axis?*

### Statements

```
declare variable $article-count as xs:integer := $data//m:article => count();
declare variable $x-axis as xs:integer := ($article-count * 30) + 30;
```

We give each article rectangle 30 pixels, plus 15 on each side to keep things legible.

### Expressions
Now that we have `x-axis` declared, we can slot that in.
```
<svg:line x1="0" 
       		y1="0" 
           	x2="{$x-axis}" 
            	y2="0" 
            stroke="black"/>
```

Great! Now we draw the other axes.
```
<!-- draws left y-axis -->            
         <svg:line  x1="0"
                    y1="0" 
                    x2="0" 
                    y2="-{$y-axis-height + 20}" 
                    stroke="black"/>
        <!-- draws right y-axis -->
         <svg:line  x1="{$x-axis}"
                    y1="0" 
                    x2="{$x-axis}" 
                    y2="-{$y-axis-height + 20}" 
                    stroke="black"/>
```

How would we decide on a y-axis height? We need to account for both the height of the word counts and the height of the place counts.

### Statements

```
declare variable $word-count-max as xs:double := $data/descendant::m:word-count => max();
declare variable $y-axis-height as xs:double := $word-count-max div 10; 
```

We choose a scale factor of -10x so we can have a manageable y-axis length.

## Build the view: rectangles
We need to use a higher order function. This is just a special way of calling a function so that either its input or output is a function too (read more on page 191 of *XQuery for Humanists*). Let's not sweat the syntax right now and just take a look at what this is doing.

```
for $article at $pos in ($data/descendant::m:by-article/m:article =>
         sort((),function($a){$a/m:date}))
    return
        <svg:rect
            x="{45}" 
            y="{-$y-axis-height}" 
            width="30" 
            height="{$y-axis-height}"/> 
```

Pseudo code for every article