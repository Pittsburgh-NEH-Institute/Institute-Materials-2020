# Integrating Git with eXist-db

## The issue

Git typically works with files on the filesystem, which can be accessed with any appropriate tool. For example, any file that consists of character data (code, XML, etc.) can be accessed with text-aware operations like `cat`, `grep`, etc. Meanwhile, files inside eXist-db are stored in a custom format on upload. eXist-db applications like eXide and the Java Admin Client will serialize the XML on access, so that you can interact with it as character data, but the serialized XML does not exist in that form inside the database. That means that there is no directory on the filesystem inside your eXist-db space that contains your XML and other files in human-readable form, and therefore no directory within which you can issue command-line Git instructions like `add`, `commit`, `push`, and `pull`.

## A solution

eXist-db supports a WebDAV interface, which makes it possible to interact with the contents of the database using regular file-system tools. See <https://exist-db.org/exist/apps/doc/webdav> for details. If you use WebDAV to *mount* your eXist-db database on your local filesystem, you can `cd` into the location of your app and initialize it as a Git repo the way you would any other filesystem directory. For example, after I mount the database inside MacOS by following the instructions at the link above, I can use `cd /Volumes/db` to navigate to the top-level collection of my local eXist-db instance.

Note that you can mount eXist-db to your filesystem and interact with it using WebDAV only while it is running.