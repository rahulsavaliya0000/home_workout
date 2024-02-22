import 'package:flutter/material.dart';
import 'package:home_workout/constants/colors/app_color.dart';
import 'package:home_workout/view/steps/step_two.dart';

class step_one extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        // backgroundColor: AppColor.blueColor,
        title: Center(
          child: Text('Step 1 of 3',
              style: TextStyle(
                  color: AppColor.blueColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 25)),
        ),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: screenHeight * .009),
            Image.asset(
              'assets/start1.png', // Replace with the actual image path
              width: 209,
              height: 248,
              fit: BoxFit.cover,
            ),
            SizedBox(height: screenHeight * .039),
            Text(
              'Welcome to\nHomeworkout Application',
              style: TextStyle(
                  color: AppColor.blueColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 26),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: screenHeight * .015),
            Text(
              'Personalized workouts will help you\ngain strength, get in better shape, and\nembrace a healthy lifestyle',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            Expanded(child: SizedBox()),
            SizedBox(
              width: 220,
              height: 45,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StepTwo(),
                    ),
                  );
                },
                child: Text('Get Started',
                    style: TextStyle(
                        color: AppColor.blueColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 18)),
              ),
            ),
            // SizedBox(height: screenHeight * .1),
            Expanded(child: SizedBox()),
          ],
        ),
      ),
    );
  }
}
