


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class delete_data extends StatefulWidget {
  @override
  _delete_dataState createState() => _delete_dataState();
}

class _delete_dataState extends State<delete_data> {
  final FirebaseManager _firebaseManager = FirebaseManager();

  @override
  void initState() {
    super.initState();
    _initializeFirebase();
  }

  Future<void> _initializeFirebase() async {
    await _firebaseManager.initializeFirebase();
  }

  Future<void> _deleteExercises() async {
    await _firebaseManager.deleteExercises();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My App'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            _deleteExercises();
          },
          child: Text('Delete Exercises'),
        ),
      ),
    );
  }
}

class FirebaseManager {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> initializeFirebase() async {
    await Firebase.initializeApp();
  }

  Future<void> deleteExercises() async {
    try {
      await _firestore.runTransaction((transaction) async {
        final levelsDocRef = _firestore.collection('Workout').doc('Levels');

        final QuerySnapshot levelsSnapshot =
            await levelsDocRef.collection('advanced').get();

        for (final QueryDocumentSnapshot dayDoc in levelsSnapshot.docs) {
          final exercisesCollection =
              dayDoc.reference.collection('Exercises');

          final QuerySnapshot exercisesSnapshot =
              await exercisesCollection.get();

          for (final QueryDocumentSnapshot exerciseDoc in exercisesSnapshot.docs) {
            await transaction.delete(exerciseDoc.reference);
          }
        }
      });
    } catch (e) {
      print('Error deleting exercises: $e');
    }
  }
}

