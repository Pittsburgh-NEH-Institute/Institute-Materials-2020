# Steps toward minimal functional search

## Hugh: Clone, build, install

1. Clone <https://github.com/Pittsburgh-NEH-Institute/06-controller> (hopefully you already did this in the first session; if you did, do `git pull`).
2. `cd` into the repo and type `ant` to build
3. Make sure eXist-db is started (if it is running, don’t start a second instance!), open it, log in as userid “admin”, open the package manager, and install the new repo that you just built.
4. Switch to the launcher and launch “My amazing 06-controller application”. You’ll see an error message; this is correct, and we fix it in the next step.
5. Edit the browser address bar to read `<http://localhost:8080/exist/apps/06-controller/titles>`. If you see a list of titles, put up your green sticky note. If you don’t, put up your red sticky note.
6. We're going to work in VS Code and sync to eXist. Open the `06-controller` directory in VS Code (hint: if you're on a Mac, do View -> Command Palette..., start typing "shell", and then choose "Install 'code' command in PATH, then you can open folders from the terminal by typing `code <directory_name>`). You will need to start synchronization (lower right status bar, where it says "Off").

If you built and installed this repo earlier, just install the new one over the old one.
 
## David: `contains()` and `matches()`

Practice `contains()` and `matches()` in eXide:

```
declare namespace tei="http://www.tei-c.org/ns/1.0";
collection('/db/apps/06-controller/data/hoax_xml')/descendant::tei:TEI[contains(., 'constable')]
```

**Issue:** `contains()` is case-sensitive.  
**Solution:** `matches()` can (optionally) be case-insensitive.  
**Bonus:** `matches()` can match *patterns*, and not just literal *strings*.

```
declare namespace tei="http://www.tei-c.org/ns/1.0";
collection('/db/apps/06-controller/data/hoax_xml')/descendant::tei:TEI[matches(., 'constable', 'i')]
```

## Hugh: Add `request:get-parameter()` to retrieve search term

Test by specifying parameter in browser address bar:

```
http://localhost:8080/exist/apps/06-controller/titles?term=constable
```

See how `contains()` and `matches()` differ.

## David: Create form in view to accept user input

```
<form action="titles" method="get">
    <input id="term" name="term" placeholder="[Search term]"/>
    <input id="submit" type="submit" value="Submit"/>
 </form>
```

1. What happens when there’s no search term?
2. How do you reset the form?

## Hugh: Improve the form

### The input field and buttons are too close to one another

```
<head>
    <title>Article titles</title>
    <style>
        input {{
            margin-right: 1em;
        }}
    </style>
</head>
```

### What should happen if no results are found?

```
{
if ($data//descendant::m:title) (: Are there any titles? :)
then (: If there are, show them :)
    <ul>{
        for $title in $data/descendant::m:title
        order by $title
        return <li>{$title ! string()}</li>
    }</ul>
else (: If not, say something user-friendly :)
    <p>No matching articles found.</p>}
```

### How can we clear the input field?

```
<form action="titles" method="get">
    <input id="term" name="term" placeholder="[Search term]" value="{request:get-parameter('term','')}"/>
    <input id="submit" type="submit" value="Submit"/>
    <button id="clear-form" onclick="document.getElementById('term').value='';">Reset</button>
</form>
```

Hmm … why doesn’t `<input type="reset"/>` do what we think it does? Why do we need `<button>` with `onclick` instead?


