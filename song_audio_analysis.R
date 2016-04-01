get_artist_song_list <- function(echonest_api_key, artist_name, start){
     #Function parameter error checking
     if(!is.character(echonest_api_key) | !is.character(artist_name) | !is.numeric(start)){
          stop("echonest_api_key & artist_name: Character, start: Number")
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
     
     # create a list object to be used in the "data" object, consisting of bind_rows function applied to
     # audio_summary to convert it to a data frame.  Have to clean up the NULL values in the audio_summary
     # object for this to work
     
      list(number.songs = length(r.artist.songs),
           rate.limit.remaining = as.numeric(headers(r.artist)$`x-ratelimit-remaining`),
           
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
                        content(r.artist)$response$songs %>% lapply(function(x) x$audio_summary) %>% 
                                       lapply(function(x){
                                            x[sapply(x, is.null)] <- NA
                                            return(x)
                                       }) %>% bind_rows() %>% 
                             mutate(mode = factor(mode, labels = c("major", "minor")))# %>%
                            # mutate(key = factor(key, labels = c("C", "Db", "D", "Eb", "E", "F",
                            #                                     "Gb", "G", "Ab", "A", "Bb", "B")))
     ))
}

# Function to run a loop to repeatedly grab a certain artist's song data, and return a data frame
# Pauses if API rate limit is close to expiring (i.e. if it equals 1) --> waits 15 seconds
get_artist_data <- function(echonest_api_key, artist, rem_song_duplicates = TRUE, num_songs_guess = 500){
     df1 <- data.frame()
     initial.run <- TRUE
     for(i in seq(1, num_songs_guess - 99, by = 100)){
          if(!initial.run){
               if(song.list$number.songs < 100){
                    break
               }
          }
          
          song.list <- get_artist_song_list(echonest_api_key, artist, start = i)
          print(song.list)
          if(song.list$rate.limit.remaining == 1){
               Sys.sleep(30)
          }
          
          df1 <- rbind(df1, song.list$data)
          
          initial.run <- FALSE
     }
     if(rem_song_duplicates){
          df1 %>% distinct(song.title)
     } else{
          df1
     }
}
