# Week 2, Day 2: Tuesday, July 19, 2022
[Link to instructor-view navigation page](../daily_instructor_view.md)

## Synopsis

Implementing publication strategies. The morning is devoted to typeswitch, an
                operator that helps us mimic XSLT template processing in XQuery. With typeswitch, we
                begin to develop the *view* compenents of the laboratory edition’s MVC architecture.
                In session two, participants return to the application in eXist-db and gain
                experience with application requirements. In the afternoon, we introduce writing and
                testing user-defined functions. To close out the day, we discuss mapping features
                and use an external JavaScript library and API to create embed a map in our
                application.

## Outcome goals
* Learn how to use `typeswitch` for dispatch.
* Focus on the *view* in MVC in an eXist-db context.
* Connect the data model and view by enhancing the controller.
* Modularize your code with user-defined functions.
* Write and run your first tests.
* Create the gazetteer model for use later.
* Evaluate whether the best visualization for your data is a map.
* Use external documentation and tutorials to create and adapt code for your project.
* Introduce external APIs.

## Legend

* **Presentation:** by instructors
* **Discussion:** instructors and participants
* **Talk lab:** participants discuss or plan in small groups
* **Code lab:** participants code alone or in small groups

* * *
## 9:00–10:30: Creating views and using typeswitch

### Edition repo stages for session

* [Creating index](https://github.com/Pittsburgh-NEH-Institute/placeholder)
* [Creating title view: use `typeswitch`](https://github.com/Pittsburgh-NEH-Institute/placeholder)

Time | Topic | Type | Instructor
---- | ---- | ---- | ---- 
30 min | Using typeswitch and local functions. | Code lab|Leif-Jöran
60 min | Using typeswitch and local functions to create rich text reading views. | Code lab|Cliff

## 10:30–11:00: Coffee break

## 11:00–12:30: Putting MVC together: building the reading view

### Edition repo stages for session

* [Creating title view: use `typeswitch`](https://github.com/Pittsburgh-NEH-Institute/placeholder)
* [Creating reading view](https://github.com/Pittsburgh-NEH-Institute/placeholder)

Time | Topic | Type | Instructor
---- | ---- | ---- | ---- 
30 min | The Model in action. | Code lab|Gabi
30 min | The View in action. | Code lab|Cliff
30 min | The Model, View, and Controller in action. | Code lab|David

## 12:30–2:00: Lunch

## 2:00–3:30: XQuery functions and unit testing

### Edition repo stages for session

* [Creating reading view](https://github.com/Pittsburgh-NEH-Institute/placeholder)
* [Creating functions.xqm](https://github.com/Pittsburgh-NEH-Institute/placeholder)

Time | Topic | Type | Instructor
---- | ---- | ---- | ---- 
35 min | Writing user-defined functions. | Code lab|Hugh
40 min | Testing user-defined functions with XQSuite. | Code lab|Cliff
15 min | Testing and continuous integration (CI). | Presentation|Hugh

## 3:30–4:00: Coffee break

## 4:00–5:30: Visualizing our geodata and integrating external APIs

### Edition repo stages for session

* [Creating functions.xqm](https://github.com/Pittsburgh-NEH-Institute/placeholder)
* [Maps and `map`: implementing a map](https://github.com/Pittsburgh-NEH-Institute/placeholder)

Time | Topic | Type | Instructor
---- | ---- | ---- | ---- 
15 min | Write the model for our geodata and explore our ideas on how visual information can be displayed. | Talk lab|Gabi
15 min | Choose the right mapping tools for your project. | Talk lab|Gabi
60 min | Together, we integrate basic map functionality into the app using a mapping JS library. | Code lab|Gabi

We’ll end each day with a request for feedback, based on a general version of the day’s outcome goals, and we’ll try to adapt on the fly to your responses. Links to the feedback forms will be provided in our Slack workspace, to which we’ll subscribe all Institute participants.