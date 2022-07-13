
# XQuery FLWOR

Our goal today is to convert the expression below into a FWLOR expression. Remember that FLWOR stands for *f*or, *l*et, *w*here, *o*rder by, and *r*eturn. A FLWOR expression requires either a `let` clause or a `for` clause (or both) and must end with a `return` clause.

## Original query

```xquery
xquery version "3.1";

declare namespace tei = "http://www.tei-c.org/ns/1.0";

fn:collection("/db/apps/shakespeare-pm/data")//tei:titleStmt/tei:title[@type = "statement"] 
    ! string(.) 
    ! fn:tokenize(., "from Mr. William")[1] 
    ! fn:normalize-space(.)
```

## FLWOR version of the query

```xquery
xquery version "3.1";

declare namespace tei = "http://www.tei-c.org/ns/1.0";

let $collection := fn:collection("/db/apps/shakespeare-pm/data")
for $doc in $collection
for $title in $doc//tei:titleStmt/tei:title[@type = "statement"] 
let $stringy-title := string($title)
let $tokenize-title := fn:tokenize($stringy-title, "from Mr. William")[1] 
let $normalized-title := fn:normalize-space($tokenize-title)
return $normalized-title
```

## Counting the titles

```xquery
xquery version "3.1";

declare namespace tei = "http://www.tei-c.org/ns/1.0";

fn:count(
    let $collection := fn:collection("/db/apps/shakespeare-pm/data")
    for $doc in $collection
    for $title in $doc//tei:titleStmt/tei:title[@type = "statement"] 
    let $stringy-title := string($title)
    let $tokenize-title := fn:tokenize($stringy-title, "from Mr. William")[1] 
    let $normalized-title := fn:normalize-space($tokenize-title)
    return $normalized-title
)
```