# Editing XQuery inside eXist-db with \<oXygen/\>

## Configuration

There are multiple ways to configure eXist-db to use \<oXygen/\> (instead of, for example, eXide) to edit files inside the database. The easiest and most robust is to use the configuration wizard, about which see <https://www.oxygenxml.com/doc/versions/21.1/ug-editor/topics/how-to-exist.html>. 

### Notes

* \<oXygen/\> will let you establish connections of this sort with multiple eXist-db servers (for example, one running on your local machine, one running on a remove server, etc.), but it is not able to use those multiple connection in a reliable manner. For reliable functionality, do not establish more than one eXist-db database connection of this type inside \<oXygen/\>. 
* You need to configure the database resource only once, but it is available only while eXist-db is running. That means that you need to start eXist-db on your system not only to work with files inside it, but also if you want to use it as your XQuery validation engine (see below).

## Editing XQuery inside eXist-db

To use \<oXygen/\> to edit files inside eXist-db, as you would with eXide, click on the rightmost of the four *perspective* icons in the upper right corner of your \<oXygen/\> interface (these icons are, in order from left to right, Editor, XSLT Debugger, XQuery Debugger, and Database). If you have configured \<oXygen/\> to use eXist-db according to the instructions at the link above, when you click on the Database view, you’ll see a one-item list of connections in a left sidebar, where the one item will be labeled eXist-db localhost. The first level under this is *db*, which is the root of your eXist-db database. If you open files from there, edit them, and save them, the changes will be saved directly into the database, as with eXide. You can also create new resources (files), remove resources, and otherwise perform the same sorts of operations you would inside \<oXygen/\> with regular files on your file system.

## XQuery validation with eXist-db

Once you have configured a connection between \<oXygen/\> and eXist-db, you can tell \<oXygen/\> to use eXist-db (rather than Saxon, which is the default) for XQuery validation. This is necessary if you want to use eXist-specific functionality in your XQuery (and you do). Follow the instructions at <https://www.oxygenxml.com/doc/versions/21.1/ug-editor/topics/preferences-xquery.html> and choose *eXist-db localhost* as your validation engine. If you use the XPath/XQuery builder view (<https://www.oxygenxml.com/doc/versions/21.1/ug-editor/topics/xquery-builder-view.html>), you can select eXist-db as your XQuery engine there, as well (from a drop-down menu at the top of the view).

## XQuery transformation and debugging with eXist-db

Note that the XQuery Debugger perspective (the third of the four *perspective* buttons in the upper right of yiour \<oXygen/\>) will not let you select eXist-db as your XQuery engine. You can, however, use an eXist-db connection as the XQuery processor within an XQuery transformation scenario, about which see <https://www.oxygenxml.com/doc/versions/21.1/ug-editor/topics/xquery-transformation.html>.
