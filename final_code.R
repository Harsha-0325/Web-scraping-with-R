library(rvest)
library(dplyr)

extract_company_links <- function(main_url) {
  web_page <- read_html(main_url)
  
  # Extract company links (adjust the CSS selector based on the actual HTML structure)
  company_links <- web_page %>%
    html_nodes("div.o-bfyaNx.o-bNxxEB.o-bqHweY") %>%
    html_nodes("ul.o-XylGE.o-bCRRBE.o-cpnuEd") %>%
    html_nodes("a.o-cKuOoN.o-frwuxB") %>%
    html_attr("href")
  
  # Concatenate the base URL with each company link
  company_links <- paste0("https://www.bikewale.com", company_links)
  
  return(company_links)
}

mainlinks <- extract_company_links("https://www.bikewale.com")

# Initialize an empty list to store all links
all_links <- list()

for (i in 1:length(mainlinks)) {
  web_page <- read_html(mainlinks[[i]])
  
  # Extract additional links
  links <- web_page %>%
    html_nodes("a.o-cpnuEd.o-SoIQT.o-eZTujG.o-fzpilz") %>%  
    html_attr("href")
  links <- sapply(strsplit(links, '/'), function(x) x[3])
  # Concatenate the base URL with each link
  links <- paste0(mainlinks[[i]], links)
  
  # Add links to the all_links list
  all_links[[i]] <- links
}

# Combine all links into a single vector
all_links <- unlist(all_links)
all_bike_data_df <- data.frame()
for(i in 1:length(all_links)){
  bike_url <- all_links[[i]]
  # Function to scrape individual bike details
  web_page <- read_html(bike_url)
  
  # Creating an empty list to store bike details
  bike_details <- list()
  
  # Getting bike name directly from h1 tag and storing in the list
  bike_details["bike_name"] <- html_text(web_page %>% html_nodes("h1"))
  
  # Getting price of the bike directly from span tag and storing in the list
  bike_details["price"] <- html_text(web_page %>% html_nodes("span.o-Hyyko.o-bPYcRG.o-eqqVmt"))
  
  # Mini table information from tbody element and storing in the list
  keys <- html_text(web_page %>% html_nodes("span.o-cpNAVm.o-KxopV.o-byFsZJ"))
  values <- html_text(web_page %>% html_nodes("td.o-eqqVmt.o-eemiLE.o-cYdrZi.o-eZTujG"))
  
  # Combine keys and values into the list
  bike_details[keys] <- values
  
  # Getting data from the large table with li and ul tags and storing in the list
  largetable_keys <- html_text(web_page %>% html_nodes("div.o-cpNAVm.lI0JO_.o-cpnuEd"))
  largetable_values <- html_text(web_page %>% html_nodes("div.mLrdoz.lI0JO_"))
  
  # Combine large table keys and values into the list
  bike_details[largetable_keys] <- largetable_values 
  # Convert bike details to a dataframe
  bike_details_df <- as.data.frame(t(bike_details), stringsAsFactors = FALSE)
  
  # Bind the new bike details to the existing dataframe
  all_bike_data_df <- bind_rows(all_bike_data_df, bike_details_df)
}
