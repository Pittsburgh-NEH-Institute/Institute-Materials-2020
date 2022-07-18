# Getting started with your app

## Overview

We’ve been using Yeoman to scaffold a new eXist-db app, but developing an app that uses the MVC architecture that we introduced in the Institute also requires, at a minimum, that you do the following:

1. Add your own data.
1. Create a *controller.xql* file in the root directory of the app. This controls a) URL rewriting and b) the relationship between the model and the view.
2. For each *action* (type of functionality, e.g., list titles, read an article, etc.) you want to provide create a pair of XQuery files, one to create the model and the other to transform the model into the view.
3. Create an *collection.xconf* file in the root directory of the app to control indexing (including facets and fields).

Below we describe how to do parts 1–3. We’ll add part 4 later.

## Terminology

The standard term for what we think of as a directory is *collection* and the standard term for what we think of as a file is *resource*. We use the terms interchangeably in this document.

## General

You’ll work with two repos, one for your own project and the other for a clone of one of our sample projects, from which you’ll copy selected information to paste into your own project files:

1. Create a new directory and, inside it, [initialize your own skeletal app with Yeoman](https://github.com/Pittsburgh-NEH-Institute/pr-app/blob/main/pr-app-tutorials/yeoman.md) and push it to GitHub.
1. Create a different new directory and clone our [03-titles-model](https://github.com/Pittsburgh-NEH-Institute/03-titles-model) repo into it. This repo contains files you can use as starting points for developing your own project. **Don’t start a project by copying our entire project;** start your project with your own Yeoman skeleton and copy just the information we mention below.

## Add data

You need to add your own data to your project. One conventional way to do that is to create a subcollection called *data* and put your source XML files there.

For the *03-titles-model* app, instead of putting our XML files directly inside our *data* collection we created three subcollections, one for our primary source documents (*hoax_xml*), another for ancillary documents (*aux_html*, which contains lists of persons and places mentioned in the sources), and a third for our schemas (*schemas*). 

If your project has only source XML, you can put those files directly inside *data*. If you also have auxiliary XML files, we recommend using subcollections, as we describe above.

## Create a controller

Copy *controller.xql* from the root directory of our *03-titles-model* app into the root directory of your app. You do not have to make any changes in this file. 

If you would like to understand more about how *controller.xql* works, you can read about it in the eXist-db book or at <https://exist-db.org/exist/apps/doc/urlrewrite.xml>. Both are a bit out of date, but nonetheless helpful in explaining how the controller does what it does.

## Create actions

For each action you want to perform (e.g., list all titles, read a single document, show the main index page) you need to 1) come up with name for the action and 2) create two files, one to build the model and the other to transform the model into the view. The name of the action should not have a dot in it. For example, the names for the actions we implement in *03-titles-model* are *index* and *titles*.

Our controller relies on a specific regular filename correspondence: for each action, the file that creates the model is called *name-of-action.xql* (e.g., *titles.xql*, *index.xql*, *read.xql*) and the corresponding file that creates the view adds *-to-html* to the filename (e.g., *titles-to-html.xql*, *index-to-html.xql*, *read-to-html.xql*). 

See below about where to store those files.

### Create files for models

If it doesn’t already exist, create a subcollection called *modules* under the root of your app. You will save the files that create the models for your project (e.g., *titles.xql*, *read.xql*, *index.xql*) there.

Our *titles.xql* assumes that our data files are located in the *data/hoax_xml* subcollection and it also declares our own namespaces. We recommend copying our file as a starting point, but adapting it carefully to your own filenames and namespaces.

### Create files for views

If it doesn’t already exist, create a subcollection called *views* under the root of your app. You will save the files that create the views for your project (e.g., *titles-to-html.xql*, *read-to-html.xql*, *index-to-html.xql*) there.

As with our *titles.xql*, our *titles-to-html.xql* relies on information in our specific model namespace. With views, as with models, we recommend copying our file as a starting point, but adapting it carefully to your data and your namespaces.

### Your main page

Our controller is configured to return *index.xql* (piped through *index-to-view.xql*) if the user asks just for <http://localhost:8080/exist/apps/03-titles-model/>. You can copy our *index.xql* and *index-to-html.xql* files to create a suitable landing page for your project.

