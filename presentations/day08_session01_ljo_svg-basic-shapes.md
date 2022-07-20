# SVG basic shapes

Day 08 Session 01 slot 03


## What are the basic shapes?
 * Rectangle (rect)
 * Circle (circle)
 * Ellipse (ellipse)
 * Line (line)
 * Polyline (polyline)
 * Polygon (polygon)






## The rectangle

```
<svg xmlns="http://www.w3.org/2000/svg" width="300" height="300">
    <rect x="100" y="100" width="100" height="80" fill="green" 
          stroke="blue" stroke-width="4"/>
</svg>
```









## The circle

```
<svg xmlns="http://www.w3.org/2000/svg" width="300" height="300">
    <circle cx="150" cy="150" r="100" fill="green" 
            stroke="blue" stroke-width="8"/>
</svg>
```








## The ellipse

```
<svg xmlns="http://www.w3.org/2000/svg" width="300" height="300">
    <ellipse cx="100" cy="150" rx="50" ry="60" fill="green" 
             stroke="blue" stroke-width="4"/>
</svg>
```









## The line
2D, but

```
<svg xmlns="http://www.w3.org/2000/svg" width="300" height="300">
    <!--<line x1="100" y1="150" x2="200" y2="150"/> -->
    <line x1="0" y1="0" x2="200" y2="200" 
          style="stroke:rgb(255,0,0);stroke-width:2" />
</svg>
```









## The polyline
an open shape

```
<svg xmlns="http://www.w3.org/2000/svg" width="300" height="300">
     <polyline fill="green" stroke="blue" stroke-width="8"
             points="100,100 200,200, 200,100"/>
</svg>
```









## The polygon
an closed shape

```
<svg xmlns="http://www.w3.org/2000/svg" width="300" height="300">
    <polygon fill="green" stroke="blue" stroke-width="8"
             points="100,100 200,200, 100,200 100,100"/>
</svg>
```


