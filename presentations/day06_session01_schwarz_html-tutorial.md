# Recipe: how to write HTML

## Ingredients (or, elements)

To get directly to the recipe, go to [“Recipe: HTML”](#recipe-html)

### Required ingredients

* `<!DOCTYPE html>`
    - Declares the type of a document (in this case, HTML)
    - **Not** an element, but a required tag at the beginning of a document
* `<html>`
    - The root element
    - Contains all other elements
    - XML version requires a namespace
* `<head>`
    - Contains a document's metadata
* `<title>`
    - Declares a title for the page
    - Visible in a browser, as a bookmarked page's title, etc.
    - Stored inside of the `<head>` element
* `<body>`
    - Contains the content of a page (what is visible to the user)
    - Holds the optional elements listed below

### Optional ingredients (developer's choice)

This is just a sample of possible elements that are used on this page. For a list of resources describing these elements and more, head to the [resources section](#further-resources).

* `<h1>` to `<h6>`
    - Section headers
    - Organized hierarchically, can be used to structure page content
    - For example, “Recipe: how to write HTML” (`<h1>`), “Ingredients (or, elements)” (`<h2>`), and “Required ingredients” (`<h3>`)
* `<p>`
    - Paragraphs
    - Contains sections of text (like a paragraph in a novel)
* `<ul>`
    - Unnumbered, bulleted lists
    - For example, the ingredient lists
* `<ol>`
    - Numbered lists
    - For example, the numbered recipe steps below
* `<li>`
    - List items
    - Contained within either an unordered or ordered list
    - For example, each bulleted item in the ingredient lists
* `<a>`
    - Contains a link to another web page
    - Can be used to link between sections of a page
* `<table>`
    - Tables 
    - Contains `<tr>`, `<th>`, and `<td>` elements
* `<tr>`
    - Table rows 
    - Contains either `<th>` elements or `<td>` elements
* `<th>`
    - Table headers 
    - Labels each column of a table 
* `<td>`
    - Table data 
    - Populates the rows of each table column with data

## Recipe: HTML

Here, we will detail the process of creating a sample HTML page. Broadly, this entails creating an empty file ending in .html or .xhtml, declaring the document type as HTML, then populating the HTML root element `<html>` with its metadata and content in the `<head>` and `<body>` elements, respectively. Then, to look at your page, open the file in a browser. To view the raw HTML, right-click on the page, and select “View page source.” The steps for creating this HTML recipe page are outlined below. For additional help, you can look at what the source HTML for this page might look like in the [“Completed recipe view”](#completed-recipe-view) section.

### Directions

1. In VSCode, open a blank file ending in .html.
1. Declare the document type by writing `<!DOCTYPE html>` at the top of the page.
1. Create the root element `<html></html>`. If using the XML version of HTML, be sure to include a namespace. For example, `<html         xmlns="http://www.w3.org/1999/xhtml"></html>`.
1. Place the metadata `<head></head>`. Make sure that the `<head>` element is **within** the root element.
1. Give the page a descriptive title, and place it in the `<title>` element **within** the `<head>` element. In this case, it is “HTML Tutorial.” It will look like this: `<title>HTML Tutorial</title>`.
1. Create the content of the page by placing the `<body>` element **below** the `<head>` and **within** the root element.
1. Give the page a visible header title. Place the `<h1>` element **within** the `<body>`, then write “Recipe: how to write HTML” between the corresponding `<h1>` tags. It will look like this: `<h1>`Recipe: how to write HTML`</h1>`.
1. Then, place the second header by writing `<h2>Ingredients (or, elements)</h2>` **below** the first header.
1. Provide a direct link to the “Recipe” section. Write `<p>To get directly to the recipe, go to <a href="#recipeStart">"Recipe: HTML"</a>.</p>` **under** the second header. (We will place the element that is being linked to through the `<a>` element later).
1. Place a subheader for required ingredients, writing the following underneath the above direct link: `<h3>Required ingredients</h3>`.
1. All of the nested, unnumbered lists follow the same structure. Head to [the tutorial](#directions-making-a-nested-list) to follow along with making a list. Then, return to complete the rest of the steps of the recipe.
1. The “Optional ingredients” section follows the same process as the “Required ingredients,” beginning at step 9. Here, instead of linking to the “Recipe” section, the “Resources” section is linked to through its id “#resourceStart” instead of “#recipeStart.”
1. Now, we have reached the “Recipe” section. To both place and link to the “Recipe” `<h2>` element, write: `<h2 id="recipeStart">Recipe: HTML</h2>`.
1. Write the recipe description within a `<p>` element.
1. Then, place the “Directions” subheader within an `<h3>` element.
1. To write numbered directions, follow the same general process of the unnumbered list (without nesting). However, this time place the `<li>` elements within an **ordered list**, the element `<ol>`.
1. For "Directions: making a nested list," continue the process of constructing a numbered list and linking between headers. The link id for the nested list tutorial is "#listTutorial".
1. The “Further resources” section of the page departs from the list-making conventions established previously. This time, we construct a table, with two columns and four rows. First, place a `<table>` element. Then, create the first row by placing a `<tr>` element within the `<table>` element. This will be your first row (the header row that labels the columns of the table).
1. Place the two table headers by writing `<th>Resource</th>` and `<th>Description</th>` within the `<tr>` element. Then, create the second row by placing a new `<tr>` element below the first one. Place `<td><a href="https://www.w3schools.com/html/">W3Schools HTML Tutorial</a></td>` and `<td>An expansive collection of tutorials and other resources</td>` within that second `<tr>` element.
1. The remaining two resources and their accompanying descriptions follow this same pattern of placing a `<tr>` element, then placing `<td>` elements within that `<tr>` element.
1. Congratulations, you've completed the recipe!

### Directions: making a nested list

1. Create an unordered list `<ul></ul>`.
1. Place a list item element `<li></li>` within the unordered list. 
1. Within the `<li>` element, write the name of an element.
1. Then, place the nested list, writing another `<ul>` element, this time within the `<li>` element you just placed.
1. As above, place more `<li>` elements within the second, nested `<ul>` element.
1. The resulting HTML should look like the “Tea” entry in the following [W3Schools nested list tutorial](https://www.w3schools.com/html/tryit.asp?filename=tryhtml_lists_nested).
1. Now, return to step 12 of the recipe. 

## Further resources

| Resource    | Description |
| ----------- | ----------- |
| [W3Schools HTML Tutorial](https://www.w3schools.com/html/)      |	An expansive collection of tutorials and other resources |
| [David J. Birnbaum's “HTML Basics”](http://dh.obdurodon.org/html_basics.xhtml)   | An XML-focused introduction to HTML     |
| [MDN Web Docs HTML Resources](https://developer.mozilla.org/en-US/docs/Web/HTML)            | Another expansive collection of tutorials and resources, this time from Mozilla            |

## Completed recipe view

        <!DOCTYPE html>
        <html>
            <head>
                <title>HTML Tutorial</title>
            </head>
            <body>
                <h1>Recipe: how to write HTML</h1>
                <h2>Ingredients (or, elements)</h2>
                <p>To get directly to the recipe, go to <a href="#recipeStart">"Recipe: HTML"</a>.</p>
                <h3>Required ingredients</h3>
                <ul>
                    <li><code>&lt;!DOCTYPE html&gt;</code>
                        <ul>
                            <li>Declares the type of a document (in this case, HTML)</li>
                            <li><b>Not</b> an element, but a required tag at the beginning of a document</li>
                        </ul>
                    </li>
                    <li><code>&lt;html&gt;</code>
                        <ul>
                            <li>The root element</li>
                            <li>Contains all other elements</li>
                            <li>XML version requires a namespace</li>
                        </ul>
                    </li>
                    <li><code>&lt;head&gt;</code>
                        <ul>
                            <li>Contains a document's metadata</li>
                        </ul>
                    </li>
                    <li><code>&lt;title&gt;</code>
                        <ul>
                            <li>Declares a title for the page</li>
                            <li>Visible in a browser, as a bookmarked page's title, etc.</li>
                            <li>Stored inside of the <code>&lt;head&gt;</code> element</li>
                        </ul>
                    </li>
                    <li><code>&lt;body&gt;</code>
                        <ul>
                            <li>Contains the content of a page (what is visible to the user)</li>
                            <li>Holds the optional elements listed below</li> 
                        </ul>
                    </li>
                </ul>
                <h3>Optional ingredients (developer's choice)</h3>
                <p>This is just a sample of possible elements that are used on this page. For a list of resources 
                    describing these elements and more, head to the <a href="#resourceStart">resources section</a>.
                </p>
                <ul>
                    <li><code>&lt;h1&gt;</code> to <code>&lt;h6&gt;</code>
                        <ul>
                            <li>Section headers</li>
                            <li>Organized hierarchically, can be used to structure page content</li>
                            <li>For example, "Recipe: How to Write HTML" (<code>&lt;h1&gt;</code>),
                                "Ingredients (or, elements)" (<code>&lt;h2&gt;</code>), and 
                                "Required ingredients" (<code>&lt;h3&gt;</code>)
                            </li>
                        </ul>
                    </li>
                    <li><code>&lt;p&gt;</code>
                        <ul>
                            <li>Paragraphs</li>
                            <li>Contains sections of text (like a paragraph in a novel)</li>
                        </ul>
                    </li>
                    <li><code>&lt;ul&gt;</code>
                        <ul>
                            <li>Unnumbered, bulleted lists</li>
                            <li>For example, the ingredient lists</li>
                        </ul>
                    </li>
                    <li><code>&lt;ol&gt;</code>
                        <ul>
                            <li>Numbered lists</li>
                            <li>For example, the numbered recipe steps below</li>
                        </ul>
                    </li>
                    <li><code>&lt;li&gt;</code>
                        <ul>
                            <li>List items</li>
                            <li>Contained within either an unordered or ordered list</li>
                            <li>For example, each bulleted item in the ingredient lists</li>
                        </ul>               
                    </li>
                    <li><code>&lt;a&gt;</code>
                        <ul>
                            <li>Contains a link to another web page</li>
                            <li>Can be used to link between sections of a page</li>
                        </ul>
                    </li>
                    <li><code>&lt;table&gt;</code>
                        <ul>
                            <li>Tables</li>
                            <li>Contains <code>&lt;tr&gt;</code>, <code>&lt;th&gt;</code>, and <code>&lt;td&gt;</code> elements</li>
                        </ul>
                    </li>
                    <li><code>&lt;tr&gt;</code>
                        <ul>
                            <li>Table rows</li>
                            <li>Contains either <code>&lt;th&gt;</code> elements or <code>&lt;td&gt;</code> elements</li>
                        </ul>
                    </li>
                    <li><code>&lt;th&gt;</code>
                        <ul>
                            <li>Table headers</li>
                            <li>Labels each column of a table</li>
                        </ul>
                    </li>
                    <li><code>&lt;td&gt;</code>
                        <ul>
                            <li>Table data</li>
                            <li>Populates the rows of each table column with data</li>
                        </ul>
                    </li>
                </ul>
                <h2 id="recipeStart">Recipe: HTML</h2>
                <p>Here, we will detail the process of creating a sample HTML page. Broadly, this 
                    entails creating an empty file ending in .html or .xhtml, declaring the document
                    type as HTML, then populating the HTML root element <code>&lt;html&gt;</code> 
                    with its metadata and content in the <code>&lt;head&gt;</code> and 
                    <code>&lt;body&gt;</code> elements, respectively. Then, to look at your page, open 
                    the file in a browser. To view the raw HTML, right-click on the page, and select 
                    "View page source." The steps for creating this HTML recipe page are outlined below.
                    For additional help, you can follow along with the raw HTML for this page by clicking 
                    "View page source." 
                </p>
                <h3>Directions</h3>
                <ol>
                    <li>In VSCode, open a blank file ending in .html.</li>
                    <li>Declare the document type by writing <code>&lt;!DOCTYPE html&gt;</code>
                        at the top of the page.
                    </li>
                    <li>Create the root element <code>&lt;html&gt;&lt;/html&gt;</code>. If 
                        using the XML version of HTML, be sure to include a namespace. For example, 
                        <code>&lt;html xmlns="http://www.w3.org/1999/xhtml"&gt;&lt;/html&gt;</code>.
                    </li>
                    <li>Place the metadata <code>&lt;head&gt;&lt;/head&gt;</code>. Make sure 
                        that the <code>&lt;head&gt;</code> element is <b>within</b> the
                        root element.
                    </li>
                    <li>Give the page a descriptive title, and place it in the <code>&lt;title&gt;</code>
                        element <b>within</b> the <code>&lt;head&gt;</code> element. In this case, 
                        it is "HTML Tutorial." It will look like this: <code>&lt;title&gt;HTML 
                            Tutorial&lt;/title&gt;</code>. 
                    </li>
                    <li>Create the content of the page by placing the <code>&lt;body&gt;</code>
                        element <b>below</b> the <code>&lt;head&gt;</code> and <b>within</b>
                        the root element. 
                    </li>
                    <li>Give the page a visible header title. Place the <code>&lt;h1&gt;</code>
                        element <b>within</b> the <code>&lt;body&gt;</code>, then write "Recipe: 
                        how to write HTML" between the corresponding <code>&lt;h1&gt;</code> tags. 
                        It will look like this: <code>&lt;h1&gt;Recipe: how to write HTML&lt;/h1&gt;</code>. 
                    </li>
                    <li>Then, place the second header by writing <code>&lt;h2&gt;Ingredients 
                        (or, elements)&lt;/h2&gt;</code> <b>below</b> the first header.
                    </li>
                    <li>Provide a direct link to the "Recipe" section. Write <code>&lt;p&gt;To get 
                        directly to the recipe, go to &lt;a href="#recipeStart"&gt;"Recipe: HTML"&lt;/a&gt;.&lt;/p&gt; 
                        </code> <b>under</b> the second header. (We will place the element that is being linked
                        to through the <code>&lt;a&gt;</code> element later).
                    </li>
                    <li>Place a subheader for required ingredients, writing the following
                        underneath the above direct link: <code>&lt;h3&gt;Required
                        ingredients&lt;/h3&gt;</code>.
                    </li>
                    <li>All of the nested, unnumbered lists follow the same structure. Head to <a href="#listTutorial">the tutorial</a>
                        to follow along with making a list. Then, return to complete the rest of the 
                        steps of the recipe. 
                    </li>
                    <li>The "Optional ingredients" section follows the same process as the "Required ingredients," beginning
                        at step 9. Here, instead of linking to the "Recipe" section, the "Resources" section is linked to through
                        its id "#resourceStart" instead of "#recipeStart."
                    </li>
                    <li>Now, we have reached the "Recipe" section. To both place and link to the "Recipe" <code>&lt;h2&gt;</code>
                        element, write: <code>&lt;h2 id="recipeStart"&gt;Recipe: HTML&lt;/h2&gt;</code>.
                    </li>
                    <li>Write the recipe description within a <code>&lt;p&gt;</code> element.</li>
                    <li>Then, place the "Directions" subheader within an <code>&lt;h3&gt;</code> element.</li>
                    <li>To write numbered directions, follow the same general process of the unnumbered list (without nesting). 
                        However, this time place the <code>&lt;li&gt;</code> elements within an <b>ordered list</b>,
                        the element <code>&lt;ol&gt;</code>.
                    </li>
                    <li>For "Directions: making a nested list," continue the process of constructing a numbered list and linking
                        between headers. The link id for the nested list tutorial is "listTutorial."
                    </li>
                    <li>The "Further resources" section of the page departs from the list-making conventions established previously. 
                        This time, we construct a table, with two columns and four rows. First, place a <code>&lt;table&gt;</code> element. 
                        Then, create the first row by placing a <code>&lt;tr&gt;</code> element within the <code>&lt;table&gt;</code> element. 
                        This will be your first row (the header row that labels the columns of the table).     
                    </li>
                    <li>Place the two table headers by writing <code>&lt;th&gt;Resource&lt;/th&gt;</code> and 
                        <code>&lt;th&gt;Description&lt;/th&gt;</code> within the <code>&lt;tr&gt;</code> element. Then, create the second 
                        row by placing a new <code>&lt;tr&gt;</code> element below the first one. Place 
                        <code>&lt;td&gt;&lt;a href="https://www.w3schools.com/html/"&gt;W3Schools HTML Tutorial&lt;/a&gt;&lt;/td&gt;</code> 
                        and <code>&lt;td&gt;An expansive collection of tutorials and other resources&lt;/td&gt;</code> within that second 
                        <code>&lt;tr&gt;</code> element. 
                    </li>
                    <li>The remaining two resources and their accompanying descriptions
                        follow this same pattern of placing a <code>&lt;tr&gt;</code> element, then placing <code>&lt;td&gt;</code> elements
                        within that <code>&lt;tr&gt;</code> element.
                    </li>
                    <li>Congratulations, you've finished the recipe!</li>
                </ol>
                <h3 id="listTutorial">Directions: making a nested list</h3>
                <ol>
                    <li>Create an unordered list <code>&lt;ul&gt;&lt;/ul&gt;</code>.</li>
                    <li>Place a list item element <code>&lt;li&gt;&lt;/li&gt;</code>
                        within the unordered list.</li>
                    <li>Within the <code>&lt;li&gt;</code> element, write the name of an element.</li>
                    <li>Then, place the nested list, writing another <code>&lt;ul&gt;</code> element, 
                        this time within the <code>&lt;li&gt;</code> element you just placed.
                    </li>
                    <li>As above, place more <code>&lt;li&gt;</code> elements within the second, nested
                        <code>&lt;ul&gt;</code> element.
                    <li>The resulting HTML should look like the "Tea" entry in the following 
                        <a href="https://www.w3schools.com/html/tryit.asp?filename=tryhtml_lists_nested">W3Schools nested
                        list tutorial</a>.
                    </li> 
                    <li>Now, return to step 12 of the recipe.</li>     
                </ol>
                <h2 id="resourceStart">Further resources</h2>
                <table>
                    <tr>
                        <th>Resource</th>
                        <th>Description</th> 
                    </tr>
                    <tr>
                        <td><a href="https://www.w3schools.com/html/">W3Schools HTML Tutorial</a></td>
                        <td>An expansive collection of tutorials and other resources</td>
                    </tr>
                    <tr>
                        <td><a href="http://dh.obdurodon.org/html_basics.xhtml">David J. Birnbaum's "HTML Basics"</a></td>
                        <td>An XML-focused introduction to HTML</td>
                    </tr>
                    <tr>
                        <td><a href="https://developer.mozilla.org/en-US/docs/Web/HTML">MDN Web Docs HTML Resources</a></td>
                        <td>Another expansive collection of tutorials and resources, this time from Mozilla</td>
                    </tr>          
                </table>
            </body>
        </html>

        