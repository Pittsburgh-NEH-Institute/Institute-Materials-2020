# Using the Mapbox JavaScript Library to render a map

## Discussion
- Why do this? Why not do this?
- There are risks to using a JavaScript library! Do you understand and accept those risks?
	- You are introducing an external dependency that can and will change at [the whim of software companies](https://gis.stackexchange.com/questions/130910/google-earth-plugin-deprecated-which-alternatives).
	- You are introducing external dependencies which may cause security issues
	- You are depending on an external service to maintain its uptime promises
	- You might have to pay for it at some point
	- If you aren't paying for it, you're the product

## Geolocating historical maps
My mapping feature is meant to be an article discovery tool for users of the app, so it wasn't a priority for me to georeference and use historical tiles. Instead, I worked with a variety of sources that helped me understand places relationally. In some cases, I drew out those relationships by hand. In those cases, geodata was not as useful, but still helped me be precise when I had opportunities to not be so precise.

## Big question: is what I have worth mapping?
People love looking at maps, but you should have a clear goal in mind when you set out to do mapping. In my case, I want to visualize distribution of place mentions and connect back to reading texts by listing titles. I was more interested in showing density and outliers, but the map I chose doesn't do a great job of highlighting that. This isn't a particularly data-rich visualization, which is fine for what I wanted. A future iteration of this could have links instead of just listing the titles. I could also choose to incorporate maps for individual articles, but I think the low density of the data might limit the usefulness of that as a visualization.

I have more skepticism about maps than I do about visualizations. Proceed with caution!

## Do I need to learn JavaScript? Or GIS?
I do not write JavaScript, I can parse what it's doing and not much else. But I do use a JS library pretty frequently in my job, so I know the basics for most of them. You need a link in the head of your HTML, you need the object you want to parse, and you need something that executes the script. When you can identify those parts (and the libraries that want you to use them are going to help you out), the rest is just finicky syntax.

There are plenty of other ways to make maps that do not require you to write any code. I've used them, they can be great tools, but they have their own unique and steep learning curves. I would be skeptical of anything marketing itself as easy, geographers study for a long time to be good at even basic versions of this stuff. Today we'll mostly focus on how to “get smart” about this stuff.

## Resources
- [GEOJSON playground](https://geojson.io/#map=2/22.4/0.0)
- [Mapbox tutorial](https://docs.mapbox.com/help/tutorials/custom-markers-gl-js/)
- Gabi's Mapbox public API key
	- `pk.eyJ1IjoiZ2FiaWtlYW5lIiwiYSI6ImNqdWlzYWwxcTFlMjg0ZnBnM21kem9xZm4ifQ.CQ5LDwZO32ryoGVb-QQwCg`
- [ghost icon](https://github.com/Pittsburgh-NEH-Institute/pr-app/blob/main/resources/img/map-ghost.png)
- [CodePen](codepen.io)
- [Georeferencing: Working with raster maps](https://storymaps.arcgis.com/stories/c5e6af6d6d014aaf90ec09fd2a4c05d4)




