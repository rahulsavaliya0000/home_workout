import 'package:flutter/material.dart';
import 'package:home_workout/constants/button/buttons.dart';
import 'package:home_workout/constants/colors/app_color.dart';
import 'package:home_workout/view/auth_ui/create_account.dart';

class onboarding_screen_one extends StatefulWidget {
  const onboarding_screen_one({super.key});

  @override
  State<onboarding_screen_one> createState() => _onboarding_screen_oneState();
}

class _onboarding_screen_oneState extends State<onboarding_screen_one> {

  int imageCounter = 0; // Counter to keep track of image changes

  void changeImage() async {
    if (mounted) {
      setState(() {
        imageCounter = (imageCounter + 1) % 3; // Cycle through 0 to 3
      });

      if (imageCounter == 2) {
        // Delay for 1 second before navigating to the next screen
        await Future.delayed(Duration(seconds: 1));

        // Check if the widget is still mounted before navigating
        if (mounted) {
          // Navigate to the next screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => CreateAccountPage(),
            ),
          );
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // Additional initialization if needed
  }

  @override
  void dispose() {
    // Dispose of any subscriptions or resources here
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.sizeOf(context).height;
    return Scaffold(
      backgroundColor: AppColor.blueColor,
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            bottom: screenHeight * 0.410,
            child: Stack(
              children: [
                Container(
                  height: 618,
                  width: 618,
                  decoration: BoxDecoration(
                      color: Colors.white, shape: BoxShape.circle),
                ),
                Positioned(
                  bottom: -200,
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Image.asset(
                    'assets/onboarding$imageCounter.png',
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: MediaQuery.sizeOf(context).height * .17,
            child: Text(
              'Great this\nillustration When\npassion fades, only\ntrue love lasts\nforever.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 23,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Positioned(
            bottom: MediaQuery.sizeOf(context).height * .07,
            child: CustomizeButton(
              color: AppColor.whiteColor,
              height: 50,
              width: 250,
              onPressed: changeImage,
              text: 'Get started',
              textcolor: AppColor.blueColor,
              fontfamily: '',
              fontweightt:  FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
