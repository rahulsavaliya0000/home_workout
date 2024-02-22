// import 'package:awesome_notifications/awesome_notifications.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:home_workout/constants/colors/app_color.dart';
// import 'package:home_workout/utils/provider/auth_provider.dart';
// import 'package:home_workout/utils/provider/fitness_level.dart';
// import 'package:home_workout/utils/provider/theme_provider.dart';
// import 'package:home_workout/view/home_screen/Exercise.dart';
// import 'package:home_workout/view/home_screen/gemini.dart';
// import 'package:home_workout/view/home_screen/profile_screen/profile_screen.dart';
// import 'package:provider/provider.dart';
// import 'package:animated_text_kit/animated_text_kit.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class Home_screen extends StatefulWidget {
//   @override
//   _Home_screenState createState() => _Home_screenState();
// }

// class _Home_screenState extends State<Home_screen>
//     with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
//   @override
//   bool get wantKeepAlive => true;
//   final controller = ScrollController();

//   List<String> days = [];

//   int streak = 1;

//   final FirebaseFirestore firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   DateTime? lastAppOpenDate;
//   Future<int> fetchStreak() async {
//     try {
//       String uid = _auth.currentUser!.uid;
//       DocumentReference userRef = firestore.collection('users').doc(uid);
//       DocumentSnapshot userSnapshot = await userRef.get();

//       bool fieldExists = userSnapshot.exists &&
//           (userSnapshot.data() as Map<String, dynamic>)
//               .containsKey('lastAppOpenDate');

//       if (!fieldExists) {
//         await userRef.update({
//           'lastAppOpenDate': FieldValue.serverTimestamp(),
//           'streak': streak,
//         });
//         lastAppOpenDate = DateTime.now();
//         print('Streak initialized successfully.');
//       } else {
//         lastAppOpenDate =
//             (userSnapshot.data() as Map<String, dynamic>)['lastAppOpenDate']
//                 .toDate();
//         streak = (userSnapshot.data() as Map<String, dynamic>)['streak'];
//       }

//       updateStreak(DateTime.now(), streak, lastAppOpenDate!);
//       return streak;
//     } catch (e) {
//       print('Error fetching streak: $e');
//       return 1;
//     }
//   }

//   Future<bool> updateStreak(
//       DateTime currentDate, int currentStreak, DateTime lastOpenDate) async {
//     try {
//       String uid = _auth.currentUser!.uid;
//       DocumentReference userRef = firestore.collection('users').doc(uid);

//       currentDate = DateTime.now();

//       bool isSameDate = currentDate.day == lastOpenDate.day;

//       if (isSameDate) {
//         print('Keeping streak due to the same calendar day...');
//         await userRef.update({'streak': currentStreak});
//         await Auth_Provider().updateS(currentStreak);

//         print('Streak maintained: $currentStreak');
//         return true;
//       } else {
//         if (currentDate.day == lastOpenDate.day + 1) {
//           print('Increasing streak due to the next calendar day...');
//           await userRef.update(
//               {'streak': currentStreak + 1, 'lastAppOpenDate': currentDate});
//           await Auth_Provider().updateSandU(currentStreak + 1, currentDate);
//           print('Streak increased to ${currentStreak + 1}');
//           return true;
//         } else {
//           print('Resetting streak due to a gap of more than 1 day...');
//           await userRef.update({'streak': 1, 'lastAppOpenDate': currentDate});
//           await Auth_Provider().updateSandU(1, currentDate);

//           print('Streak reset successfully.');
//           return false;
//         }
//       }
//     } catch (e) {
//       print('Error updating streak: $e');
//       return false;
//     }
//   }

//   Stream<int> streamStreakFromFirebase() {
//     String uid = _auth.currentUser!.uid;
//     Stream<DocumentSnapshot> stream =
//         firestore.collection('users').doc(uid).snapshots();

//     return stream.map((snapshot) {
//       if (snapshot.exists) {
//         return (snapshot.data() as Map<String, dynamic>)['streak'] ?? 0;
//       } else {
//         return 1;
//       }
//     });
//   }

//   void _scheduleDefaultNotifications() {
//     _scheduleNotification(6, 0, 'Good Morning!', 'Have a great day!');
//     _scheduleNotification(18, 0, 'Good Afternoon!', 'Enjoy your afternoon!');
//   }

//   void _scheduleNotification(int hour, int minute, String title, String body) {
//     AwesomeNotifications().createNotification(
//       content: NotificationContent(
//         id: hour * 60 + minute,
//         channelKey: 'basic_channel',
//         title: title,
//         body: body,
//         notificationLayout: NotificationLayout.Default,
//       ),
//       schedule: NotificationCalendar(
//         hour: hour,
//         minute: minute,
//         second: 0,
//         repeats: true,
//       ),
//     );
//   }

//   Widget buildAvatar() {
//     User? user = _auth.currentUser;
//     return StreamBuilder<DocumentSnapshot>(
//       stream: FirebaseFirestore.instance
//           .collection('users')
//           .doc(user!.uid)
//           .snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.hasData && snapshot.data!.data() != null) {
//           final url = snapshot.data!.get('photoUrl');
//           if (url != null) {
//             return CircleAvatar(
//               radius: 21,
//               backgroundImage: NetworkImage(url),
//             );
//           }
//         }
//         return Consumer<ThemeProvider>(
//           builder: (context, themeProvider, _) => Icon(
//             Icons.account_circle,
//             size: 41,
//             color: themeProvider.isDarkMode ? Colors.white : AppColor.blueColor,
//           ),
//         );
//       },
//     );
//   }

//   late ScrollController _scrollController;
//   late AnimationController _animationController;
//   late Animation<double> _animation;
//   final double _initialButtonWidth = 110.0;
//   final double _scrollingButtonWidth = 45.0;
//   final double _threshold = 100.0;

//   @override
//   void initState() {
//     super.initState();

//     _scrollController = ScrollController();
//     _animationController = AnimationController(
//       vsync: this,
//       duration: Duration(milliseconds: 300),
//     );

//     _animation = Tween<double>(
//       begin: _initialButtonWidth,
//       end: _scrollingButtonWidth,
//     ).animate(
//       CurvedAnimation(
//         parent: _animationController,
//         curve: Curves.easeInOut,
//       ),
//     );

//     _scrollController.addListener(_onScroll);
//     fetchStreak();

//     SharedPreferences.getInstance().then((prefs) {
//       bool areNotificationsScheduled =
//           prefs.getBool('areNotificationsScheduled') ?? false;

//       if (!areNotificationsScheduled) {
//         _scheduleDefaultNotifications();
//         prefs.setBool('areNotificationsScheduled', true);
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     _animationController.dispose();
//     super.dispose();
//   }

//   void _onScroll() {
//     double scrollDelta = _scrollController.position.pixels -
//         _scrollController.position.minScrollExtent;
//     double progress = scrollDelta / _threshold;

//     if (progress > 0.6) {
//       _animationController.forward();
//     } else {
//       _animationController.reverse();
//     }
//   }

//   Future<List<String>> fetchDaysFromFirestore(String level) async {
//     try {
//       final daysSnapshot = await FirebaseFirestore.instance
//           .collection('Workout')
//         .doc('Levels')
//           .collection(level)
//           .get();

//       List<String> days = daysSnapshot.docs.map((dayDoc) {
//         return dayDoc.id;
//       }).toList();

//       days.sort((a, b) =>
//           int.parse(a.substring(3)).compareTo(int.parse(b.substring(3))));

//       return days;
//     } catch (e) {
//       return [];
//     }
//   }

//   List<String> levels = ['beginner', 'intermediate', 'advanced', 'cardio'];

//   List<String> gymImages = [
//     'https://th.bing.com/th?id=OIP.EwbatycHx_915hcNzd7vRgHaE8&w=306&h=204&c=8&rs=1&qlt=90&o=6&dpr=1.3&pid=3.1&rm=2',
//     'https://th.bing.com/th?id=OIP.faTcei8217MQT8FXn_SXIQHaEK&w=333&h=187&c=8&rs=1&qlt=90&o=6&dpr=1.3&pid=3.1&rm=2',
//     'https://th.bing.com/th/id/OIP.XHITimhGQlRAOOjNO8au6wHaEo?w=278&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7',
//     'https://th.bing.com/th/id/OIP.NX414__4scth8qE76W8yFQHaEK?w=270&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7',
//   ];

//   @override
//   Widget build(BuildContext context) {
//     super.build(context);

    
//     int current = context.watch<FitnessLevelProvider>().selectedLevel;
//     List<bool> dataFetched = List.generate(levels.length, (index) => false);



    
//     Widget buildExerciseList(List<String> days) {
//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Consumer<ThemeProvider>(
//             builder: (context, themeProvider, _) {
//               return Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 child: Text(
//                   '${levels[current - 1]} Workouts',
//                   style: TextStyle(
//                     fontSize: 24,
//                     fontFamily: 'Quicksand',
//                     fontWeight: FontWeight.bold,
//                     color: themeProvider.isDarkMode
//                         ? Colors.white
//                         : AppColor.blueColor,
//                   ),
//                 ),
//               );
//             },
//           ),
//           SizedBox(height: 16),
//           Column(
//             children: days.map((day) {
//               return GestureDetector(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => ExerciseScreen(
//                         level: levels[current - 1],
//                         day: day,
//                       ),
//                     ),
//                   );
//                 },
//                 child: Container(
//                   margin: EdgeInsets.all(8),
//                   padding: EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     border: Border.all(
//                       color: Provider.of<ThemeProvider>(context).isDarkMode
//                           ? Colors.white.withOpacity(.7)
//                           : AppColor.blueColor,
//                       width: 2.0,
//                     ),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Provider.of<ThemeProvider>(context).isDarkMode
//                             ? Colors.white.withOpacity(.01)
//                             : AppColor.blueColor.withOpacity(.2),
//                       ),
//                     ],
//                     gradient: LinearGradient(
//                       colors: [Colors.white12, Colors.white12],
//                       begin: Alignment.topCenter,
//                       end: Alignment.bottomCenter,
//                     ),
//                     borderRadius: BorderRadius.circular(15),
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Consumer<ThemeProvider>(
//                         builder: (context, themeProvider, _) => Text(
//                           '  $day',
//                           style: TextStyle(
//                             color: themeProvider.isDarkMode
//                                 ? Colors.white
//                                 : AppColor.blueColor,
//                             fontFamily: 'Quicksand',
//                             fontSize: 20,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ),
//                       Icon(
//                         Icons.arrow_forward,
//                         color: Provider.of<ThemeProvider>(context).isDarkMode
//                             ? Colors.white.withOpacity(.9)
//                             : AppColor.blueColor,
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             }).toList(),
//           ),
//         ],
//       );
//     }

//     return Scaffold(
//       body: Stack(
//         children: [
//           Consumer<ThemeProvider>(
//             builder: (context, themeProvider, _) {
//               return themeProvider.isDarkMode
//                   ? Container(
//                       // Dark mode: Put your dark mode content here
//                       color: Colors.black.withOpacity(0.9),
//                     )
//                   : Container(
//                       decoration: BoxDecoration(
//                         image: DecorationImage(
//                           image: NetworkImage(
//                             'https://as1.ftcdn.net/v2/jpg/01/62/79/30/1000_F_162793029_LaUDuiMah7NnLSJ8Q2e7tCxfwZ6gigIt.jpg',
//                           ),
//                           fit: BoxFit.cover,
//                           colorFilter: ColorFilter.mode(
//                             Colors.black.withOpacity(0.6),
//                             BlendMode.dstATop,
//                           ),
//                         ),
//                       ),
//                     );
//             },
//           ),
//           SingleChildScrollView(
//             controller: _scrollController,
//             child: Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(right: 14, top: 40),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Stack(
//                         alignment: Alignment.center,
//                         children: [
//                           Container(
//                             height: 70,
//                             width: 75,
//                             child: Image.asset(
//                               'assets/fire.png',
//                             ),
//                           ),
//                           Positioned(
//                               bottom: 20,
//                               top: 26,
//                               child: StreamBuilder<int>(
//                                 stream: streamStreakFromFirebase(),
//                                 initialData: streak,
//                                 builder: (context, snapshot) {
//                                   if (snapshot.connectionState ==
//                                       ConnectionState.active) {
//                                     int streakFromFirebase =
//                                         snapshot.data ?? streak;
//                                     return AnimatedTextKit(
//                                       animatedTexts: [
//                                         ColorizeAnimatedText(
//                                           '$streakFromFirebase',
//                                           textStyle: TextStyle(
//                                             color: Provider.of<ThemeProvider>(
//                                                         context)
//                                                     .isDarkMode
//                                                 ? Colors.white
//                                                 : Colors.black,
//                                             fontSize: 21,
//                                             fontFamily: "Quicksand",
//                                             fontWeight: FontWeight.w900,
//                                           ),
//                                           colors: [
//                                             Colors.black,
//                                             Colors.black,
//                                                       ],
//                                         ),
//                                       ],
//                                       );
//                                   } else {
//                                     return Center(
//                                         child: CircularProgressIndicator());
//                                   }
//                                 },
//                               )),
//                         ],
//                       ),
//                       SizedBox(width: 10),
//                       AnimatedTextKit(
//                         animatedTexts: [
//                           ColorizeAnimatedText(
//                             'Home Workout',
//                             textStyle: const TextStyle(
//                               fontFamily: 'Quicksand',
//                               fontWeight: FontWeight.w700,
//                               fontSize: 25,
//                             ),
//                             colors: [
//                               AppColor.blueColor,
//                               Colors.orange,
//                               Colors.yellow,
//                               Colors.green,
//                               Colors.blue,
//                               Colors.purple,
//                             ],
//                           ),
//                         ],
//                         isRepeatingAnimation: true,
//                         repeatForever: true,
//                       ),
//                       SizedBox(width: 10),
//                       GestureDetector(
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => ProfileScreen(),
//                             ),
//                           );
//                         },
//                         child: buildAvatar(),
//                       )
//                     ],
//                   ),
//                 ),
//                 Container(
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: [
//                         Colors.white30,
//                         Colors.white12,
//                       ],
//                       begin: Alignment.topCenter,
//                       end: Alignment.bottomCenter,
//                     ),
//                     borderRadius: BorderRadius.circular(15),
//                   ),
//                   child: Container(
//                     width: MediaQuery.of(context).size.width,
//                     child: Row(
//                       children: [
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.stretch,
//                             children: [
//                               SizedBox(
//                                 height: 12,
//                               ),
//                               Align(
//                                 alignment: Alignment.center,
//                                 child: CarouselSlider(
//                                   items: gymImages.map((imageUrl) {
//                                     return Container(
//                                       margin:
//                                           EdgeInsets.symmetric(vertical: 10),
//                                       decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(20),
//                                         boxShadow: [
//                                           BoxShadow(
//                                             color: Colors.black26,
//                                             offset: Offset(2, 4),
//                                             blurRadius: 8.0,
//                                           ),
//                                         ],
//                                         image: DecorationImage(
//                                           image: NetworkImage(imageUrl),
//                                           fit: BoxFit.cover,
//                                         ),
//                                       ),
//                                     );
//                                   }).toList(),
//                                   options: CarouselOptions(
//                                     height: 230,
//                                     aspectRatio: 16 / 9,
//                                     viewportFraction: 0.8,
//                                     initialPage: 0,
//                                     enableInfiniteScroll: true,
                                    
//                                     reverse: false,
//                                     autoPlay: false,
//                                     autoPlayInterval: Duration(seconds: 3),
//                                     autoPlayAnimationDuration:
//                                         Duration(milliseconds: 800),
//                                     autoPlayCurve: Curves.fastOutSlowIn,
//                                     enlargeCenterPage: true,
//                                     scrollDirection: Axis.horizontal,
//                                     onPageChanged: (index, reason) {
//                                       context
//                                           .read<FitnessLevelProvider>()
//                                           .setFitnessLevel(index + 1);
//                                     },
//                                   ),
//                                 ),
//                               ),
//                               Consumer<ThemeProvider>(
//                                 builder: (context, themeProvider, _) {
//                                   return Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: levels.map((level) {
//                                       int index = levels.indexOf(level);
//                                       return Container(
//                                         width: 12.0,
//                                         height: 12.0,
//                                         margin: EdgeInsets.symmetric(
//                                             vertical: 8.0, horizontal: 4.0),
//                                         decoration: BoxDecoration(
//                                           shape: BoxShape.circle,
//                                           color: themeProvider.isDarkMode
//                                               ? Colors.white.withOpacity(
//                                                   current == index + 1
//                                                       ? 0.9
//                                                       : 0.4)
//                                               : Colors.blue[900]!.withOpacity(
//                                                   current == index + 1
//                                                       ? 0.9
//                                                       : 0.4),
//                                         ),
//                                       );
//                                     }).toList(),
//                                   );
//                                 },
//                               ),
//                               SizedBox(height: 20),
//                               FutureBuilder(
//                                 future:
//                                     fetchDaysFromFirestore(levels[current - 1]),
//                                 builder: (context, snapshot) {
//                                   if (!dataFetched[current - 1]) {
//                                     if (snapshot.connectionState ==
//                                         ConnectionState.waiting) {
//                                       return Center(
//                                           child: CircularProgressIndicator());
//                                     } else if (snapshot.hasError) {
//                                       return Center(
//                                           child:
//                                               Text('Error: ${snapshot.error}'));
//                                     } else {
//                                       dataFetched[current - 1] = true;
//                                       List<String> days =
//                                           snapshot.data as List<String>;
//                                       return buildExerciseList(days);
//                                     }
//                                   } else {
//                                     if (snapshot.connectionState ==
//                                         ConnectionState.waiting) {
//                                       return SizedBox();
//                                     } else if (snapshot.hasError) {
//                                       return Center(
//                                           child:
//                                               Text('Error: ${snapshot.error}'));
//                                     } else {
//                                       List<String> days =
//                                           snapshot.data as List<String>;
//                                       return buildExerciseList(days);
//                                     }
//                                   }
//                                 },
//                               )
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: AnimatedBuilder(
//         animation: _animation,
//         builder: (context, child) {
//           return Container(
//             width: _animation.value,
//             height: 49,
//             child: FloatingActionButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => ChatScreen()),
//                 );
//               },
//               child: Container(
//                 height: 49,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(16.0),
//                   color: AppColor.blueColor.withOpacity(.8),
//                 ),
//                 child: Row(
//                   children: [
//                     SizedBox(
//                       width: 10,
//                     ),
//                     Icon(
//                       Icons.headset_mic,
//                       size: 24,
//                       color: Colors.white,
//                     ),
//                     SizedBox(
//                       width: 2,
//                     ),
//                     Visibility(
//                       visible: _animationController.value < 0.01,
//                       child: Opacity(
//                         opacity: 1.0 - _animationController.value,
//                         child: Text(
//                           "Talk to Us",
//                           style: Theme.of(context)
//                               .textTheme
//                               .button
//                               ?.copyWith(color: Colors.white),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 8.0),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }


// // class TalkToUsButton extends StatefulWidget {
// //   final VoidCallback onPressed;
  
// //   final bool showText;

// //   const TalkToUsButton({super.key, required this.onPressed,
// //     required this.showText,});

// //   @override
// //   State<TalkToUsButton> createState() => _TalkToUsButtonState();
// // }

// // class _TalkToUsButtonState extends State<TalkToUsButton>
// //     with SingleTickerProviderStateMixin {
// //   late AnimationController _animationController;
// //   late Animation<double> _scaleAnimation;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _animationController = AnimationController(
// //       vsync: this,
// //       duration: const Duration(milliseconds: 300),
// //     );
// //     _scaleAnimation =
// //         Tween<double>(begin: 1.0, end: .75).animate(_animationController);
// //   }

// //   @override
// //   void dispose() {
// //     _animationController.dispose();
// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return AnimatedBuilder(
// //       animation: _animationController,
// //       builder: (context, child) {
// //         return GestureDetector(
// //           onTapDown: (_) => _animationController.forward(),
// //           onTapUp: (_) => _animationController.reverse(),
// //           onTap: widget.onPressed,
// //           child: Transform.scale(
// //             scale: _scaleAnimation.value,
// //             child: Container(
// //               decoration: BoxDecoration(
// //                 borderRadius: BorderRadius.circular(16.0),
// //                 color: AppColor.blueColor.withOpacity(.8),
// //                 boxShadow: [
// //                   BoxShadow(
// //                     color: Colors.black.withOpacity(0.5),
// //                     blurRadius: 4.0,
// //                     offset: Offset(0.0, 2.0),
// //                   ),
// //                 ],
// //               ),
// //               padding:
// //                   const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
// //               child: Row(
// //                 mainAxisSize: MainAxisSize.min,
// //                 children: [
// //                   Icon(
// //                     Icons.headset_mic,
// //                     color: Colors.white,
// //                     size: 24.0,
// //                   ),
// //                    SizedBox(width: 8.0),
// //                   Visibility(
// //                     visible: widget.showText,
// //                     child: Text(
// //                       "Talk to Us",
// //                       style: Theme.of(context)
// //                           .textTheme
// //                           .button
// //                           ?.copyWith(color: Colors.white),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ),
// //         );
// //       },
// //     );
// //   }
// // }
