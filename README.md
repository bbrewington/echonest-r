# README: echonest-hipsterness-plot

Link to R Script: [HipsternessPlot.R](HipsternessPlot.R)
### Usage in R

Source the function script
```R
source("https://raw.githubusercontent.com/bbrewington/echonest-hipsterness-plot/master/HipsternessPlot.R")
```

The "artists" character vector below is shown for example.  The plot_hipsterness function takes a character vector of artists as an argument (replace spaces with "+")
- [ ] Note to self: need to write in the "replace spaces with +" functionality using gsub

```R
artists <- c("cake", "darwin+deez","weezer","pretty+lights","radiohead","yo+yo+ma","big+data",
"tycho","skrillex","sufjan+stevens","foo+fighters","death+cab+for+cutie","the+decemberists",
"justice","haim","green+day","the+glitch+mob","imogen+heap","the+strokes","crooked+still","spoon")
```
Call the plot_hipsterness function, with the above character vector as an argument
```R
plot_hipsterness("EchoNest API Key", artists, listeners_name = "Brent")
```

### Results
![Example HipsterPlot](HipsternessPlot_annotated.png?raw=true)
