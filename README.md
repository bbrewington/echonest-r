# echonest-hipsterness-plot
Call the EchoNest API via R package "httr", and generate a plot with ggplot2 of hotttnesss vs. discovery

Link to R Script: [HipsternessPlot.R](HipsternessPlot.R)
### Usage in R
Enter a list of artists (replace spaces with "+")
```R
artists <- c("cake", "darwin+deez","weezer","pretty+lights","radiohead","yo+yo+ma","big+data",
"tycho","skrillex","sufjan+stevens","foo+fighters","death+cab+for+cutie","the+decemberists",
"justice","haim","green+day","the+glitch+mob","imogen+heap","the+strokes","crooked+still","spoon")
```
Call the plot_hipsterness function
```R
plot_hipsterness("EchoNest API Key", artists, "Brent")
```

### Results
![Example HipsterPlot](HipsternessPlot_annotated.png?raw=true)
