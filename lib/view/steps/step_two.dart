import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:home_workout/constants/colors/app_color.dart';
import 'package:home_workout/utils/provider/fitness_level.dart';
import 'package:home_workout/view/steps/step_three.dart';
import 'package:provider/provider.dart';

class StepTwo extends StatefulWidget {
  @override
  _StepTwoState createState() => _StepTwoState();
}

class _StepTwoState extends State<StepTwo> {
  int selectedLevel = -1;

  void selectLevel(int level) {
    setState(() {
      selectedLevel = level;
    });
  }

  void onFitnessLevelSelected(int level) {
    if (selectedLevel != -1) {
      print('Selected Level: $level');
      // context.read<FitnessLevelProvider>().setFitnessLevel(level);
      // print(
          // 'Provider Level: ${context.read<FitnessLevelProvider>().selectedLevel}');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => StepThree(),
        ),
      );
    } else {
      Fluttertoast.showToast(
        msg: 'Please select a fitness level.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            'Step 2 of 3',
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Your Fitness Level:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            FitnessLevelOption(
              level: 1,
              title: 'Beginner',
              description: '  You are new to fitness training',
              isSelected: selectedLevel == 1,
              onSelect: selectLevel,
            ),
            FitnessLevelOption(
              level: 2,
              title: 'Intermediate',
              description: '  You have been training regularly',
              isSelected: selectedLevel == 2,
              onSelect: selectLevel,
            ),
            FitnessLevelOption(
              level: 3,
              title: 'Advanced',
              description:
                  '  You\'re fit and ready for an intensive \n  workout plan',
              isSelected: selectedLevel == 3,
              onSelect: selectLevel,
            ),
            SizedBox(height: 80),
            Center(
              child: SizedBox(
                width: 220,
                height: 48,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      AppColor.blueColor,
                    ),
                  ),
                  onPressed: () => onFitnessLevelSelected(selectedLevel),
                  child: Text(
                    'Next',
                    style: TextStyle(
                      color: AppColor.whiteColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FitnessLevelOption extends StatelessWidget {
  final int level;
  final String title;
  final String description;
  final bool isSelected;
  final Function(int) onSelect;

  FitnessLevelOption({
    required this.level,
    required this.title,
    required this.description,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onSelect(level);
      },
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColor.blueColor.withOpacity(.2) : null,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check,
                color: AppColor.blueColor,
              ),
          ],
        ),
      ),
    );
  }
}
