# Session plan: Leif-Jöran

[Link to instructor-view navigation page](daily_instructor_view.md)

## Week 1

### Monday, July 11, 2022

#### 11:00–12:30: The edition as a computational pipeline

Time | Topic | Type | Instructor
---- | ---- | ---- | ---- 
30 min | We introduce the computational pipeline as a way of modeling the development of a digital edition. | Presentation | Ronald
30 min | Initial stages: TEI XML (base view), exploring with XPath, and exploratory data analysis (EDA) with Shakespeare. | Presentation | Elli
**30 min** | **Transformation: how do I transform, what do I transform to? We also introduce the model-view-controller (MVC) architecture we’ll use in app development later on.** | **Presentation** | **Leif-Jöran**

### Tuesday, July 12, 2022

#### 11:00–12:30: Git, GitHub, and Markdown

Time | Topic | Type | Instructor
---- | ---- | ---- | ---- 
30 min | Git: introduce and begin to use version control software. | Presentation | Ronald
30 min | GitHub: code management, issues, projects, and Markdown. | Presentation | David, Gabi
**30 min** | **XQuery: introduce FLWOR (Ghost Hoax data).** | **Presentation** | **Leif-Jöran**

### Wednesday, July 13, 2022

#### 2:00–3:30: Creating a pipeline with XQuery: you are the controller (Ghost Hoax data).

Time | Topic | Type | Instructor
---- | ---- | ---- | ---- 
30 min | Translating your research goals into your work plan. | Talk lab | Chelcie
**60 min** | **Building a title list with XQuery: Create the model, part 2: construct model in model namespace.** | **Code lab** | **Leif-Jöran**

### Thursday, July 14, 2022

#### 9:00–10:30: XML databases and indexes

Time | Topic | Type | Instructor
---- | ---- | ---- | ---- 
30 min | Databases have at minimum data and a method of querying that data. Indexes enable direct and fast retrieval for querying the data. | Presentation | Cliff
**30 min** | **Indexing and profiling. Examine indexes and profiles in Monex.** | **Code lab** | **Leif-Jöran**
30 min | Using Lucene indexes. What are facets and fields? | Code lab | David

#### 2:00–3:30: The controller

Time | Topic | Type | Instructor
---- | ---- | ---- | ---- 
20 min | Where are we in the project? Planning for the next step? | Talk lab | Chelcie
15 min | What is a controller? Why do we need it? What factors determine controller design? | Discussion | Hugh
**15 min** | **Explore how the out-of-the-box controller works, along with what it can and cannot do.** | **Presentation** | **Leif-Jöran**
**10 min** | **URL rewriting: configure the controller to return the combined model plus view (title-list query).** | **Code lab** | **Leif-Jöran**
**10 min** | **Configure controller to return just the model (title-list query).** | **Code lab** | **Leif-Jöran**
**20 min** | **The full controller pipeline: returning the view (title-list query).** | **Code lab** | **Leif-Jöran**

#### 4:00–5:30: Collation

Time | Topic | Type | Instructor
---- | ---- | ---- | ---- 
45 min | Collation. | Presentation | Ronald
**45 min** | **Participant project presentations.** | **Discussion** | **Leif-Jöran**

### Friday, July 15, 2022

#### 11:00–12:30: Git and GitHub in Real Life

Time | Topic | Type | Instructor
---- | ---- | ---- | ---- 
40 min | Branches and you. | Presentation | Ronald
20 min | Practice with branches. | Code lab | Elli
**30 min** | **Create merge conflicts on purpose to gain familiarity with resolving them (without being thrown into a [vim black hole](https://dev.to/matthew_collison/comment/fi9p)).** | **Code lab** | **Leif-Jöran**

#### 4:00–5:30: Catchup session

Time | Topic | Type | Instructor
---- | ---- | ---- | ---- 
30 min | XQuery: taking stock. | Code lab | Cliff
30 min | Command line tips and tricks. | Code lab | Elli
**30 min** | **Slide slam.** | **Code lab** | **Leif-Jöran**

## Week 2

### Tuesday, July 19, 2022

#### 9:00–10:30: XQuery: model and view from the ground up

Time | Topic | Type | Instructor
---- | ---- | ---- | ---- 
**45 min** | **Enhancing the title list model.** | **Code lab** | **Leif-Jöran**
45 min | Adapt the view to the model using `typeswitch`. | Code lab | Cliff

#### 4:00–5:30: XQuery topics + review

Time | Topic | Type | Instructor
---- | ---- | ---- | ---- 
30 min | Using regular expressions to clean and encode our data. | Code lab | Cliff
**30 min** | **Find all the TEI elements used / attribute values used / etc.** | **Code lab** | **Leif-Jöran**
30 min | GEOJSON for maps. | Code lab | Gabi

### Wednesday, July 20, 2022

#### 9:00–10:30: SVG basics

Time | Topic | Type | Instructor
---- | ---- | ---- | ---- 
15 min | What is SVG and how does it work? | Presentation | Hugh
10 min | The SVG coordinate space. | Code lab | David
15 min | SVG housekeeping. | Code lab | David
**25 min** | **SVG basic shapes.** | **Code lab** | **Leif-Jöran**
25 min | Planning a sample visualization. | Talk lab | Gabi

#### 4:00–5:30: Special topic: Using Cytoscape to visualize network relationships with Elisa Beshero-Bondar

Time | Topic | Type | Instructor
---- | ---- | ---- | ---- 
30 min | Import TSV and explore network analysis data. | Code lab | Elisa
45 min | Style nodes and edges, create sub-networks from a complex network, and explore export formats from Cytoscape. | Code lab | Elisa
**15 min** | **(TEI) graphing for eXist-db.** | **Presentation** | **Leif-Jöran**

### Thursday, July 21, 2022

#### 9:00–10:30: Visualizing our geodata and integrating external APIs

Time | Topic | Type | Instructor
---- | ---- | ---- | ---- 
15 min | Write the model for our geodata and explore our ideas on how visual information can be displayed. | Talk lab | Gabi
15 min | Choose the right mapping tools for your project. | Talk lab | Gabi
30 min | Integrate basic map functionality into the app using a mapping JS library. | Presentation | Gabi
**30 min** | **(TEI) Graphing inside eXist-db.** | **Presentation** | **Leif-Jöran**

#### 11:00–12:30: Application programming interfaces (API)

Time | Topic | Type | Instructor
---- | ---- | ---- | ---- 
30 min | What is an Application Programming Interface (API)? | Presentation | Hugh
30 min | Our verb and noun choices, how we made them, what we might have done differently. | Presentation | David
**30 min** | **Documenting our decisions.** | **Talk lab** | **Leif-Jöran**

### Friday, July 22, 2022

#### 11:00–12:30: Implementation choices

Time | Topic | Type | Instructor
---- | ---- | ---- | ---- 
**20 min** | **Why use eXist-db?** | **Discussion** | **Leif-Jöran**
20 min | Why use MVC? | Discussion | Hugh
20 min | Why not XSLT? Can I use XSLT? | Discussion | David
10 min | Why is it organized by verb? | Discussion | Gabi
**10 min** | **Why use Git and GitHub? What are some management alternatives?** | **Discussion** | **Leif-Jöran**
10 min | Why use VSCode? What could we have used instead? | Discussion | Cliff

