## HipsternessPlot.R: Takes an input list of artists, calls the EchoNest API via package "httr", and
## creates a labeled scatterplot of the artists: hotttnesss (buzz value) vs. discovery (unexpected popularity value)

library(stringr)

# Register your own API at developer.echonest.com, and replace this text
echonest_api_key <- "YOUR_ECHO_API_KEY" 
# Sample artist list
artists <- c("cake", "darwin+deez","weezer","pretty+lights","radiohead","yo+yo+ma","big+data","tycho","skrillex","sufjan+stevens","foo+fighters","death+cab+for+cutie","the+decemberists","justice","haim","green+day","the+glitch+mob","imogen+heap","the+strokes","crooked+still","spoon")

# Replace spaces in artist list with "+" (to match how echonest handles artist names)
artists <- str_replace(str_trim(artists), "\\s", "+")

plot_hipsterness <- function(echonest_api_key, artists, listeners_name){
     #Function parameter error checking
     if(echonest_api_key == "YOUR_ECHO_API_KEY"){
          stop("Make sure to register your own EchoNest API key at developer.echonest.com")
     }
     if(!is.character(echonest_api_key) | !is.character(artists) | !is.character(listeners_name)){
          stop("parameters echonest_api_key, artists, and listeners_name must be of class Character")
     }
     
     library(httr)
     library(ggplot2)
     
     num_artists <- length(artists)
     
     # Set up URL's for EchoNest API call (using buckets "hotttnesss" and "discovery")
     all.targets <- paste(rep("http://developer.echonest.com/api/v4/artist/profile?api_key=", times=num_artists),
                          rep(echonest_api_key, times=num_artists),
                          rep("&name=", times=num_artists),
                          artists,
                          rep("&bucket=hotttnesss&bucket=discovery", times=num_artists),
                          sep="")
     
     # Loop through each member of vector all.targets and call EchoNest API and
     # save each result to a row in data frame df
     
     df <- data.frame()
     
     for (i in 1:length(all.targets)){
          r <- GET(all.targets[i])
          warn_for_status(r)
          df[i,1] <- content(r)$response$artist$name
          df[i,2] <- content(r)$response$artist$hotttnesss
          df[i,3] <- content(r)$response$artist$discovery
     }
    
     names(df) <- c("artist.name", "hotttnesss", "discovery")
     
     # Plot results using geom_text, which displays the artist's name on a scatter plot
     
     ggplot(df, aes(discovery,hotttnesss,label=artist.name)) + 
          geom_text() + 
          xlim(0,1) + ylim(0,1) + 
          ggtitle(paste("Hipsterness Plot of ", listeners_name, "'s Favorite Artists", sep=""))
}
