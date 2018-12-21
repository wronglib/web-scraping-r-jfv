
#  Web Scraping with R and Fernández-Villaverde              
#  https://www.fortuneoblige.com/

 

# Install and load the recquired packages
install.packages("tidyverse")
install.packages("rvest")

library("rvest")
library("tidyverse")

web <- choose.files()

page <- read_html(web)

# Extract titles and links

titles_html <- html_nodes(page,'h3 a') 

## Separate text

titles <- html_text(titles_html)

### Clean the vector

titles <- titles[-c(617)] 

## Separate links

urls <- titles_html %>%
  xml_attr('href')

### Clean vector

urls <- urls[-c(617)] 

# Extract dates

dates_html <- html_nodes(page, 'time')

## Separate text

dates <- html_text(dates_html)

### Clean vector

dates <- gsub("\n\t\t\t\t\t\t","", dates)
dates <- gsub("\t\t\t\t\t","", dates)

# Create a data.frame

JFV <- data.frame(dates, titles, urls)

# Save the result

write.csv2(JFV, file = "JFV.csv", row.names=FALSE)