# Querying the database

Download links for *xar* packages

* [App for this exercise, with scripts](neh_04_http-0.1.xar) 

## Synopsis

In this stage we create XQuery that can employ user input to do more than just retrieve a file by name. We develop this query in three stages:

1. The first version, which runs only in eXide (not in a web browser), returns plain text and shows how a user-supplied parameter value can control the output.
2. The second version changes the output format from plain text to XML so that it will run in both eXide and a browser.
3. The third version changes the output to richer XML.

This lesson is longer than the preceding ones because it begins with a longer set of terminological notes (which you can skim, but don’t skip them entirely) and it discusses the first XQuery script in detail (our explanations become shorter after that). We’ve kept it all in one lesson because the pieces are closely interconnected; the three XQuery scripts differ only in the last statement, and everything that precedes is the same.

If you are not already at least passingly familiar with XPath and XQuery, we would recommend reading the brief tutorials listed on our [XQuery Resources](../ref/xquery_resources.md) page before beginning the lesson.

## Notes on terminology

The notes on terminology are longer in this tutorial than in previous ones. You don’t need to memorize the details, but reading through them will help clarify how eXist-db is able to run queries in response to browser requests. We will return to HTTP in more detail toward the end of the Institute, when we discuss *APIs* (application program interfaces).

### Stored procedure

Queries can be written in advance and stored in the database, so that at run time the user passes in only *parameter values*, instead of submitting the entire XQuery code. In this exercise we store a query that knows how to find stories with titles that begin with a certain letter, and instead of having to supply the entire query at run time, the user can just pass an initial letter into the preconfigured query. The technical term for an XQuery script stored inside the database is *stored procedure*.

### HTTP

[*HTTP*](https://en.wikipedia.org/wiki/Hypertext_Transfer_Protocol) (hypertext transfer protocol) is best known as the language that web browsers and web servers use to communicate with each other. HTTP observes a *client-server* architecture, where the *client* (e.g., web browser) sends a request to the *server* (e.g., web server) and receives information in response. Most often the user sees (and needs to see) only part of the initial request (in the browser address bar) and part of the result (in the browser window), but HTTP connections also exchange other information (*headers*) that describe and facilitate the communication. Most often the server and client are different physical machines, but in this exercise you will be running both the server (eXist-db runs inside Jetty, a web server installed automatically when you install eXist-db) and the browser on your laptop.

### GET queries

In addition to being able to request a web page, an HTTP URL is able to pass additional information to the server by using a GET, which appends a *query string* to the rest of the URL, as in the following example:

```
http://localhost:8080/exist/apps/neh_04_http/modules/03_document_by_first_letter.xql?initial=A
```

This URL has the following parts (some URLs have additional components):

1. **Scheme:** The transfer protocol, in this case *http*. The scheme is followed by a colon and two slashes.
3. **Host:** The address of the server on the web, in this case *localhost*, which means that the server is the same machine as the client. A more common shape for a hostname is *www.example.com*.
4. **Port:** Hosts can listen on multiple *ports* (communication channels), which makes it possible for a single host machine to run multiple servers and route requests to the correct one. By default, http communications go to port 80; since we run Jetty (the web server bundled with eXist-db) on a different port, we need to specify it explicitly, in this case as *8080*. The port, if specified, is separated from the host by a colon.
5. **Path:** The location on the server where the desired resource is located, ending with the resource name itself, in this case */exist/apps/neh\_04\_http/modules/03\_document\_by\_first_letter.xql*. The document actually lives at */db/apps/neh\_04\_http/modules/03\_document\_by\_first_letter.xql* (note the different beginning); in a standard eXist-db installation, paths the begin with */exist/apps* are already routed to the */db/apps* collction.
6. **Query string:** Information that the resource will use to tailor the response, expressed as name/value pairs, preceded by a question mark. In this case, we tell the script that we want titles beginning with “A” by passing “A” in as the value of the parameter name `initial`.

The query string is an HTTP GET convention for passing parameter values to the server—in this case,into a stored procedure. We’ll look at other ways to submit queries and pass information into eXist-db later. We’ll also see how to pass in multiple parameters, as well as parameters with spaces or punctuation.

## Querying inside eXide

### Query #1: plain text

*01\_document\_by\_first\_letter.xql* can be run in eXide to return, as plain text, the titles of all documents in the collection that begin with a specific letter. Run queries in eXide by hitting the Eval button (not, confusingly, the Run button).

Here is the XQuery code for version #1, which consists of six statements; we have removed the comments that you’ll find in the app to make the code easier to read:

```xquery
xquery version "3.1";
declare namespace tei="http://www.tei-c.org/ns/1.0";
declare variable $stories as document-node()+ := 
	collection('/db/apps/neh_04_http/xml');
declare variable $initial as xs:string := 
	request:get-parameter('initial', 'A');
declare variable $hits as document-node()* := 
    $stories[descendant::tei:titleStmt/tei:title[starts-with(., $initial)]];
$hits/descendant::tei:titleStmt/tei:title ! string()
```

XQuery lets you split or add spaces to what would otherwise be long lines to improve legibility, with no impact on the meaning, and here we’ve split the long statements over two lines, indenting the second line. 

The first statement is the XQuery declaration, and it is added automatically by eXide when you create a new XQuery document. It is optional, but it’s good practice to leave it in. Note that it ends in a semicolon, which is required.

The next four statements are *declarations*: one *namespace declaration* and three *variable declarations*. All declarations in XQuery begin with the keyword `declare` and end with a semicolon. Here is how they work:

**The namespace declaration:** Since TEI documents are in the TEI namespace, if you query them, you need to look for their elements in that namespace. The namespace declaration lets you use `tei:` as the namespace prefix for TEI elements.

**Variable declarations:** Variable declaration have the following parts:

* The statement `declare variable`.
* The name of the variable, which must begin with a dollar sign. You can use any name you want, except that names cannot contain spaces or most punctuation (limit yourself to dot, hyphen, and underscore).
* The *datatype* of the variable, preceded by the keyword `as` and optionally followed by a *repetition indicator*. Documents have the type `document-node()` and strings have the type `xs:string`. The plus sign when we declare `$stories` means one or more (since we know that our collection has at least one story); the asterisk when we declare `$hits` means zero or more, since we could ask for a letter that doesn’t begin any stories. There is no repetition indicator where we declare `$initial`, which means that the variable must be equal to exactly one string. The datatype specification is optional, but it’s good practice to use it. 
* The assignment operator for variables (confusingly unlike the one for namespaces!) is `:=`, called the [*walrus operator*](https://miro.medium.com/max/1370/1*gPNpG9kXdIC-n0n8TChEQw.jpeg). 
* The value of the variable comes last. This can be an *atomic value* (string, integer, etc.) or something computed using XPath or XQuery.
* Because these statements are declarations (i.e., they begin with the keyword `declare`), they must end with a semicolon. 

We declare the following three variables:

* `$stories` points to all XML story documents in our app, using the XPath `collection()` function.
	* `$initial` specifies the first letter that interests us, that is, we can ask for titles that begin with “A” or “T” or anything else. The eXist-db way of letting the user specify a parameter at run-time (we’ll do this when we run version #2 of our query in a browser) is to use the `request:request()` function, which takes two arguments: the parameter name to which the variable is assigned when the user makes the request and a default value. Here we say that the parameter will be called `initial` and the default value will be “A”.
* `$hits` holds the result of an XPath expression that filters the full collection of stories and keeps only those that have a title that begins with the value we’ve assigned to `$initial`. Parse this expression as:
  * Find all story documents.
  * Filter them to keep only those that have a descendant `<title>` in the TEI namespace that is a child of `<titleStmt>`, also in the TEI namespace. This is where TEI documents store their titles. Note that *all* elements in a namespace (here `<titleStmt>` and `<title>`) must be preceded by the namespace prefix.
  * But don’t keep *all* documents that have just any `<title>` element as described above! Filter them further to keep only those where the `<title>` element begins with the value assigned to the `$initial` variable.

The last line specifies what the XQuery returns, and since it is not a declaration, it has no semicolon at the end. If we return just `$hits`, without the predicate, we’ll return the entire documents (try it!). That’s often what we want in Real Life, but for legibility in this exercise, we’ll use XPath to return just the titles of those documents. If we just ask for the titles, without the trailing `! string()`, we’re asking not for what a human thinks of as a title, but for the `<title>` *elements*, complete with markup. To make the output more legible, we use the XPath *simple map* operator to extract just the string value of the titles, thus removing the markup. The simple map operator takes each item to the left (the titles with their markup) and applies the function to the right (“extract the string value, without markup”) to each of them. To see the difference, removie the `! string()` and run the query without it.

To return titles that begin with a different letter, change the second argument to the `request:request()` function, that is, change the default. What do you expect to happen if you specify a letter that doesn’t begin any titles, like “Q” (try it!)? 

You can address this first query from your browser at:

```
http://localhost:8080/exist/apps/neh_04_http/modules/01_document_by_first_letter.xql?initial=A
```

but you’ll raise an error. That’s because eXist-db by default sends the output of the query as XML, but we’re creating only plain text, without markup, which the browser cannot interpret as XML. eXist does have a mechanism (additional declarations) to tell the browser to expect plain text instead of XML, but we’ll skip over that for now and look into keeping the browser happy by creating XML instead of plain text.

### Query #2: simple XML

The second query is identical to the first except for the last line, which reads:

```xquery
<result>{$hits/descendant::tei:titleStmt/tei:title ! string()}</result>
```

The difference is that we’ve wrapped the result in `<result>` tags. You can use any element name you want (try it!); the important difference is that by wrapping it in tags we are now returning XML, instead of plain text. 

So what are the curly braces doing, just inside the new tags? XQuery lets you intermingle XQuery code with literal XML, and to do that it has to be able to switch from one to the other. An XQuery script starts out in XQuery mode, and parses everything as XQuery instructions, to be interpreted and executed. To switch into XML mode, just type some XML; that’s what we do when we type our `<request>` start-tag. Within XML mode, though, everything you type will be understood as XML, and not XQuery, unless you specify otherwise, and curly braces switch back into XQuery mode when you’re inside XML mode. Here the `<result>` start- and end-tag demarcate an XML zone, and the curly braces inside that element demarcate an XQuery zone inside the XML zone. This is how XQuery lets you output the results of interpreting your XQuery inside XML tags. You can nest XQuery and XML inside each other as deeply as you need.

When you run this query inside eXide, the output is the same as with the first version, except that it is wrapped in the XML tags and run together as a single line. The text runs together because eXist-db assumes that you don’t care about white-space differences inside your XML; this is similar to the way an XML editor like \<oXygen/\> freely changes whitespace when you pretty-print a document during editing.

Wrapping the output in an element (any element) makes it well-formed XML, which means that the browser can now render it, unlike with the earlier plain-text version. So if you run:

```
http://localhost:8080/exist/apps/neh_04_http/modules/02_document_by_first_letter.xql?initial=A
```

in your browser address bar, eXist-db will return the XML to you. See that *query string* at the end of the URL, after the question mark (*initial=A*)? That consists of a parameter name `initial` and a value “A”, separated by an equal sign. If you change the value to a different letter, you’ll get a different result (try it!). This works because when you address an XQuery script inside eXist-db (that is, a *stored procedure*) with an HTTP request, which is what happens when you type the address of the script into the browser address bar, eXist-db executes it instead of just returning it to you literally. And if you add a query string after the resource name, eXist-db interprets this as a GET request, looks for a parameter with the specified name, and assigns the specified value to it. This is why the first argument to the `request:request()` function and the parameter name in the URL, in this case `initial`, must agree.

What happens if you try to match a lowercase letter instead of an uppercase one? Omit the value after the equal sign? Omit the entire query string (after the question mark)? Specify a word, instead of just a letter? Capitalize the parameter name? 

### Query #3: smarter XML

In Real Life we’ll return our list of titles not as a blob of continuous text, but formatted like a list, as in our third script. Here, again, we change only the last statement, this time to:

```xquery
<results>
    {
        for $hit in $hits
        return <title>{$hit/descendant::tei:titleStmt/tei:title ! string()}</title>
    }
</results>
```

The white space is for human legibility, so you can modify it as you want. As with query #2, we return a `<results>` element and we switch into XQuery mode inside it with curly braces. But now instead of just dumping all of the raw titles in plain text, as we did in query #2, we loop over them with an XQuery FLWOR expression. This is a simple FLWOR with only two statements, one `for` statement and a `return`:

* The `for` statement uses the *sequence variable* `$hits`, which we declared earlier, and loops over it with the *range variable* `$hit`. The variable names are up to you, but using a singular noun for a range variable that loops over the same noun in the plural as the sequence variable is common, since it’s self-documenting.
* The `return` after the `for` uses the range variable to return one thing for each item in the sequence over which we’re looping, and we wrap the individual titles in `<title>` tags.

You can execute this in eXide or in the browser and the result will come back looking like legible XML.

## Thinking about namespaces

We said earlier that we used the *simple map operator* (the `! string()`) to strip off the markup and get just the text of the title, and now we’re wrapping `<title>` tags around it before output. Why didn’t we just leave the original `<title>` tags there? To try it and see what happens, change the `return` statement to:

```xquery
return $hit/descendant::tei:titleStmt/tei:title
```

In this new version we don’t strip the original markup and we don’t add our own `<title>` tags. How do we understand the different output of the two versions?

## Optional (advanced)

Anything you can enter in a browser address bar can also be used as an argument to curl or wget, if you have those installed. See the bottom of the [previous lesson](neh_03_uploading-xml.md) for more information about how to execute stored procedures from the command line using these programs, and not just in a browser.

## What next?

