# 2022 NEH Institute CSS Lesson Plan

---

## Pre-analysis

### Goal

Learners should be able to do the following:
    - Construct simple CSS to target any element, class, or id
    - Change the color, background, size, and margins of any element
    - Recognize different measurement units in CSS
    - Be able to grow their CSS knowledge beyond what they've been taught

### What they should already know

Learners should come with the following knowledge:
    - The ability to construct (X)HTML pages

---

## Lesson Plans
| Hour | Minute | Topic |
| :--: | :--: | :--: |
|2:| 30 - 33 | Creating a CSS document and linking to HTML |
|2:| 33 - 37 | Construction of simple rules (coloring and sizing text) |
|2:| 37 - 40 | Classes and ids |
|2:| 40 - 50 | Width, height, margin, and padding (also: block vs inline) |
|2:| 50 - 53 | Introduction to different units |
|2:| 53 - 57 | Psuedo-classes |
|2:| 57 - 59 | Further resources |

---

## In-depth look

---

## Rough ending CSS
~~~
body {
    background: tan;
}
h1{
    text-align: center;
    border: solid black 5px;
    width: 50%;
    margin: auto;
}
li {
    margin: .5%;
}
code {
    font-weight: 600;
}
a:hover {
    font-size: 110%;
}
a:visited {
    color: black;
}
/* BELOW ARE CLASSES */
.listTitle {
    font-weight: bold;
    font-size: 1.25em;
}
/* BELOW ARE IDS */
#mainTitle {
    color: blue;
}
~~~