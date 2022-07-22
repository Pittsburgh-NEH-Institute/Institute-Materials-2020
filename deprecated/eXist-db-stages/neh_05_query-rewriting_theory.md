# URL rewriting

## Synopsis

In this lesson we describe the role of URL rewriting in eXist-db apps and how it is implemented. The present lesson is just a reading, with no hands-on component; in the next (and subsequent) lessons we will apply these methods by incorporating URL rewriting into our edition. The concepts and their implementation are not so much difficult as fussy, and trying to remember all of the predefined variable names and other information introduced below is likely to make your head hurt, at least until you have had a chance to practice using them. For now you’ll want to read this tutorial carefully, but without trying to memorize anything, and then come back to it for review during implementation.

## A note on terminology

In this Institute we use the [Model–View–Controller](https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93controller) (MVC) design pattern as a perspective on the logical organization of our web app. In this context the term *controller* refers to the part of the system organization that mediates between dynamic data (the *model*) and what is returned to the user (the *view*). Meanwhile, eXist-db apps include a file called *controller.xql* that, among other things, is responsible for URL rewriting. This makes the phrase “the controller” potentially ambiguous, and to avoid that ambiguity in these materials we will refer to *controller.xql* by its full resource name.

## About URL rewriting

### The role of URL rewriting in an app

The URLs that we used in previous lessons were long and cumbersome, which makes them difficult to read, write, and remember. eXist-db needs to see each part of the URL because it serves a purpose, but some of it is predictable, e.g., queries in our app will be located in a *modules* subcollection, so why should we have to specify that explicitly for each query? The mechanism that eXist-db uses to mediate between abbreviated, user-friendly URLs and complete literal paths to system resources is called *URL rewriting* or *query rewriting*.

### How eXist-db implements URL rewriting

A typical eXist-db app uses an XQuery script called *controller.xql* inside the main app collection to rewrite URLs. If *controller.xql* is present, it will intercept all URLs that point anywhere into the app and eithr respond to them in their original form or modify them to point to a resource at a different location. eXist-db supports more than one method of URL rewriting, and we use the *controller.xql* approach because it is the most mature, robust, and full-featured option.

## Implementing *controller.xql*

In the next lesson we will create a *controller.xql* file inside our app and begin to configure it. To prepare for that, we introduce here some of the concepts and features that eXist-db provides for implementing URL rewriting with *controller.xql*.

### Paths inside the app

eXist-db resources can be addressed with full URLs like *http://localhost:8080/exist/rest/db/apps/hoax/modules/home.xql*, but eXist-db apps are commonly packaged and distributed for installation by other users in other systems, where they may run on different hosts (not localhost) or at different ports (not 8080), and they may be installed into other locations inside the database (not under *apps*). If we hard-code those full paths into our app, the links could break when the app is installed in other systems. Two strategies are available to avoid avoid unnecessary dependencies on specific hosting path information: relative paths and *controller.xql* variables.

#### Relative paths

App resources that point to other resources may use relative paths. For example, if your CSS lives at *localhost:8080/exist/rest/db/apps/hoax/resources/css/style.css* and you are returning static HTML at *localhost:8080/exist/rest/db/apps/hoax/resources/html/filename.html*, the link from the HTML to the CSS could be implemented as a full URL:

```html
<link rel="stylesheet" type="text/css" 
    href="http://localhost:8080/exist/rest/db/apps/hoax/resources/css/style.css"/>
```

or as a relative path (relative to the HTML):

```html
<link rel="stylesheet" type="text/css" href="../css/style.css"/>
```

The relative path is better than the full URL since only the relative path is immune to differences in hostname, port, or app location when the app is installed by other users. 

#### *controller.xql* variables

When an app uses a *controller.xql* file to rewrite URLs, eXist-db automatically makes five variables that can be used to construct URLs available, and it also supports two functions that provide additional path-related information. These variables and functions make it possible to construct an absolute (not relative) path within the app that is also immune to accidents of host, port, and app location.

**[TODO: When to use absolute and when to use relative paths]**

The five variables that are automatically made available to *controller.xql* are described below. This description assumes a standard installation: the app is located at */db/apps/hoax*, *controller.xql* is inside that collection, and the user has entered the URL *http://localhost:8080/exist/rest/db/apps/hoax/home*:

* `$exist:root` The part of the database URL that precedes the name of the collection that contains *controller.xql*. In a standard installation, where apps are installed under */db/apps* and the *controller.xql* file for the app is in its main collection (e.g., inside */db/apps/hoax* for the Hoax app), the location of the root is *xmldb:exist:///db/apps*, that is, a pointer to */db/apps* that uses the eXist-db-specific URL scheme *xmldb:exist*.
* `$exist:prefix` The last part of the URL that precedes the location of *controller.xql*. The default value is */apps* because *controller.xql* is typically located in the root collection of the app and the app is typically installed under */db/apps*. In a default installation, then, the value of `$exist:prefix` is equal to the last part of `$exist:root`.
* `$exist:controller` The part of the URL leading from the prefix (typically */apps*) into the collection that contains the controller script, which in this case (and typically) is the root collection of the app, for example: */hoax*.
* `$exist:path` The part of the URL after the part that led to *controller.xql*. For example: if the URL is *http://localhost:8080/exist/rest/db/apps/hoax/home*, the path is */home*. The path may be longer if the app content uses deeper subcollections. For example, if the URL reads *http://localhost:8080/exist/rest/db/apps/hoax/long/path/home*, with nested subcollections, the path is */long/path/home*.
* `$exist:resource` The part of the URL after the last `/` character, e.g., *home*. This value is null if the URL ends in a slash.

`$exist:prefix`, `$exist:controller`, and `$exist:path` always begin with a slash; `$exist:resource` never does. None of these variables ever ends in a slash, with the exception of `$exist:path` when no resource is specified. This is important because we’re going to stitch some of these pieces together to form a new path, and we need to understand where we have to add slashes and where they are already present.

#### Functions that return location information

In addition to the preceding five variables that are automatically available to *controller.xql*, the following two functions may be used for URL rewriting:

* `request:get-uri()` Returns the URL before query rewriting, for example, */exist/apps/hoax/home*. This function omits the */rest/db* steps from the path, but the briefer version points to the same location. (Try both versions in the browser address bar!)
* `request:get-context-path()` Returns the part of the URL that precedes the prefix, typically */exist*.

We sometimes find it useful to use XPath to construct a full path to the collection that holds *controller.xql*, which we can do by using the XPath `concat()` function to stitch together some of the variables declared above. For example, for any URL in an app that lives at *http://localhost:8080/exist/rest/db/apps/hoax/more-path-stuff*:

```xpath
concat($context, $exist:prefix, $exist:controller, '/')
```

returns */exist/apps/hoax/*. We find this useful enough that we typically assign it to a variable (we call it `$fqcontroller`, for “fully qualified controller”), and it can be used to construct an absolute path within the app that is not dependent on fixed values for the hostname and port (since neither is specified) or the location where the app was installed (since that part is returned dynamically by the `$exist:prefix` variable). This means that such absolute paths, unlike full URLs, are safe to use in applications that will be installed by others.

#### Summary of *controller.xql* variables and functions

Given an input URL like *http://localhost:8080/exist/rest/db/apps/hoax/home* that will be rewritten by *controller.xql*, the variables and functions described above make the following values available:

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

The five variables are automatically available whether you declare them or not, but it’s good practice to declare them anyway. Since their meaning has been defined automatically, we declare them with the keyword `external`. We also typically assign the values of the two functions discussed above to variables, and we do the same with the composed absolute path to the location of *controller.xql*. You can copy and paste the following into any *controller.xql* that you need to write, or you can include only the values you actually wind up using.

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

Initially our app will deliver just a few resources, such as a simple reading view of a story and a main (home) page, so we’ll start by configuring *controller.xql* to receive these requests and rewrite them to point to the appropriate locations inside the database. We will then add further URL rewrite rules as they are needed to provide additional information.

## Retrospective overview of *controller.xql*

The *controller.xql* file is central to the operation of an app, but once you know how it works, its development is a small part of building the app. *controller.xql* for the type of app we will build is rarely more than a couple of screens in length, and it can be thought of (with some simplification) as having three parts:

1. Boilerplate, such as the automatic variables and path functions described above. These are the same in every app, and can be copied and pasted from one to another.
2. Utility functions. We’ll create a few functions to identify the extension (e.g., *.xml*, *.xql*, etc.) of a resource and do some other housekeeping. This, too, is largely the same from one app to another.
3. Rewriting logic. Different apps will use different types of URLs and provide different types of functionality. Although an app may contain a large number of files, it typically contains a small number of *types of files* or *modes of interaction* with information, which means that it typically needs only a small number of rewrite rules. For example, the same URL rewrite rule can provide a reading view of any story, no matter how many there are; another single rule can provide a map of the places in any story; etc. 

The preceding means that much of the content of *controller.xql* (items 1 and 2) is automatic regardless of the research goals of the app, and the part that is app-specific (item 3) is rarely extensive. 

## Optional (advanced)

### For more information

This tutorial assumes a default installation, which is useful for getting started, but also simplified. For more complete information about URL rewriting in eXist-db see:

* [URL rewriting](https://exist-db.org/exist/apps/doc/urlrewrite), the official eXist-db introduction.
* Chapter 9, “Building applications”, of Erik Siegel and Adam Retter’s *eXist. A NoSQL document database and application platform*. Beijing et al.: O’Reilly, 2014, pp. 191–235.

### Relative paths and constructed absolute paths

Resource paths are used by the eXist-db XML database itself and by Jetty, the HTTP server inside which eXist-db is embedded. In a default installation, the variable `$exist:root`, described above, returns the value *xmldb:exist:///db/apps*, which only eXist-db (but not Jetty) can interpret, since it begins with the eXist-db-specific *xmldb:exist* URL scheme. For example, links to CSS or JavaScript cannot be described by using `$exist:root` because they are interpreted by Jetty, which doesn’t understand the *xmldb:exist* scheme. For that reason, we use our constructed `$fqcontroller` variable when we need an absolute path that points to the main collection of the app in a way that Jetty, too, can interpret. 

**[ADD: When to use relative vs absolute (with controller variables) paths]**

## What next?

In the next lesson we use the concepts, models, and methods introduced here to begin to incorporate URL rewriting into our edition.