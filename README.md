
# TailMate

TailMate is an app designed to connect sports fans, concert enthusiasts, cultural festivals, and more through saving and locating nearby tailgates. 


## Background

Tailgating is a popular activity, particularly for sports fans, to meet in parking lots and empty spaces before sporting events. Fans can share food, drinks, fun activities, and even set up TVs to watch the game. Growing up near Detroit, my team and I know how important tailgating is to Detroit sports fans. According to Crestline, Detroit is ranked fourth in the NFL for the "most hardcore tailgaters". However, many fans such as myself don't always know where the best tailgates are or how to find them. This is where TailMate comes in, allowing a user to open the app and easily locate nearby tailgates filtered by event, density, and location.


![Screenshot 2024-03-30 at 7 02 56 PM](https://github.com/Gabep14/ThreeMusketeers/assets/148350526/5dfa78c6-eaa8-497a-ac73-62c7c41157d3)

## Screenshots

<img width="300" alt="image" src="https://github.com/Gabep14/ThreeMusketeers/assets/148350526/c84aa76e-d45b-4bca-be53-75f4e785ed4b">

<img width="300" alt="image" src="https://github.com/Gabep14/ThreeMusketeers/assets/148350526/9d599b1d-525c-4096-865c-2b9d7a408d15">

<img width="300" alt="image" src="https://github.com/Gabep14/ThreeMusketeers/assets/148350526/87752cac-b3b1-44f3-aaf8-40c44730193e">

<img width="300" alt="image" src="https://github.com/Gabep14/ThreeMusketeers/assets/148350526/d4e7fcd6-4fdb-4295-a7b8-de401bd5e969">

<img width="300" alt="image" src="https://github.com/Gabep14/ThreeMusketeers/assets/148350526/d334cf34-eca5-45e5-9f62-d77b5d5e00ce">


## Objectives

- Code a tailgate app to connect sports fans and other enthusiasts
- Develop Hi-Fi prototypes and translate into an Xcode app
- Collaboration between Coder and Designer to produce a final product
- Incorporate MapKit API
- Test code to find any inconsistencies
- Submit Project to TestFlight
- Collect User Feedback and make necessary changes
## Skills

Swift, Swift UI, Xcode, Sketch, MapKit, Maps
## Project Timeline

<img width="800" alt="Screenshot 2024-03-30 at 6 39 28 PM" src="https://github.com/Gabep14/ThreeMusketeers/assets/148350526/afee7bf7-ba13-4770-b513-35731b8ea313">

<img width="800" alt="Screenshot 2024-03-30 at 6 37 36 PM" src="https://github.com/Gabep14/ThreeMusketeers/assets/148350526/48de4b27-df91-402a-a341-62a6b6c60b58">

<img width="800" alt="Screenshot 2024-03-30 at 6 35 47 PM" src="https://github.com/Gabep14/ThreeMusketeers/assets/148350526/da56619b-82c3-4d77-b86d-eeea0412c956">

![Screenshot 2024-03-30 at 6 39 52 PM](https://github.com/Gabep14/ThreeMusketeers/assets/148350526/5688bee4-6695-4930-a69c-181af2368ff2)

<img width="800" alt="Screenshot 2024-03-30 at 6 38 33 PM" src="https://github.com/Gabep14/ThreeMusketeers/assets/148350526/a38d3f29-6b10-4387-adf5-8e9e1a2e9403">


## Technical Walkthrough

TailMate took a lot of learning and perserverence as it involved using the MapKit API and connecting UI Views in a way I have not developed previously. The idea of the app is to connect sports fans and other event enthusiasts through finding nearby tailgates. The user can add a location to the map if they are at a tailgate, search for any place in the map, see nearby map pins where tailgates are, save a location to their favorites, check the density of tailgates in the area(green, yellow, or red for really busy), and even get directions to the tailgate - both in-app and in the Apple Maps app. 

The MapKit API is native to Apple and works well with Apple Maps functionalities, however it yielded many challenges and sparked an immense learning project for me. I quickly realized the map functionalities such as search and map pins were not built-in Swift functions, I had to hard code them myself. This took most of the projet time, as well as connecting these functionalities between views and using @Binding variables. We quickly realized many of the ambitions we had in our Hi-Fi prototypes were not attainable in our short timeline, so I focused on the necesseties of the app, including search, map pins, favoriting locations, and density areas. I was also able to add some features to enhance user experience, such as look around previews and in-app directions, as well as a button to take you to Apple Maps directions. This complex project taught me so much as a developer, from simple aspects of connecting UI views to learning how to use an API and code complex, interconnected functions. 

## TailMate Team

![Screenshot 2024-03-30 at 7 00 06 PM](https://github.com/Gabep14/ThreeMusketeers/assets/148350526/95841b6c-c2c1-406a-9a31-808cf8189801)


## Demo

Below is a YouTube link to a walkthrough of TailMate 1.0
- On appear, the user is greeted with nearby tailgates as map pins and the density of tailgates in the area

https://youtube.com/shorts/eumO5F7y3cQ?si=tc4_bZcElMt0COHK
