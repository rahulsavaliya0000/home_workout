import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:connectivity/connectivity.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home_workout/constants/button/buttons.dart';
import 'package:home_workout/constants/colors/app_color.dart';
import 'package:home_workout/firebase_options.dart';
import 'package:home_workout/utils/provider/auth_provider.dart';
import 'package:home_workout/utils/provider/fitness_level.dart';
import 'package:home_workout/utils/provider/ref_provider.dart';
import 'package:home_workout/utils/provider/theme_provider.dart';
import 'package:home_workout/view/splash_view/Splash_view.dart';
import 'package:provider/provider.dart';
 
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await AwesomeNotifications().initialize(null, [
    NotificationChannel(
        channelKey: "basic_channel",
        channelName: "Basic Notifications",
        channelDescription: "Test Notifications",
        channelGroupKey: 'Basic_channel_group')
  ], channelGroups: [
    NotificationChannelGroup(
        channelGroupKey: "Basic_channel_group", channelGroupName: "Basic Group")
  ]);


  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  bool isAllowedToNotification = await AwesomeNotifications().isNotificationAllowed();
  if(!isAllowedToNotification){
    print('it is worked');
    AwesomeNotifications().requestPermissionToSendNotifications();
  }

  runApp(DevicePreview(
    enabled: true,
    tools: const [
      ...DevicePreview.defaultTools,
    ],
    builder: (context) => MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => FitnessLevelProvider()),
        ChangeNotifierProvider(create: (context) => Auth_Provider()),
        ChangeNotifierProvider(create: (context) => RefProvider()),
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
          lazy: false,
        ),
      ],
      child: MyApp(),
    ),
  ));
}

class MyApp extends StatelessWidget {
  final Connectivity _connectivity = Connectivity();

  Future<bool> _checkConnectivity() async {
    final result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return FutureBuilder(
      future: _checkConnectivity(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        } else if (snapshot.hasError && snapshot.data!=null) {
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                        color: AppColor.blueColor,
                        backgroundColor: AppColor.whiteColor),
                    SizedBox(height: 20),
                    Text(
                      'No internet connection',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColor.blueColor, fontSize: 18),
                    ),
                  ],
                ),
              ),
              bottomNavigationBar: Padding(
                padding: EdgeInsets.symmetric(vertical: 29, horizontal: 60),
                child: CustomizeButton(
                  color: AppColor.blueColor,
                  textcolor: AppColor.whiteColor,
                  height: 45,
                  width: 20,
                  onPressed: () {
                    runApp(MyApp());
                  },
                  text: 'Restart the App',
                  fontfamily: 'Quicksand',
                  fontweightt: FontWeight.w600,
                ),
              ),
            ),
          );
        } else {
          return MaterialApp(
                theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      
            home: Splash_view(),
          );
        }
      },
    );
  }
}
