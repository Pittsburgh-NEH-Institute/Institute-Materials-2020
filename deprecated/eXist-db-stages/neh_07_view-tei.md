# Creating a reading view in HTML

## Synopsis

In the preceding lesson we used XQuery to return part of the TEI XML content of a story chosen by the user. At that stage we returned the raw TEI XML; in this lesson we will convert the TEI XML to HTML. For now we will view the HTML with whatever styling the browser supplies by default; later we will enrich the HTML with CSS in order to implement our own styling.

Transforming XML to HTML using XQuery requires some background information, and this lesson is therefore divided into the following topics:

* Preparatory
	* Transformation as part of the Model–View–Controller (MVC) design pattern
	* Push and pull processing
	* Declarative programming, recursion, and *walking the tree*
	* Declaring your own XQuery functions
* Implementation
	* Introducing XQuery `typeswitch`
	* Outlining our XML
	* Writing the worker functions
	* Putting it all together … almost
	* Telling *controller.xql* about the new View
	* Wrapping the output in boilerplate

This lesson is longer than many of the others because of the new concepts that it introduces in the Preparatory sections. Much of that is background information that you can read once without trying to memorize it, just to familiarize yourself with the concepts. You’ll want, though, to pay careful attention to the Preparatory section about declaring your own functions, since we’ll be doing that extensively in the Implementation section.

## Preparatory sections

### Transformation and the Model–View–Controller design pattern

We mentioned earlier the [Model–View–Controller](https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93controller) (MVC) design pattern as a way of organizing an app, and [Siegel and Retter](http://shop.oreilly.com/product/0636920026525.do) relate this pattern to eXist-db URL explicitly when they write (2014: 203):

> URL rewriting is capable of more than just passing on or redirecting a request. It can also pass on the results of a forwarded request to a *pipeline* (a.k.a. sequence or view) of additional processing steps (usually XQuery and/or XSLT scripts).
> > The most common use case for this is probably the Model-View-Controller or MVC pattern, separating the application logic from its presentation. In the case of URL rewriting, *controller.xql* is the *controller* in the MVC pattern. Then we create an XML document, describing the contents of the response (but not its presentation). This becomes the *model* in the MVC pattern. Subsequent processing steps add the presentation to this, usually by transforming it to (X)HTML. This is the *view* in the MVC pattern.

In the previous lesson we used XQuery to select information from the collection of stories (specifically, part of the content of one story, ass specified by the user), which we returned as TEI XML using XQuery in the *read.xql* module. Had we wanted to return HTML instead of XML, we could have incorporated the code to transform the XML to HTML in that module, but we deliberately separated them, as in the MVC design pattern described above. There are several reasons for this separation, two of which are:

* We will perform the transformation to HTML using XQuery, but that task is also well suited to XSLT, and the two languages can work together smoothly within eXist-db. (We use XQuery in these lessons for pedagogical reasons, to avoid having to teach an additional programming language in a limited amount of time.) By separating the code that produces the model from the code that transforms it into the view, we can switch the transformation code from XQuery to XSLT later without having to touch *read.xql* or similar modules. 
* If our entire app consisted of only the *read.xql* module, the preceding wouldn’t seem like much of an advantage, but an important payoff accrues when we use the same code to transform XML to HTML for multiple modules. If the XQuery script that does the transformation to HTML is separate from the module that selects the data to present, we don’t have to repeat the same transformation instructions inside every module. This is consistent with a software development principle called DRY (Don’t Repeat Yourself), and the motivation is that repetitive code takes longer to write, and, especially, that it is more difficult to maintain without accidentally forgetting to change the repeated code everywhere it occurs. The extent to which we can reuse parts of the View will vary depending on the app, and we’ll examine some ways of organizing the code base as our app grows more complex over the course of this project.

### Push and pull processing

Transforming a document from TEI XML to HTML isn’t like retrieving information for reading, as we did in our *read.xql* module. The retrieval used *pull* processing, where we looked for specific information where we expected to find it; in this case we sought out the story we wanted and, once we had found it, we extracted the content we wanted from it. We will implement our transformation from TEI XML to HTML, though, using *push* processing, where we will push the document through a set of rules, each of which knows how to do one thing, such as how to transform a particular type of element. If pull processing is like ordering from a menu in a restaurant, push processing like [conveyer belt sushi](https://en.wikipedia.org/wiki/Conveyor_belt_sushi), where all dishes are always available and diners select what they want when they want it, as it passes by. With push processing, for example, one rule might convert a TEI `<p>` (paragraph) to an HTML `<p>` (these are not the same element because they are in different namespaces), another might convert a TEI `<item>` (list item) to an HTML `<li>`, etc. Every transformation rule has access to every node of the input as the document is pushed through the set of rules, and each rule selects and operates on the nodes it knows how to handle as the stream of nodes passes by. 

We can think of push processing as separating a statement that a particular node should be processed from the code that specifies how to perform that the processing. For example, we might say “process the child nodes of this element, whatever they might be” in one place, whhile the code that knows how to process each type of node would be located elsewhere. 

### Declarative programming, recursion, and walking the tree

XML documents in humanities research often contain great structural variety and deep hierarchical nesting, and they may make liberal use of *mixed content*, that is, elements that contain unpredictable combinations of plain text and other elements (which, in turn, may also contain mixed content). Since we cannot realistically predict all of the type of content we’ll encounter at different locations in a document we are transforming, we process the entire document with a *declarative* model that uses *recursion*, as follows:

1. We perform a complete, recursive, *depth-first* traversal of the document tree from the root element. *Recursion* in this context means is that at each location in the tree, after we handle the immediate location (e.g., process whatever node we have stopped at), we then look at its children, and then their children, and when we run out of children we look at following siblings in order (looking at children before siblings is what makes the traversal depth-first). Unless we say otherwise, this guarantees that we will visit every node in the tree. While a complete depth-first traversal is the most common way of walking a tree, we can also access any part of the tree from any other part, and we can omit parts we don’t care about. What matters is that we can visit and deal with every node in the tree that we do care about no matter how complex, varied, or unpredictable each document tree might be.
2. Instead of trying to anticipate what we might find at a particular location in the tree, which isn’t realistic given the aforementioned complexity, variability, and unpredictability of a lot of humanities XML, we define a set of proceedures for handling *every* type of node we might encounter *anywhere*, each of which is always available, and therefore available when our depth-first traversal runs into the data it knows how to handle. The way we implement this is that a *dispatcher* function is the first to see every node in the document, and it sends that node to a node-type-specific helper function that knows how to deal with it. This ensures that every node will be processed correctly without our having to predict where nodes of different types may or may not occur.

### Declaring your own XQuery function

Before we use XQuery `typeswitch` to manage our View we need to take a detour into user-defined XQuery functions. This will prepare us to write our own dispatcher and helper functions.

#### Function namespaces

XQuery functions are all in a namespace, including the functions in the standard library, but since those are in the default function namespace, eXist-db does not require us to declare it explicitly. What this means, though, is that when we write our own functions, we need to put them into a different namespace; if we don’t, eXist-db will look for them in the default namespace, fail to find them, and raise an error. You can declare and use you own namespace for this purpose, but eXist-db makes the `local:` namespace prefix available automatically for user-defined functions, without requiring an explicit namespace declaration, and we take advantage of that feature here.

#### Why declare your own function

User-defined functions provide a way of structuring your code that makes it easier to read, write, and maintain. It is possible to write XQuery programs without user-defined functions, but in the example below we will see how the use of functions improve legibility and  maintainability.

#### How to declare your own function

A minimal XQuery function declaration takes the following shape:

```xquery
declare function local:titleCase($input) {
    concat(upper-case(substring($input, 1, 1)), lower-case(substring($input, 2)))
};
```

This declaration will make a function called `local:titleCase()` available for your use. The keywords `declare function` initiate the declaration. The next part is the name that you’ll use to call the function, including its namespace prefix. The name must be followed by parentheses, inside which you specify parameter names (parameters are a type of variable, so their names must begin with a `$`) that you will use to refer to the input to the function when you operate on it. The parentheses are required even if the function does not accept any input. You can have as many input parameters as you want, called whatever you want, and they must be separated by commas. These parameters are available (the technical term is *in scope*) only inside the function. This means that if you have a different variable called `$input` elsewhere in your program, XQuery won’t confuse them, and it also means that this `$input` exists only inside your function, you can’t refer to it by name outside the function body. After the function name and its parentheses there is a set of curly braces, which contains the body of the function, that is, the code that the function executes. A function declaration, like any other declaration in XQuery, must end, after the closing curly brace, with a semicolon. The newlines and indentation are for human legibility, and XQuery will understand your code no matter how you lay it out.

The preceding function skeleton, then, declares a function called `local:titleCase()`, which takes one parameter and uses the standard library functions `concat()`, `upper-case()`, and `lower-case()` to process it and return a result. We describe what the processing does below.

In practice we strongly recommend declaring the datatypes and cardinality (optionality, repeatability) of your parameters and the return type, using the XQuery `as` keyword. Our declaration then looks like:

```xquery
declare function local:titleCase($input as xs:string) as xs:string {
    concat(upper-case(substring($input, 1, 1)), lower-case(substring($input, 2)))
};
```

Here we specify that the sole input parameter must be a string, that it is required, and that it is not repeatable (that is, “exactly one”), and that the function will return a string. Don’t omit the datatype declarations just because they are not strictly required; including them will help you find errors in your code that might pass unnoticed otherwise, and your code may also run more quickly because the processor can use the datatype information for optimization.

It’s easiest to read the nested functions inside the body from the inside out:

1. Apply the `substring()` function to whatever the input string is to select just the first character. 
2. Wrap that in the `upper-case()` function, which means that character will be converted to upper case. 
3. Use the `lower-case()` function around `substring()` similarly to convert all of the input string except the first character to lower case. 
4. Wrap the output of those two functions in the `concat()` function to fuse them together into a single string. 

XQuery automatically returns the result of evaluating the code inside the curly braces, which is to say that, unlike in some other programming languages, XQuery functions do not include an explicit `return` statement.

You can read about how `concat()`, `upper-case()`, and `lower-case()` work in the references listed on our [XQuery references page](/ref/xquery_references.md). In practice, although you’ll have to look up the standard library functions at first, while you are learning their names and their *signatures* (input parameters and return type), you will quickly memorize the ones you use frequently.

#### Testing your function

When you create your own functions, it’s wise to test them in isolation against all realistically possible input, and not just the ideal input that you have in mind when you create them. If you try to submit something that isn’t a single string, like an integer or a sequence of strings or an empty sequence (nothing at all) as input to this function, the type declaration will raise an error to alert you, but what if it’s a string that isn’t just a bunch of letters? For example, what happens when you try to convert something that doesn’t have case (digit, punctuation, space) using the standard functions? What happens when the input string has only a single character, so there is no remainder to convert to lower case? What if it’s the empty string? 

## Implementation sections

### Introducting XQuery `typeswitch`

#### The dispatcher

The XQuery `typeswitch` operator is a special if-then-else structure that can be used to take control of each node, as it is encountered, and send it to a function that knows how to process that type of node. A simplified application of `typeswitch` might look like the following function, which is called the *dispatcher* (adapted from <https://en.wikibooks.org/wiki/XQuery/Typeswitch_Transformations>):

```xquery
declare function local:dispatch($node as node()) as item()* {
    typeswitch($node)
        case text() return $node
        case element(bill) return local:bill($node)
        case element(btitle) return local:btitle($node)
        case element(section-id) return local:section-id($node)
        case element(bill-text) return local:bill-text($node)
        case element(strike) return local:strike($node)
        default return local:passthru($node)
};
```

Once we create our helper functions (see below), the dispatcher will ensure that all `text()` nodes and `<bill>`, `<btitle>`, `<section-id>`, `<bill-text>`, and `<strike>` elements in our input document are transformed to appropriate counterparts on output. The final `default` statement strips all other input markup without transforming it into anything else.

The `local:dispatch()` function accepts one argument, which must be a node (of any type), and returns zero or more items (that is, anything at all). What `typeswitch` does inside this function is test the type of a node, just returns it as is if it’s plain text, and otherwise sends it to a specialized helper function that knows how to handle it. The `case` statements mean “in case it’s plain text” (a `text()` node), “in case it’s a `<bill>` element”, etc. Although XQuery *functions* don’t require a `return` statement, the `case` statements in `typeswitch` use the keyword `return` to say “pass the node to the correct helper function, get the result, and then return (that is, output) that.”

#### Helper functions

Each of the helper functions that is specific to an element type will process the node and (most commonly) then pass its children into the dispatcher, which is how the system implements the depth-first traversal of the entire tree. The dispatcher ends with a default rule that handles nodes for which we have not declared a specific rule, and in this example that function just processes the children of the node. As we’ll see below, if the node is an element, this has the effect of throwing away the markup; if it is a comment or processing instruction it throws it away entirely, since those types of nodes don’t have children. 

The `local:bill()` helper function, to which the dispatcher passes `<bill>` input elements for handling, might look as follows:

```xquery
declare function local:bill($node as element(bill)) as element(Bill) {
    <Bill>{local:passthru($node)}</Bill>
};
```

This expects the input to be a single node that is a `<bill>` element and it outputs a `<Bill>` element and, inside it, passes the node to the passthru rule, which will process its children (see below). Most node-specific helper rules will be similar, although they can incorporate more complex XQuery logic, such as “create an `<A>` element in the output if my parent is `<X>` and a `<B>` element if my parent is `<Y>`”. This particular transformation throws away attributes, but we can also process them and output the results, if desired.

The `local:passthru()` rule just processes all of the children:

```xquery
declare function local:passthru($node as node()) as item()* {
    for $child in $nodes/node() return local:dispatch($child)
};
```

This receives a single node at a time and loops over its children, sending each of them to the dispatcher to ensure that they get routed to the rule that knows how to handle them. In this example all of the helper functions send their children there as part of creating a new output element, and the `default` statement essentially throws away the original markup and just sends the children to the passthru rule for processing, without creating a new output element.  

`typeswitch` expressions are namespace aware, so `case element(p)` will normally match a `<p>` element in no namespace. The exception is that if you have declared a default element namespace, `typeswitch` will match only `<p>` element in that namespace. If you are not using a default namespace, you need to use a namespace prefix that you have declared previously, e.g., `case element(tei:p)` if you have declared the `tei:` namespace prefix.

#### Running the transformation

We can start the transformation by passing the XML document (that is the document node that is the parent of the root element) to the dispatcher. This begins the depth-first traversal, and the script will run recursively until it has visited every node in the input tree.

### Outlining our XML

For every node type in the input that requires non-default processing the transformation script needs both a `case` statement inside the dispatcher and a matching helper function. This means that we might want to start developing the transformation script by compiling an inventory of the element types in the corpus. The most robust way to compile this list is to let XQuery do it for us, and XQuery can also write the dispatcher and create abbreviated placeholder helper functions. We do that with the *get_gis.xql* XQuery script in the *scratch* subcollection in the app for this lesson  (*GI* stands for *generic identifier*, which is the technical term for the name of an element type). 

This script is customized for our project; it reads the `<text>` elements of or stories, creates a sorted, deduplicated list of all element types, and uses that to create the dispatcher and skeletal helper functions (the technical term for functioning placeholder code during development is *stub*). (In addition to `<text>`, *read.xql* fetches the main document title from the `<teiHeader>`, but since there are also `<title>` elements inside `<text>`, the `case` statement and stub will be created for that element type, and we just have to remember to write our helper function to treat the main title differently from `<title>` elements inside `<text>`.) Since we will be creating HTML output, we let our script make the HTML namespace the default and we bind the TEI namespace to the traditional `tei:` prefix. The workflow is that we run *get_gis.xql* to create a skeletal XQuery script for transforming the output of *read.xql* to HTML, save it in the same *scratch* subcollection with the resource name *view_skeleton.xql*, and then edit it manually to edit the placeholder information.

### Writing the helper functions

#### Introduction

The outlining script generates a default helper function for each element type that reads, as in this example for the TEI `<ab>` element:

```xquery
declare function local:ab($node as element(tei:ab)) as element() {
    <GI>{local:passthru($node)}</GI>};
```

We have named the function after the element type, specified that the input to it is a single instance of that element type, and specified that it will output a single element. We’ve made this the default because it is what we’ll want to do in most cases, but if you want to output something other than a single element, you can change the datatype of the result. We’ve used a placeholder output element name of `<GI>`, which we’ll change to the name of the actual desired output element. We need a namespace for the input, but not the output, because we’ve declared the HTML namespace as the default. For better control we recommend specifying the name of the output element, e.g., `element(p)` intead of just `element()` when you are creating an HTML `<p>` element.

#### Processing the children

The helper function creates an output element and, inside it, processes its children by passing the element itself (not its children) to the passthru function. The passthru function reads:

```xquery
declare function local:passthru($node as node()) as item()* {
    for $child in $node/node() return local:dispatch($child)
```

which means that it iterates over the children of its input (that is, the children of the node we pass to it) and sends each of those nodes, one at a time, to the dispatcher for processing. Processing the children of every node in this way ensures a complete traversal of the input document, but if you want to exclude certain parts, or create their output in a particular order, you can specify that in the helper function.

#### Subcategorization

The `case` statements in `typeswitch` can test only for node type, and not for other properties, such as whether the node has a particular attribute, or an attribute with a particular value, or a particular parent, or whether it’s the first in a sequence of similar elements, or has a specific number of ancestors of a particular type, etc. One way to handle such conditions is to test for them in the `case` statement within `typeswitch`. The following `case` statement, an extract from within a `typeswitch`, passes control to different helper functions depending on the value of a `@rend` attribute on the input `<emph>` element. 

```xquery
case element(tei:emph) return 
    if ($node/@rend eq 'bold') 
    then local:embold($node)
    else local:italicize($node)
```

Alternatively, the XQuery `switch` statement (not ot be confused with `typeswitch`) provides a legible way of writing tests with more options:

```xquery
case element(tei:emph) return 
    switch($node/@rend)
        case 'bold' return local:embold($node)
        case 'italic' return local:italicize($node)
        case 'sc' return local:smallcap($node)
        default return ()
```   

One limitation is that `switch` can test only for atomic values, and adding even this much extra code inside the dispatcher can make it difficult to read and maintain. For that reason, we recommend doing any such testing inside the helper functions, rather than the dispatcher, especially if the tests are more complicated. For example, `typeswitch` might send all `<div>` elements to `local:div()`, which could use `switch` or `if–then–else` tests for triage. In the example below, we use `if–then–else` to tailor the output to the depth of nesting:

```xquery
declare function local:div($node as element(tei:div)) as element(section) {
    if (count($node/ancestor::tei:div) eq 0) 
    then <section class="section">{local:passthru($node)}</section>
        else if (count($node/ancestor::tei:div) eq 1) 
        then <section class="subsection">{local:passthru($node)}</section>
            else if (count($node/ancestor::tei:div) eq 2)
            then <section class="subsubsection">{local:passthru($node)}</section>
                else <section>{local:passthru($node)}</section>
};
```

There are other (and perhaps better) ways to manage sections differently depending on the depth of nesting, such as `switch` or omitting the `@class` attribute entirely and using CSS selectors to adapt the styling to the depth of nesting, but `if–then–else` remains an option in situations where the developer finds it clear and legible.

### Putting it all together … almost

When we add real HTML output to our helper functions we create an HTML fragment, but it isn’t wrapped in the higher-level HTML boilerplate: there are no `<html>`, `<head>`, or `<body>` elements. We explain below why we write that information separately; what’s important now is that the output is not yet valid HTML. In the next section we’ll integrate a call to our transformation script into *controller.xql* so that we can see the results, but because those results won’t be valid HTML, the browser may raise and error and refuse to display the file. In that case, we can execute a View source inside the browser and see the raw HTML, even if the browser cannot render it like a normal HTML document.

### Telling *controller.xql* about the new View

#### About pipelining

We are creating our output as a pipeline, that is, a sequence of steps, each of which 1) does one thing, and 2) passes its output along as the input into the next step. Pipeline development is makes it possible to develop the steps separately from one another, and test each one as it is added, so that when the code breaks, the developer knows which change caused the problem to surface. Pipeline development also makes it possible to change an intermediate step with minimal collateral damage. For example, if we want to change the rendering of an element, we can make the change in the script that performs the transformation (View), without touching the one that retrieves the information (Model). This separation is not entirely complete, though; for example, if we change the Model to extract additional elements from the source, we’ll need to ensure that the View knows how to transform that new content. But despite the inevitability of some degree of interdependence, the pipeline is easier to maintain that a single monolithic script.

#### Pipelining in our app

We modify *controller.xql* to pipe the Model, after it is created, into the script that creates the View as follows:

```xquery
<dispatch xmlns="http://exist.sourceforge.net/NS/exist">
    <forward url="{concat($exist:controller, '/modules', $exist:path, ".xql")}"/>
    <view>
        <forward url="{concat($exist:controller, '/views/reading_view.xql')}"/>
    </view>
</dispatch
```

Our earlier *controller.xql* had just the first `<forward>` statement inside the `<dispatch>` element. If we follow that with a `<view>` element that contains another `<forward>`, this will automatically forward the Model into the transformation script. If we want to perform an additional transformation of the output of the first one, we can add a second `<forward>` statement inside the `<View>`, and we’ll do that in the next section, when we add a boilerplate wrapper to make our output valid HTML.

When we forward the Model to *reading_view.xql*, though, we also need to tell *reading_view.xql* what to do with it. We do that by including, after all of the declarations in *reading_view.xql*, a single statement that launches the whole transformation:

```xquery
local:dispatch(request:get-data())
```

The `request:get-data()` function retrieves the Model, and by passing it (that is, its document node) into the dispatcher, we initiate the depth-first traversal that will transform the Model into the View.

Because the input into *reading_view.xql* is two elements (`<title>` from `<teiHeader>` and `<text>`), the output is an `<h1>` and a `<section>`, with no parent. Since this is not well-formed XML, let alone valid HTML, a web browser will raise an error, but we can see the output as raw HTML by using the View source feature of the browser. In the next—and final—section, we’ll wrap these two output elements in boilerplate and turn it into valid HTML.

### Wrapping the output in boilerplate

Our app will have a common format for all pages, including perhaps some sort of banner heading, menu navigation, or other boilerplate features. Since that information will be common to all pages, even though both the Model and the View may vary depending on the type of information requested by the user, we pipe the output of *reading_view.xql* into a second XQuery script to wrap it in this information. The wrapper will add the `<html>`, `<head>`, and `<body>` tags required in valid HTML. We’ll enhance this later by linking to CSS for styling, customizing the `<title>` inside the HTML `<head>`, and in other ways, but for now our goal is to produce somewhat simplified valid HTML.

eXist-db can pass information in a pipeline by using *session attributes* (not the same thing as XML attributes). Specifically, we will set an attribute in *reading_view.xql* that holds the output of the transformation, and we will access that inside our new *wrapper.xql* to use it.

The controller declares the full pipeline as follows:

```xml
<dispatch xmlns="http://exist.sourceforge.net/NS/exist">
    <forward url="{concat($exist:controller, '/modules', $exist:path, '.xql')}"/>
    <view>
        <forward url="{concat($exist:controller, '/views/reading_view.xql')}"/>
        <forward url="{concat($exist:controller, '/views/wrapper.xql')}"/>
    </view>

    <cache-control cache="no"/>
</dispatch>
```

The first `<forward>` statement takes the original URL and rewrites it, so that *read.xql* (in the *modules* subcollection) retrieves TEI XML from the requested story. What it retrieves is not a valid TEI document, or even a well-formed one; it is a sequence of one `<title>` element (from the `<teiHeader>`) and the `<text>`. (The technical term for XML that would be valid except that it lacks a surrounding root element is that it is *well balanced*.) The well-balanced TEI XML output of that retrieval is automatically passed into the View, where the first of the two `<forward>` statements there uses `typeswitch` to transform the TEI XML to HTML. We change the last line of that file to store the result of the transformation of a session attribute, which we create with the name `html`:

```xquery
request:set-attribute('html', local:dispatch(request:get-data()))
```

This step does not produce any regular output (or, more technically, it does not write to *stdout*); it just creates an attribute to hold the result.

The next step in the pipeline, *wrapper.xql*, reads as follows (in its entirety):

```xquery
xquery version "3.1";
declare default element namespace "http://www.w3.org/1999/xhtml";
<html>
    <head><title>Hi, Mom!</title></head>
    <body>{request:get-attribute('html')}</body>
</html>
```

We are creating just temporary, placeholder wrapper information, and we can retrieve the value of the `html` attribute that we created by using the eXist-db `request:get-attribute()` function. The output of our pipeline is now valid HTML. The wrapper has no real content and the page looks like a [generic supermarket cereal box](https://i.pinimg.com/originals/f3/90/d6/f390d6acf0ed11aa7ea51d26e730ad4c.jpg), but we’ll start to fix that in the next lesson.

## Optional (advanced)

### HTML templating

Our *wrapper.xql* pipeline step mimics a functionality that eXist-db also implements, in another way, as [HTML templating](https://exist-db.org/exist/apps/doc/templating). The point of templating is that on many sites, including the one our app presents, pages will have a common outer core, with the same stable (or largely stable) boilerplate information, which surrounds different core content on different pages, depending on what the user requests. In this way the parts of the page that don’t change are implemented directly in HTML, and the parts that do change are generated on demand with XQuery. The HTML templates use attribute values (some eXist-db specific, but also the standard HTML `@class` attribute) to tell eXist-db where to inject certain generated content (eXist-db calls this *parameter injection*). We mimic this functionality using pure XQuery partially for pedagogical reasons, that is, to avoid having to learn the conventions that eXist-db HTML templating observes. But we also are not persuaded that learning the conventions of eXist-db HTMl templating is really cleaner or easier to maintain than using pure XQuery. What is most important for maintenance is separating the stable from the variable parts of the page, which can be done in different ways.

### XQuery or XSLT?

The XML family of standards supports two broadly capable XML-oriented programming languages, XSLT (eXtensible Stylesheet Language Transformations) and XQuery. XSLT excels at transforming a single XML document to something else (commonly HTML, although other output formats are supported), but it is also capable of working with collections of documents in a database-like way. XQuery excels at working with collections of documents in a database-like way, but it is also capable of transforming a single XML document to something else. The two language can be used together easily, and developers who are comfortable with both are most likely to use XQuery for database operations over collections and XSLT to transform the results retrieved with XQuery. On the other hand, developers who are more comfortable in one language than the other may use only that one for all purposes. 

As was noted above, our Institute uses XQuery for all purposes, including transformation, for pedagogical reasons, that is, to avoid having to learn an additional programming language in a limited amount of time. Although the [XQuery WikiBook](https://en.wikibooks.org/wiki/XQuery/Benefits) writes correctly that “typeswitch enables XQuery to perform nearly the full set of transformations that XSLT does”, there are important differences in the way those transformations are performed:

1. The XSLT developer typically creates `<xsl:template>` elements to process different types of nodes, and this is analogous to the individual, node-type-specific functions to which XQuery `typeswitch` passes nodes for processing. But to add processing for each additional element type using XQuery `typeswitch`, the developer has to both create the handler function (which is analogous to writing a new `<xsl:template>` in XSLT) and add a new `case` statement to the dispatcher (a step not required in XSLT). Not only is this extra effort, but because the two have to be kept in sync, it creates an opportunity for inconsistency or error. The reason for this difference is that the dispatch logic is baked into XSLT, but the developer has to create it explicitly in XQuery. 
1. XQuery `typeswitch` matches only by node type (most commonly by element name), while XSLT templates can match XPath patterns of any complexity. This means that XQuery must use `if` statements or other triage methods (such as `switch`, not to be confused with `typeswitch`) after identifying the node type in order to manage a choice among richer contexts that might have been expressed in a more declarative manner in XSLT, as the value of the `@match` attribute on `<xsl:template>`. The technical term for this difference is that XSLT, but not XQuery, supports *multiple dispatch*. Although both XSLT and XQuery are commonly described as *declarative* languages, the implementation of *multiple dispatch* gives XSLT a more consistent declarative profile.

If you are already comfortable with XSLT (or would like to become comfortable with XSLT), we encourage you to explore performing the transformation to HTML with XSLT instead of the XQuery we employ here.