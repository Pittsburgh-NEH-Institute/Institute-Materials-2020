# Creating a reading view in HTML

## Synopsis

In the preceding lesson we used XQuery to return part of the TEI XML content of a story chosen by the user. At that stage we returned the raw TEI XML; in this lesson we will convert that TEI XML to HTML. We will view the HTML with whatever styling the browser supplies by default; later we will enrich the HTML with CSS in order to implement our own styling.

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
	* Putting it all together
	* Telling *controller.xql* about the new View

This lesson is longer than many of the others because of the new concepts that it introduces in the Preparatory sections. Much of that is background information that you can read once without trying to memorize it, just to familiarize yourself with the concepts. You’ll want, though, to pay especially careful attention to the Preparatory section about declaring your own functions, since we’ll be doing that extensively in the Implementation section.

## Preparatory sections

### Transformation and the Model–View–Controller design pattern

We mentioned earlier the [Model–View–Controller](https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93controller) (MVC) design pattern as a way of organizing an app, and [Siegel and Retter](http://shop.oreilly.com/product/0636920026525.do) relate this pattern to eXist-db URL explicitly when they write (2014: 203):

> URL rewriting is capable of more than just passing on or redirecting a request. It can also pass on the results of a forwarded request to a *pipeline* (a.k.a. sequence or view) of additional processing steps (usually XQuery and/or XSLT scripts).
> > The most common use case for this is probably the Model-View-Controller or MVC pattern, separating the application logic from its presentation. In the case of URL rewriting, *controller.xql* is the *controller* in the MVC pattern. Then we create an XML document, describing the contents of the response (but not its presentation). This becomes the *model* in the MVC pattern. Subsequent processing steps add the presentation to this, usually by transforming it to (X)HTML. This is the *view* in the MVC pattern.

In the previous lesson we used XQuery to select information from the collection of stories (specifically, part of the content of one story, ass specified by the user), which we returned as TEI XML using XQuery in the *read.xql* module. Had we wanted to return HTML instead of XML, we could have incorporated the code to transform the XML to HTML in that module, but we deliberately separated them, as in the MVC design pattern described above. There are several reasons for this separation, two of which are:

* We will perform the transformation to HTML using XQuery, but that task is also well suited to XSLT, and the two languages can work together smoothly within eXist-db. (We use XQuery in these lessons for pedagogical reasons, to avoid having to teach an additional programming language in a limited amount of time.) By separating the code that produces the model from the code that transforms it into the view, we can switch the transformation code from XQuery to XSLT later without having to touch *read.xql*. 
* If our entire app consisted of only the *read.xql* module, the preceding wouldn’t seem like much of an advantage, but an important payoff accrues when we use the same code to transform XML to HTML for multiple modules. If the XQuery script that does the transformation to HTML is separate from the module that selects the data to present, we don’t have to repeat the same transformation instructions inside every module. This is consistent with a software development principle called DRY (Don’t Repeat Yourself), and the motivation is that repetitive code takes longer to write, and, especially, that it is more difficult to maintain without accidentally forgetting to change the repeated code everywhere it occurs. The extent to which we can reuse parts of the View will vary depending on the app, and we’ll examine some ways of organizing the code as our app grows more complex over the course of this project.

### Push and pull processing

Transforming a document from TEI XML to HTML isn’t like retrieving information for reading, as we did in our *read.xql* module. The retrieval uses *pull* processing, where we look for specific information where we can expect to find it; in this case we seek out the story we want and, once we’ve found it, we extract the content we want from it. We will implement our transformation from TEI XML to HTML, though, using *push* processing, where we will push the document through a set of rules, each of which knows how to do one thing, such as how to transform a particular type of element. For example, one rule might convert a TEI `<p>` (paragraph) to an HTML `<p>` (these are not the same element because they are in different namespaces), another might convert a TEI `<item>` (list item) to an HTML `<li>`, etc. Every transformation rule has access to every node of the input as the document is pushed through the set of rules, and each rule selects and operates on the nodes it knows how to handle as the stream of nodes passes by. 

We can think of push processing as separating an instruction to process a particular node from the code that specifies how to perform that the processing. For example, we might say “process the child nodes of this element, whatever they might be” in one place, whhile the code that knows how to process each type of node (most common text and different types of elements) would be located elsewhere. 

### Declarative programming, recursion, and walking the tree

XML documents in humanities research often contain great structural variety and deep hierarchical nesting, and they may make liberal use of *mixed content*, that is, elements that contain unpredictable combinations of plain text and other elements (which, in turn, may contain mixed content). Since we cannot realistically predict all of the type of content we’ll encounter at different locations in a document we are transforming, we process the entire document with a *declarative* model that uses *recursion*, as follows:

1. We perform a complete, recursive, depth-first traversal of the document tree from the root element. *Recursion* in this context means is that at each location in the tree after we handle the immediate content (e.g., process whatever node we have stopped at) we then look at its children, and then their children, and when we run out of children we look at following siblings in order. Unless we say otherwise, this guarantees that we will visit every node in the tree. While a complete depth-first traversal is the most common way of walking a tree, we can also access any part of the tree from any other part, and we can omit parts we don’t care about. What matters is that we can visit and deal with every node in the tree that we do care about no matter how complex, varied, or unpredictable each document tree might be.
2. Instead of trying to anticipate what we might find at a particular location in the tree, which isn’t realistic given the aforementioned complexity, variability, and unpredictability of a lot of humanities XML, we also define a set of proceedures for handling *every* type of node we might encounter *anywhere*. Specifically, at every node during our traversal a *dispatcher* function sends that node to a rule that knows how to deal with it. This ensures that every node will be processed correctly without our having to predict where nodes of different types may or may not occur.

### Declaring your own XQuery function

Before we use XQuery `typeswitch` to manage our View we need to take a detour into user-defined XQuery functions. This will prepare us to write our own functions, which, under the management of `typeswitch`, will perform the transformation from XML to HTML.

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

This declaration will make a function called `local:titleCase()` available for your use. The keywords `declare function` initiate the declaration. The next part is the name that you’ll use to call the function, including its namespace prefix. The name must be followed by parentheses, inside which you specify parameter names (parameters are a type of variable, so their names must begin with a `$`) that you will use to refer to the input to the function when you operate on it. The parentheses are required even if the function does not accept any input. You can have as many input parameters as you want, called whatever you want, and they must be separated by commas. These parameters are available (the technical term is *in scope*) only inside the function. This means that if you have a different variable called `$input` elsewhere in your program, XQuery won’t confuse them, and it also means that `$input` exists only inside your function, you can’t refer to it by name outside the function body. After the function name and its parentheses there is a set of curly braces, which contains the body of the function, that is, the code that the function executes. A function declaration, like any other declaration in XQuery, must end with a semicolon. The newlines and indentation are for human legibility, and XQuery will understand your code no matter how you lay it out.

The preceding function skeleton, then, declares a function called `local:titleCase()`, which takes one parameter and uses the standard library functions `concat()`, `upper-case()`, and `lower-case()` to process it and return a result. We describe what the processing does below.

In practice we strongly recommend declaring the datatypes and cardinality (optionality, repeatability) of your parameters and the return type, using the XQuery `as` keyword. Our declaration then looks like:

```xquery
declare function local:titleCase($input as xs:string) as xs:string {
    concat(upper-case(substring($input, 1, 1)), lower-case(substring($input, 2)))
};
```

Here we specify that the sole input parameter must be a string, that it is required, that it is not repeatable (that is, “exactly one”), and that the function will return a string. Don’t omit the datatype declarations just because they are not strictly required; including them will help you find errors in your code that might pass unnoticed otherwise.

It’s easiest to read the nested functions inside the body from the inside out:

1. Apply the `substring()` function to whatever the input string is to select just the first character. 
2. Wrap that in the `upper-case()` function, which means that character will be converted to upper case. 
3. Use the `lower-case()` function around `substring()` similarly to convert all of the input string except the first character to lower case. 
4. Wrap the output of those two functions in the `concat()` function to fuse them together into a single string. 

XQuery automatically returns the result of evaluating the code inside the curly braces, which is to say that, unlike in some other programming languages, XQuery functions do not include an explicit `return` statement.

You can read about how `concat()`, `upper-case()`, and `lower-case()` work in the references listed on our [XQuery references page](/ref/xquery_resources.md). In practice, although you’ll have to look up the standard library functions at first, while you are learning their names and their *signatures* (input parameters and return type), you will quickly memorize the ones you use frequently.

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

We create a function called `local:dispatch()` that accepts one argument, which must be a node (of any time), and returns zero or more items (that is, anything at all). What `typeswitch` does inside this function is test the type of a node, just returns it as is if it’s plain text, and otherwise sends it to a specialized helper function that knows how to handle it. The `case` statements mean “in case it’s plain text” (a `text()` node), “in case it’s a `<bill>` element”, etc. Although functions don’t require a `return` statement, the `case` statements in `typeswitch` use the keyword `return` to say “pass the node to the correct helper function, get the result, and then return (that is, output) that.”

#### Helper functions

Each of the helper functions that is specific to an element type will process the node and (most commonly) then pass its children into the dispatcher, which is how it implements the depth-first traversal of the entire tree. The dispatcher ends with a default rule that handles nodes for which we have not declared a specific rule, and in this example that function just processes the children of the node. As we’ll see below, if the node is an element, this has the effect of throwing away the markup; if it is a comment or processing instruction it throws it away entirely, since those types of nodes don’t have children. 

The `local:bill()` helper function above might look as follows:

```xquery
declare function local:bill($node as element(bill)) as element() {
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

This receives a single node at a time and loops over its children, sending each of them to the dispatcher to ensure that they get routed to the rule that knows how to handle them. In this example all of the helper functions send their children there, and the `default` statement essentially throws away the original markup and just sends the children to the passthru rule for processing.  

`typeswitch` expressions are namespace aware, so `case element(p)` will normally match a `<p>` element in no namespace. The exception is that if you have declared a default element namespace, `typeswitch` will match only `<p>` element in that namespace. If you are not using a default namespace, you need to use a namespace prefix that you have declared previously.

#### Running the transformation

We can start the transformation by passing the XML document to the dispatcher. When the dispatcher hits the root node, that begins the depth-first traversal, and the script will run recursively until it has visited every node in the input tree.

### Outlining our XML

The transformation script needs to create both a `case` statement inside the dispatcher and a matching helper function for each node type that requires non-default processing. This means that we need an inventory of the element types in our corpus. The most robust way to compile this list is to let XQuery do it for us, and the script can also write the dispatcher and create abbreviated placeholder helper functions. We do that with the *get_gis.xql* XQuery script in the *scratch* subcollection in the repo for this lesson  (*GI* stands for *generic identifier*, which is the technical term for the the name of element types). 

This script is customized for our project; it reads the `<text>` elements of all of the basic XML data, creates a sorted, deduplicated list of all element types, and uses that to create the dispatcher and skeletal helper rules (the technical term for functioning placeholder code during development is *stub*). Our *read.xql* module fetches the main document title from the `<teiHeader>`, but since there are also `<title>` elements inside `<text>`, the `case` statement and stub will be created for that element type, and we just have to remember to write our helper function to treat the main title differently from `<title>` elements inside `<text>`. Since we will be creating HTML output, we make the HTML namespace the default; we bind the TEI namespace to the traditional `tei:` prefix, and our scripts uses it where necessary. We save the output of *get_gis.xql* in the same *scratch* subcollection, with the resource name *view_skeleton.xql*.

### Writing the helper functions



### Putting it all together

###Telling *controller.xql* about the new View

## Optional (advanced)

### XQuery or XSLT?

The XML family of standards supports two broadly capable XML-oriented programming languages, XSLT (eXtensible Stylesheet Language Transformations) and XQuery. XSLT excels at transforming a single XML document to something else (commonly HTML, although other output formats are supported), but it is also capable of working with collections of documents in a database-like way. XQuery excels at working with collections of documents in a database-like way, but it is also capable of transforming a single XML document to something else. The two language can be used together easily, and developers who are comfortable with both are most likely to use XQuery for database operations over collections and XSLT to transform the results retrieved with XQuery. On the other hand, developers who are more comfortable in one language than the other may use only that one for all purposes. 

As was noted above, our Institute uses XQuery for all purposes, including transformation, for pedagogical reasons, that is, to avoid having to learn an additional programming language in a limited amount of time. Although the [XQuery WikiBook](https://en.wikibooks.org/wiki/XQuery/Benefits) writes correctly that “typeswitch enables XQuery to perform nearly the full set of transformations that XSLT does”, there are important differences in the way those transformations are performed:

1. The XSLT developer typically creates templates to process different types of nodes, and this is analogous to the individual, node-type-specific functions to which XQuery `typeswitch` passes nodes for processing. But to add processing for each additional element type using XQuery `typeswitch`, the developer has to both create the handler function and add a new `case` statement to the dispatcher. Not only is this extra effort, but because the two have to be kept in sync, it creates an opportunity for error. To add processing for a newe element type in XSLT, the developer has to do just one thing: create a new template. The reason is that the dispatch logic is baked into XSLT, but the developer has to create it explicitly in XSLT. 
1. XQuery `typeswitch` matches only by node type (most commonly by element name), while XSLT templates can match XPath patterns of any complexity. This means that XQuery must use `if` statements after identifying the node type in order to manage a choice among richer contexts that might have been expressed in a more declarative manner in XSLT, as the value of the `@match` attribute on `<xsl:template>`. The technical term for this difference is that XSLT, but not XQuery, supports *multiple dispatch*. Although both XSLT and XQuery are commonly described as *declarative* languages, the implementation of *multiple dispatch* gives XSLT a more consistent declarative profile.

If you are already comfortable with XSLT (or would like to become comfortable with XSLT), we encourage you to explore performing the transformation to HTML with XSLT instead of the XQuery we employ here.