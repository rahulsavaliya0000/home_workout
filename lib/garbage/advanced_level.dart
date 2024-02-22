import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class advanced_level extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final List<Map<String, String>> advancedExercises = [
              {
                'name': 'Diamond Push-Ups',
                'description':
                    'Engage your triceps and core with this intense variation. Place your hands close together in a diamond shape under your chest, lower your body down, and push back up.',
                'imageUrl':
                    'https://firebasestorage.googleapis.com/v0/b/homeworkout-7fe50.appspot.com/o/advanced%2FDiamond%20Push%20Up.webp?alt=media&token=a525f161-e77c-4951-ae6a-987cfe332932',
                'videoLink': 'https://m.youtube.com/watch?v=kGhDnFwMY3E',
              },
              {
                'name': 'Archer Push-Ups',
                'description':
                    'Build unilateral strength and stability with this challenging exercise. Raise one hand behind your back and perform a push-up with the other arm. Switch sides and repeat.',
                'imageUrl':
                    'https://firebasestorage.googleapis.com/v0/b/homeworkout-7fe50.appspot.com/o/advanced%2FArcher%20Push-Ups.webp?alt=media&token=9f9b352a-356a-4467-99d6-4b81e41ae99d',
                'videoLink': 'https://www.youtube.com/watch?v=Ycbbf7_k7Rc',
              },
              {
                'name': 'Handstand Push-Ups',
                'description':
                    'Take your upper body workout to the next level with this demanding exercise. Elevate your hands on a wall or sturdy surface and perform push-ups upside down.',
                'imageUrl':
                    'https://firebasestorage.googleapis.com/v0/b/homeworkout-7fe50.appspot.com/o/advanced%2FHandstand%20Push-Ups.webp?alt=media&token=861755ab-0e05-4658-b68b-19f1cb5f188c',
                'videoLink': 'https://www.youtube.com/watch?v=pYx7CRs7kAM',
              },
              {
                'name': 'Weighted Dips',
                'description':
                    'Increase difficulty and target more muscle groups with this variation. Add a weighted vest or backpack and perform your dips as usual.',
                'imageUrl':
                    'https://firebasestorage.googleapis.com/v0/b/homeworkout-7fe50.appspot.com/o/advanced%2FWeighted%20Dip.webp?alt=media&token=2257a4fd-fd98-4bec-94d4-974e10ede2ba',
                'videoLink': 'https://www.youtube.com/watch?v=uvfKEpwBfdI',
              },
              {
                'name': 'Plyo Dips',
                'description':
                    'Add an explosive element to your dips by pushing yourself up with power at the top of the movement. This increases strength and agility.',
                'imageUrl':
                    'https://firebasestorage.googleapis.com/v0/b/homeworkout-7fe50.appspot.com/o/advanced%2FPlyo%20Dips.webp?alt=media&token=6ddc6786-fdf8-4a78-87ab-cf42ab9855cc',
                'videoLink': 'https://www.youtube.com/watch?v=b5pSbc1eWxE',
              },
              {
                'name': 'L-Sits Dips',
                'description':
                    'Challenge your core and shoulders with this advanced dip variation. Hold your legs in an L-shape throughout the dip, keeping your back straight and engaged.',
                'imageUrl':
                    'https://firebasestorage.googleapis.com/v0/b/homeworkout-7fe50.appspot.com/o/advanced%2FL-Sits%20Dips.webp?alt=media&token=dcb3f569-e968-4834-9657-16092a8d8bdb',
                'videoLink': 'https://m.youtube.com/watch?v=ZPjyhBKH3RY',
              },
              {
                'name': 'Inverted Rows',
                'description':
                    'Build your back and grip with this exercise. Use a bar or rings suspended above you and pull yourself up until your chest touches the bar.',
                'imageUrl':
                    'https://firebasestorage.googleapis.com/v0/b/homeworkout-7fe50.appspot.com/o/advanced%2FInverted%20Rows.webp?alt=media&token=2f036241-9aa2-41a2-b64a-261bf8601f2c',
                'videoLink': 'https://www.youtube.com/watch?v=hXTc1mDnZCw',
              },
              {
                'name': 'Archer Rows',
                'description':
                    'Focus on each side independently with this advanced rowing variation. Place one hand on a higher surface and the other lower. Pull yourself up using only the lower arm. Repeat on the other side.',
                'imageUrl':
                    'https://firebasestorage.googleapis.com/v0/b/homeworkout-7fe50.appspot.com/o/advanced%2FArcher%20Rows.webp?alt=media&token=d5ed676d-1a99-4705-9940-dab53d7cd487',
                'videoLink': 'https://www.youtube.com/watch?v=NEYlZReTAXw',
              },
              {
                'name': 'Single-arm Towel Rows',
                'description':
                    'Strengthen your back and biceps with this unilateral exercise. Grip a single towel with one hand and pull yourself up towards the anchor point. Focus on controlled movements.',
                'imageUrl':
                    'https://firebasestorage.googleapis.com/v0/b/homeworkout-7fe50.appspot.com/o/advanced%2FSingle-arm%20Towel%20Rows.webp?alt=media&token=f61690ea-6e80-4703-8ed4-acfa238a3d28',
                'videoLink':
                    '[https://www.youtube.com](https://www.youtube.com)',
              },
              {
                'name': 'Tuck Front Lever Rows',
                'description':
                    'Advance your bodyweight training with this challenging exercise. Hang from a bar, pull your body up, and bring your knees towards your chest to achieve the tuck front lever position.',
                'imageUrl':
                    'https://firebasestorage.googleapis.com/v0/b/homeworkout-7fe50.appspot.com/o/advanced%2FTuck%20Front%20Lever%20Rows.webp?alt=media&token=e029d54d-c32c-4483-a196-a7a16d995b9f',
                'videoLink': 'https://www.youtube.com/watch?v=J47C1JBR7wk',
              },
              {
                'name': 'Russian Twists',
                'description':
                    'Engage your obliques with this core-strengthening exercise. Sit on the ground, lean back slightly, lift your legs, and twist your torso to touch the ground on each side.',
                'imageUrl':
                    'https://firebasestorage.googleapis.com/v0/b/homeworkout-7fe50.appspot.com/o/advanced%2FRussian%20Twists.webp?alt=media&token=f8550deb-ce46-44ce-9f8a-c7226b8e5356',
                'videoLink': 'https://www.youtube.com/watch?v=wkD8rjkodUI',
              },
              {
                'name': 'Dragon Flags',
                'description':
                    'Challenge your core strength and stability with this advanced exercise. Lie on a bench or sturdy surface, lift your legs towards the ceiling, and lower them down under control.',
                'imageUrl':
                    'https://firebasestorage.googleapis.com/v0/b/homeworkout-7fe50.appspot.com/o/advanced%2FDragon%20Flags.webp?alt=media&token=97db34d5-4db6-49a2-a089-575f3878ea4f',
                'videoLink': 'https://www.youtube.com/watch?v=n51Xvc2Uaqk',
              },
              {
                'name': 'Planche Push-Ups',
                'description':
                    'Develop incredible upper body strength with this gymnastic-inspired exercise. Lean forward with your hands on the ground and push up, keeping your body parallel to the ground.',
                'imageUrl':
                    'https://firebasestorage.googleapis.com/v0/b/homeworkout-7fe50.appspot.com/o/advanced%2Fplanche.webp?alt=media&token=b84eb639-5f33-4081-862a-fdc35fed6b8c',
                'videoLink': 'https://www.youtube.com/watch?v=3l5G-8dPbSg',
              },
              {
                'name': 'Human Flag',
                'description':
                    'Showcase your strength with this impressive static hold. Grip a vertical pole, lift your body horizontally, and maintain the position with straight arms.',
                'imageUrl':
                    'https://firebasestorage.googleapis.com/v0/b/homeworkout-7fe50.appspot.com/o/advanced%2FHuman%20Flag.webp?alt=media&token=1f3ca2e1-272d-473a-9442-6d8e1ea34b45',
                'videoLink': 'https://www.youtube.com/watch?v=eo5t1vNCA6I',
              },
              {
                'name': 'Muscle-Ups',
                'description':
                    'Combine a pull-up and a dip in this advanced upper body exercise. Pull yourself up and transition into a dip at the top.',
                'imageUrl':
                    'https://firebasestorage.googleapis.com/v0/b/homeworkout-7fe50.appspot.com/o/advanced%2FMuscle-Ups.webp?alt=media&token=fdc7f00b-cbf6-4eb0-b70b-d40665f38af9',
                'videoLink': 'https://www.youtube.com/watch?v=eEYfFTE2fKU',
              },
            ];

            for (int day = 1; day <= 30; day++) {
              // Shuffle the exercises independently for each day
              List<Map<String, String>> shuffledExercises =
                  List.from(advancedExercises);
              shuffledExercises.shuffle();

              await uploadExercisesForDay('Day $day', shuffledExercises);
            }
          },
          child: Text('Upload Exercises for 30 Days'),
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

      // Adding print statements for debugging
      print('Uploading Exercise ${i + 1} for $day:');
      print('Exercise Name: ${exercise['name']}');
      print('Video Link: ${exercise['videoLink']}');
      print('Description: ${exercise['description']}');
      print('Image URL: ${exercise['imageUrl']}');

      // Adding a null check for imageUrl
      final imageUrl = exercise['imageUrl'] ?? ''; // Provide a default empty string if null

      await FirebaseFirestore.instance
          .collection('Workout')
          .doc('Levels')
          .collection("advanced")
          .doc(day)
          .collection('ExercisesList')
          .doc('Exercise${i + 1}')
          .set({
        'exerciseName': exercise['name'],
        'videoLink': exercise['videoLink'],
        'description': exercise['description'],
        'imageUrl': imageUrl, // Using the imageUrl variable
      });

      print('Exercise ${i + 1} uploaded successfully for $day\n');
    }
    print('Exercises uploaded successfully for $day');
  } catch (e) {
    print('Error uploading exercises for $day: $e');
  }
}
