import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BeginnerLevel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            // Specify the number of days and exercises per day
            int numberOfDays = 30;
            int exercisesPerDay = 8;

            // Beginner Level Exercises
                 final List<Map<String, String>> Basicexercises = [
  {
    'name': 'Bench Press',
    'description': 'Bench Press strength standards help you to compare your one-rep max lift with other lifters at your bodyweight.',
    'imageUrl': 'https://firebasestorage.googleapis.com/v0/b/homeworkout-7fe50.appspot.com/o/Bench%20press.jpg?alt=media&token=5e6ddc83-509b-44b3-8419-a554b36f205c',
    'videoLink': 'https://youtu.be/lwKeQoXk4mk?si=nh-0_ESiMT68WXkh',
  },
  {
    'name': 'Barbell Squat',
    'description': 'Squat strength standards help you to compare your one-rep max lift with other lifters at your bodyweight.',
    'imageUrl': 'https://firebasestorage.googleapis.com/v0/b/homeworkout-7fe50.appspot.com/o/Barbell%20squat.jpg?alt=media&token=a5684760-a006-451b-9160-4ee55294cdfb',
    'videoLink': 'https://youtu.be/eb4rKCM3BKM?si=z8qhph1XNMX8o4XR',
  },
  {
    'name': 'Shoulder Press Standards',
    'description': 'Shoulder Press strength standards help you to compare your one-rep max lift with other lifters at your bodyweight.',
    'imageUrl': 'https://firebasestorage.googleapis.com/v0/b/homeworkout-7fe50.appspot.com/o/Shoulder%20Press.jpg?alt=media&token=b4f7fee1-5a6d-4379-aa81-27337edd0921',
    'videoLink': 'https://youtu.be/oAP_a-8rH5c?si=XrHPYD0d4YfGT4do',
  },
  {
    'name': 'Pull Ups Standards',
    'description': 'Pull Ups strength standards help you to compare your one-rep max lift with other lifters at your bodyweight.',
    'imageUrl': 'https://firebasestorage.googleapis.com/v0/b/homeworkout-7fe50.appspot.com/o/Pull%20%20ups.jpg?alt=media&token=8b827d04-c482-4430-bd6b-2f37b532893f',
    'videoLink': 'https://youtu.be/swLoMW9WFZI?si=OJWMCWiwSWL6oWiv',
  },
  {
    'name': 'Bent Over Row Standards',
    'description': 'Bent Over Row strength standards help you to compare your one-rep max lift with other lifters at your bodyweight.',
    'imageUrl': 'https://firebasestorage.googleapis.com/v0/b/homeworkout-7fe50.appspot.com/o/Bent%20Over%20Row.jpg?alt=media&token=44abfc91-1019-4496-a974-f1464d72aa56',
    'videoLink': 'https://youtu.be/6lxD4IdfZUE?si=C149CXob-8GhTw6n',
  },
  {
    'name': 'Dips Standards',
    'description': 'Dips strength standards help you to compare your one-rep max lift with other lifters at your bodyweight.',
    'imageUrl': 'https://firebasestorage.googleapis.com/v0/b/homeworkout-7fe50.appspot.com/o/Dips%20Standards.jpg?alt=media&token=a41ce29d-2553-4f2d-b1d5-e33e09ab51cb',
    'videoLink': 'https://youtu.be/rZl4D4p_nO4?si=ZTfoosH61kbtnrvI',
  },
  {
    'name': 'Sumo Deadlift Standards',
    'description': 'Sumo Deadlift strength standards help you to compare your one-rep max lift with other lifters at your bodyweight.',
    'imageUrl': 'https://firebasestorage.googleapis.com/v0/b/homeworkout-7fe50.appspot.com/o/Sumo%20Deadlift%20Standards.jpg?alt=media&token=7583574b-b196-440e-9ca7-152135b8eda8',
    'videoLink': 'https://youtu.be/o5FvhPAZ_yw?si=G2DST4lEmR-KQN68',
  },
  {
    'name': 'Barbell Curl Standards',
    'description': 'Barbell Curl strength standards help you to compare your one-rep max lift with other lifters at your bodyweight.',
    'imageUrl': 'https://firebasestorage.googleapis.com/v0/b/homeworkout-7fe50.appspot.com/o/Barbell%20curl.jpg?alt=media&token=c94906f5-2d81-480f-a489-c138a260f15d',
    'videoLink': 'https://youtu.be/NiWoiu7WL-Y?si=ti-9OZxh3zsFWJRr',
  },
];

            // Upload exercises for each day
            for (int day = 1; day <= numberOfDays; day++) {
              List<Map<String, String>> shuffledExercises =
                  List.from(Basicexercises);
              shuffledExercises.shuffle();

              await uploadExercisesForDay('beginner', day, exercisesPerDay, shuffledExercises);
            }
          },
          child: Text('Upload Beginner Level Exercises'),
        ),
      ),
    );
  }
}

Future<void> uploadExercisesForDay(
    String level, int day, int exercisesPerDay, List<Map<String, String>> exercises) async {
  try {
    for (int i = 0; i < exercisesPerDay; i++) {
      final exercise = exercises[i];

      // Use automatic document ID generation
      await FirebaseFirestore.instance
          .collection('Workout')
          .doc('Levels')
          .collection(level)
          .doc('Day $day')
          .collection('ExercisesList')
          .add({
            'exerciseName': exercise['name'],
            'videoLink': exercise['videoLink'],
            'description': exercise['description'],
            'imageUrl': exercise['imageUrl'],
          });

      print('Uploaded exercise ${i + 1} for $level level, Day $day: ${exercise['name']}');
    }

    print('Exercises uploaded successfully for $level level, Day $day');
  } catch (e) {
    print('Error uploading exercises for $level level, Day $day: $e');
  }
}
