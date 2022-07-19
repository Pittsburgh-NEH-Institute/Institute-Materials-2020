# Interim stages of the hoax app

We build the hoax app in several stages, which we’ve saved in separate GitHub repos, so that you can download and examine each of them, and run them to see what they output. The stages are:

* **01-data:** Contains data, but no XQuery processing
* **02-titles-no-controller:** Outputs formatted titles (preview of one output goal)
* **03a-titles-model:** Outputs the model for titles (not formatted)
* **04-index:** Adds *collection.xconf* to support indexed querying
* **05-base-models:** Adds base models for persons and places
* **06-controller:** Adds a *controller.xql* for MVC output of formatted views
* **06a-controller-search:** Adds word-search functionality to the preceding stage (06-controller).

Note that there is a **03a-titles-model** but not a **03-titles-model**.

You can clone each of these, build an installable *xar* file by typing `ant` in the root directory of the app, and install it into your local eXist-db instance with the Package Manager.

We haven’t built stages for some subsequent housekeeping, but the preceding ones implement all of the meaningful functionality of the app from the persepctive of the research goals that motivated its development.

## 01-data

**Synopsis:** This stage contains just the app data. 

**URL:** <https://github.com/Pittsburgh-NEH-Institute/01-data>

The hierarchical organization of the data part of the repo looks like:

```
pr-app
    ├── data
    │   ├── aux_xml
    │   ├── hoax_xml
    │   └── schemas
```

The *pr-app* main directory has several subdirectories, one of which is called *data*. The *data* directory has three subdirectories:

* *aux_xml* contains auxiliary TEI XML files with information about persons and places mentioned in the corpus. We use these for our persons and places lists.
* *hoax_xml* contains TEI XML files for the newspaper articles that form the main focus of the research. We use these for the titles list (including the search interface), the formatted reading view, and the TEI view.
* *schemas* contains ODD, Relax NG, and Schematron files used for validating the data. We do not use these files for processing. 

When you install and launch this app you see an XML representation of the hierarchical structure of the app. In the next stage we’ll enhance the app by created a formatted list of article titles.

## 02-titles-no-controller

**Synopsis:** This stage adds an XQuery module that creates a formatted list of titles in HTML. 

**URL:** <https://github.com/Pittsburgh-NEH-Institute/02-titles-no-controller>

When you install and launch the app the initial output looks like the output of the preceding stage. If you edit the address bar in the browser by changing it to:

```
http://localhost:8080/exist/apps/02-titles-no-controller/modules/titles.xql
```

you’ll see a formatted (HTML) list of article titles.

If you look inside the repo at the `titles.xql` file you’ll notice that the XQuery operates in two steps. The first step is:

```xquery
declare variable $data as element(m:titles) :=
<m:titles>{
    for $article in $articles
    return
        <m:title>{$article//tei:titleStmt/tei:title ! fn:string(.)}</m:title>
}</m:titles>;
```

This creates a representation of the table in the model namespace and binds the entire representation to the variable name `$data`. The second stage then transforms the model (in the model namespace) into the view (in the HTML namespace):

```xquery
<html:section>
  <html:ul>{
    for $title in $data/m:title
    return
        <html:li>{$title ! string(.)}</html:li>
}</html:ul>
</html:section>
```

For reasons we explained when we introduced MVC architecture, in Real Life we don’t normally transform TEI XML source to HTML output in a single script. What we do instead is create two separate XQuery modules (files), one to build the model and the other to transform the model into the view. These two modules form a *computational pipeline*, where the controller ensures that the output of the first module functions as the input to the second module. We’ve put all of the functionality into a single XQuery module in this repo just to illustrate our target output, but it isn’t what we do in real projects.

## 03a-titles-model

**Synopsis:** This stage removes the second step in the preceding pipeline, so we create the model for the titles list (in the model namespace) and return it directly. 

**URL:** <https://github.com/Pittsburgh-NEH-Institute/03a-titles-model>

## 04-index

**Synopsis:** This stage add a *collection.xconf* file to support indexed retrieval. 

**URL:** <https://github.com/Pittsburgh-NEH-Institute/04-index>

eXist-db can perform most XQuery operations with or without indexing, but:

1. Some eXist-db functions and features are supported only if the developer has created an appropriate index.
2. Some functions operate more quickly, especially with large amounts of data, if a supporting index is present.

eXist-db provides an `ft:query()` function that can be used to search for words or other strings of text. Some of the functionality of `ft:query()` can be mimicked with standard XPath functions (e.g., `contains()`, `matches()`), but one unique feature of `ft:query()` is that provides straightforward support for highlighting words that are searched in a text. For example, we can search for all articles in our collection that contain the word “constable” and `ft:query()` provides a simple way of highlighting that word when it returns the document.

In this sample repo we add a *collection.xconf* that configures a full-text index for `<TEI>` elements. We then modify *titles.xql* by making the following changes:

```
declare variable $articles as element(tei:TEI)+ 
    := $articles-coll/tei:TEI[ft:query(., 'ghost')];
```

Instead of setting the variable `$articles` equal to all `<TEI>` elements in the corpus, we use the full-text index to filter those articles and keep only those that contain the word “ghost”. We’ll talk about how `ft:query()` does that filtering later. Since all of our articles contain the word “ghost” we aren’t really filtering anything, but the full-text index makes it possible to highlight all matches, which we do with:

```
declare variable $data as element(m:titles) :=
<m:titles>{
    for $article in $articles 
    return
        <m:title>{$article//tei:titleStmt/tei:title => util:expand()}</m:title>
}</m:titles>;
```

Instead of stringifying the title we arrow it into the eXist-db `util:expand()` function, which highlights all matches identified by the `ft:query()` function. The output now looks like (excerpt):

```
<title xmlns="http://www.tei-c.org/ns/1.0">
Fears of a
<exist:match xmlns:exist="http://exist.sourceforge.net/NS/exist">Ghost</exist:match>
, and the Fatal Catastrophe
</title>
```

The `ft:query()` and `util:expand()` functions conspire to wrap `<exist:match>` tags around all parts of the result that matched the string specified as the second argument to `ft:query()`. We can’t just stringify the title now because we would lose that highlighting, but in Real Life the XQuery that transforms the model into the view would throw away the `<title>` tags and translate `<exist:match>` into an HTML `<span>` with a `@class` value that can be used for CSS styling. 

## 05-base-models

**Synopsis:** This stage creates models for article titles, persons,
and places (the persons and places are new). There is no controller yet and it does not create views.

**URL:** <https://github.com/Pittsburgh-NEH-Institute/05-base-models>

## 06-controller

**Synopsis:** This stage builds on *05-base-models* by using the controller to creates views for titles, persons, and places.

**URL:** <https://github.com/Pittsburgh-NEH-Institute/06-controller>

## 06a-controller-search

**Synopsis:** This stage builds on *06-controller* to add word-search filtering. 

**URL:** <https://github.com/Pittsburgh-NEH-Institute/06a-controller-search>

You can perform the filtering either with the search form shown on the page or by specifying the term in the address bar of the browser. For example (you must enable search filtering for this to work; see below):

1. <http://localhost:8080/exist/apps/06a-controller-search/titles> returns all titles
2. <http://localhost:8080/exist/apps/06a-controller-search/titles?term=constable> returns titles of all articles where the article text (not necessarily the title) contains the word “constable”
3. <http://localhost:8080/exist/apps/06a-controller-search/titles?term=potato> returns an informative error message because no article in the collection happens to contain the word “potato”

This stage builds changes two files from *06-controller*:

1. *modules/titles.xql* retrieves a user-specified `$term` parameter and uses it to show titles only for articles that contain the term. If no term is specified, it shows all titles. There are three declarations in *titles.xql* for the `$articles` variable, only one of which can be active at a time (you must comment out the other two). The first does no filtering, the second filters by exact string (so specifying “Constable” will not find articles that contain “constable”), and the third does case-insensitive filtering.
2. *views/titles-to-html.xql* displays the search form.

