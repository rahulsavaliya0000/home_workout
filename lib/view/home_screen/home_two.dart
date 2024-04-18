import 'dart:async';
import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:confetti/confetti.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:home_workout/constants/colors/app_color.dart';
import 'package:home_workout/utils/provider/auth_provider.dart';
import 'package:home_workout/utils/provider/fitness_level.dart';
import 'package:home_workout/utils/provider/theme_provider.dart';
import 'package:home_workout/view/home_screen/Exercise.dart';
import 'package:home_workout/view/home_screen/gemini.dart';
import 'package:home_workout/view/home_screen/profile_screen/profile_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home_screen extends StatefulWidget {
  @override
  _Home_screenState createState() => _Home_screenState();
}

class _Home_screenState extends State<Home_screen> with TickerProviderStateMixin {
  final TimeTracker _timeTracker = TimeTracker();

  late PageController _pageViewController;
  int _currentPage = 0;
  late PageController _listPageController;
  late ScrollController _singleChildScrollViewController;
  late AnimationController _animationController;
  late Animation<double> _animation;
  final double _initialButtonWidth = 110.0;
  final double _scrollingButtonWidth = 42.0;
  final double _threshold = 100.0;

  late ConfettiController _controllerBottomCenter;

  @override
  void initState() {
    super.initState();
    _pageViewController =
        PageController(initialPage: _currentPage, viewportFraction: 0.8);
    _listPageController = PageController();
    _singleChildScrollViewController = ScrollController();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    _animation = Tween<double>(
      begin: _initialButtonWidth,
      end: _scrollingButtonWidth,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _timeTracker.startTimer();

    initializeAudioPlayer();
    _controllerBottomCenter =
        ConfettiController(duration: const Duration(seconds: 6));
    _singleChildScrollViewController.addListener(_onScroll);
    fetchStreak();

    SharedPreferences.getInstance().then((prefs) {
      bool areNotificationsScheduled =
          prefs.getBool('areNotificationsScheduled') ?? false;

      if (!areNotificationsScheduled) {
        _scheduleDefaultNotifications();
        prefs.setBool('areNotificationsScheduled', true);
      }
    });
  }

  void _onScroll() {
    double scrollDelta = _singleChildScrollViewController.position.pixels -
        _singleChildScrollViewController.position.minScrollExtent;
    double progress = scrollDelta / _threshold;

    if (progress > 0.6) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  Future<List<String>> fetchDaysFromFirestore(String level) async {
    try {
      final daysSnapshot = await FirebaseFirestore.instance
          .collection('Workout')
          .doc('Levels')
          .collection(level)
          .get();

      List<String> days = daysSnapshot.docs.map((dayDoc) {
        return dayDoc.id;
      }).toList();

      days.sort((a, b) =>
          int.parse(a.substring(3)).compareTo(int.parse(b.substring(3))));

      return days;
    } catch (e) {
      return [];
    }
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  int streak = 1;

  Widget buildAvatar() {
    User? user = _auth.currentUser;
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.data() != null) {
          final url = snapshot.data!.get('photoUrl');
          if (url != null) {
            return CircleAvatar(
              radius: 21,
              backgroundImage: NetworkImage(url),
            );
          }
        }
        return Consumer<ThemeProvider>(
          builder: (context, themeProvider, _) => Icon(
            Icons.account_circle,
            size: 41,
            color: themeProvider.isDarkMode ? Colors.white : AppColor.blueColor,
          ),
        );
      },
    );
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<int> streamStreakFromFirebase() {
    String uid = _auth.currentUser!.uid;
    Stream<DocumentSnapshot> stream =
        firestore.collection('users').doc(uid).snapshots();

    return stream.map((snapshot) {
      if (snapshot.exists) {
        return (snapshot.data() as Map<String, dynamic>)['streak'] ?? 0;
      } else {
        return 1;
      }
    });
  }

  DateTime? lastAppOpenDate;
  Future<int> fetchStreak() async {
    try {
      String uid = _auth.currentUser!.uid;
      DocumentReference userRef = firestore.collection('users').doc(uid);
      DocumentSnapshot userSnapshot = await userRef.get();

      bool fieldExists = userSnapshot.exists &&
          (userSnapshot.data() as Map<String, dynamic>)
              .containsKey('lastAppOpenDate');

      if (!fieldExists) {
        await userRef.update({
          'lastAppOpenDate': FieldValue.serverTimestamp(),
          'streak': streak,
        });
        lastAppOpenDate = DateTime.now();
        print('Streak initialized successfully.');
      } else {
        lastAppOpenDate =
            (userSnapshot.data() as Map<String, dynamic>)['lastAppOpenDate']
                .toDate();
        streak = (userSnapshot.data() as Map<String, dynamic>)['streak'];
      }

      updateStreak(DateTime.now(), streak, lastAppOpenDate!);
      return streak;
    } catch (e) {
      print('Error fetching streak: $e');
      return 1;
    }
  }

  bool _userSwiped = false;
  Future<bool> updateStreak(
      DateTime currentDate, int currentStreak, DateTime lastOpenDate) async {
    try {
      String uid = _auth.currentUser!.uid;
      DocumentReference userRef = firestore.collection('users').doc(uid);

      currentDate = DateTime.now();

      bool isSameDate = currentDate.day == lastOpenDate.day;

      if (isSameDate) {
        print('Keeping streak due to the same calendar day...');
        await userRef.update({'streak': currentStreak});
        await Auth_Provider().updateS(currentStreak);

        print('Streak maintained: $currentStreak');
        return true;
      } else {
        if (currentDate.day == lastOpenDate.day + 1) {
          print('Increasing streak due to the next calendar day...');
          await userRef.update(
              {'streak': currentStreak + 1, 'lastAppOpenDate': currentDate});
          await Auth_Provider().updateSandU(currentStreak + 1, currentDate);
          print('Streak increased to ${currentStreak + 1}');
          return true;
        } else {
          print('Resetting streak due to a gap of more than 1 day...');
          await userRef.update({'streak': 1, 'lastAppOpenDate': currentDate});
          await Auth_Provider().updateSandU(1, currentDate);

          print('Streak reset successfully.');
          return false;
        }
      }
    } catch (e) {
      print('Error updating streak: $e');
      return false;
    }
  }

  List<String> levels = ['beginner', 'intermediate', 'advanced', 'cardio'];

  void _scheduleDefaultNotifications() {
    _scheduleNotification(6, 0, 'Good Morning!', 'Have a great day!');
    _scheduleNotification(18, 0, 'Good Afternoon!', 'Enjoy your afternoon!');
  }

  void _scheduleNotification(int hour, int minute, String title, String body) {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: hour * 60 + minute,
        channelKey: 'basic_channel',
        title: title,
        body: body,
        notificationLayout: NotificationLayout.Default,
      ),
      schedule: NotificationCalendar(
        hour: hour,
        minute: minute,
        second: 0,
        repeats: true,
      ),
    );
  }

  bool refreshing = false;

  // Simulating some data fetching
  Future<void> _refreshData() async {
    setState(() {
      refreshing = true;
    });

    await Future.delayed(Duration(seconds: 2)); // Simulate some async operation

    setState(() {
      refreshing = false;
    });
  }

  Future<void> initializeAudioPlayer() async {}

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime? startTime;
  final AudioPlayer _audioPlayer =
      AudioPlayer(); // Create an AudioPlayer instance
  final _audioAssetPath =
      'clane_whoa.mp3'; // Replace with your audio asset path

  void showCongratsPopup() {
    final themeProvider = Provider.of<ThemeProvider>(context);
    OverlayEntry? entry;
    if (!_userSwiped && _scaffoldKey.currentContext != null) {
      if (_scaffoldKey.currentContext != null) {
        entry = OverlayEntry(
          builder: (BuildContext context) => Stack(
            children: [
                Positioned.fill(
              child: Image.network(
                'https://wallpaperaccess.com/full/381931.jpg',
                fit: BoxFit.cover,
              ),
            ),
              AlertDialog(
                title: Text("Congratulations!",         style: TextStyle(
                          color: themeProvider.isDarkMode? AppColor.blackColor:AppColor.whiteColor,
                          fontFamily: 'Quicksand',
                          fontWeight: FontWeight.w700,
                          fontSize: 19),
               ),
                content: Text("You've spent 30 minutes in the app.",         style: TextStyle(
                          color: Colors.grey.shade400,
                          fontFamily: 'Quicksand',
                          fontWeight: FontWeight.w700,
                          fontSize: 18),
               ),
                actions: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: ConfettiWidget(
                      confettiController: _controllerBottomCenter,
                      blastDirection: -pi / 2,
                      emissionFrequency: 0.01,
                      maximumSize: const Size(40, 40),
                      numberOfParticles: 30,
                      maxBlastForce: 80,
                      blastDirectionality: BlastDirectionality.explosive,
                      minBlastForce: 50,
                      gravity: 1,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      entry
                          ?.remove(); // Remove the overlay when the dialog is closed
                    },
                    child: GestureDetector(
                        onTap: () {
                          entry?.remove(); // _controllerBottomCenter.play();
                        },
                        child: Text("Close",         style: TextStyle(
                          color: AppColor.redColor,
                          fontFamily: 'Quicksand',
                          fontWeight: FontWeight.w700,
                          fontSize: 19),
               )),
                  ),
                ],
              ),
            ],
          ),
        );

        // Insert the dialog overlay
        Overlay.of(_scaffoldKey.currentContext!)?.insert(entry);

        // Play the confetti animation after a short delay
        Future.delayed(Duration(milliseconds: 500), () async {
          _controllerBottomCenter.play();
          try {
            AssetSource audioSource = AssetSource(_audioAssetPath);
            _audioPlayer.play(audioSource);
          } catch (error) {
            // Handle audio playback error gracefully (e.g., log or display a message)
            print('Error playing audio: $error');
          } finally {
            // Optionally release resources when audio playback is complete
          }
        });
      } // Your existing code for showing the popup
    }

    _userSwiped = false;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
        stream: _timeTracker.timeStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            int minutesSpent = snapshot.data!;
            if (minutesSpent >= 30) {
              Future.microtask(() {
                showCongratsPopup();
              });
            }
          }
          return Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Provider.of<ThemeProvider>(context).isDarkMode
                  ? Colors.black // Dark mode color
                  : Colors.white,
              elevation: 0,
              title: Padding(
                padding: const EdgeInsets.only(right: 14, top: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          height: 70,
                          width: 75,
                          child: Image.asset(
                            'assets/fire.png',
                          ),
                        ),
                        Positioned(
                            bottom: 20,
                            top: 29,
                            child: StreamBuilder<int>(
                              stream: streamStreakFromFirebase(),
                              initialData: streak,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.active) {
                                  int streakFromFirebase =
                                      snapshot.data ?? streak;
                                  return Text(
                                    '$streakFromFirebase',
                                    style: TextStyle(
                                      color: Provider.of<ThemeProvider>(context)
                                              .isDarkMode
                                          ? Colors.black
                                          : Colors.black,
                                      fontSize: 21,
                                      fontFamily: "Quicksand",
                                      fontWeight: FontWeight.w900,
                                    ),
                                  );
                                } else {
                                  return Text(
                                    '$streak',
                                    style: TextStyle(
                                      color: Provider.of<ThemeProvider>(context)
                                              .isDarkMode
                                          ? Colors.black
                                          : Colors.black,
                                      fontSize: 21,
                                      fontFamily: "Quicksand",
                                      fontWeight: FontWeight.w900,
                                    ),
                                  );
                                }
                              },
                            )),
                      ],
                    ),
                    SizedBox(width: 10),
                    AnimatedTextKit(
                      animatedTexts: [
                        ColorizeAnimatedText(
                          'Home Workout',
                          textStyle: const TextStyle(
                            fontFamily: 'Quicksand',
                            fontWeight: FontWeight.w700,
                            fontSize: 25,
                          ),
                          colors: [
                            AppColor.blueColor,
                            Colors.orange,
                            Colors.yellow,
                            Colors.green,
                            Colors.blue,
                            Colors.purple,
                          ],
                        ),
                      ],
                      isRepeatingAnimation: true,
                      repeatForever: true,
                    ),
                    SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfileScreen(),
                          ),
                        );
                      },
                      child: buildAvatar(),
                    )
                  ],
                ),
              ),
            ),
            body: Stack(
              children: [
                Consumer<ThemeProvider>(
                  builder: (context, themeProvider, _) {
                    return themeProvider.isDarkMode
                        ? Container(
                            // Dark mode: Put your dark mode content here
                            color: Colors.black.withOpacity(0.9),
                          )
                        : Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(
                                  'https://as1.ftcdn.net/v2/jpg/01/62/79/30/1000_F_162793029_LaUDuiMah7NnLSJ8Q2e7tCxfwZ6gigIt.jpg',
                                ),
                                fit: BoxFit.cover,
                                colorFilter: ColorFilter.mode(
                                  Colors.black.withOpacity(0.6),
                                  BlendMode.dstATop,
                                ),
                              ),
                            ),
                          );
                  },
                ),
                PageView.builder(
                  // controller: _pageViewController,
                  onPageChanged: (int page) {
                    setState(() {
                      _currentPage = page;
                      _userSwiped = true;
                    });
                  },
                  itemCount: 4,
                  itemBuilder: (BuildContext context, int index) {
                    List<String> gymImages = [
                      'https://th.bing.com/th?id=OIP.EwbatycHx_915hcNzd7vRgHaE8&w=306&h=204&c=8&rs=1&qlt=90&o=6&dpr=1.3&pid=3.1&rm=2',
                      'https://th.bing.com/th?id=OIP.faTcei8217MQT8FXn_SXIQHaEK&w=333&h=187&c=8&rs=1&qlt=90&o=6&dpr=1.3&pid=3.1&rm=2',
                      'https://th.bing.com/th/id/OIP.XHITimhGQlRAOOjNO8au6wHaEo?w=278&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7',
                      'https://th.bing.com/th/id/OIP.NX414__4scth8qE76W8yFQHaEK?w=270&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7',
                    ];
                    return Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: RefreshIndicator(
                        onRefresh: _refreshData,
                        child: SingleChildScrollView(
                          controller: _singleChildScrollViewController,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: double.infinity, // width as needed
                                height: MediaQuery.of(context).size.height *
                                    0.25, // height as neded

                                child: CarouselSlider(
                                  items:
                                      _buildImageCarousel([gymImages[index]]),
                                  options: CarouselOptions(
                                    viewportFraction: 0.8,
                                    enableInfiniteScroll: false,
                                    enlargeCenterPage: true,
                                    // Enlarge the center page
                                    onPageChanged: (index, reason) {
                                      context
                                          .read<FitnessLevelProvider>()
                                          .setFitnessLevel(index + 1);

                                      setState(() {
                                        _currentPage = index;
                                      });

                                      _listPageController.animateToPage(index,
                                          duration: Duration(milliseconds: 300),
                                          curve: Curves.ease);
                                    },
                                  ),
                                ),
                              ),
                              Consumer<FitnessLevelProvider>(
                                builder: (context, fitnessProvider, _) {
                                  return PageDots(
                                      currentPage: _currentPage + 1);
                                },
                              ),
                              ListFromFirebase(
                                level: getLevelName(index),
                                fetchDaysFromFirestore: fetchDaysFromFirestore,
                                pageController: _listPageController,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            floatingActionButton: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return SizedBox(
                  width: _animation.value,
                  height: 49,
                  child: FloatingActionButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ChatScreen()),
                      );
                    },
                    backgroundColor: AppColor.blueColor.withOpacity(.8),
                    child: Row(
                      children: [
                        SizedBox(width: 10),
                        Icon(
                          Icons.headset_mic,
                          size: 24,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 5.0),
                        Visibility(
                          visible: _animationController.value < 0.01,
                          child: Text(
                            "Talk to Us",
                            style: Theme.of(context)
                                .textTheme
                                .button
                                ?.copyWith(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        });
  }

  List<Widget> _buildImageCarousel(List<String> imageUrls) {
    return imageUrls.map((imageUrl) {
      return Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(2, 4),
              blurRadius: 8.0,
            ),
          ],
        ),
        width:
            MediaQuery.of(context).size.width * 0.8, // Adjust width as needed
        height:
            MediaQuery.of(context).size.height * 0.6, // Adjust height as needed
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      );
    }).toList();
  }

  String getLevelName(int index) {
    switch (index) {
      case 0:
        return 'beginner';
      case 1:
        return 'intermediate';
      case 2:
        return 'advanced';
      case 3:
        return 'cardio';
      default:
        return '';
    }
  }

  @override
  void dispose() {
    _timeTracker.dispose();
    _controllerBottomCenter.dispose();
    _singleChildScrollViewController.dispose();
    _animationController.dispose();
    super.dispose();
  }
}

class PageDots extends StatelessWidget {
  final int currentPage;

  const PageDots({required this.currentPage});

  @override
  Widget build(BuildContext context) {
    List<String> levels = ['beginner', 'intermediate', 'advanced', 'cardio'];
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: levels.map((level) {
            int dotIndex = levels.indexOf(level) + 1;
            return Container(
              width: 12.0,
              height: 12.0,
              margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: dotIndex == currentPage
                    ? themeProvider.isDarkMode
                        ? Colors.white.withOpacity(0.9)
                        : Colors.blue[900]!.withOpacity(0.9)
                    : themeProvider.isDarkMode
                        ? Colors.white.withOpacity(0.4)
                        : Colors.blue[900]!.withOpacity(0.4),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class ListFromFirebase extends StatefulWidget {
  final String level;

  final Future<List<String>> Function(String) fetchDaysFromFirestore;
  final PageController pageController;

  const ListFromFirebase({
    Key? key,
    required this.level,
    required this.fetchDaysFromFirestore,
    required this.pageController,
  }) : super(key: key);

  @override
  _ListFromFirebaseState createState() => _ListFromFirebaseState();
}

class _ListFromFirebaseState extends State<ListFromFirebase>
    with AutomaticKeepAliveClientMixin {
  late Future<List<String>> _future;

  @override
  void initState() {
    super.initState();
    _future = widget.fetchDaysFromFirestore(widget.level);
  }

  @override
  Widget build(BuildContext context) {
    super
        .build(context); // Ensure that AutomaticKeepAliveClientMixin is applied
    return FutureBuilder<List<String>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          List<String> days = snapshot.data!;
          return Container(
            color: Colors.transparent,
            height: 2435, // Set an appropriate height
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              itemCount: days.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    children: days.map((day) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ExerciseScreen(
                                level: widget.level,
                                day: day,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.all(8),
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(
                              color:
                                  Provider.of<ThemeProvider>(context).isDarkMode
                                      ? Colors.white.withOpacity(.7)
                                      : AppColor.blueColor,
                              width: 2.0,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Provider.of<ThemeProvider>(context)
                                        .isDarkMode
                                    ? Colors.white.withOpacity(.01)
                                    : AppColor.blueColor.withOpacity(.2),
                              ),
                            ],
                            gradient: LinearGradient(
                              colors: [Colors.white12, Colors.white12],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Consumer<ThemeProvider>(
                                builder: (context, themeProvider, _) => Text(
                                  '  $day',
                                  style: TextStyle(
                                    color: themeProvider.isDarkMode
                                        ? Colors.white
                                        : AppColor.blueColor,
                                    fontFamily: 'Quicksand',
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward,
                                color: Provider.of<ThemeProvider>(context)
                                        .isDarkMode
                                    ? Colors.white.withOpacity(.9)
                                    : AppColor.blueColor,
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class TimeTracker {
  final StreamController<int> _timeStreamController = StreamController<int>();
  Stream<int> get timeStream => _timeStreamController.stream;

  DateTime? _startTime;

  void startTimer() {
    _startTime = DateTime.now();
    _timeStreamController.add(0); // Initial value
    _updateTimer();
  }

  void _updateTimer() {
    Timer.periodic(Duration(minutes: 1), (timer) {
      if (_startTime != null) {
        DateTime currentTime = DateTime.now();
        Duration timeSpent = currentTime.difference(_startTime!);
        int minutesSpent = timeSpent.inMinutes;
        _timeStreamController.add(minutesSpent);

        if (minutesSpent >= 30) {
          timer.cancel();
        }
      }
    });
  }

  void dispose() {
    _timeStreamController.close();
  }
}
