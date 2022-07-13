# Week 1, Day 4: Thursday, July 14, 2022
[Link to instructor-view navigation page](../daily_instructor_view.md)

## Synopsis

XQuery in XML databases. Day four reimagines the edition in a research-driven way
                within a digital environment. In the morning, we guide participants through
                installing an application into eXist-db and exploring its indexes. In the afternoon,
                participants practice these new skills by developing their own XQuery to be
                implemented later in an eXist-db application framework. Next, we begin writing the
                controller, which stitches together the data, the models, and eventually, the views.
                The final session of the day will focus on collation.

## Outcome goals
* Understand the benefits and limitations of XML databases.
* Become familiar with the different types of indexes one can use in an XML database.
* Understand indexes by running queries with and without indexed data.
* Gain experience writing code aligned with research goals.
* Use MVC framework to output *model* data.
* Prepare to write your own controller.
* Understand controller writing syntax.

## Legend

* **Presentation:** by instructors
* **Discussion:** instructors and participants
* **Talk lab:** participants discuss or plan in small groups
* **Code lab:** participants code alone or in small groups

* * *
## 9:00–10:30: XML databases and indexes

### Edition repo stages for session

* [Creating title list: model only](https://github.com/Pittsburgh-NEH-Institute/03-titles-model)
* [Creating index: collection.xconf](https://github.com/Pittsburgh-NEH-Institute/04-index)

Time | Topic | Type | Instructor
---- | ---- | ---- | ---- 
30 min | Databases have at minimum data and a method of querying that data. Indexes enable direct and fast retrieval for querying the data. | Presentation|Cliff
30 min | Indexing and profiling. Examine indexes and profiles in Monex. | Code lab|Leif-Jöran
30 min | Using Lucene indexes. What are facets and fields? | Code lab|David

## 10:30–11:00: Coffee break

## 11:00–12:30: Developing the model to support a feature

### Edition repo stages for session

* [Creating index: collection.xconf](https://github.com/Pittsburgh-NEH-Institute/04-index)
* [Creating models: feature base models](https://github.com/Pittsburgh-NEH-Institute/05-base-models)

Time | Topic | Type | Instructor
---- | ---- | ---- | ---- 
30 min | Building a title list with XQuery: Create the view: transform the model to HTML. | Code lab|Cliff
60 min | Participants work together on preliminary code that they would like to develop into a feature. | Code lab|Gabi

## 12:30–2:00: Lunch

## 2:00–3:30: The controller

### Edition repo stages for session

* [Creating models: feature base models](https://github.com/Pittsburgh-NEH-Institute/05-base-models)
* [Creating a controller](https://github.com/Pittsburgh-NEH-Institute/06-controller)

Time | Topic | Type | Instructor
---- | ---- | ---- | ---- 
20 min | Where are we in the project? Planning for the next step? | Talk lab|Chelcie
15 min | What is a controller? Why do we need it? What factors determine controller design? | Discussion|Hugh
15 min | Explore how the out-of-the-box controller works, along with what it can and cannot do. | Presentation|Leif-Jöran
10 min | URL rewriting: configure the controller to return the combined model plus view (title-list query). | Code lab|Leif-Jöran
10 min | Configure controller to return just the model (title-list query). | Code lab|Leif-Jöran
20 min | The full controller pipeline: returning the view (title-list query). | Code lab|Leif-Jöran

## 3:30–4:00: Coffee break

## 4:00–5:30: Collation

Time | Topic | Type | Instructor
---- | ---- | ---- | ---- 
45 min | Collation. | Presentation|Ronald
45 min | Participant project presentations. | Discussion|Leif-Jöran

We’ll end each day with a request for feedback, based on a general version of the day’s outcome goals, and we’ll try to adapt on the fly to your responses. Links to the feedback forms are in our Slack workspace in the #daily-feedback channel (posting from Mason on Mon, July 11).