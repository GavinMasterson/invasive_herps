#RSelenium scraper for GISD

URL <- "http://www.iucngisd.org/gisd/"

# START SELENIUM ------------------------------------------------------------------------------------------------------

# Start the Docker image (if you don't already have one running!).
# Open docker in the working directory for the project (ideally)
#
# NOTE: To mount the current folder on the container use
#
# - $(pwd)       [Linux or Mac]
# - %cd%         [Windows command line (untested)]
# - ${PWD}       [Windows PowerShell (untested)]
#
# NOTE: You also need to reference the *absolute* path for Downloads folder on the container, so no starting with ~.
#
# docker run -d --rm \
#   --name selenium \
#   -p 4444:4444 \
#   -p 5900:5900 \
#   -v ${PwD}:C:/invasive_herps/downloads \
#   -v ${PwD}:/home/seluser/Downloads \
#   selenium/standalone-chrome-debug:3.141

# Verify that it is running.
#
# $ docker ps

# VNC CONNECTION ------------------------------------------------------------------------------------------------------

# Fire up VNC Viewer and create a connection to Selenium.

# LIBRARIES -----------------------------------------------------------------------------------------------------------

library(RSelenium)

# ---------------------------------------------------------------------------------------------------------------------

# 1. Use remoteDriver() to create a connection to Selenium.
# 2. Open the browser.
# 3. Navigate to the URL.

browser <- remoteDriver(
  browserName = "chrome",
  # NOTE: Use the following IP addresses:
  #
  # - 127.0.0.1 [Linux or Mac? or Windows and Docker Desktop]
  # - 192.168.99.100 [Windows and Docker Toolbox]
  #
  remoteServerAddr = "192.168.99.100",
  port=4444
)

class(browser)

browser$open(silent = TRUE)
browser$navigate(URL)

# PAGE DETAILS --------------------------------------------------------------------------------------------------------

# 1. Get the current URL.
# 2. Get the page title.

browser$getCurrentUrl()
browser$getTitle()

# SCREENSHOT ----------------------------------------------------------------------------------------------------------

# 1. Take a screenshot and save it to "rselenium-homepage.png".

browser$screenshot(file = "C:/invasive_herps/GISD_home.png")

# FIND ADVANCED SEARCH BUTTON -----------------------------------------------------------------------------------------

# 1. Find the element which contains the advanced search button.
# 2. Click it.

adv_search <- browser$findElement(using = "id","search_advanced_button_closed")

adv_search$clickElement()

# CLICK "REPTILE" AND "AMPHIBIAN" -------------------------------------------------------------------------------------

# 1. Open drop downs for 'Animalia' and 'Chordata'.
# 2. Click check box for 'Reptile' and 'Amphibian'

animalia <- browser$findElement("css selector",".dynatree-expander")
animalia$clickElement()

chordata <- browser$findElement("css selector","#tree-search-taxonomy > ul > li:nth-child(1) > ul > li:nth-child(3) > span > .dynatree-expander")
chordata$clickElement()

amphibia <- browser$findElement("css selector","#tree-search-taxonomy > ul > li:nth-child(1) > ul > li:nth-child(3) > ul > li:nth-child(2) > span > .dynatree-checkbox")
amphibia$clickElement()

reptilia <- browser$findElement("css selector","#tree-search-taxonomy > ul > li:nth-child(1) > ul > li:nth-child(3) > ul > li.dynatree-lastsib > span > .dynatree-checkbox")
reptilia$clickElement()

# 3. Hit search!

search_go <- browser$findElement("css selector","#submit_advanced_criteria")
search_go$clickElement()


# FIND AND CLICK BUTTON TO DOWNLOAD .CSV -----------------------------------------------------------------------------


browser$screenshot(file = "C:/invasive_herps/search_results.png")

dl_csv <- browser$findElement("css selector","#fa-pdf")
dl_csv$clickElement()

# CLEANUP ------------------------------------------------------------------------------------------------------------

# 1. Close the browser.
# 2. Delete the screenshot.

browser$close()
#file.remove("C:/invasive_herps/GISD_home.png")
