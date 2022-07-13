# Building a title list with XQuery

## Create the view: transform the model to HTML

The goal of this view is to transform the model into HTML for display on web browsers. Be sure to save this file in the `views` folder in the app with a filename of `titles-to-html.xql`.

```xquery
xquery version "3.1";

declare namespace html="http://www.w3.org/1999/xhtml";
declare namespace m = "http://www.obdurodon.org/model";

declare variable $data as document-node() := request:get-data();

<html:section>
  <html:ul>
{ 
    for $title in $data/m:titles/m:title
    return
    <html:li>{$title ! string(.)}</html:li>
}
  </html:ul>
</html:section>
```