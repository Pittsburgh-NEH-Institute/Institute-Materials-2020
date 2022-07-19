# Enhancing titles to link to reading views

## Get the `xml:id` of the article into the model

Edit *titles.xql* to read:

```
<m:titles>{
    for $article in $articles 
    return
        <m:title xml:id="{$article/@xml:id}">{ 
            $article/descendant::tei:titleStmt/tei:title ! string()
        }</m:title>
}</m:titles>
```

Run in the browser as:

<http://localhost:8080/exist/apps/06-controller/modules/titles.xql>

Output should include lines like:

```
<m:title xml:id="GH-TIMES-18300708">The Bermondsey Ghost</m:title>
<m:title xml:id="GH-GNCCO-18581204">A Ghost Caught</m:title>
<m:title xml:id="GH-19CUK-18250130">The New Hammersmith Ghost</m:title>
```

## Translate the new model information into the view

Edit *titles-to-html.xql* to read:

```
<ul>{
    for $title in $data/descendant::m:title
    order by $title
    return <li><a href="read?id={$title/@xml:id}">{$title ! string()}</a></li>
}</ul>
```

Run in browser as:

<http://localhost:8080/exist/apps/06-controller/titles>

Titles should be clickable links. Click on one to read the article.