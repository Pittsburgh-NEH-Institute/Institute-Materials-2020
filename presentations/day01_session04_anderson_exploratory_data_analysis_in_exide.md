# Exploratory Data Analysus in Exide

## Open a collection in eXist

```xquery
xquery version "3.1";

fn:collection("/db/apps/shakespeare-pm/data") 
```

## List the URIs of documents in a collection

```xquery
xquery version "3.1";

fn:collection("/db/apps/shakespeare-pm/data") ! fn:base-uri(.)
```

## Convert verses to upper case

```xquery
xquery version "3.1";

declare namespace tei = "http://www.tei-c.org/ns/1.0";

fn:collection("/db/apps/shakespeare-pm/data")//tei:l ! fn:upper-case(.)
```

## Filter to an individual document

```xquery
xquery version "3.1";

fn:doc((fn:collection("/db/apps/shakespeare-pm/data") ! fn:base-uri())[. = "/db/apps/shakespeare-pm/data/F-oth.xml"])
```

## List titles of documents

```xquery
xquery version "3.1";

declare namespace tei = "http://www.tei-c.org/ns/1.0";

fn:collection("/db/apps/shakespeare-pm/data")//tei:titleStmt/tei:title[@type = "statement"] ! string(.)
```

## Count documents in a collection

```xquery
xquery version "3.1";

fn:collection("/db/apps/shakespeare-pm/data") => fn:count()
```

## Cleaning up titles with the simple mapping operator

```xquery
xquery version "3.1";

declare namespace tei = "http://www.tei-c.org/ns/1.0";

fn:collection("/db/apps/shakespeare-pm/data")//tei:titleStmt/tei:title[@type = "statement"] 
    ! string(.) 
    ! fn:tokenize(., "from Mr. William")[1] 
    ! fn:normalize-space(.)
```