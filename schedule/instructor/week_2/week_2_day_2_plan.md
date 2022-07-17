# Week 2, Day 2: Tuesday, July 19, 2022
[Link to instructor-view navigation page](../daily_instructor_view.md)

## Synopsis

Implementing publication strategies. The morning is devoted to typeswitch, an
                operator that helps us mimic XSLT template processing in XQuery. With typeswitch, we
                begin to develop the *view* components of the laboratory edition’s MVC architecture.
                In session two, participants return to the application in eXist-db and gain
                experience with application requirements. In the afternoon, we introduce writing and
                testing user-defined functions. To close out the day, we discuss mapping features
                and use an external JavaScript library and API to create embed a map in our
                application.

## Outcome goals
* Add more information to this feature.
* Practice XQuery.
* Focus on the *view* in MVC in an eXist-db context.
* Connect the data, model, and view.
* Build a simplified search.

## Legend

* **Presentation:** by instructors
* **Discussion:** instructors and participants
* **Talk lab:** participants discuss or plan in small groups
* **Code lab:** participants code alone or in small groups

* * *
## 9:00–10:30: XQuery: model and view from the ground up

### Edition repo stages for session

* [Creating index](https://github.com/Pittsburgh-NEH-Institute/placeholder)
* [Creating title view: use `typeswitch`](https://github.com/Pittsburgh-NEH-Institute/placeholder)

Time | Topic | Type | Instructor
---- | ---- | ---- | ---- 
45 min | Enhancing the title list model. | Code lab|Leif-Jöran
45 min | Adapt the view to the model using `typeswitch`. | Code lab|Cliff

## 10:30–11:00: Coffee break

## 11:00–12:30: Search function

### Edition repo stages for session

* [Creating reading view](https://github.com/Pittsburgh-NEH-Institute/placeholder)
* [Creating functions.xqm](https://github.com/Pittsburgh-NEH-Institute/placeholder)

Time | Topic | Type | Instructor
---- | ---- | ---- | ---- 
90 min | Search interface. | Code lab|David, Hugh

## 12:30–2:00: Lunch

## 2:00–3:30: Putting MVC together: building the reading view

### Edition repo stages for session

* [Creating title view: use `typeswitch`](https://github.com/Pittsburgh-NEH-Institute/placeholder)
* [Creating reading view](https://github.com/Pittsburgh-NEH-Institute/placeholder)

Time | Topic | Type | Instructor
---- | ---- | ---- | ---- 
30 min | The Model in action (article reading-view query). | Code lab|Gabi
30 min | The View in action (article reading-view query). | Code lab|Cliff
30 min | The Model, View, and Controller in action (article reading-view query). | Code lab|David

## 3:30–4:00: Coffee break

## 4:00–5:30: XQuery topics + review

Time | Topic | Type | Instructor
---- | ---- | ---- | ---- 
30 min | Using regular expressions to clean and encode our data. | Code lab|Cliff
30 min | Find all the TEI elements used / attribute values used / etc. | Code lab|Leif-Jöran
30 min | GEOJSON for maps. | Code lab|Gabi

We’ll end each day with a request for feedback, based on a general version of the day’s outcome goals, and we’ll try to adapt on the fly to your responses. Links to the feedback forms are in our Slack workspace in the #daily-feedback channel (posting from Mason on Mon, July 11).