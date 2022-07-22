# Verbs and nouns in the *pr-app* API

## Preliminary

1. The eXist-db controller is a type of API.
2. This Institute activity focuses on **human** interactions with the **eXist-db controller** in a **web browser** (that is, on how the **URL** in the **browser address bar** is processed). 
3. There are other ways that users (and machines) interact with APIs:
    * Mapbox server (Gabi’s geo presentation)
    * IIIF server interactions (Jeffrey’s upcoming IIIF guest lecture) 

## Conclusion

1. Think about project goals, services, and resources.
2. Some choices are equally useful.
3. Document your decisions—especially for your future self.

## Preliminaries

### CRUD

(Based partially on: <https://nordicapis.com/crud-vs-rest-whats-the-difference/>)

* **CRUD** (**Create**, **Read**, **Update**, **Delete**) describes actions to interact with a server. 
* **HTTP** (HyperText Transfer Protocol) has methods (**Get**, **Post**, **Delete**, **Put**) that correspond (loosely) to CRUD actions.

CRUD | HTTP
---- | ----
Create | Post/Put
Read | Get/Post
Update | Post/Put/Patch
Delete | Delete

HTTP supports other interactions, e.g., Hugh used the GitHub API in the TEI repos to create a new Git branch. 

*pr-app* requires only Read, which we implement only with Get.

### Human or machine?

* Machine-to-machine: The formal structure of APIs facilitates reliable machine-to-machine interaction (cf. Mapbox, IIIF).
* Human-to-machine: *pr-app* prioritizes human-to-machine interaction.

API guides often focus on metadata and discovery, with endpoints (URIs) to learn about the site or project structure and resources. HATEOS (Hypermedia as the Engine of Application State, a REST constraint) supplies link relations that can guide subsequent queries (example at [Wikipedia](https://en.wikipedia.org/wiki/HATEOAS)). *pr-app* prioritizes human interaction and human-oriented modes of discovery.

### Human-readable URL?

* *pr-app*: <http://localhost:8080/exist/apps/pr-app/read?id=GH-TIMES-1804011>
* *eXist-db documentation*: <http://exist-db.org/exist/apps/doc/lucene.xml?field=all&id=D3.15.73#D3.15.73> (points to “Full Text Index”)

## Issues

### Order of components: noun first or verb first

* Resource (noun) first
    * I want to do something with GH-TIMES-18040106, and what I want to do is read it
    * */path-to-app/GH-TIMES-18040106/read*
    * */path-to-app/GH-TIMES-18040106/tei*
* Action (verb) first
    * I want to read something, and what I want to read is GH-TIMES-18040106
    * */path-to-app/read/GH-TIMES-18040106*
    * */path-to-app/tei/GH-TIMES-18040106*

*pr-app* is verb first:

* Most “best practice” recommendations favor noun first.
* API guides imagine full CRUD interactions, but our access is read-only.
* Cf. “Intent-based APIs” [Don’t Use CRUD Styled APIs, Consider Intent-Based Rest APIs](https://betterprogramming.pub/intent-based-rest-apis-or-an-alternative-to-crud-based-rest-apis-1815599db60a)

### Singleton and collection

* Always include collection (if relevant)
    * */path-to-app/articles*
    * */path-to-app/articles/GH-TIMES-18040106*
    * */path-to-app/articles/GH-TIMES-18040106/read*
* No collection (even when potentially relevant)
    * */path-to-app/GH-TIMES-18040106/read*

*pr-app* omits the plurals. We do not expose subcollections, although we could (*hoax_xml* vs *aux_xml*). 

### Path components or parameters for resource identifiers

* Path component: */path-to-app/read/GH-TIMES-18040106*
* Parameter: */path-to-app/read?id=GH-TIMES-18040106*

*pr-app* uses parameters:

* All of our menu items aggregate information (titles [articles], map, visualize, persons, places)
* The only actions that select individual items are *read* and *tei*.

Filtered search in *pr-app*:

http://localhost:8080/exist/apps/pr-app/search?term=&publishers%5B%5D=Leader%2C+The&month-years%5B%5D=1853-07

* Path to app: *http://localhost:8080/exist/apps/pr-app*
* What to do: */search*
* No search term: *term=*
* Publishers:
    * publishers%5B%5D=Leader%2C+The*
    * publishers[]=Leader, The
* (No decades)
* Month-year combinations:
    * month-years%5B%5D=1853-07
    * month-years[]=1853-07

### HTTP status codes

HTTP servers return a numerical code for each request, such as:

* 200: Success
* 301: Permanent redirect
* 404: Not found
* 500: Server error

eXist-db has its own HTTP server (Jetty). When we ask for an article that doesn’t exist, Jetty returns successfully (200) and we handle the error ourselves, but from the user perspective the resource was not found (404). How much do we care?

### Composite pages

With side-by-side image and transcription, each is a resource. What should the URL look like?

### For more information

[REST API tutorial](https://restfulapi.net/)
