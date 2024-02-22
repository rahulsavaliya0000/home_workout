import 'package:flutter/material.dart';
import 'package:home_workout/constants/colors/app_color.dart';
import 'package:home_workout/utils/provider/theme_provider.dart';
import 'package:provider/provider.dart';

class FAQScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'FAQ Page',
          style: TextStyle(
            color:
                themeProvider.isDarkMode ? Colors.white : AppColor.blueColor,
            fontWeight: FontWeight.bold,
            fontFamily: 'Quicksand',
            fontSize: 22.0,
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          FAQCard(
            question: 'How can I start a home workout routine?',
            answer:
                'To start a home workout routine, begin by setting realistic goals, '
                'choosing exercises you enjoy, and creating a schedule. Start with '
                'short sessions and gradually increase intensity.',
          ),
          FAQCard(
            question: 'What equipment do I need for home workouts?',
            answer:
                'You can start with minimal equipment like resistance bands, dumbbells, '
                'or a yoga mat. Bodyweight exercises such as squats, push-ups, and lunges '
                'are also effective without equipment.',
          ),
          FAQCard(
            question: 'How often should I work out at home?',
            answer:
                'The frequency depends on your fitness goals. For general health, aim for '
                'at least 150 minutes of moderate-intensity exercise or 75 minutes of vigorous '
                'exercise per week. Include strength training 2-3 times a week.',
          ),
          FAQCard(
            question: 'Are home workouts effective for weight loss?',
            answer:
                'Yes, home workouts can be effective for weight loss when combined with '
                'a balanced diet. High-intensity interval training (HIIT) and strength training '
                'are particularly effective for burning calories and building muscle.',
          ),
          FAQCard(
            question: 'How do I stay motivated for home workouts?',
            answer:
                'Set specific goals, vary your workouts, find a workout buddy, and create '
                'a dedicated workout space at home. Celebrate small achievements to stay motivated.',
          ),
          FAQCard(
            question: 'Is it necessary to warm up before a home workout?',
            answer:
                'Yes, warming up is crucial to prepare your body for exercise and reduce '
                'the risk of injury. Include dynamic stretches and light aerobic exercises in your warm-up.',
          ),
          FAQCard(
            question: 'Can I build muscle with home workouts?',
            answer:
                'Yes, you can build muscle with home workouts by incorporating strength '
                'training exercises. Use resistance bands, dumbbells, or bodyweight exercises like '
                'push-ups and squats.',
          ),
          FAQCard(
            question: 'What are effective home exercises for abs?',
            answer:
                'Effective home exercises for abs include crunches, planks, leg raises, '
                'and bicycle crunches. Consistency is key to seeing results in your abdominal muscles.',
          ),
          FAQCard(
            question: 'How do I avoid overtraining with home workouts?',
            answer:
                'Avoid overtraining by incorporating rest days, listening to your body, '
                'and adjusting your workout intensity. Quality sleep and proper nutrition are also important.',
          ),
          FAQCard(
            question: 'Are online workout videos effective?',
            answer:
                'Yes, online workout videos can be effective for guided home workouts. '
                'Choose reputable fitness channels or platforms that offer a variety of workouts for all fitness levels.',
          ),
          FAQCard(
            question: 'Can I do home workouts with health conditions?',
            answer:
                'Consult with your healthcare provider before starting a home workout program '
                'if you have pre-existing health conditions. They can provide guidance on exercises suitable for your condition.',
          ),
          FAQCard(
            question: 'How long should a home workout session be?',
            answer:
                'The duration of a home workout session depends on your fitness level and '
                'goals. Aim for at least 30 minutes of moderate-intensity exercise most days of the week.',
          ),
          FAQCard(
            question: 'Is it better to do cardio or strength training at home?',
            answer:
                'Both cardio and strength training are important. Include a mix of both in your '
                'home workout routine for overall fitness. Cardio improves cardiovascular health, '
                'while strength training builds muscle and boosts metabolism.',
          ),
          FAQCard(
            question: 'What are effective home exercises for lower body?',
            answer:
                'Effective home exercises for the lower body include squats, lunges, '
                'glute bridges, and leg press exercises. These help strengthen the quadriceps, hamstrings, and glutes.',
          ),
          FAQCard(
            question: 'How can I track progress in my home workouts?',
            answer:
                'Track progress by keeping a workout journal, taking regular measurements, '
                'and assessing changes in strength and endurance. Celebrate achievements and set new goals.',
          ),
          FAQCard(
            question: 'Should I hire a personal trainer for home workouts?',
            answer:
                'Hiring a personal trainer for home workouts can provide personalized guidance '
                'and motivation. Consider online training sessions if an in-person trainer is not feasible.',
          ),
          FAQCard(
            question: 'Is it necessary to cool down after a home workout?',
            answer:
                'Yes, cooling down after a home workout is important to gradually lower '
                'your heart rate and prevent muscle stiffness. Include static stretches and deep breathing exercises.',
          ),
          FAQCard(
            question: 'What are good home exercises for improving flexibility?',
            answer:
                'Good home exercises for improving flexibility include yoga, Pilates, and static stretches. '
                'Incorporate these into your routine to enhance joint mobility and prevent injuries.',
          ),
          FAQCard(
            question: 'Can I do home workouts during pregnancy?',
            answer:
                'Yes, you can do home workouts during pregnancy, but consult with your healthcare '
                'provider first. Choose low-impact exercises, avoid lying flat on your back, and prioritize safety.',
          ),
          FAQCard(
            question: 'Are home workouts suitable for beginners?',
            answer:
                'Yes, home workouts are suitable for beginners. Start with beginner-friendly exercises '
                'and gradually progress. Follow instructional videos or consider hiring a certified fitness trainer for guidance.',
          ),
        ],
      ),
    );
  }
}

class FAQCard extends StatelessWidget {
  final String question;
  final String answer;

  FAQCard({required this.question, required this.answer});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      margin: EdgeInsets.all(12.0),
      color: Colors.white,
      child: ExpansionTile(
        leading: Icon(
          Icons.help_outline,
          color: themeProvider.isDarkMode ? Colors.black : AppColor.blueColor,
          size: 25,
          shadows: [
            Shadow(
              color: Colors.grey,
              blurRadius: 2,
              offset: Offset(0, .5),
            ),
          ],
          semanticLabel: 'Help Icon',
          textDirection: TextDirection.ltr,
        ),
        title: Text(
          question,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: themeProvider.isDarkMode ? Colors.black : AppColor.blueColor,
            fontSize: 16.0,
          ),
        ),
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              answer,
              style: TextStyle(
                color: Colors.blueGrey.shade800,
                fontSize: 16.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
