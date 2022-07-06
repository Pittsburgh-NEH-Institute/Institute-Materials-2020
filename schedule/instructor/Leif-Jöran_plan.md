# Session plan: Leif-Jöran

[Link to instructor-view navigation page](daily_instructor_view.md)

## Week 1

### Monday, July 11, 2022

#### 11:00–12:30: The edition as a computational pipeline

Time | Topic | Type | Instructor
---- | ---- | ---- | ---- 
30 min | We introduce the computational pipeline as a way of modeling the development of a digital edition. | Presentation | Ronald
30 min | Initial stages: TEI XML (base view), exploring with XPath, and exploratory data analysis (EDA). | Presentation | Elli
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
10 min | Plan goals and pipeline organization. | Discussion | Gabi
10 min | Create the model, part 1: find the information you need. | Code lab | Gabi
**30 min** | **Create the model, part 2: construct model in model namespace.** | **Code lab** | **Leif-Jöran**
**10 min** | **Prepare to connect the model and the view: save the model to a variable.** | **Code lab** | **Leif-Jöran**
30 min | Create the view: transform the model to HTML. | Code lab | Cliff

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
**10 min** | **URL rewriting: configure the controller to return the combined model plus view.** | **Code lab** | **Leif-Jöran**
**10 min** | **Configure controller to return just the model.** | **Code lab** | **Leif-Jöran**
**20 min** | **The full controller pipeline: returning the view.** | **Code lab** | **Leif-Jöran**

### Friday, July 15, 2022

#### 11:00–12:30: Git and GitHub in Real Life

Time | Topic | Type | Instructor
---- | ---- | ---- | ---- 
20 min | Issues and pull requests. | Code lab | Elli
40 min | Branches and you. | Presentation | Ronald
**30 min** | **Create merge conflicts on purpose to gain familiarity with resolving them (without being thrown into a VIM black hole).** | **Code lab** | **Leif-Jöran**

## Week 2

### Tuesday, July 19, 2022

#### 9:00–10:30: Creating views and using typeswitch

Time | Topic | Type | Instructor
---- | ---- | ---- | ---- 
**30 min** | **Using typeswitch and local functions.** | **Code lab** | **Leif-Jöran**
60 min | Using typeswitch and local functions to create rich text reading views. | Code lab | Cliff

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
45 min | Upload TSV and explore data. | Code lab | Elisa
30 min | Export SVG from Cytoscape and upload to the edition. | Code lab | Elisa
**15 min** | **(TEI) graphing for eXist-db.** | **Presentation** | **Leif-Jöran**

### Thursday, July 21, 2022

#### 9:00–10:30: Review and practice: version control and project management with git and GitHub.

Time | Topic | Type | Instructor
---- | ---- | ---- | ---- 
**20 min** | **Development and feature branches, tracking branches, and branch strategies.** | **Code lab** | **Leif-Jöran**
20 min | Releases and semantic versioning. | Presentation | Hugh
15 min | Project management reflections. | Discussion | Chelcie
35 min | Planning our own projects. | Talk lab | Chelcie

#### 2:00–3:30: Database indexes, queries, and profiling

Time | Topic | Type | Instructor
---- | ---- | ---- | ---- 
**30 min** | **Understanding eXist-db indexing.** | **Presentation** | **Leif-Jöran**
20 min | Examining indexes in Monex. | Code lab | David
**20 min** | **Profiling queries.** | **Code lab** | **Leif-Jöran**
**20 min** | **Optimizing queries.** | **Code lab** | **Leif-Jöran**

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

