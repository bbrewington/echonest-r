# Register your own API at developer.echonest.com, and replace "YOUR_ECHO_API_KEY"
echonest_api_key <- "YOUR_ECHO_API_KEY" 

get_artist_song_list <- function(echonest_api_key, artist_name, start = 1){
     #Function parameter error checking
     if(echonest_api_key == "YOUR_ECHO_API_KEY"){
          stop("Make sure to register your own EchoNest API key at developer.echonest.com")
     }
     if(!is.character(echonest_api_key) | !is.character(artist_name)){
          stop("parameters echonest_api_key & artist_name must be of class Character")
     }
     
     require(httr)
     require(ggplot2)
     
     # Create api call target url
     target <- paste0("http://developer.echonest.com/api/v4/song/search?api_key=",echonest_api_key,
            "&artist=", artist_name, "&song_type=studio",
            "&sort=song_hotttnesss-desc", "&format=json",
            "&bucket=song_hotttnesss", "&bucket=song_type",
            "&bucket=audio_summary", "&bucket=song_currency", 
            "&start=", start, "&results=100")
     
     # GET request to API (the URLencode function replaces spaces with %20, etc)
     # add_headers() allows for extracting the rate limit variable, used later on
     r.artist <- GET(URLencode(target), add_headers())
     warn_for_status(r.artist)
     r.artist.songs <- content(r.artist)$response$songs
     
     # return a list with 2 parts:
     #    -data (data frame of song data returned on the API)
     #    -rate.limit.remaining (a number representing how many API calls are left)
     list(rate.limit.remaining = as.numeric(headers(r.artist)$`x-ratelimit-remaining`),
          data = cbind(data.frame(song.id = sapply(r.artist.songs, function(x) x$id), 
                            song.title = sapply(r.artist.songs, function(x) x$title),
                            song.hotttnesss = sapply(r.artist.songs, function(x) x$song_hotttnesss),
                            song.currency = sapply(r.artist.songs, function(x) x$song_currency),
                            song.type.studio.flag = sapply(lapply(r.artist.songs, function(x) x$song_type), 
                                                 function(x) if("studio" %in% x) 1 else 0),
                            song.type.electric.flag = sapply(lapply(r.artist.songs, function(x) x$song_type), 
                                                 function(x) if("electric" %in% x) 1 else 0),
                            song.type.vocal.flag = sapply(lapply(r.artist.songs, function(x) x$song_type), 
                                                 function(x) if("vocal" %in% x) 1 else 0)
                            ), 
                        rbind_all(lapply(content(r.artist)$response$songs, function(x) x$audio_summary))
     ))
}

# Function to run a loop to repeatedly grab a certain artist's song data, and return a data frame
# Pauses if API rate limit is close to expiring (i.e. if it equals 1) --> waits 15 seconds
get_artist_data <- function(artist, num_songs_guess = 500){
     df1 <- data.frame()
     for(i in seq(1, num_songs_guess - 99, by = 100)){
          song.list <- get_artist_song_list(echonest_api_key, artist, start = i)
          if(song.list$rate.limit.remaining == 1){
               Sys.sleep(30)
          }
          df1 <- rbind(df1, song.list$data)
     }
     df1
}
