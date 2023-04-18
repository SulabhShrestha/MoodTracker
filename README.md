# Mood Tracker

The Mood Tracker is a minimalist and intuitive mobile application that allows users to track and manage their moods on a daily basis. With its simplicity and focus solely on mood tracking, users can easily prioritize their emotional well-being without any distractions. The app also provides seamless cloud storage for data synchronization and offers filtering options for customized data analysis. Additionally, the app supports localization for the calendar feature as of now, with plans for expanding to other languages in the future. The app's beautiful user interface enhances the overall user experience.

___

## Features

### Simple Mood Tracking
    
- Users can quickly and easily log their moods by selecting from a predefined list of emotions, such as happy, sad, angry, anxious, etc.
- The app does not include any additional habit tracking features, allowing users to solely focus on monitoring their moods.

### Cloud Data Storage

- The app securely saves mood data to the cloud, ensuring users can access their data across multiple devices and never lose their valuable information.

### Data Filtering

- Users can filter their mood data based on specific dates or time ranges, enabling them to analyze their moods over a period of time and gain insights into their emotional patterns.

### Localization Support

- The app supports localization for the calendar feature, providing users with the option to view their mood data in their preferred language.
- The app plans to expand localization support to other features and languages in the future.

### Beautiful User Interface

- The app features a visually appealing and user-friendly interface, providing an enjoyable and seamless experience for tracking and managing moods.

___

## Installation instructions

### Steps

1. Clone this repo using git: `git clone https://github.com/SulabhShrestha/MoodTracker.git`
2. Change to the cloned directory: `cd MoodTracker`
3. Install flutter dependencies: `flutter pub get`
4. Set up firebase:  
   * Create a Firebase project in the Firebase console (if you haven't already).
   * Follow the Firebase setup instructions to add the Firebase configuration files to your Flutter project.
   * Enable Firebase Authentication and Firestore for your project in the Firebase console.
5. Run the app on the device you desired.

___

## Known issues

1. <ins>**Back Button Behavior on Search Page and Add New Mood Page**</ins>
   
   **Status**: Unresolved
   
   **Description**: Currently, when the user presses the back button on the search page or the add new mood page, the app tries to close instead of going back to the previous page as expected. This behavior may cause inconvenience to users who expect the back button to navigate to the previous page within the app.
   
   **Workaround**: Users can manually navigate back to the previous page by using on-screen navigation elements i.e. Leading Icon on appbar.
   
   **Future Plans**: I am actively investigating and working on fixing this issue.

___ 

## Screenshots

<img title="Homepage" height="350px" src="/screenshots/flutter_01.png">
<img title="Calendar page" height="350px" src="/screenshots/flutter_02.png">
<img title="Filter page" height="350px" src="/screenshots/flutter_03.png">
<img title="More page" height="350px" src="/screenshots/flutter_04.png">
<img title="Search Page" height="350px" src="/screenshots/flutter_05.png">
<img title="AddNewMood page" height="350px" src="/screenshots/flutter_06.png">

