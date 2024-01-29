# Vilea Tech-Interview

## iOS Assignment

Let's dive into the coding assignment! Your mission is to develop a native iOS app, following the product backlog provided below. The app helps drivers of electric cars to find nearby charging stations and show their availability status in real time.

While it's not mandatory to tackle all the requirements, we encourage you to implement at least
the "MUST" ones. Choose the functionalities that you feel most comfortable with and enjoy the
process of implementing them. Remember, it's crucial that you can articulate your choices and
solutions effectively. Have fun doing the assignment and make a nice application!


## SUBMISSION

To ensure a smooth review process before the technical interview, we kindly request that you
submit your implementation at least one day prior to the scheduled interview. Please create a
public Git repository on GitHub or any similar platform that contains the project codebase.
Once you have completed the implementation, please notify us so that we can review the code
thoroughly.

As part of the second interview you will be asked questions about your code, design/architecture choices and to extend the app with minor features.

## Reference material

Data about the location of charging points in Switzerland and live availability is provided by the Swiss confederation at https://github.com/SFOE/ichtankestrom_Documentation/blob/main/Access%20Download%20the%20data.md / https://opendata.swiss/de/dataset/ladestationen-fuer-elektroautos


## PRODUCT BACKLOG

### [SHOULD] As a user I want to see a map centered around my current position

Acceptance criteria:
* opening the app, a map is presented
* the initial map position is the current user location
* the map does not need to be scrollable

### [SHOULD] As a user I want to see all charging stations in the radius of 1km of my position on the map

Acceptance criteria:
* charging stations are visible on the map at their correct location
* validate against map.geo.admin.ch (see below)

### [MUST] As a user I want to see all charging stations in the radius of 1km of my position on a list

Acceptance criteria:
* a second tab is available in the app, showing a list of charging stations
* the list shall be sorted by "Power", descending (i.e. stations with highest charging power at the top)
* list entries shall display "id", "Power" and availability at a minimum

### [SHOULD] As a user I want to see a different icon for the charging station based on its availability

Acceptance criteria:
* charging station icons are different (or in a different color) based on their availability status
* validate against map.geo.admin.ch (see below)

### [MUST] As a user I want to see availability in real time, without the need to reload data manually

Acceptance criteria:
* charging station availability is updated automatically
* a 'last update' field shows in the UI when the last data update took place
* validate against map.geo.admin.ch (see below)

### [MUST] As a user I want to be able to see the last loaded list of charging stations when I am offline

Acceptance criteria:
* open the app with internet connectivity available synchronizes the available charging stations around me
* disabling internet connectivity, terminating the app and re-opening it results in the list to be available
* the map does not need to be cached/stored. In offline mode only the list is available


* https://map.geo.admin.ch/?lang=en&topic=energie&bgLayer=ch.swisstopo.pixelkarte-grau&zoom=0&layers=ch.bfe.ladestellen-elektromobilitaet&catalogNodes=2419,2420,2427,2480,2429,2431,2434,2436,2767,2441,3206 can be used to validate the app. It shows all charging stations in switzerland with their current state
