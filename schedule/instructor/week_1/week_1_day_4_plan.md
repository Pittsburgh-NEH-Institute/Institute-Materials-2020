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
* Become familiar with eXist-db index syntax.
* Implement fields.
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

Time | Topic | Type | Instructor
---- | ---- | ---- | ---- 
30 min | Databases have at minimum data and a method of querying that data. Indexes enable direct and fast retrieval for querying the data. | Presentation|Cliff
30 min | Indexing and profiling. Examine indexes and profiles in Monex. | Code lab|Leif-Jöran
30 min | Using Lucene indexes. What are facets and fields? | Code lab|David

## 10:30–11:00: Coffee break

## 11:00–12:30: Developing the model to support a feature

Time | Topic | Type | Instructor
---- | ---- | ---- | ---- 
30 min | Add your fields to the index and begin querying. | Code lab|David
60 min | Participants work together on preliminary code that they would like to develop into a feature. | Code lab|Gabi

## 12:30–2:00: Lunch

## 2:00–3:30: The controller

Time | Topic | Type | Instructor
---- | ---- | ---- | ---- 
20 min | Where are we in the project? Planning for the next step? | Talk lab|Chelcie
15 min | What is a controller? Why do we need it? What factors determine controller design? | Discussion|Hugh
15 min | Explore how the out-of-the-box controller works, along with what it can and cannot do. | Presentation|Leif-Jöran
10 min | URL rewriting: configure the controller to return the combined model plus view. | Code lab|Leif-Jöran
10 min | Configure controller to return just the model. | Code lab|Leif-Jöran
20 min | The full controller pipeline: returning the view. | Code lab|Leif-Jöran

## 3:30–4:00: Coffee break

## 4:00–5:30: Collation

Time | Topic | Type | Instructor
---- | ---- | ---- | ---- 
90 min | Collation. | Presentation|Ronald

We’ll end each day with a request for feedback, based on a general version of the day’s outcome goals, and we’ll try to adapt on the fly to your responses. You can fill out a feedback form at [insert URL here]