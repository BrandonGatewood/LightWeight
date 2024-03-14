# LightWeight - Workout Tracker App

LightWeight is a simple and easy-to-use workout tracker app built with Flutter. It allows users to create multiple workouts, track workout splits, monitor progress for each exercise, and keep track of their body weight on a monthly basis. The app aims to provide users with a seamless experience for managing their fitness routines without the need for user accounts.

## Table of Contents
- [Features](#Features)
- [Usage](#usage)
- [Installation](#installation)
- [License](#license)

## Features
- **Workout Creation**: Users can create and customize multiple workouts tailored to their fitness goals.
- **Workout Split Tracking**: Track workout splits to organize exercises effectively.
- **Exercise Progress Tracking**: Monitor progress for each exercise to visualize improvement over time.
- **Monthly Body Weight Tracking**: Keep track of body weight changes on a monthly basis to monitor overall progress.
- **No Account Required**: LightWeight does not require users to create accounts, ensuring a hassle-free experience.

## Installation

Follow these steps to install LightWeight on your device:

1. Clone this repository to your local machine:

```bash
$ git clone https://github.com/BrandonGatewood/LightWeight
```

2. Navigate to the project directory:

```bash
$ cd lightweight
```

3. Install dependecies:
```bash
$ flutter pub get
```

4. Run the app:
```bash
$ flutter run
```

## Usage
Once the app is installed, follow these steps to start using LightWeight:

- **Inserting New Exercise**: 
1. Tap on "My Exercises" button in the homepage
2. Tap on the "+" icon on the top right
3. Enter exercise name
4. Tap save

- **Renaming Exercise name**:
1. Tap on "My Exercises" button in the homepage
2. Tap on the exercise you want to rename
3. Enter new name
4. Tap save 

- **Deleting Exercise**:
1. Tap on "My Exercises" button in the homepage
2. Tap on the exercise you want to delete
3. Tap on the trash Icon
4. Tap on check Icon the confirm deletion

- **Create Workouts**:
1. Tap on "My Workouts" button in the homepage
2. Tap on the "+" icon on the top right
3. Enter workout name
4. Click save
5. Tap on the "+" icon on the top right to insert exercises for the new workout
6. Order matters, long hold an exercise card to change the order
7. Increase or decrease the number of sets with the "+" or "-" icon on the right of an exercise card
8. Click save 

- **View Contents of a Workout**:
1. Tap on "My Workouts" button in the homepage
2. Tap on a workout card

- **Rename a Workout**:
1. Tap on "My Workouts" button in the homepage
2. Tap on a workout card
3. Tap on the three dots Icon on the top right
4. Tap on "Rename workout"
5. Enter new workout name
6. Tap save

- **Updating Exercises in a Workout**:
1. Tap on "My Workouts" button in the homepage
2. Tap on a workout card
3. Tap on the three dots Icon on the top right
4. Tap on "Edit Exercises"
5. Edit the exercises
6. Tap save

- **Delete Workout**:
1. Tap on "My Workouts" button in the homepage
2. Tap on a workout card
3. Tap on the three dots Icon on the top right
4. Tap on "Delete workout"
5. Tap check icon the confirm deletion

- **Managing Current Split**:
1. Make sure workouts have been created
2. Tap on "My Current Split" button in the homepage
3. Select the day
4. Tap on the pencil icon on the top right
5. Select a workout

- **Tracking Current Split**:
1. Tap the "Track" button on the bottom right of the homepage or progress page
2. Fill in the information as you workout
3. Tap save

- **View progress**:
View graphs of body weight and progress of exercises that will be done the day of:
1. Scroll down to the highlights section in the home page
View stats of every exercise:
1. Navigate to progress page using bottom nav bar
2. Select desired exercise 
3. Scroll up/down to view progress

- **Updating Body Weight**:
Body weight can only be updating once a month. 
1. Tap "Body Weight  >" button
2. Enter new body weight
3. Click save

## License
LightWeight is open-source software licensed under the **MIT License**. Feel free to use, modify, and distribute it as per the terms of the license.