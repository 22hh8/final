artwork <- read_csv("https://raw.githubusercontent.com/tategallery/collection/master/artwork_data.csv")
artist <- read_csv("https://raw.githubusercontent.com/tategallery/collection/master/artist_data.csv")

# Make sure the right artist are being matched to their painting // artists with the same name
tate <- left_join(artist,artwork,by= c("name"="artist")) %>% filter(year >= yearOfBirth)

# Multiple artworks with the same name
# If artworks have same artist ID, dimension, medium, then same artwork has been duplicated
tate_unique <- tate %>% group_by(artistId,dimensions,title,medium,year,acquisitionYear) %>% filter(n() <=1) %>% 
        select(artistId,name,gender,yearOfBirth,yearOfDeath,title,medium,dimensions,creditLine,year,acquisitionYear,inscription)
write_csv(tate_unique,"tate.csv")