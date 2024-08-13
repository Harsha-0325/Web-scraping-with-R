# # # library(rvest)
# # # library(dplyr)
# # # url <- "https://www.bikewale.com/royalenfield-bikes/hunter-350/"

# # # web_page <- read_html(url)
# # # # print(web_page)

# # # # creating empty dictionary
# # # bike_brands_info <- list()

# # # # getting bike name directly from h1 tag and storing in dictionary
# # # bike_brands_info["bike_name"] <- html_text(web_page %>% html_nodes("h1"))
# # # # print(bike_brands_info)

# # # # getting price of bike directly from span tag and storing in dictionary
# # # bike_brands_info["price"] <- html_text(web_page %>% html_nodes("span.o-Hyyko.o-bPYcRG.o-eqqVmt"))
# # # # print(bike_brands_info)

# # # # mini table information from tbody element and storing in dictionary
# # # keys <- html_text(web_page %>% html_nodes("span.o-cpNAVm.o-KxopV.o-byFsZJ"))
# # # values <- html_text(web_page %>% html_nodes("td.o-eqqVmt.o-eemiLE.o-cYdrZi.o-eZTujG"))

# # # bike_brands_info[keys] <- values
# # # # print(bike_brands_info)


# # # # getting data from large table with li and ul tags and stroing in dictionary
# # # largetable_keys <- html_text(web_page %>% html_nodes("div.o-cpNAVm.lI0JO_.o-cpnuEd"))
# # # largetable_values <- html_text(web_page %>% html_nodes("div.mLrdoz.lI0JO_"))

# # # bike_brands_info[largetable_keys] <- largetable_values
# # # print(bike_brands_info)

# # # # converting this dictionary into dataframe
# # # df <- as.data.frame(bike_brands_info)
# # # print(df)


# # # Load the required packages
# # library(rvest)
# # library(dplyr)

# # # Define the URL
# # url <- "https://www.bikewale.com/royalenfield-bikes//"  # Use the actual URL you are scraping

# # # Read the webpage content
# # web_page <- read_html(url)

# # # Extract all links
# # links <- web_page %>%
# #   html_nodes("a.o-cpnuEd.o-SoIQT.o-eZTujG.o-fzpilz") %>%  # Select all anchor tags
# #   html_attr("href")    # Extract the href attribute

# # # Print the extracted links
# # print(links)


# ---------------------------------------------------------------------------------------------------------------------------------------------

# # Load the required packages
# library(rvest)
# library(dplyr)

# # Function to scrape individual bike details
# scrape_bike_details <- function(bike_url) {
#   web_page <- read_html(bike_url)
  
#   # Creating an empty list to store bike details
#   bike_details <- list()
  
#   # Getting bike name directly from h1 tag and storing in the list
#   bike_details["bike_name"] <- html_text(web_page %>% html_nodes("h1"))
  
#   # Getting price of the bike directly from span tag and storing in the list
#   bike_details["price"] <- html_text(web_page %>% html_nodes("span.o-Hyyko.o-bPYcRG.o-eqqVmt"))
  
#   # Mini table information from tbody element and storing in the list
#   keys <- html_text(web_page %>% html_nodes("span.o-cpNAVm.o-KxopV.o-byFsZJ"))
#   values <- html_text(web_page %>% html_nodes("td.o-eqqVmt.o-eemiLE.o-cYdrZi.o-eZTujG"))
  
#   # Combine keys and values into the list
#   bike_details[keys] <- values
  
#   # Getting data from the large table with li and ul tags and storing in the list
#   largetable_keys <- html_text(web_page %>% html_nodes("div.o-cpNAVm.lI0JO_.o-cpnuEd"))
#   largetable_values <- html_text(web_page %>% html_nodes("div.mLrdoz.lI0JO_"))
  
#   # Combine large table keys and values into the list
#   bike_details[largetable_keys] <- largetable_values
  
#   # Return the bike details as a named list
#   return(bike_details)
# }

# # Function to extract all bike links from the main page
# extract_company_links <- function(main_url) {
#   web_page <- read_html(main_url)
  
#   # Extract company links (adjust the CSS selector based on the actual HTML structure)
#   # Extract company links
#     company_links <- list(web_page %>%
#     html_nodes("div.o-bfyaNx.o-bNxxEB.o-bqHweY") %>%
#     html_nodes("ul.o-XylGE.o-bCRRBE.o-cpnuEd") %>%
#     html_nodes("a.o-cKuOoN.o-frwuxB") %>%
#     html_attr("href"))

#   # pasting the main url to the each company link with for loop
#   for (i in 1:length(company_links)) {
#     company_links[[i]] <- paste0("https://www.bikewale.com", company_links[[i]])
#   }
  
#   return(company_links)
# }


# # Main function to combine steps and store data in a dataframe
# scrape_all_bike_data <- function(main_url) {
#   bike_links <- extract_bike_links(main_url)
  
#   all_bike_data <- lapply(bike_links, function(link) {
#     tryCatch({
#       scrape_bike_details(link)
#     }, error = function(e) {
#       message(paste("Error scraping", link))
#       return(NULL)
#     })
#   })
  
#   # Remove any NULL entries from the list
#   all_bike_data <- all_bike_data[!sapply(all_bike_data, is.null)]
  
#   # Convert list of bike details into a dataframe
#   df <- bind_rows(all_bike_data)
  
#   return(df)
# }

# # Define the URL of the main page
# main_url <- "https://www.bikewale.com/"

# # Scrape all bike data and store in a dataframe
# bike_data_df <- scrape_all_bike_data(main_url)

# # Print the dataframe
# print(bike_data_df)



# # ---------------------------------------------------------------------------------------------------------------------------------------------


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

print(all_links)





