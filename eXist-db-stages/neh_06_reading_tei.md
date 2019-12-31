# URL rewriting: reading a document (TEI)

Download links for *xar* packages

* [Starting point](neh_05_http-01.xar)
* [Ending point](neh_06_reading_tei-0.1.xar) (end of this stage)

## Synopsis

In this lesson we add functionality to enable our app to display a reading view of a single story. We’ll do that in stages:

1. We will write an XQuery module (script) that can receive parameters, such as the name of the story we want to read. Since we are not yet using *controller.xql*, we’ll address the module directly at its actual location inside the database. The module will initially have only limited, diagnostic functionality, and will not yet return the text of the story.
2. We will then create an initial version of *controller.xql* that can accept a less cumbersome URL and rewrite it internally to point to our module.
3. Next we will add real code to our module to find and return the actual story we requested, as the raw TEI XML.

While our edition may want to make raw TEI XML available to users, that won’t be the default reading view, and the next steps will involve transforming the TEI XML for a single story into HTML, so that we can embed it inside a header, navigation bar, and other boilerplate and style it with CSS. We’ll save that for the next lesson; for now our goal will be to work up to returning just the requested raw TEI XML.

We have removed the XQuery that we used in an earlier lesson to list documents according to the first letter of the title. The starting app for this lesson contains the stories (in the *xml* subcollection) and the (temporarily invalid) beginnings of a *controller.xql* file, which we will repair during the lesson.

## About development

If you write your module all at once and test it, it probably won’t work because you will probably have done something wrong. That isn’t because you are new to XQuery or to eXist-db, although you may be; it will be because code is fussy and literal, which means that it does exactly what you tell it to do, while humans make assumptions and leaps of logic to which code has no access. For that reason, you will save time and frustration if you add one small bit of functionality at a time and test it before you add another. With that approach, the moment it goes from working to not working you will know that the most recent change is what caused the problem to surface, which will help you find and debug it.

For that reason, we will develop our module in the following micro-stages:

1. Write a module in XQuery that does nothing but read a user-supplied parameter value and echo it back. This module will have three lines of code: the XQuery declaration, a variable declaration that reads the parameter, and a statement that creates the output. At this point we haven’t tested anything and we don’t know whether it works.
2. Run the module inside eXide. The eXist-db function that retrieves a parameter value can specify a default, and since an XQuery script run inside eXide has no access to a parameter value we might supply in a URL, when we run the module inside eXide, it will report the default value. If it doesn’t, debug it before proceeding, since if it can’t run inside eXide, it won’t run properly from a browser.
3. Run the module from a browser, using a URL that points to its actual location inside the database and passes in the parameter as part of the query string. If it doesn’t produce the expected output, debug it before proceeding, since until the script works the way it should there’s no point in moving on to URL rewriting.
3. Add a *controller.xql* file to the app that will let us address the module at a briefer, more legible URL, rewriting what the user submits so that it points to the actual location of the module inside the database. This initial version of *controller.xql* will have limited functionality, and we’ll develop it further in subsequent lessons. If we are able to address our module with the abbreviated URL, that will confirm that *controller.xql* is rewriting the URL correctly.
4. Modify the module to return the text of a story, and not just echo the supplied parameter value. Since we are now looking for real data, we will need to supply a parameter value that selects a story in the corpus, which could be a filename or a unique identifier in the markup, such as an `@xml:id` attribute on the root `<TEI>` element or an `<idno>` in the TEI `<sourceDesc>` inside the `<teiheader>`. Producing real TEI XML from a real story specified in a URL is our final goal for this lesson.

In subsequent lessons we will enhance the functionality of the reading view in several ways. The most important are that:

1. We will return formatted and styled HTML, instead of just raw TEI XML. 
1. Because it is not realistic to expect users to know and supply filenames or other identifiers for the stories in the collection, we will add interface *widgets* (graphical display components) that will let the user select stories from a list of titles or by searching according to specific properties (places mentioned, keywords, etc.). 

## A minimal first module

### Inside eXide

Inside eXide click on the black New XQuery icon, create the following file, and save it inside your app at */db/apps/neh\_06\_reading\_tei/modules/read.xql*:

```xquery
xquery version "3.1";
declare variable $story_id as xs:string := 
	request:get-parameter('story', 'hi', false());
<root>{$story_id}</root>
```

This module consists of three statements, the first of which is the formulaic XQuery declaration. The second statement uses the eXist-db function `request:get-parameter()` to ask for the value of the parameter that will eventually be passed in with the name `story`. `request:get-parameter()` takes three arguments, only the first two of which need concern us: the first is the name of the parameter (which will be passed as part of the query string in an HTTP request), the second is a default value (if the parameter value is missing from the HTTP request), and the third is a bit of housekeeping that helps with debugging. We specify the default as “hi” for diagnostic purposes, so that we can verify that the module is functioning. In real life we might want to return an informative documentation message, redirect to the main page, or something else.

When you push the black Eval (not Run) icon in the eXide menu bar, you should see `<root>hi<root>` in a sidebar. If you don’t, you need to debug the code before you proceed; the point of our incremental development workflow is that we develop and test just one thing at a time. If your module does not work at this stage, it contains an error, and until you fix the error, code that you write on top of it cannot realistically be expected to work. 

### From the browser

Once you can run your module inside eXide and see the default output, navigate to *http://localhost:8080/exist/apps/neh\_06\_reading\_tei/modules/read.xql?story=xyz* in your browser, which should return `<root>xyz</root>`. You can change the value of the `story` parameter from “xyz” to something else, and it should return whatever you supply, except that browser cannot be expected to handle spaces or most punctuation reliably. We’ll learn later a robust strategy for including these characters in a parameter value, but for now you should limit your value to letters, digits, dot, hyphen, and underscore. 

What do you expect the system to return if you omit the `story` parameter entirely, e.g., *http://localhost:8080/exist/apps/neh\_06\_reading\_tei/modules/read.xql*? How about if you supply *http://localhost:8080/exist/apps/neh\_06\_reading\_tei/modules/read.xql?story*, that is, with the parameter name but no value?

Once this works, you know that your module is reading the parameter value and responding properly.

## Using *controller.xql* to access the module

One benefit of URL rewriting (we’ll explore others later) is that we will be able to address our module at a shorter, more legible URL. At this initial stage *controller.xql* will handle just two types of URLs: those that should be redirected to XQuery modules and those that should be returned without modification:

* If the user requests a resource without an extension, we’ll assume that it’s an XQuery module. *controller.xql* will rewrite the URL to look for the file in the *modules* subcollection with the added resource extension *.xql*. That means that we will be able to request *http://localhost:8080/exist/apps/neh\_06\_reading\_tei/read?story=xyz* (omitting */modules* and the *.xql* resource extension) to access our module.
* Otherwise the controller will return a resource at the literal location specified in the URL. This means that our original URL will continue to work, since it has an *.xql* extension.

We will modify *controller.xql* later to handle additional types of requests. When *controller.xql* rewrites the URL, it passes any parameters along automatically. This means that *controller.xql* will specify the new, rewritten URL without the query string, and the original parameters and values will nonetheless be made available to the module, and we do not have to forward them ourselves.

The automatic variable `$exist:resource` contains the part of the URL after the last slash, and since our only concern for rewriting purposes at this point is whether it contains an extension, we can test for the presence of a dot with the XPath `contains()` function. This is a brittle and narrow solution, since it doesn’t retrieve the extension (eventually we might want to handle different extensions differently) and it doesn’t distinguish situations where a resource name may contain more than one dot, where only the last one demarcates an extension, but it meets our needs at this preliminary stage. If `$exist:resource` does not contain a dot, then, we’ll treat it as an XQuery module and rewrite the URL, and if it does, we’ll leave it unmodified. Here is the part of *controller.xql* that manages that logic, which you can add to *controller.xql* under the variable declarations:

```xquery
if (not(contains($exist:resource, '.')))
then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{concat($exist:controller, '/modules', $exist:path, ".xql")}"/>
    </dispatch>
else
    <ignore xmlns="http://exist.sourceforge.net/NS/exist">
        <cache-control cache="yes"/>
    </ignore>
```

An XQuery `if` expression must wrap the test in parentheses. Read the nested functions in the test itself from the inside out: `contains($exist:resource, '.')` returns True if there is a dot in the resource name and False if there isn’t, and by wrapping that in the `not()` function, we invert those return values. In other words, the `then` clause will apply when the resource name does *not* contain a dot, and the `else` clause will apply if it does.

The `<dispatch>` element, in the eXist-db namespace, contains a `<forward>` element that specifies the path to the actual location of the XQuery module that should process the request. These element names are predefined by eXist-db, so the only part of the instruction that we need to customize is the value of the `@url` attribute. We specify the new URL by stitching together the pieces with the XPath `concat()` function:

1. Start at the location of *controller.xql*, which is *neh\_06\_reading\_tei*. This is the root collection of our app, and it is automatically supplied by the `$exist:controller` variable. It’s more robust to use the variable than the literal string, since that lets us reuse the same controller logic in other apps that might be installed into different locations.
2. From there navigate to the *modules* subcollection.
3. Once there, find the desired module by taking the name originally specified in the URL (e.g., *read*, with no *.xql* extension) and appending the *.xql* extension. In other words, URL rewriting means that navigating in the browser to *http://localhost:8080/exist/apps/neh\_06\_reading\_tei/read?story=xyz* will cause */db/apps/neh\_06\_reading\_tei/modules/read.xql* to run, with access to a parameter called `story` with a value of “xyz”.

The `else` clause says that if a resource *does* contain a dot, URL rewriting should ignore it, so that the resource will be found at the location specified in the original URL and returned from there. The cache setting tells eXist-db to remember the rules for such URLs, so that they will not have to be processed by *controller.xql* the next time they recur. This value is normally set to “yes” when URLs are ignored. 

With *controller.xql* in place, if you ask for a resource that has an extension (that is, a dot), it should be found at its location and 1) executed and the result returned if it is an XQuery script, or 2) just returned as is otherwise. For example:

* XQuery script: *http://localhost:8080/exist/apps/neh\_06\_reading\_tei/modules/read.xql?story=xyz* locates the module at its actual address and runs it.
* Other file: *http://localhost:8080/exist/apps/neh\_06\_reading\_tei/xml/hammersmithghost\_times\_1804.xml* returns the full text of the story in raw TEI XML.

If you ask for something literal that doesn’t exist, you’ll get an error. If you ask for *http://localhost:8080/exist/apps/neh\_06\_reading\_tei/controller.xql*, which does exist, the script will be executed and an error will be returned; this is because *controller.xql* is not meant to be executed directly. And if you ask for a module that doesn’t exist in a way that relies on URL rewriting, e.g., *http://localhost:8080/exist/apps/neh\_06\_reading\_tei/stuff?story=xyz* (there is no *stuff.xql* in the *modules* subcollection), you’ll get a “not found” error message.

## Reading a story

### Processing real titles

The last step in this lesson is to modify *read.xql* to return the raw TEI XML for a story, instead of just echoing the parameter value. For this exercise we will use the resource name of the story without the *.xml* extension as an identifier for the story we want to read; in Real Life we could, alternatively, use the full filename (with the extension) or, perhaps, a short identifier matching an `@xml:id` value on the root `<TEI>` element or an `<idno>` element in the `<sourceDesc>` inside the `<teiHeader>`.

A full TEI document for a story contains metadata in the `<teiHeader>` that you may not want to include in a reading view, or that you might want to treat separately from the `<text>` element, that is, the core data for the story. We will refine what we return for a reading view later, but for now we’ll use XQuery to retrieve just the main title for the story (from the `<title>` child of `<titleStmt>`) and the entire `<text>`.

To return these features from a real story, replace *read.xql* with the following XQuery:

```xquery
xquery version "3.1";
declare default element namespace "http://www.tei-c.org/ns/1.0";
declare variable $stories as document-node()+ := 
	collection('/db/apps/neh_06_reading_tei/xml');
declare variable $story_id as xs:string := 
	request:get-parameter('story', 'hi', false());
declare variable $story_filename as xs:string: = concat($story_id, '.xml');
declare variable $story as document-node()? := 
	$stories[ends-with(base-uri(), $story_filename)];
	
if ($story) then
    <TEI>Found!</TEI>
else
    <error xmlns="">{concat('No such story:', $story_id)}</error>
```

We begin with six declarations, some of which will by now be familiar:

* The XQuery declaration is added by eXide when we create a new XQuery script. It is optional, but we recommend leaving it in place.
* XQuery lets us declare a default element namespace, which saves us from having to use namespace prefixes to refer to elements in the input documents or when we create elements for output. Since both our input (our corpus of stories) and our output (the information we choose to provide from the story requested by the user) are in the TEI namespace, this is a good opportunity to declare the TEI namespace as a default.
* We then declare four variables:
	* `$stories` is a collection of all stories in our corpus, defined using the XPath `collection()` function. Since each story is an XML document and we know that we have at least one of them, we use the plus sign as a repetition operator.
	* `$story_id` is the parameter value supplied by the user in the query string. It is unchanged from the earlier version of the XQuery script.
	* `$story_filename` is formed by appending the string `.xml` to the value of `$story_id`. We could, alternatively, have required the user to add the extension in the original URL.
	* `$story` uses an XPath predicate to filter the collection of stories and select only the one (if it exists) that the user asked for. Since the user may request a story that doesn’t exist, and since we cannot have two stories with the same filename, we use the question mark repetition indicator to specify that there should be exactly zero or one hit. The predicate uses the XPath `base-uri()` function, which returns the fully qualified resource name, that is, the entire path through the database to the resource (you can test this by running `collection('/db/apps/neh_06_reading_tei/xml') ! base-uri()` in a new XQuery script; it returns the `base-uri()` value for every story in the corpus). For each story in the corpus the predicate checks whether the fully qualified resource name ends with `$story_filename`, and we assign all documents that satisfy that test as part of the value of `$story`. As we mentioned earlier, this variable will wind up pointing to zero or one document.

Remember that all declarations in XQuery end in semicolons and other statements do not end in semicolons.

Our script then uses an `if` expression to test whether there is or is not a story with the specified resource name. If there is, it tells us that it found it and returns a `<TEI>` root element (in the TEI namespace) with a report of success (and at the next stage we will replace this report of success with real TEI data). If no story is found, it reports the error. The error report is not in the TEI namespace, so we override the default with a null namespace declaration. 

When we test this in eXide it returns `<error>No such story:hi</error>` because it reads the default value of `$story_id`. We can test whether it can find a story by replacing the default value of that variable with the resource name of a real story (without the *.xml* extension). When we change the default to `hammersmithghost_times_1804` and hit Eval, it reports success. We can then run the script from a browser at:

```
http://localhost:8080/exist/apps/neh_06_reading_tei/read?story=hammersmithghost_times_1804
```

and it will report success. If we change the value of the `story` parameter to something that doesn’t exist, it will report an error.

### Returning real content

Now that we can find real stories in our corpus, we can modify our XQuery script to return the information we want, which will be the title of the story (which we’ll retrieve from the `<teiHeader>`) and the content (the `<text>` element). The output will be wrapped in a `<TEI>` element and will be in the TEI namespace, but because this is an interim result (we will later transform it to valid HTML), we are not concerned about whether it is valid TEI (it isn’t).

Change the XQuery module code to the following (the only change is in the line that specifies what to return if a story is found):

```xquery
xquery version "3.1";
declare default element namespace "http://www.tei-c.org/ns/1.0";
declare variable $stories as document-node()+ := 
	collection('/db/apps/neh_06_reading_tei/xml');
declare variable $story_id as xs:string 
	:= request:get-parameter('story', 'hammersmithghost_times_1804', false());
declare variable $story_filename as xs:string: = concat($story_id, '.xml');
declare variable $story as document-node()? := 
	$stories[ends-with(base-uri(), $story_filename)];
	
if ($story) then
    <TEI>{
        $story//(titleStmt/title | text)
    }</TEI>
else
    <error xmlns="">{concat('No such story:', $story_id)}</error>
```

The new value says to start from the `$story` (which is a single XML document), look on the descendant axis (that is, anywhere inside the story), and retrieve the union of the `<title>` child of `<titleStmt>` and `<text>`. We need to use `<titleStmt>` to specify which title we want because there may be other `<title>` elements in the document, but our story documents have only one `<text>`.

## Optional (advanced)

### XQuery standard and extension functions

XQuery comes with a large standard function *library* (the technical term for a resource that provides predefined functions or other types of functionality), and functions in that library can be specified just by name. For example, in our controller we use the `contains()` function from the standard library to determine whether the resource part of our URL contain a dot. Functions in the standard XQuery library may be preceded by the `fn:` namespace prefix, but it is usually omitted in practice because eXist-db assumes it as the default. You can read about the standard function library in the spec (official specification, published by the W3C, the World Wide Web Consortium) at <https://www.w3.org/TR/xpath-functions-31/>.

Because the spec does not define all of the functionality needed to manage a database, XML databases normally include extension functions in other namespaces. eXist-db uses the `request:` namespace prefix to identify eXist-db-specific functionality pertaining to HTTP requests, such as the parameter value we supply in our app to retrieve a particular story. If you develop an app using a different XML database, the standard functions will continue to be available, but each database defines its own extension functions, so you will probably use a different function in a different namespace to access a user-supplied parameter value. eXist-db knows about the custom functions it supports in other namespaces, so although you can declare the namespace, you don’t have to, and we don’t declare it here.

The online eXist-db documentation at <https://exist-db.org/exist/apps/fundocs/index.html> documents all functions available within eXist, both those that belong to the standard library and those that are eXist-db extensions. You can install a local copy of that documentation into your own eXist-db instance with the eXist-db Package manager, which is accessible from the eXist-db Dasboard when you authenticate as userid *admin*.

### Validity

The `<TEI>` element that we return on success in the final version of our module is not a valid TEi document. This is common during development, where we extract selected information from a TEI document, instead of returning the entire document. If our goal were to return TEI, we would want it to be valid, but in this case we are at an interim stage toward eventually transforming the data to valid HTML and returning that. 

### The XPath union operator (`|`)

In the final version of our module we used the XPath path expression `$story//(titleStmt/title | text)`. The pipe (`|`), which is the *union operator*, returns the union of the things specified, sorted into document order and with duplicates removed. Since the title precedes the text in our document, we can’t see the effect of either the sorting or the deduplication, but if we change the expression to `$story//(text | titleStmt/title)` or `$story//(text | text | titleStmt/title)` one instance of the title will still come back before one instance of the text.

Perhaps confusingly, the comma operator does not behave the same way as the union operator. If you want to retrieve elements in a specified order, such as the text before the title (which is contrary to document order), use `$story//text, $story//titleStmt/title` or `$story/(descendant::text, descendant::titleStmt/title)`.

### Organizing your app

Our simplified initial controller rewrote our query to insert the *modules* subcollection into the path. It is possible to use a deep hierarchy to group modules in subcollections inside other subcollections, but the more varied the resource locations grow, the more complicated it will become to perform string surgery on URLs. For that reason, you will want to balance the organizational convenience of grouping and subgrouping similar resources, on the one hand, against, on the other, the code complexity of having to rewrite the URLs for those resources differently depending on their location. In practice we are more likely to rewrite URLs that point to XQuery modules than those that point to static resources, such as images, CSS, etc., for which we will specify `<ignore>` in *controller.xql*. For that reason, we are not concerned about having subcollections inside *resources* in our app, but we will be cautious about splitting XQuery modules into separate subcollections.

### About `request:get-parameter()`

The `request:get-parameter()` function takes two or three arguments. The first argument is the name of the parameter, and it must match the parameter name that will be used in the query string in the HTTP request. The second argument is the default value, to be used if no value is supplied in the HTTP request. For information about the third argument, which is needed only when using \<oXygen/\> instead of eXide to edit the query, see <https://www.oxygenxml.com/pipermail/oxygen-user/2019-December/006495.html>.

### About default namespaces

XSLT users may remember that XSLT makes it possible to declare a default input namespace with `@xpath-default-namespace` and a different default output namespace with `@xmlns`. XQuery does not have this flexibility; a default namespace declarations applies equally to input and output. This isn’t an issue in the current lesson because the input and output are both in the TEI namespace, and in later lessons we’ll learn how manage multiple namespaces.

### About indexing

We retrieve a specified story by comparing the resource names of each and every story to the value supplied in the URL. As an alternative, eXist-db provides a mechanism for building *persistent indexes*, which provide much quicker lookups because they don’t need to run the `base-uri()` function in real time on every resource for every HTTP request. With even a few hundred stories you probably won’t notice the difference in speed, but for some more complex queries indexing will make for a measurable difference in performance, and other types of queries are possible only with indexing. We’ll add indexing to our app later.

## What next?

We are successfully returning the information we care about from a story we care about, but the information is coming back as raw TEI XML. In the next lesson ([neh_07_view](neh_07_tei-view.md)) we will enhance our app to transform the XML that we have requested into HTML and style it with CSS.