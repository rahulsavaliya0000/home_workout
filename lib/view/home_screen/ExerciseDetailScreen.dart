import 'dart:async';
import 'package:flutter/material.dart';
import 'package:home_workout/constants/button/scale_button.dart';
import 'package:home_workout/constants/colors/app_color.dart';
import 'package:home_workout/utils/provider/theme_provider.dart';
import 'package:home_workout/view/home_screen/video_page.dart';
import 'package:provider/provider.dart';

class ExerciseDetailScreen extends StatefulWidget {
  final String level;
  final String day;
  final List<Map<String, dynamic>> exercises;
  final int initialExerciseIndex;

  ExerciseDetailScreen({
    Key? key,
    required this.level,
    required this.day,
    required this.exercises,
    required this.initialExerciseIndex,
  }) : super(key: key);

  @override
  _ExerciseDetailScreenState createState() => _ExerciseDetailScreenState();
}

class _ExerciseDetailScreenState extends State<ExerciseDetailScreen> {
  late PageController _pageController;
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialExerciseIndex);
    currentPage = widget.initialExerciseIndex;
  }

  void goToNextExercise() {
    if (currentPage < widget.exercises.length - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void goToPreviousExercise() {
    if (currentPage > 0) {
      _pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: widget.exercises.length,
            onPageChanged: (index) {
              setState(() {
                currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return buildExercisePage(widget.exercises[index]);
            },
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TimerBar(),
                BottomBar(
                  goToPreviousExercise: goToPreviousExercise,
                  goToNextExercise: goToNextExercise,
                  exercise: widget.exercises[currentPage],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildExercisePage(Map<String, dynamic> exercise) {
    return SingleChildScrollView(
      child: Container(
        color: Provider.of<ThemeProvider>(context).isDarkMode
            ? AppColor.blackColor
            : null,
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 50),
                Center(
                  child: Text(
                    '${widget.level} - ${widget.day} ',
                    style: TextStyle(
                      fontSize: 24,
                      fontFamily: 'Quicksand',
                      fontWeight: FontWeight.w600,
                      color: AppColor.blueColor,
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * .03),
                Image.network(
                  exercise['imageUrl'] ??
                      'https://example.com/default_image.jpg',
                  height: 300,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Center(
                  child: Text(
                    '${exercise['exerciseName']}',
                    style: TextStyle(
                      fontSize: 24,
                      fontFamily: 'Quicksand',
                      fontWeight: FontWeight.w600,
                      color: AppColor.blueColor,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  '  Description :',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Quicksand',
                    fontWeight: FontWeight.w600,
                    color: AppColor.blueColor,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Text(
                    '${exercise['description']}',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Quicksand',
                      fontWeight: FontWeight.w600,
                      color: Provider.of<ThemeProvider>(context).isDarkMode
                          ? AppColor.whiteColor
                              .withOpacity(0.6) // Set text color for dark mode
                          : AppColor
                              .secondaryTextColor, // Set text color for light mode
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TimerBar extends StatefulWidget {
  @override
  _TimerBarState createState() => _TimerBarState();
}
class _TimerBarState extends State<TimerBar> {
  late Duration _currentDuration;
  late bool _isTimerRunning;
  late Timer? _timer; // Make sure to initialize it as nullable.

   @override
  void initState() {
    super.initState();
    _currentDuration = Duration(minutes: 3);
    _isTimerRunning = false;
  }

  void _startOrPauseTimer() {
    if (_isTimerRunning) {
      _timer?.cancel();
    } else {
      _timer = Timer.periodic(Duration(seconds: 1), _updateTimer);
    }

    setState(() {
      _isTimerRunning = !_isTimerRunning;
    });
  }

  void _restartTimer() {
    if (_isTimerRunning) {
      _timer?.cancel(); // Use the null-aware operator to check if _timer is not null.
    }

    setState(() {
      _currentDuration = Duration(minutes: 3);
      _isTimerRunning = false;
    });
  }

  void _updateTimer(Timer timer) {
    if (_currentDuration.inSeconds > 0) {
      setState(() {
        _currentDuration = _currentDuration - Duration(seconds: 1);
      });
    } else {
      _timer?.cancel();
      print('Timer ended');
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final minutes = _currentDuration.inMinutes;
    final seconds = _currentDuration.inSeconds % 60;

    return Container(
      color: themeProvider.isDarkMode ? Colors.black : Colors.white,
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            onPressed: _startOrPauseTimer,
            style: ElevatedButton.styleFrom(
              primary: themeProvider.isDarkMode ? Colors.black : Colors.white,
              onPrimary: AppColor.blueColor,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: BorderSide(
                  color: AppColor.blueColor,
                  width: 1,
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: Text(
              _isTimerRunning ? 'Pause Timer' : 'Start Timer',
              style: TextStyle(fontSize: 16),
            ),
          ),
          Text(
            '$minutes:$seconds',
            style: TextStyle(
              color: AppColor.blueColor,
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
          ElevatedButton(
            onPressed: _restartTimer,
            style: ElevatedButton.styleFrom(
              primary: themeProvider.isDarkMode ? Colors.black : Colors.white,
              onPrimary: AppColor.blueColor,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: BorderSide(
                  color: AppColor.blueColor,
                  width: 1,
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: Text(
              'Restart Timer',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}

class BottomBar extends StatelessWidget {
  final VoidCallback goToPreviousExercise;
  final VoidCallback goToNextExercise;
  final Map<String, dynamic> exercise;

  const BottomBar({
    Key? key,
    required this.goToPreviousExercise,
    required this.goToNextExercise,
    required this.exercise,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Container(
      color: themeProvider.isDarkMode ? Colors.black : Colors.white,
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          InkWell(
            onTap: goToPreviousExercise,
            child: Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                color: AppColor.blueColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColor.blackColor,
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: Offset(1, .8),
                    blurStyle: BlurStyle.inner,
                  ),
                ],
              ),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 27,
                color: themeProvider.isDarkMode ? Colors.white : Colors.white,
                shadows: [
                  Shadow(color: Colors.black, blurRadius: 10),
                ],
              ),
            ),
          ),
          Scale_button(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      VideoPage(videoUrl: exercise['videoLink']),
                ),
              );
            },
          ),
          InkWell(
            onTap: goToNextExercise,
            child: Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                color: AppColor.blueColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColor.blackColor,
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: Offset(.8, 1),
                    blurStyle: BlurStyle.inner,
                  ),
                ],
              ),
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                size: 27,
                color: themeProvider.isDarkMode ? Colors.white : Colors.white,
                shadows: [
                  Shadow(color: Colors.black, blurRadius: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
