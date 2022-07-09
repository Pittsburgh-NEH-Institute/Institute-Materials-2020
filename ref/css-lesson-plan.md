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
|2:| 53 - 57 | Pseudo-classes |
|2:| 57 - 59 | Further resources |

---

## In-depth look
An XHTML link to CSS looks like the following <link rel="stylesheet" type="text/css" href="style.css"/>

### The basic outline of a CSS rule is as follows:

~~~
selector {
    property: value;
}
~~~

### Major measurement units:

#### Measurement unit types:
*Dynamic Units:* like em and percentages acquire part of their value from their context. For example, the size of an em is proportional to the font size and percentage values are proportional to the size of the parent element.

*Static Units:* like pixels, centimeters, and inches have a real-world meaning that is independent of other styling features.

- px (pixels)
- % (percent) - percentage of the parent's space that they should take up
- vh, vw (view height and view width) - How much of the viewport width and height the element should take up
- em, rem - These are both based on the height of fonts being used. em is based on the current font for the element and font size, whereas rem is based off of :root
- in and cm - Inches and centimeters, not very reliable

### Margin & padding
Margin is outside the box, padding is inside

4 different ways to build the property
1. margin: 0 0 0 0 (top, left, bottom, right)
1. margin: 0 0 0 (top & bottom, left, right)
1. margin: 0 0 (top & bottom, left & right)
1. margin-(top, bottom, left, right): 0

### Further resources
- [Mozilla Developer Network](https://developer.mozilla.org/en-US/docs/Web/CSS)
- [W3Schools](https://www.w3schools.com/css/default.asp)
- [CSS Textbook](https://books.goalkicker.com/CSSBook/)
- [Going further with CSS](http://dh.obdurodon.org/cssAnimationsIntro.xhtml)
- [Emmet](https://emmet.io)

## Rough ending CSS (attached to Emma's XHTML)
~~~
body {
    background: tan;
    padding-left: 1em;
}
h1{
    text-align: center;
    text-decoration: underline;
    font-size: 3em;
    width: 50%;
    margin: auto;
    margin-top: 3%;
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
table, tr, td, th {
    border: solid black 2px;
    border-collapse: collapse;
    padding: 2%;
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