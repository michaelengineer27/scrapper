# Description

This project is a simple scrapper app that loads a page, caches the content and looks for some values in it. 

# How to set up 

- Run the rails server using `rails s` command 
- Run the rails cache using `rails dev:cache` commend. Warning: this command will toggle rails cache on and off. be sure that you do not stop it unintentionally. 
- Run tests using `rails test` command.

# Explaining tasks

### 1- finding fields:

- The app will load the url received as a param and fetches the content. Since it might be occasionally unsuccessful, there is a retry mechanism to make sure we will repeat the process until we can get the page content successfully. 

- We will use `nokogiri` gem to find fields using css selectors. In case of having multiple items matching the css rule it will concatenate the values. 


### 2- fining meta tags:

- Pretty much similar to the previous step we find meta tags using nokogiri and include them in the response.

### 3- caching

- We use rails cache to avoid downloading recently downloaded urls again. The expiration time is set to 1 hour. Depending on how often we expect pages to be updated we can increase or decrease the expiration time. 

- We were also able to use Redis for this purpose, But I decided to use Rails cache because it doesn't require any external database or gem. 

### 4- Improvement
- One area to improvement is to use a more powerful caching tool like Redis instead of Rails cache to make sure we can support larger data 
- We also use background jobs to periodically scrap most frequently requested pages by users and analyze the data and see how often those pages are being updated then we can set dynamic expiration time for each page.
- we can also use background jobs to scrap popular pages again before they expire, to make sure we always have them cached and users do not need to wait until we scrap them again
- In case of a need for searching many fields in very large pages we can use parallel threads to look for values in parallel and reduce the response time.     
- In case of dealing with dynamic pages (like when we should search something, press a button and wait for the page to return the search result) our current app may be a good solution, we should use tools like selenium web drive and consider different and potentially complex scenarios. 