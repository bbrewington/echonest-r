# Register your own API at developer.echonest.com, and replace this text
echonest_api_key <- "YOUR_ECHO_API_KEY" 

song_analysis <- function(echonest_api_key, artist_name, song_name){
     #Function parameter error checking
     if(echonest_api_key == "YOUR_ECHO_API_KEY"){
          stop("Make sure to register your own EchoNest API key at developer.echonest.com")
     }
     if(!is.character(echonest_api_key) | !is.character(song_name) | !is.character(artist_name)){
          stop("parameters echonest_api_key, song_name, & artist_name must be of class Character")
     }
     
     library(httr)
     library(ggplot2)
     
     # Replace spaces with %20 in artist_name and song_name
     artist_name <- gsub(" ", "%20", artist_name)
     song_name <- gsub(" ", "%20", song_name)
     
     target <- paste0("http://developer.echonest.com/api/v4/song/search?api_key=",echonest_api_key,
                          "&format=json",
                          "&results=1",
                          "&artist=",artist_name,
                          "&title=",song_name,
                          "&bucket=audio_summary")
     
     print(target)
     r <- GET(target)
     warn_for_status(r)
     r.content <- content(r)
     r.content.data <- r.content$response$songs[[1]]
     r.content.data.audio.summary <- r.content.data$audio_summary
     data.frame(artist_id = r.content.data$artist_id, artist_name = r.content.data$artist_name,
                id = r.content.data$id, title = r.content.data$title,
                audio.summary.key = r.content.data.audio.summary$key,
                audio.summary.analysis_url = r.content.data.audio.summary$analysis_url,
                audio.summary.energy = r.content.data.audio.summary$energy,
                audio.summary.liveness = r.content.data.audio.summary$liveness,
                audio.summary.tempo = r.content.data.audio.summary$tempo,
                audio.summary.speechiness = r.content.data.audio.summary$speechiness,
                audio.summary.acousticness = r.content.data.audio.summary$acousticness,
                audio.summary.instrumentalness = r.content.data.audio.summary$instrumentalness,
                audio.summary.mode = r.content.data.audio.summary$mode,
                audio.summary.time_signature = r.content.data.audio.summary$time_signature,
                audio.summary.duration = r.content.data.audio.summary$duration,
                audio.summary.loudness = r.content.data.audio.summary$loudness,
                #audio.summary.audio_md5 = r.content.data.audio.summary$audio.md5,
                #audit_md5 is left out b/c getting data from song id
                audio.summary.valence = r.content.data.audio.summary$valence,
                audio.summary.danceability = r.content.data.audio.summary$danceability)
}