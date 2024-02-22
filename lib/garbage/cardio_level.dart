
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class cardio_level extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final List<Map<String, String>> cardioExercises = [
                {
                'name': 'Running',
                'description':
                    'Running is a great cardiovascular exercise that improves endurance.',
                'imageUrl':
                    'https://firebasestorage.googleapis.com/v0/b/homeworkout-7fe50.appspot.com/o/cardio%2Frunning.jpeg?alt=media&token=066833ef-2445-4b89-9b4e-73e47231e244',
                'videoLink': "https://youtu.be/E9KirsWSE04?si=0RxiwO7r44HrKuyM",
              },
              {
                'name': 'Jump Rope',
                'description':
                    'Jump Rope is an excellent cardio workout that enhances agility.',
                'imageUrl':
                    'https://firebasestorage.googleapis.com/v0/b/homeworkout-7fe50.appspot.com/o/cardio%2Fjumping%20rope.jpeg?alt=media&token=91ffb625-69c8-4843-b159-7e44880b41db',
                'videoLink':
                    "https://youtube.com/shorts/8l4JVDU1ovU?si=t2jk-Kc2Y2l-kkbA",
              },
              {
                'name': 'Cycling',
                'description':
                    'Cycling is a low-impact cardio exercise that strengthens leg muscles.',
                'imageUrl':
                    'https://firebasestorage.googleapis.com/v0/b/homeworkout-7fe50.appspot.com/o/cardio%2Fcycling.jpeg?alt=media&token=f19fd1db-2913-47dd-9672-918e7e5639a7',
                'videoLink': "https://youtu.be/0MLnC3bzXgQ?si=44wpDDQ3BzUZSH0V",
              },
              {
                'name': 'High Knees',
                'description':
                    'High Knees is a cardio exercise that targets the lower body and boosts heart rate.',
                'imageUrl':
                    'https://firebasestorage.googleapis.com/v0/b/homeworkout-7fe50.appspot.com/o/cardio%2Fhigh%20knees.jpeg?alt=media&token=24a90315-e989-4440-9e48-48432d002f83',
                'videoLink': "https://youtu.be/Xh8JEoYjYhg?si=BMJLBNxC9MzHb9Pd",
              },
              {
                'name': 'Burpees',
                'description':
                    'Burpees are a full-body cardio exercise that combines strength and endurance.',
                'imageUrl':
                    'https://firebasestorage.googleapis.com/v0/b/homeworkout-7fe50.appspot.com/o/cardio%2Fburpees.jpeg?alt=media&token=d160c3fb-59af-416d-9949-f04359316718',
                'videoLink': "https://youtu.be/auBLPXO8Fww?si=AmC64ZpezihZAlKJ",
              },
              {
                'name': 'Mountain Climbers',
                'description':
                    'Mountain Climbers are a dynamic cardio exercise that engages multiple muscle groups.',
                'imageUrl':
                    'https://firebasestorage.googleapis.com/v0/b/homeworkout-7fe50.appspot.com/o/cardio%2FMountain%20Climbers.jpeg?alt=media&token=737a7f2b-788f-46e8-b30c-5646dc19079d',
                'videoLink':
                    "https://youtu.be/kLh-uczlPLg?si=QLXtScTxKiQY7ZPQ ",
              },
              {
                'name': 'Jumping Jacks',
                'description':
                    'Jumping Jacks are a classic cardio exercise that improves heart health.',
                'imageUrl':
                    'https://firebasestorage.googleapis.com/v0/b/homeworkout-7fe50.appspot.com/o/cardio%2FJumping%20Jacks.jpeg?alt=media&token=8fc213b7-d9c9-4597-902f-5ede12348c53',
                'videoLink': "https://youtu.be/yDSMdd8hiFg?si=SK1Jnp8kM7JIlMVO",
              },
              {
                'name': 'Box Jumps',
                'description':
                    'Box Jumps are a plyometric cardio exercise that enhances leg power.',
                'imageUrl':
                    'https://firebasestorage.googleapis.com/v0/b/homeworkout-7fe50.appspot.com/o/cardio%2FBox%20Jumps.jpeg?alt=media&token=99314b18-7bfa-4b6d-8429-38bee4bc98e0',
                'videoLink':
                    " https://youtu.be/I0T5YWUSVKE?si=4RSXxWiuVoJ8X8lk",
              },
              {
                'name': 'Sprinting',
                'description':
                    'Sprinting is an intense cardio workout that boosts metabolism.',
                'imageUrl':
                    'https://firebasestorage.googleapis.com/v0/b/homeworkout-7fe50.appspot.com/o/cardio%2FSprinting.jpeg?alt=media&token=02afd936-5999-4db1-a7d4-7d6283321f63',
                'videoLink':
                    "https://youtube.com/shorts/vVgivxihx_4?si=eLJkUFHQs3ZYCWEr",
              },
              {
                'name': 'Biking',
                'description':
                    'Biking is an outdoor cardio activity that provides a full-body workout.',
                'imageUrl':
                    "https://firebasestorage.googleapis.com/v0/b/homeworkout-7fe50.appspot.com/o/cardio%2FBiking'.jpeg?alt=media&token=91d58aaa-da33-4811-8637-aaa7b8483b6e",
                'videoLink': "https://youtu.be/lT-ufiBSmHo?si=TCzvKLyIKoRGmlCd",
              },
              {
                'name': 'Rowing',
                'description':
                    'Rowing is a low-impact cardio exercise that targets the upper body and core.',
                'imageUrl':
                    'https://firebasestorage.googleapis.com/v0/b/homeworkout-7fe50.appspot.com/o/cardio%2FRowing.jpeg?alt=media&token=2541e390-c093-44d7-9df6-5e3288ab123a',
                'videoLink':
                    'https://youtube.com/shorts/qu0Ln0TUVQ4?si=8vWI5ngpMxt95erh',
              },
              {
                'name': 'Dancing',
                'description':
                    'Dancing is a fun and energetic cardio workout that improves flexibility.',
                'imageUrl':
                    'https://firebasestorage.googleapis.com/v0/b/homeworkout-7fe50.appspot.com/o/cardio%2FDancing.jpeg?alt=media&token=097390bb-f3c8-4b5e-a9bb-34e53ceef236',
                'videoLink': 'https://youtu.be/YakUb8FPqD8?si=wUSlI6FqlmhaErNk',
              },
            ];

            for (int day = 1; day <= 30; day++) {
              // Shuffle the exercises independently for each day
              List<Map<String, String>> shuffledExercises =
                  List.from(cardioExercises);
              shuffledExercises.shuffle();

              await uploadExercisesForDay('Day $day', shuffledExercises);
            }
          },
          child: Text('Upload Exercises for 3 Days'),
        ),
      ),
    );
  }
}

Future<void> uploadExercisesForDay(
    String day, List<Map<String, String>> exercises) async {
  try {
    for (int i = 0; i < 8; i++) {
      final exercise = exercises[i];

      await FirebaseFirestore.instance
          .collection('Workout')
          .doc('Levels')
          .collection("cardio")
          .doc(day)
          .collection('ExercisesList')
          .doc('Exercise${i + 1}')
          .set({
        'exerciseName': exercise['name'],
        'videoLink': exercise['videoLink'],
        'description': exercise['description'],
        'imageUrl': exercise['imageUrl'],
      });
    }

    print('Exercises uploaded successfully for $day');
  } catch (e) {
    print('Error uploading exercises: $e');
  }
}

