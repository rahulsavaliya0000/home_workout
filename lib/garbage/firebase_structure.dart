import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> initializeFirestore() async {
  await Firebase.initializeApp();

  final rootCollection = FirebaseFirestore.instance.collection('Workout');

  final levelsDocRef = rootCollection.doc('Levels');
  // await levelsDocRef.
  final levels = ['beginner', 'intermediate', 'advanced', 'cardio'];

  for (final level in levels) {
    final levelSubcollectionRef = levelsDocRef.collection(level);

    for (int day = 1; day <= 30; day++) {
      final dayDocRef = levelSubcollectionRef.doc('Day $day');

      await dayDocRef.set({
      });

      final exercisesCollection = dayDocRef.collection('Exercises');

      for (int exercise = 1; exercise <= 8; exercise++) {
        final exerciseDocRef = exercisesCollection.doc('Exercise $exercise');

        await exerciseDocRef.set({
          'Name': 'Exercise $exercise',
          'Image': 'image_ur',
          'Video': 'video_link',
          'Description':'description'
        });
      }
    }
  }
}
