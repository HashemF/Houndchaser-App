## Authors
- Hashem FAWZY (hafawzy@upei.ca)
- Evan LAVALLEE (elavalee2@upei.ca)
- Luis MONDRAGON (lfmondragonverduzco@upei.ca)
- Tristan WHITEN (tjwhiten@upei.ca)
# Houndchaser Proposal
# Outline
Greetings! This is a proposal for an application dedicated for users who have pet dogs called Houndchaser, designed to help manage your pet dogs via one of their most common activities; daily walks. This app will be user based, where they will be able to manage one or multiple dogs and make sure they have a healthy and constant source of outside sun and exercise, with time being checked to ensure when you have dedicated enough time outside to go back. This app will be mainly focused on dogs and its core audience is dedicated dog owners. 
The app will remind the owner every unspecified period to walk their dog. Throughout their walk, they will keep track of their route through a map and by the end of their walk be presented a results screen for their dog. They will also be able to input information about their pets through the application, such as their name and such. 
Finally, some optional feature may or may not be added, such as the ability to have a recommended walk time based on information, a overall comparison between other walks taken, and more.
## API and Packages Reference

### Geolocator Package

#### Description:

The OpenWeatherMap API provides weather data, including current weather conditions, forecasts, and historical data, based on geographic coordinates or city names. It offers a wide range of weather information.

#### Usage:

To use Geolocator in your application, you'll need to add the following dependency to your `pubspec.yaml` file:

```yaml
dependencies:
  geolocator: ^7.0.3
```
After adding the dependency, you can import the package in your Dart code and start using its functionality.

#### API Key:
No API key is required for Geolocator.
#### Doc:
https://pub.dev/documentation/geolocator/latest/geolocator/geolocator-library.html


### OpenweatherMap API 

#### Description:

Geolocator is a package that provides easy access to platform-specific location services. It allows your application to retrieve the device's current location, listen for location updates, and perform geocoding and reverse geocoding operations.

#### Usage:
make HTTP requests to their API endpoints to retrieve weather data.
```yaml
dependencies:
  http: ^0.14.0
```
#### API Key:
--------------------------------
#### Doc:
https://openweathermap.org/api

### Google Maps Flutter API

#### Description:
The Google Maps Flutter API allows you to integrate interactive maps into your Flutter applications. It provides a variety of features, including displaying maps, adding markers, drawing routes, and more. With this API, you can create rich mapping experiences for your users.
#### Usage:
To use the Google Maps Flutter API in your application, you'll need to add the google_maps_flutter package to your pubspec.yaml file:
```yaml
dependencies:
  google_maps_flutter: ^2.0.10
```
#### API Key:
--------------------------------
#### Doc:
https://pub.dev/documentation/google_maps_flutter/latest/index.html


## Roadmap

- General Timeline
-Sprint 1: February 15-28
Create home page
Create pet screen
Create walk finished screen
Research location tracking
Home screen fully functional

- Sprint 2: February 29 - March 15
Create walk in progress screen
Create functionality to store and modify pets
Pet screen display functionality implemented
Integrate all screens together

- Sprint 3: March 16-29
Create location tracking function
Create functionality to store and calculate walk recording data
Create walk finished display functionality

- Sprint 4: March 29 - April 16
Implement location tracking function to walk in progress screen
Create schedule walk screen
Create function to create a reminder for scheduled walks
Implement schedule walk screen functionality
Create pet tips pop ups (on a timer?)

# Mockups of specific screens
- Main Menu (allows users to schedule a walk or view their pets)
![mainmenuLarge](https://github.com/UPEI-Android/cs3130-2024w-group4-finalproject-cs3130-team-4/assets/113602543/48023c14-0908-4a73-91fd-c12554fcb140)
- Menu to schedule a walk (When the walk will occur, when to alert the user to get ready, and which pets to walk)
![schedulewalkLarge](https://github.com/UPEI-Android/cs3130-2024w-group4-finalproject-cs3130-team-4/assets/113602543/b144d817-d5b4-4f1f-9a8d-5470a9190d75)
- List of pets (possible alternative main menu if walk scheduling is dropped. Allows user to view all pets and add, edit, and remove pets)
![petListLarge](https://github.com/UPEI-Android/cs3130-2024w-group4-finalproject-cs3130-team-4/assets/113602543/81dd7104-4eeb-41ce-a95a-49a3d877f55d)
- Pet info (Allows user to see info on a specific pet.)
![largepetinfo](https://github.com/UPEI-Android/cs3130-2024w-group4-finalproject-cs3130-team-4/assets/113602543/08cd73b6-7aeb-4547-a800-5366cdb25cec)
- Walk in progress screen (Check info on the current walk [distance traveled, time, and a map that updates during the walk, showing the user's path])
![walkInProgress](https://github.com/UPEI-Android/cs3130-2024w-group4-finalproject-cs3130-team-4/assets/113602543/fce6fbbc-5e32-43e9-afa7-5b13534355a3)
- Walk complete menu (Shows info on a completed walk)
![walkCompleteLarge](https://github.com/UPEI-Android/cs3130-2024w-group4-finalproject-cs3130-team-4/assets/113602543/a754c721-cc56-4e66-88b6-c211610b2864)
- Notification (Pops up at specific times, shows random facts about a breed of pet the user owns.)
![notification](https://github.com/UPEI-Android/cs3130-2024w-group4-finalproject-cs3130-team-4/assets/113602543/2bd3bb0c-2cf8-402f-9c4a-02f1ffa373e4)

