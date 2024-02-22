import 'package:flutter/material.dart';
import 'package:home_workout/Service/splash_service.dart';

class Splash_view extends StatefulWidget {
  @override
  _Splash_viewState createState() => _Splash_viewState();
}

class _Splash_viewState extends State<Splash_view> {
  SplashServices splashServices = SplashServices();

  @override
  void initState() {
    super.initState();
    // Using Future.delayed to execute the logic after the build is complete
    Future.delayed(Duration.zero, () {
      // Check if the widget is still mounted before accessing the context
      if (mounted) {
        splashServices.isLogin(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Image.asset(
        'assets/SplashScreen.png',
        fit: BoxFit.cover,
        width: MediaQuery.of(context).size.width,
      ),
    );
  }
}
