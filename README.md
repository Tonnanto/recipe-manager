# recipe_manager

An app that manages all your recipes.

This app has been built as part of a project for university.
v0.1 only serves that purpose. 
Development wil continue in the future to fully implement all planned features and have a production ready application.

## Author
- [@Tonnanto](https://www.github.com/Tonnanto)

## Features
- Find all your favourite recipes in one app.
- Create your own detailed recipes that can't be found on any other app.
- TBD: Add recipes to recipe books and share them with your friends and family in the cloud.

## Current state of development
### Technology
- This app is built using Dart and Flutter. It can be run on iOS, Android and in the web.
- Recipe manager makes use of the following open source dart packages:
    - [flutter_form_builder](https://pub.dev/packages/flutter_form_builder)
    - [image_picker](https://pub.dev/packages/image_picker)
    - [sqflite](https://pub.dev/packages/sqflite)
    - [path](https://pub.dev/packages/path)
    - [enum_to_string](https://pub.dev/packages/enum_to_string)
    - [firebase_core](https://pub.dev/packages/firebase_core)
    - [cloud_firestore](https://pub.dev/packages/cloud_firestore)

### Data model
- Recipe books, recipes and ingredients can be created, edited and deleted.
- The data model can be found in an attached class diagram (recipe-manager-model-class-diagram.png).
- The app is pre-populated with some demo data including 3 recipe books and 7 recipes and ~75 ingredients.
- The following functionalities have been added for demo purposes:
    - Deleting all data
    - Resetting the demo data to it's initial state

### Data persistence
- iOS and Android only use a local SQLite Database on the device to persist data.
- The Web Application is connected to a Google Firestore Database (NoSQL).
- In the future every platform will be connected to the same Firestore Database (to allow sharing) and mobile devices will additionally use local databases for offline use.