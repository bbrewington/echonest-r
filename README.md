# echonest-r: working with EchoNest data in R

EchoNest is a music database that Spotify & I Heart Radio are based off of, and allows for interaction via API.  There is some really interesting data available, and the functions shown below provide methods for bringing the data into R.  I'm building this for my personal use to analyze my music and work on some music data projects.  If you have ideas of where to go from here, feel free to suggest them in the issues section, or fork the repo & submit a pull request.

Functions:
* song_audio_analysis.R
* HipsternessPlot.R

### song_audio_analysis.R
#### Get Audio attributes of combination of artist & song
This function takes an artist & song as input, and returns a data frame of info from the EchoNest database of audio attributes of the song.  Examples: duration, loudness, valence (i.e. emotional content), energy

#####Arguments:
* echonest_api_key: your developer key, registered at https://developer.echonest.com/account/register
* artist_name: character string of artist
* song_name: character string of song

#####How to Use:
1. Run this code to read the song_analysis function into R
  ```R
  source("https://raw.githubusercontent.com/bbrewington/echonest-hipsterness-plot/master/song_audio_analysis.R")
  ```
  
2. Call the function in R
  ```R
  song_audio_analysis("Your EchoNest API Key", "Weezer", "El Scorcho")
  ```
3. The function returns a data frame of various song attributes.  See the R code for details

### Hipsterness Plot
#### Create a scatterplot of artist names to show "Hipsterness"

#####Arguments:
* echonest_api_key: your developer key, registered at https://developer.echonest.com/account/register
* artists: character vector of artist names
* listeners_name: name to show in plot title

#####How to Use:
1. Source the function script
  ```R
  source("https://raw.githubusercontent.com/bbrewington/echonest-hipsterness-plot/master/HipsternessPlot.R")
  ```

  The "artists" character vector below is shown for example.  The plot_hipsterness function takes a character vector of artists as an   argument (replace spaces with "+")
  - [ ] Note to self: need to write in the "replace spaces with +" functionality using gsub

  ```R
  artists <- c("cake", "darwin+deez","weezer","pretty+lights","radiohead","yo+yo+ma","big+data",
  "tycho","skrillex","sufjan+stevens","foo+fighters","death+cab+for+cutie","the+decemberists",
  "justice","haim","green+day","the+glitch+mob","imogen+heap","the+strokes","crooked+still","spoon")
  ```

2. Call the plot_hipsterness function, with the above character vector as an argument
  ```R
  plot_hipsterness("EchoNest API Key", artists, listeners_name = "Brent")
  ```

### Results
![Example HipsterPlot](HipsternessPlot_annotated.png?raw=true)
