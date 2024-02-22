
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class intermediate_level extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final List<Map<String, String>> intermediateExercises = [
            {
    'name': 'Push-Ups',
    'description': 'A classic chest and triceps exercise that builds upper body strength and stability. Lower your body towards the ground with your hands shoulder-width apart, push back up to starting position. Modify on knees or incline walls for beginners.',
'imageUrl': 'https://firebasestorage.googleapis.com/v0/b/homeworkout-7fe50.appspot.com/o/Basic%2FPush-Ups.webp?alt=media&token=72df1cdb-7a7f-45d0-8e15-548e6008eded',
    'videoLink': 'https://www.nerdfitness.com/blog/push-up-progression-plan/',
  },
  {
    'name': 'Dips',
    'description': 'Targets triceps and chest using a sturdy chair or bench. Lower your body down by bending elbows at 90-degrees, push back up to start.',
'imageUrl': 'https://firebasestorage.googleapis.com/v0/b/homeworkout-7fe50.appspot.com/o/Basic%2Fdip.jpg?alt=media&token=c806cff0-fe0c-4f49-825a-c1f1bbb2b552',
    'videoLink': 'https://www.youtube.com/watch?v=QzUqm-lMWXY',
  },
  {
    'name': 'Rows',
    'description': 'Strengthens back and biceps. Use a stable bar or towel against a door, pull your body towards the bar or towel, squeezing your back muscles.',
'imageUrl': 'https://firebasestorage.googleapis.com/v0/b/homeworkout-7fe50.appspot.com/o/Basic%2FRows.webp?alt=media&token=f3be0e3d-c270-4d1f-acda-8cabaaae5180',
    'videoLink': 'https://www.youtube.com/watch?v=XOO-dRwnbl8',
  },
  {
    'name': 'Squats',
    'description': 'A fundamental exercise for building leg strength, glutes, and core. Stand with feet shoulder-width apart, lower your body as if sitting in a chair, then push back up.',
'imageUrl': 'https://firebasestorage.googleapis.com/v0/b/homeworkout-7fe50.appspot.com/o/Basic%2FSquats.webp?alt=media&token=f41154f5-9720-4d8a-a4aa-2dbe601c9a3a',
    'videoLink': 'https://www.reddit.com/r/bodyweightfitness/comments/gbezcx/dont_listen_to_athlean_xs_squat_advice_its/',
  },
  {
    'name': 'Lunges',
    'description': 'Great for balance and individual leg strength. Step forward with one leg, bending both knees at 90 degrees, push back up, and repeat with the other leg.',
'imageUrl': 'https://firebasestorage.googleapis.com/v0/b/homeworkout-7fe50.appspot.com/o/Basic%2FLunges_.webp?alt=media&token=83189d65-5fd6-4d0c-9e54-f0ae537d3130',
    'videoLink': 'https://www.facebook.com/athleanx/videos/dont-ignore-the-lunge/315129639083484/',
  },
  {
    'name': 'Plank',
    'description': 'Builds core strength and stability. Hold a push-up position on your forearms for as long as you can with good form.',
'imageUrl': 'https://firebasestorage.googleapis.com/v0/b/homeworkout-7fe50.appspot.com/o/Basic%2FPlank.webp?alt=media&token=f8c6c346-c820-4c52-9e9e-447627b1272c',
    'videoLink': 'http://www.startbodyweight.com/p/exercise-progressions_12.html',
  },
  {
    'name': 'Crunches',
    'description': 'Targets abdominal muscles. Lie on your back and lift your upper body off the ground. Modify with knee lifts or decline for increased difficulty.',
    'imageUrl': 'https://firebasestorage.googleapis.com/v0/b/homeworkout-7fe50.appspot.com/o/Basic%2FCrunches.webp?alt=media&token=9c983a42-bf2e-4e18-912e-e27e9f720fc1',
    'videoLink': 'https://www.youtube.com/watch?v=1fbU_MkV7NE',
  },
  {
    'name': 'Side Plank',
    'description': 'Strengthens core and obliques. Hold a plank position on one side with your arm reaching towards the ceiling. Switch sides and repeat.',
'imageUrl': 'https://firebasestorage.googleapis.com/v0/b/homeworkout-7fe50.appspot.com/o/Basic%2Fside-plank-.webp?alt=media&token=cd0be6fa-3fd4-4eb5-9b75-2c7883327644',
    'videoLink': 'https://www.youtube.com/watch?v=rCxF2nG9vQ0',
  },
  {
    'name': 'Glute Bridges',
    'description': 'Activates glutes and hamstrings. Lie on your back with knees bent, lift your hips off the ground, squeezing your glutes, then lower back down.',
'imageUrl': 'https://firebasestorage.googleapis.com/v0/b/homeworkout-7fe50.appspot.com/o/Basic%2Fglute-bridge.webp?alt=media&token=48c8647c-0fc0-4059-8463-9528212b93a1',
    'videoLink': 'https://rebellion.nerdfitness.com/index.php?/topic/113219-how-to-execute-heavy-glute-bridges-and-hip-thrusts-with-resistance-bands/',
  },
  {
    'name': 'Bird-Dogs',
    'description': 'Builds core and coordination. Start on all fours, extend opposite arm and leg simultaneously, keeping your back flat and engaged. Repeat on the other side.',
'imageUrl': 'https://firebasestorage.googleapis.com/v0/b/homeworkout-7fe50.appspot.com/o/Basic%2FBird%2BDog%2B.webp?alt=media&token=1765d50b-c14e-432e-9c1e-dccfbc19b63a',
    'videoLink': 'https://m.youtube.com/watch?v=QQot16miua8',
  },
            ];

            for (int day = 1; day <= 30; day++) {
              // Shuffle the exercises independently for each day
              List<Map<String, String>> shuffledExercises =
                  List.from(intermediateExercises);
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
          .collection("intermediate")
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

