import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:animated_weight_picker/animated_weight_picker.dart';
import 'package:home_workout/constants/button/buttons.dart';
import 'package:home_workout/constants/colors/app_color.dart';
import 'package:home_workout/utils/provider/auth_provider.dart';
import 'package:home_workout/view/home_screen/home_screen.dart';
import 'package:home_workout/view/home_screen/home_two.dart';
import 'package:provider/provider.dart';

class HeightPickerContent extends StatefulWidget {
  final Function(String?) onHeightSelected;

  HeightPickerContent({required this.onHeightSelected});

  @override
  _HeightPickerContentState createState() => _HeightPickerContentState();
}

class _HeightPickerContentState extends State<HeightPickerContent> {
  String? tempSelectedValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: const Text(
              'Choose Height',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 20),
          AnimatedWeightPicker(
            suffixText: 'Height:',
            onChange: (newValue) {
              tempSelectedValue = newValue.toString();
            },
            min: 40,
            max: 200,
          ),
          SizedBox(height: 25),
          CustomizeButton(
              color: AppColor.blueColor,
              textcolor: AppColor.whiteColor,
              height: 45,
              width: 100,
              onPressed: () {
                widget.onHeightSelected(tempSelectedValue);
                Navigator.pop(context);
              },
              text: 'Done',
              fontfamily: 'Quicksand',
              fontweightt: FontWeight.w500)
        ],
      ),
    );
  }
}

class WeightPickerContent extends StatefulWidget {
  final Function(String?) onWeightSelected;

  WeightPickerContent({required this.onWeightSelected});

  @override
  _WeightPickerContentState createState() => _WeightPickerContentState();
}

class _WeightPickerContentState extends State<WeightPickerContent> {
  String? tempSelectedValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: const Text(
              'Choose Weight',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 20),
          AnimatedWeightPicker(
            suffixText: 'Weight:',
            onChange: (newValue) {
              tempSelectedValue = newValue.toString();
            },
            min: 20,
            max: 200,
          ),
          SizedBox(height: 25),
          CustomizeButton(
              color: AppColor.blueColor,
              textcolor: AppColor.whiteColor,
              height: 45,
              width: 100,
              onPressed: () {
                widget.onWeightSelected(tempSelectedValue);
                Navigator.pop(context);
              },
              text: 'Done',
              fontfamily: 'Quicksand',
              fontweightt: FontWeight.w500)
        ],
      ),
    );
  }
}

class BirthdayPickerContent extends StatefulWidget {
  final Function(DateTime?) onDateSelected;

  BirthdayPickerContent({required this.onDateSelected});

  @override
  _BirthdayPickerContentState createState() => _BirthdayPickerContentState();
}

class _BirthdayPickerContentState extends State<BirthdayPickerContent> {
  DateTime? tempSelectedDate;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: Column(
        children: [
          const SizedBox(
            height: 3,
          ),
          const Text(
            'Choose Birthday',
            style: TextStyle(
              color: AppColor.blueColor,
              fontSize: 20,
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              initialDateTime: DateTime.now(),
              onDateTimeChanged: (DateTime newDate) {
                tempSelectedDate = newDate;
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              widget.onDateSelected(tempSelectedDate);
              Navigator.pop(context);
            },
            child: const Text('Done'),
          ),
          const SizedBox(
            height: 3,
          ),
        ],
      ),
    );
  }
}

class StepThree extends StatefulWidget {
  @override
  _StepThreeState createState() => _StepThreeState();
}

class _StepThreeState extends State<StepThree> {
  String? selectedHeight;
  String? selectedWeight;
  DateTime? selectedDate;
  bool isAllDataSelected = false;

  Future<void> _showHeightPicker(BuildContext context) async {
    String? tempSelectedValue;

    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return HeightPickerContent(
          onHeightSelected: (value) {
            setState(() {
              tempSelectedValue = value;
            });
          },
        );
      },
    );

    if (tempSelectedValue != null) {
      setState(() {
        selectedHeight = tempSelectedValue;
      });
    }
  }

  Future<void> _showWeightPicker(BuildContext context) async {
    String? tempSelectedValue;

    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return WeightPickerContent(
          onWeightSelected: (value) {
            setState(() {
              tempSelectedValue = value;
            });
          },
        );
      },
    );

    if (tempSelectedValue != null) {
      setState(() {
        selectedWeight = tempSelectedValue;
      });
    }
  }

  Future<void> _showBirthdayPicker(BuildContext context) async {
    DateTime? tempSelectedDate;

    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return BirthdayPickerContent(
          onDateSelected: (date) {
            setState(() {
              tempSelectedDate = date;
            });
          },
        );
      },
    );

    if (tempSelectedDate != null) {
      setState(() {
        selectedDate = tempSelectedDate;
      });
    }
  }

  void _checkIfAllDataSelected() {
    if (selectedHeight != null && selectedWeight != null && selectedDate != null) {
      setState(() {
        isAllDataSelected = true;
      });
    } else {
      setState(() {
        isAllDataSelected = false;
      });
    }
  }

  Future<void> _updateHeight(double height) async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      print(uid);
      // Update user height in Firestore
      await FirebaseFirestore.instance.collection('users').doc(uid).update({'height': height});
    } catch (error) {
      print('Error updating height: $error');
      // Handle error as needed
    }
  }

  Future<void> _updateWeight(double weight) async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      // Update user weight in Firestore
      await FirebaseFirestore.instance.collection('users').doc(uid).update({'weight': weight});
    } catch (error) {
      print('Error updating weight: $error');
      // Handle error as needed
    }
  }

  Future<void> _updateBirthday(DateTime birthday) async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      // Update user birthday in Firestore
      await FirebaseFirestore.instance.collection('users').doc(uid).update({'birthday': birthday});
    } catch (error) {
      print('Error updating birthday: $error');
      // Handle error as needed
    }
  }

  Widget _buildHeightSection() {
    return Container(
      margin: const EdgeInsets.symmetric(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildRow(
            'Height:',
            _buildContent(
              selectedHeight ?? 'Choose Height',
              () {
                _showHeightPicker(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeightSection() {
    return Container(
      margin: const EdgeInsets.symmetric(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildRow(
            'Weight:',
            _buildContent(
              selectedWeight ?? 'Choose Weight',
              () {
                _showWeightPicker(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBirthdaySection() {
    return Container(
      margin: const EdgeInsets.symmetric(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildRow(
            'Birthday:',
            _buildContent(
              selectedDate == null
                  ? 'Choose Birthday'
                  : '${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}',
              () {
                _showBirthdayPicker(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(String label, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: () {
        onPressed();
        _checkIfAllDataSelected();
      },
      child: Text(label),
    );
  }

  Widget _buildRow(String label, Widget child) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 20,
              fontStyle: FontStyle.normal,
              color: Colors.blue,
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.w700,
            ),
          ),
          child,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Center(
          child: Text(
            'Step 3 of 3',
            style: TextStyle(
              color: AppColor.blueColor,
              fontWeight: FontWeight.w500,
              fontSize: 25,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            const Text(
              'Personal Details',
              style: TextStyle(
                color: AppColor.blueColor,
                fontWeight: FontWeight.w700,
                fontSize: 24,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              'Let us know about you to speed up the result, Get fit with your personal workout plan!',
              style: TextStyle(
                fontSize: 19,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            _buildBirthdaySection(),
            _buildHeightSection(),
            _buildWeightSection(),
            const SizedBox(height: 16),
            ElevatedButton(
               onPressed: () {
    final authProvider = Provider.of<Auth_Provider>(context, listen: false);

    double? height = double.tryParse(selectedHeight!);
    double? weight = double.tryParse(selectedWeight!);
    DateTime? birthday = selectedDate; // No need for type casting

    authProvider.setHeight(height ?? 0);
    authProvider.setWeight(weight ?? 0);
    authProvider.setBirthday(birthday!);

    authProvider.createUserProfile();
     Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Home_screen()),
                          );
  },
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                onPrimary: AppColor.blueColor,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: BorderSide(
                    color: AppColor.blueColor,
                    width: 1,
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              ),
              child: Text(
                'Next',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
