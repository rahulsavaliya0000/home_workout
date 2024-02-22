import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:home_workout/utils/provider/fitness_level.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class PrivacyScreen extends StatelessWidget {
  String mapLevelToText(int level) {
    switch (level) {
      case 1:
        return 'Beginner';
      case 2:
        return 'Intermediate';
      case 3:
        return 'Advanced';
      default:
        return 'Unknown';
    }
  }

  Future<void> _updateUserAge(String uid, int age) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'age': age,
      });
    } catch (error) {
      print('Error updating age: $error');
    }
  }

  int calculateAge(DateTime birthday) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthday.year;

    if (currentDate.month < birthday.month ||
        (currentDate.month == birthday.month &&
            currentDate.day < birthday.day)) {
      age--;
    }

    return age;
  }

  @override
  Widget build(BuildContext context) {
    int selectedFitnessLevel =
        context.watch<FitnessLevelProvider>().selectedLevel;

    final FirebaseAuth _auth = FirebaseAuth.instance;
    String uid = _auth.currentUser!.uid;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 60, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Text(
                  'Privacy Screen',
                  style: TextStyle(
                    fontSize: 23,
                    fontFamily: 'Quicksand',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 48), // Adjust as needed
              ],
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: Text(
                      'Your Selected Fitness Level',
                      style: TextStyle(
                        fontSize: 23,
                        fontFamily: 'Quicksand',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            mapLevelToText(selectedFitnessLevel),
                            style: TextStyle(
                              fontSize: 28,
                              color: Colors.blue,
                              fontFamily: 'Quicksand',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(),
                  FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('users')
                        .doc(uid)
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (!snapshot.hasData || !snapshot.data!.exists) {
                        return Text('User not found');
                      } else {
                        var userData =
                            snapshot.data!.data() as Map<String, dynamic>;

                        DateTime? birthday = userData['birthday'] != null
                            ? (userData['birthday'] as Timestamp).toDate()
                            : null;

                        int age = birthday != null
                            ? calculateAge(birthday)
                            : -1;

                        if (age != -1) {
                          _updateUserAge(uid, age);
                        }

                        return Column(
                          children: [
                            _buildUserData('Height:',
                                userData['height']?.toString() ?? 'N/A'),
                            Divider(),
                            _buildUserData('Weight:',
                                userData['weight']?.toString() ?? 'N/A'),
                            Divider(),
                            _buildUserData(
                              'Birthday Date:',
                              birthday != null
                                  ? DateFormat('yMMMd').format(birthday)
                                  : 'N/A',
                            ),
                            Divider(),
                            _buildUserData('Age:',
                                age != -1 ? age.toString() : 'N/A'),
                          ],
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserData(String label, String value) {
    return Container(
      height: 43,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 18,
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              color: Colors.blue,
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
