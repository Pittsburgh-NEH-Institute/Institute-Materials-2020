# URL rewriting

## Synopsis

In this lesson we describe the role of URL rewriting in eXist-db apps and how it is implemented. The present lesson consists only of reading and has no hands-on component; in the next (and subsequent) lessons we will incorporate URL rewriting into our edition. The concepts and their implementation are not so much difficult as fussy, and trying to remember all of the predefined variable names and other information introduced below is likely to make your head hurt, at least until you have a chance to practice using them. For now you’ll want to read this tutorial carefully, but without trying to memorize anything, and then come back to it for review during implementation.

## A note on terminology

In this Institute we use the [Model–View–Controller](https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93controller) (MVC) design pattern as a perspective on the logical organization of our web app. In this context the term *controller* refers to the part of the system organization that mediates between dynamic data (the *model*) and what is returned to the user (the *view*). Meanwhile, eXist-db apps include a file called *controller.xql* that plays an important role in URL rewriting. This makes the phrase “the controller” potentially ambiguous, and to avoid that ambiguity in these materials we will refer to *controller.xql* by its full resource name.

## About URL rewriting

### The role of URL rewriting in an app

The URLs that we used in previous lessons were long and cumbersome, which makes them difficult to read, write, and remember. eXist-db needs to see each part of the URL because it serves a purpose, but some of it is sort of automatic (e.g., queries in our app will predictably live in a *modules* subcollection, so why should we have to specify that explicitly?), and URL rewriting makes it possible for us to enter a briefer, more human-friendly URL and let eXist eXist-db translate it into a more complete version. The mechanism that eXist-db uses to interpret abbreviated URLs is called *URL rewriting* or *query rewriting*.

### How eXist-db implements URL rewriting

A typical eXist-db app uses an XQuery script called *controller.xql* inside the main app collection to rewrite URLs. If that file is present, it will intercept all URLs that point anywhere into the app, at which point it can respond to them in their original form or modify them to return a resource at a different location. eXist-db supports more than one method of URL rewriting, and we use the *controller.xql* approach because it is the most mature, robust, and full-featured option. URL rewriting is a common feature in web applications; *controller.xql* is an eXist-db way of implementing URL rewriting.

## Implementing *controller.xql*

### Paths inside the app

eXist-db resources can be addressed with full URLs like *http://localhost:8080/exist/rest/db/apps/hoax/modules/home.xql*, but eXist-db apps are commonly distributed for installation by other users in other systems, where they may run on different hosts (not localhost) or at different ports (not 8080), and they may be installed into other locations inside the database (not under *apps*). Two strategies are available to avoid avoid unnecessary dependencies on specific hosting path information: relative paths and *controller.xql* variables.

#### Relative paths

App resources that point to other resources (for example, HTML that points to CSS using the HTML `<link>` element) may use relative paths. If your CSS lives at *localhost:8080/exist/rest/db/apps/hoax/resources/css/style.css* and you are returning static HTML at *localhost:8080/exist/rest/db/apps/hoax/resources/html/filename.html*, the link from the HTML to the CSS could be implemented as a full URL:

```html
<link rel="stylesheet" type="text/css" 
    href="http://localhost:8080/exist/rest/db/apps/hoax/resources/css/style.css"/>
```

or as a relative path (relative to the HTML):

```html
<link rel="stylesheet" type="text/css" href="../css/style.css"/>
```

The relative path should be preferred, since only it is immune to differences in hostname, port, or app location when the app is installed by other users. 

#### *controller.xql* variables

When an app uses a *controller.xql* file to rewrite URLs, eXist-db makes five variables that can be used to construct URLs available automatically within the controller, and it also supports two functions that provide additional information of this type. These variables and functions make it possible to construct a path within the app that is also immune to accidents of host, port, and app location.

The five *controller.xql* variables are:

* `$exist:root` The part of the database URL that precedes the name of the collection that contains *controller.xql*. In a standard installation this location is *xmldb:exist:///db/apps*, that is, */db/apps*.
* `$exist:prefix` The last part of the URL that precedes the location of *controller.xql*. The default value is */apps* because *controller.xql* is typically located in the root collection of the app. In a default installation, then, the value of `$exist:prefix`, then, is equal to the last part of `$exist:root`.
* `$exist:controller` The part of the URL leading from the prefix (typically */apps*) into the collection that contains the controller script, which in this case (and typically) is the root collection of your app, for example: */hoax*.
* `$exist:path` The part of the URL after the part that led to *controller.xql*. For example: */home* if your URL was *http://localhost:8080/exist/rest/db/apps/hoax/home*.
* `$exist:resource` The part of the URL after the last `/` character, which typically resolves to a resource within the database after query rewriting. For example: *home* (which URL rewriting might resolve to */modules/home.xql*, which is a real file inside the database). This value is null if the URL ends in a slash, although the controller can still resolve it to a real resource.

`$exist:prefix`, `$exist:controller`, and `$exist:path` always begin with a slash; `$exist:resource` never does. None of these variables ever ends in a slash, with the exception of `$exist:path` when no resource is specified. This is important because we’re going to stitch some of these pieces together to form a new path, and we need to understand where we have to add slashes and where they are already present.

#### Functions that return location information

In addition to the preceding five variables that are automatically available to *controller.xql*, the following two functions may be used for URL rewriting:

* `request:get-uri()` Returns the URL before query rewriting, for example, */exist/apps/hoax/home*.
* `request:get-context-path()` Returns the part of the URL that precedes the prefix, typically */exist*.

We sometimes find it useful to use XPath to construct a full path to location of *controller.xql*, which we can specify by using the XPath `concat()` function to stitch together some of the variables declared above. For example, for any URL in an app that lives at *http://localhost:8080/exist/rest/apps/hoax/more-path-stuff*:

```xpath
concat($context, $exist:prefix, $exist:controller, '/')
```

returns */exist/apps/hoax/*. We find this useful enough that we typically assign it to a variable (we call it `$fqcontroller`, for “fully qualified controller”), and it can be used to construct an absolute path within the app that is immune to the hostname and port (since neither is specified) and the location where the app was installed (since that part is returned dynamically by the `$exist:prefix` variable).

#### Summary of *controller.xql* variables and functions

Given an input URL like *http://localhost:8080/exist/rest/db/apps/hoax/home* that will be rewritten by *controller.xql*, the variables and functions make the following values available:

Variable | Source | Value
---- | ---- | ----
`$exist:root` | Automatic | xmldb:exist:///db/apps
`$exist:prefix` | Automatic | /apps
`$exist:controller` | Automatic | /hoax
`$exist:path` | Automatic | /home
`$exist:resource` | Automatic | home
`$uri` | From `request:get-uri()` | /exist/apps/hoax/home
`$context` | From `request:get-context-path()` | exist
`$fqcontroller` | Constructed | /exist/apps/hoax/


#### Using *controller.xql* variables and functions

The five variables are automatically available whether you declare them or not, but it’s good practice to declare them anyway. Since their meaning has been defined automatically, we declare them with the keyword `external`. We also typically assign the values of the two functions discussed above to variables, as well as the composed absolute path to the location of *controller.xql*. You can copy and paste the following into any *controller.xql* that you need to write, or you can copy and paste only the values you actually wind up using.

```xquery
declare variable $exist:root external;
declare variable $exist:prefix external;
declare variable $exist:controller external;
declare variable $exist:path external;
declare variable $exist:resource external;

declare variable $uri as xs:anyURI := request:get-uri();
declare variable $context as xs:string := request:get-context-path();
declare variable $ftcontroller as xs:string := concat($context, $exist:prefix, $exist:controller, '/');
```

## What to rewrite

Initially our app will deliver just a few resources, such as a simple reading view of a story and a main (home) page, and we’ll need to configure our *controller.xql* to receive these requests and rewrite them to point to the appropriate locations inside the database. We will then add further URL rewrite rules as they are needed to provide additional information.

## Optional (advanced)

### For more information

This tutorial assumes a default installation, which is useful for getting started, but also simplified. For more complete information about URL rewriting in eXist-db see:

* [URL rewriting](https://exist-db.org/exist/apps/doc/urlrewrite), the official eXist-db introduction.
* Chapter 9, “Building applications”, of Erik Siegel and Adam Retter’s *eXist. A NoSQL document database and application platform*. Beijing et al.: O’Reilly, 2014, pp. 191–235.

### Relative paths and constructed absolute paths

Resource paths inside eXist-db are used by eXist-db in the narrow sense of the eXist-db XML database and by Jetty, the HTTP server in which eXist-db is embedded. In a default installation, the *controller.xql* variable `$exist:root`, described above, return the value *xmldb:exist:///db/apps*, which only eXist-db (but not Jetty) can interpret, since it begins with the eXist-db-specific *xmldb:exist* URL scheme. eXist-db-specific paths are useful where the path is part of an XQuery, but not when it is part of the web app environment. For example, links to CSS or JavaScript cannot be described by using `$exist:root` because they are interpreted by Jetty, which doesn’t understand *xmldb:exist*. We use our constructed `$fqcontroller` variable as a way of pointing to the main collection of the app in a way that Jetty, too, can interpret, so that we can construct absolute paths from HTML files we might be generating to the CSS and JavaScript needed to deliver them with full functionality. 

**[ADD: When to use relative vs absolute (with controller variables) paths]**

## What next?

In the next lesson we use the concepts, models, and methods introduced here to begin to incorporate URL rewriting into our edition.