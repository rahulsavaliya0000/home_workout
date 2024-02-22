import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:home_workout/constants/custom_appbar/cliper.dart';
import 'package:home_workout/view/home_screen/ExerciseDetailScreen.dart';

class ExerciseScreen extends StatelessWidget {
  final String level;
  final String day;

  ExerciseScreen({required this.level, required this.day});

  static const Map<String, String> levelBackgroundImages = {
    'beginner':
        'https://th.bing.com/th?id=OIP.EwbatycHx_915hcNzd7vRgHaE8&w=306&h=204&c=8&rs=1&qlt=90&o=6&dpr=1.3&pid=3.1&rm=2',
    'intermediate':
        'https://th.bing.com/th?id=OIP.faTcei8217MQT8FXn_SXIQHaEK&w=333&h=187&c=8&rs=1&qlt=90&o=6&dpr=1.3&pid=3.1&rm=2',
    'advanced':
        'https://th.bing.com/th/id/OIP.XHITimhGQlRAOOjNO8au6wHaEo?w=278&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7',
    'cardio':
        'https://th.bing.com/th/id/OIP.NX414__4scth8qE76W8yFQHaEK?w=270&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7',
  };

  String getBackgroundImage() {
    return levelBackgroundImages[level] ??
        'https://example.com/default_background_image.jpg';
  }

  Future<List<Map<String, dynamic>>> fetchExercisesForDay(
      String level, String day) async {
    try {
      final exercisesSnapshot = await FirebaseFirestore.instance
          .collection('Workout')
          .doc('Levels')
          .collection(level)
          .doc(day)
          .collection('ExercisesList')
          .get();

      List<Map<String, dynamic>> exercises =
          exercisesSnapshot.docs.map((exerciseDoc) {
        var data = exerciseDoc.data();
        return {
          'exerciseName': data['exerciseName'] ?? 'Default Exercise Name',
          'videoLink':
              data['videoLink'] ?? 'https://example.com/default_video.mp4',
          'description': data['description'] ?? 'No description available.',
          'imageUrl':
              data['imageUrl'] ?? 'https://example.com/default_image.jpg',
        };
      }).toList();

      return exercises;
    } catch (e) {
      print('Error fetching exercises: $e');
      return [];
    }
  }

  double heightlevel() {
    return level == 'beginner' ? 150.0 : 160.0;
  }

  double getpositionHeight() {
    return level == 'beginner' ? 20.0 : 10.0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: FutureBuilder(
          future: fetchExercisesForDay(level, day),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              List<Map<String, dynamic>> exercises =
                  (snapshot.data as List<Map<String, dynamic>>?) ?? [];

              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: 150.0,
                    pinned: false,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Stack(
                        fit: StackFit.expand,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.blue.shade100,
                                  Colors.blue.shade200,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                stops: [0.0, 1.0],
                                tileMode: TileMode.clamp,
                              ),
                            ),
                          ),
                          ClipPath(
                            clipper: CircularClipper(),
                            child: Image.network(
                              getBackgroundImage(),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                      title: AnimatedOpacity(
                        duration: Duration(milliseconds: 500),
                        opacity: 1.0,
                        child: Text(
                          '$level - $day',
                          style: TextStyle(
                            fontSize: 24,
                            fontFamily: 'Quicksand',
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    automaticallyImplyLeading: false,
                  ),
                  SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        Map<String, dynamic> exercise = exercises[index];
                        return InkWell(
                           onTap: () {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        // Pass the selected exercise index to ExerciseDetailScreen
        int selectedExerciseIndex = index; // Assuming `index` is the index of the tapped exercise
        return ExerciseDetailScreen(
          level: level,
          day: day,
          exercises: exercises,
          initialExerciseIndex: selectedExerciseIndex,
        );
      },
    );
  },
                          child: Container(
                            height: 178,
                            width: 178,
                            margin: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.black54, width: 1),
                              borderRadius: BorderRadius.circular(13),
                            ),
                            child: Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(13),
                                  ),
                                ),
                                Positioned(
                                  top: getpositionHeight(),
                                  left: getpositionHeight(),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      exercise['imageUrl'] ??
                                          'https://example.com/default_image.jpg',
                                      fit: BoxFit.cover,
                                      width: heightlevel(),
                                      height: heightlevel(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      childCount: exercises.length,
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
