import 'package:flutter/material.dart';
import 'package:home_workout/constants/colors/app_color.dart';
import 'package:home_workout/utils/provider/theme_provider.dart';
import 'package:provider/provider.dart';

class CalorieCalculatorScreen extends StatefulWidget {
  @override
  _CalorieCalculatorScreenState createState() =>
      _CalorieCalculatorScreenState();
}

class _CalorieCalculatorScreenState extends State<CalorieCalculatorScreen> {
  TextEditingController ageController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController intensityController = TextEditingController();

  String selectedGender = 'Male';
  String selectedActivityLevel = 'Sedentary'; // Default activity level

  double calculateCalories() {
    double age = double.tryParse(ageController.text) ?? 0.0;
    double weight = double.tryParse(weightController.text) ?? 0.0;
    double height = double.tryParse(heightController.text) ?? 0.0;
    double intensity = double.tryParse(intensityController.text) ?? 0.0;

    double bmr = (selectedGender == 'Male')
        ? 88.362 + (13.397 * weight) + (4.799 * height) - (5.677 * age)
        : 447.593 + (9.247 * weight) + (3.098 * height) - (4.330 * age);

    double tdee = bmr * getActivityLevelFactor(selectedActivityLevel);

    return tdee * (intensity / 10);
  }

  double getActivityLevelFactor(String level) {
    switch (level) {
      case 'Sedentary':
        return 1.2;
      case 'Lightly Active':
        return 1.375;
      case 'Moderately Active':
        return 1.55;
      case 'Very Active':
        return 1.725;
      case 'Extremely Active':
        return 1.9;
      default:
        return 1.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar:AppBar(
  title: Text(
    'Calorie Calculator',
    style: TextStyle(
      color: themeProvider.isDarkMode ? Colors.white : AppColor.blueColor,
      fontWeight: FontWeight.bold,
      fontFamily: 'Quicksand',
      fontSize: 22.0,
    ),
  ),
  centerTitle: true,
  actions: [
    IconButton(
      icon: Icon(Icons.fastfood_rounded), // Use any food-related icon you prefer
      color: themeProvider.isDarkMode ? Colors.white : AppColor.blueColor,
      onPressed: () {

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                // builder: (context) => StepDashboard()),
                                builder: (context) => FoodSearchScreen()),
                          );
                        
      },
    ),
  ],
)
,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButton<String>(
                items: ['Male', 'Female'].map((gender) {
                  return DropdownMenuItem(value: gender, child: Text(gender));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedGender = value!;
                  });
                },
                value: selectedGender,
                hint: Text('Select Gender'),
                style: TextStyle(
                  color: themeProvider.isDarkMode
                      ? Colors.white
                      : AppColor.blueColor,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Quicksand',
                  fontSize: 20.0,
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: ageController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Age',
                  labelStyle: TextStyle(
                    fontSize: 15,
                    color: Color(0xff999999),
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Montserrat',
                  ),
                  fillColor: Colors.transparent,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 27, horizontal: 16),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white38),
                    borderRadius: BorderRadius.all(Radius.circular(22)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColor.blueColor),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: weightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Weight (kg)',
                  labelStyle: TextStyle(
                    fontSize: 15,
                    color: Color(0xff999999),
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Montserrat',
                  ),
                  fillColor: Colors.transparent,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 27, horizontal: 16),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white38),
                    borderRadius: BorderRadius.all(Radius.circular(22)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColor.blueColor),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: heightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Height (cm)',
                  labelStyle: TextStyle(
                    fontSize: 15,
                    color: Color(0xff999999),
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Montserrat',
                  ),
                  fillColor: Colors.transparent,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 27, horizontal: 16),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white38),
                    borderRadius: BorderRadius.all(Radius.circular(22)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColor.blueColor),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              DropdownButton<String>(
                items: [
                  'Sedentary',
                  'Lightly Active',
                  'Moderately Active',
                  'Very Active',
                  'Extremely Active',
                ].map((activityLevel) {
                  return DropdownMenuItem(
                      value: activityLevel, child: Text(activityLevel));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedActivityLevel = value!;
                  });
                },
                value: selectedActivityLevel,
                hint: Text('Select Activity Level'),
                style: TextStyle(
                  color: themeProvider.isDarkMode
                      ? Colors.white
                      : AppColor.blueColor,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Quicksand',
                  fontSize: 20.0,
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: intensityController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Intensity (1-10)',
                  labelStyle: TextStyle(
                    fontSize: 15,
                    color: Color(0xff999999),
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Montserrat',
                  ),
                  fillColor: Colors.transparent,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 27, horizontal: 16),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white38),
                    borderRadius: BorderRadius.all(Radius.circular(22)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColor.blueColor),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (ageController.text.isEmpty ||
                      weightController.text.isEmpty ||
                      heightController.text.isEmpty ||
                      intensityController.text.isEmpty) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Error'),
                        content:
                            Text('Please enter valid values for all fields.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('OK'),
                          ),
                        ],
                      ),
                    );
                  } else {
                    double calories = calculateCalories();
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Calories Burned'),
                        content: Text('You burned $calories calories.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('OK'),
                          ),
                        ],
                      ),
                    );
                  }
                },
                child: Text(
                  'Calculate Calories',
                  style: TextStyle(
                    color: themeProvider.isDarkMode
                        ? Colors.white
                        : AppColor.blueColor,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Quicksand',
                    fontSize: 18.0,
                  ),
                ),
              ),
             Padding(
  padding: const EdgeInsets.all(5.0),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      GestureDetector(
          onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                // builder: (context) => StepDashboard()),
                                builder: (context) => FoodSearchScreen()),
                          );
                        },
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: themeProvider.isDarkMode ? Colors.white : Colors.grey,
                width: 1.0, // Adjust the width of the underline as needed
              ),
            ),
          ),
          child: Text(
            'Explore Food items',
            style: TextStyle(
              color: themeProvider.isDarkMode ? Colors.white : Colors.grey,
              fontWeight: FontWeight.w600,
              fontFamily: 'Quicksand',
              fontSize: 14.0,
            ),
          ),
        ),
      ),
    ],
  ),
)

            ],
          ),
        ),
      ),
    );
  }
}
class FoodItem {
  final String name;
  final int calories;
  final double carbs;
  final double fat;
  final double protein;

  FoodItem({
    required this.name,
    required this.calories,
    required this.carbs,
    required this.fat,
    required this.protein,
  });
}

class FoodSearchScreen extends StatefulWidget {
  @override
  _FoodSearchScreenState createState() => _FoodSearchScreenState();
}

class _FoodSearchScreenState extends State<FoodSearchScreen> {
  List<FoodItem> allFoodItems = [
     FoodItem(name: 'Avocado', calories: 120, carbs: 6, fat: 10, protein: 2),
  FoodItem(name: 'Blueberries', calories: 84, carbs: 21, fat: 0.5, protein: 1),
  FoodItem(name: 'Cauliflower Rice', calories: 25, carbs: 5, fat: 0.3, protein: 2),
  FoodItem(name: 'Greek Yogurt', calories: 100, carbs: 7, fat: 5, protein: 10),
  FoodItem(name: 'Green Tea', calories: 0, carbs: 0, fat: 0, protein: 0),
  FoodItem(name: 'Oatmeal', calories: 150, carbs: 27, fat: 2.5, protein: 5),
  FoodItem(name: 'Lentils', calories: 230, carbs: 40, fat: 0.8, protein: 18),
  FoodItem(name: 'Turkey Sandwich', calories: 300, carbs: 40, fat: 8, protein: 20),
  FoodItem(name: 'Bell Peppers', calories: 30, carbs: 7, fat: 0.3, protein: 1),
  FoodItem(name: 'Eggs', calories: 70, carbs: 1, fat: 5, protein: 6),
  FoodItem(name: 'Zucchini', calories: 20, carbs: 4, fat: 0.2, protein: 1),
  FoodItem(name: 'Honey', calories: 64, carbs: 17, fat: 0, protein: 0.1),
  FoodItem(name: 'Walnuts', calories: 185, carbs: 4, fat: 18, protein: 4),
  FoodItem(name: 'Cucumber', calories: 16, carbs: 4, fat: 0.1, protein: 1),
  FoodItem(name: 'Quinoa', calories: 120, carbs: 21, fat: 2, protein: 4),
  FoodItem(name: 'Peaches', calories: 60, carbs: 15, fat: 0.4, protein: 1),
  FoodItem(name: 'Chickpeas', calories: 210, carbs: 35, fat: 3.5, protein: 11),
  FoodItem(name: 'Papaya', calories: 59, carbs: 15, fat: 0.4, protein: 0.5),
  FoodItem(name: 'Cheese', calories: 110, carbs: 1, fat: 9, protein: 7),
  FoodItem(name: 'Cottage Pie', calories: 350, carbs: 25, fat: 18, protein: 20),
   FoodItem(name: 'Pineapple', calories: 80, carbs: 22, fat: 0.1, protein: 0.5),
  FoodItem(name: 'Salmon', calories: 200, carbs: 0, fat: 13, protein: 22),
  FoodItem(name: 'Quinoa Salad', calories: 180, carbs: 30, fat: 5, protein: 8),
  FoodItem(name: 'Almonds', calories: 160, carbs: 6, fat: 14, protein: 6),
  FoodItem(name: 'Sweet Potato', calories: 112, carbs: 26, fat: 0.2, protein: 2),
  FoodItem(name: 'Pasta Primavera', calories: 250, carbs: 45, fat: 7, protein: 10),
  FoodItem(name: 'Spinach', calories: 23, carbs: 3, fat: 0.4, protein: 2),
  FoodItem(name: 'Hummus', calories: 70, carbs: 6, fat: 5, protein: 2),
  FoodItem(name: 'Mango', calories: 60, carbs: 15, fat: 0.4, protein: 0.8),
  FoodItem(name: 'Cottage Cheese', calories: 210, carbs: 6, fat: 10, protein: 25),
  FoodItem(name: 'Rice Cake', calories: 35, carbs: 7, fat: 0.3, protein: 0.7),
  FoodItem(name: 'Chicken Caesar Salad', calories: 350, carbs: 10, fat: 20, protein: 30),
  FoodItem(name: 'Peanut Butter', calories: 94, carbs: 3, fat: 8, protein: 4),
  FoodItem(name: 'Broccoli', calories: 55, carbs: 11, fat: 0.6, protein: 3),
  FoodItem(name: 'Cherry Tomatoes', calories: 22, carbs: 5, fat: 0.2, protein: 1),
  FoodItem(name: 'Tuna Salad', calories: 180, carbs: 5, fat: 12, protein: 15),
  FoodItem(name: 'Oranges', calories: 62, carbs: 15, fat: 0.2, protein: 1.2),
  FoodItem(name: 'Black Beans', calories: 120, carbs: 22, fat: 0.5, protein: 7),
  FoodItem(name: 'Soy Milk', calories: 80, carbs: 4, fat: 4, protein: 8),
  FoodItem(name: 'Pumpkin Seeds', calories: 180, carbs: 5, fat: 14, protein: 10),FoodItem(name: 'Apple', calories: 52, carbs: 14, fat: 0.2, protein: 0.3),
  FoodItem(name: 'Banana', calories: 105, carbs: 27, fat: 0.3, protein: 1.3),
  FoodItem(name: 'Carrot', calories: 41, carbs: 10, fat: 0.2, protein: 1),
  FoodItem(name: 'Oatmeal', calories: 150, carbs: 27, fat: 3, protein: 5),
  FoodItem(name: 'Greek Yogurt', calories: 100, carbs: 10, fat: 2, protein: 15),
  FoodItem(name: 'Avocado', calories: 160, carbs: 9, fat: 15, protein: 2),
  FoodItem(name: 'Blueberries', calories: 50, carbs: 12, fat: 0, protein: 1),
  FoodItem(name: 'Turkey Sandwich', calories: 250, carbs: 30, fat: 8, protein: 20),
  FoodItem(name: 'Egg Salad', calories: 180, carbs: 5, fat: 14, protein: 8),
  FoodItem(name: 'Shrimp', calories: 90, carbs: 1, fat: 1, protein: 18),
  FoodItem(name: 'Chia Seeds', calories: 70, carbs: 8, fat: 4, protein: 3),
  FoodItem(name: 'Beef Stir Fry', calories: 300, carbs: 20, fat: 15, protein: 25),
  FoodItem(name: 'Cucumber Slices', calories: 10, carbs: 2, fat: 0, protein: 0.5),FoodItem(name: 'Salmon', calories: 206, carbs: 0, fat: 13, protein: 22),
  FoodItem(name: 'Spinach', calories: 23, carbs: 3.6, fat: 0.4, protein: 2.9),
  FoodItem(name: 'Almonds', calories: 207, carbs: 7, fat: 18, protein: 7),
  FoodItem(name: 'Pineapple', calories: 50, carbs: 13, fat: 0.1, protein: 0.5),
  FoodItem(name: 'Brown Rice', calories: 215, carbs: 45, fat: 1.6, protein: 5),
  FoodItem(name: 'Chicken Breast', calories: 165, carbs: 0, fat: 3.6, protein: 31),
  FoodItem(name: 'Sweet Potato', calories: 112, carbs: 26, fat: 0.1, protein: 2),
  FoodItem(name: 'Broccoli', calories: 55, carbs: 11, fat: 0.6, protein: 3.7),
  FoodItem(name: 'Cherries', calories: 50, carbs: 12, fat: 0.3, protein: 1),
  FoodItem(name: 'Peanut Butter', calories: 94, carbs: 3.1, fat: 8, protein: 4),
  FoodItem(name: 'Tuna', calories: 132, carbs: 0, fat: 0.5, protein: 29),
  FoodItem(name: 'Raspberries', calories: 64, carbs: 15, fat: 0.5, protein: 1.5),
  FoodItem(name: 'Shrimp', calories: 84, carbs: 0.2, fat: 0.9, protein: 18),
  FoodItem(name: 'Cabbage', calories: 22, carbs: 5, fat: 0.1, protein: 1.3),
  FoodItem(name: 'Beef Steak', calories: 250, carbs: 0, fat: 20, protein: 26),
  FoodItem(name: 'Oranges', calories: 52, carbs: 12, fat: 0.2, protein: 1),
  FoodItem(name: 'Green Beans', calories: 31, carbs: 7, fat: 0.3, protein: 1.8),
  FoodItem(name: 'Kiwi', calories: 61, carbs: 15, fat: 0.5, protein: 1.1),
  FoodItem(name: 'Pumpkin Seeds', calories: 151, carbs: 5, fat: 13, protein: 7),
  FoodItem(name: 'Cranberries', calories: 46, carbs: 12, fat: 0.1, protein: 0.4),FoodItem(name: 'Lentils', calories: 230, carbs: 40, fat: 0.8, protein: 18),
  FoodItem(name: 'Chickpeas', calories: 164, carbs: 27, fat: 2.6, protein: 8.9),
  FoodItem(name: 'Black Beans', calories: 227, carbs: 40, fat: 0.9, protein: 15),
  FoodItem(name: 'Green Peas', calories: 81, carbs: 14, fat: 0.4, protein: 5),
  FoodItem(name: 'Kidney Beans', calories: 127, carbs: 22, fat: 0.8, protein: 8.7),
  FoodItem(name: 'Split Peas', calories: 116, carbs: 21, fat: 0.4, protein: 8.3),
  FoodItem(name: 'Pinto Beans', calories: 143, carbs: 26, fat: 1.1, protein: 9),
  FoodItem(name: 'Black Eyed Peas', calories: 160, carbs: 35, fat: 0.6, protein: 9),
  FoodItem(name: 'Cannellini Beans', calories: 136, carbs: 24, fat: 0.5, protein: 9),
  FoodItem(name: 'Garbanzo Beans', calories: 164, carbs: 27, fat: 2.6, protein: 8.9),
  FoodItem(name: 'Red Lentils', calories: 115, carbs: 20, fat: 0.4, protein: 7.9),
  FoodItem(name: 'Mung Beans', calories: 212, carbs: 38, fat: 1.2, protein: 14),
  FoodItem(name: 'Adzuki Beans', calories: 294, carbs: 57, fat: 0.5, protein: 17),
  FoodItem(name: 'Cowpeas', calories: 198, carbs: 35, fat: 1.3, protein: 11),
  FoodItem(name: 'Navy Beans', calories: 255, carbs: 48, fat: 1.2, protein: 15),
  FoodItem(name: 'Soybeans', calories: 446, carbs: 30, fat: 20, protein: 36),
  FoodItem(name: 'Great Northern Beans', calories: 209, carbs: 38, fat: 0.9, protein: 13),
  FoodItem(name: 'Chana Dal', calories: 160, carbs: 27, fat: 3.6, protein: 7),
  FoodItem(name: 'Toor Dal', calories: 209, carbs: 38, fat: 1.3, protein: 11),
  FoodItem(name: 'Urad Dal', calories: 235, carbs: 35, fat: 0.8, protein: 25),
  FoodItem(name: 'Moong Dal', calories: 106, carbs: 19, fat: 0.4, protein: 7),
FoodItem(name: 'Salmon', calories: 230, carbs: 0, fat: 12, protein: 22),
  FoodItem(name: 'Shrimp', calories: 70, carbs: 0, fat: 1, protein: 14),
  FoodItem(name: 'Cod', calories: 80, carbs: 0, fat: 1, protein: 19),
  FoodItem(name: 'Tilapia', calories: 120, carbs: 0, fat: 2, protein: 26),
  FoodItem(name: 'Sardines', calories: 230, carbs: 0, fat: 16, protein: 22),

  // Lean meats
  FoodItem(name: 'Chicken breast', calories: 165, carbs: 0, fat: 3, protein: 31),
  FoodItem(name: 'Turkey breast', calories: 170, carbs: 0, fat: 3, protein: 31),
  FoodItem(name: 'Lean beef', calories: 250, carbs: 0, fat: 6, protein: 26),
  FoodItem(name: 'Veal', calories: 170, carbs: 0, fat: 3, protein: 29),
  FoodItem(name: 'Lean pork tenderloin', calories: 170, carbs: 0, fat: 8, protein: 25),

  // Eggs
  FoodItem(name: 'Egg', calories: 78, carbs: 1, fat: 5, protein: 6),

  // Dairy (low-fat)
  FoodItem(name: 'Greek yogurt (non-fat)', calories: 80, carbs: 8, fat: 0, protein: 20),
  FoodItem(name: 'Cottage cheese (low-fat)', calories: 160, carbs: 6, fat: 2, protein: 28),
  FoodItem(name: 'Skim milk', calories: 80, carbs: 12, fat: 0, protein: 8),

  // Leumes
  FoodItem(name: 'Lentils', calories: 230, carbs: 38, fat: 1, protein: 18),
  FoodItem(name: 'Black beans', calories: 230, carbs: 41, fat: 1, protein: 15),
  FoodItem(name: 'Chickpeas', calories: 260, carbs: 45, fat: 4, protein: 15),
  FoodItem(name: 'Tofu', calories: 80, carbs: 3, fat: 4, protein: 8),

  // Veetables (non-starchy)
  FoodItem(name: 'Broccoli', calories: 34, carbs: 6, fat: 0, protein: 2),
  FoodItem(name: 'Spinach', calories: 25, carbs: 2, fat: 0, protein: 3),
  FoodItem(name: 'Kale', calories: 33, carbs: 6, fat: 0, protein: 3),
  FoodItem(name: 'Asparaus', calories: 20, carbs: 3, fat: 0, protein: 2),
  FoodItem(name: 'Bell peppers', calories: 30, carbs: 6, fat: 0, protein: 1),

  // Fruits (low-sugar)
  FoodItem(name: 'Berries', calories: 80, carbs: 12, fat: 0, protein: 1),

  ];

  List<FoodItem> filteredFoodItems = [];

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredFoodItems = allFoodItems;
  }

  void filterSearchResults(String query) {
    List<FoodItem> searchResults = allFoodItems
        .where((food) =>
            food.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    setState(() {
      filteredFoodItems = searchResults;
    });
  }


  String _getFirstLetter(String text) {
    return text.isNotEmpty ? text[0].toUpperCase() : '';
  }
  @override
  Widget build(BuildContext context) {
     final themeProvider = Provider.of<ThemeProvider>(context);
     filteredFoodItems.sort((a, b) =>
    a.name.toLowerCase().compareTo(b.name.toLowerCase()));

    return Scaffold(
      appBar: AppBar(
        title: Text('Food Caleroies',style: TextStyle(
            color: themeProvider.isDarkMode ? Colors.white : AppColor.blueColor,
            fontWeight: FontWeight.bold,
            fontFamily: 'Quicksand',
            fontSize: 22.0,
          ),),
        
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              
              controller: searchController,
              onChanged: filterSearchResults,
              decoration: InputDecoration(
                suffixIcon: Icon(Icons.search_sharp,color: Colors.grey,weight: 200,grade: 120),
                  labelText: 'Search Food',
                  labelStyle: TextStyle(
                    fontSize: 15,
                    color: Color(0xff999999),
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Montserrat',
                  ),
                  fillColor: Colors.transparent,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 27, horizontal: 16),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white38),
                    borderRadius: BorderRadius.all(Radius.circular(22)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColor.blueColor),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                ),
                
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredFoodItems.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(filteredFoodItems[index].name,style: TextStyle(
            color: themeProvider.isDarkMode ? Colors.white : AppColor.blueColor,
            fontWeight: FontWeight.bold,
            fontFamily: 'Quicksand',
            fontSize: 18.0,
          ),),
                  subtitle: Text(
                    'Calories: ${filteredFoodItems[index].calories.toString()}',
                    style: TextStyle(
            color: themeProvider.isDarkMode ? Colors.white : Colors.grey,
            fontWeight: FontWeight.bold,
            fontFamily: 'Quicksand',
            fontSize: 14.0,
          ),
                  ),
                  // Add more information if needed
               onTap: () {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(filteredFoodItems[index].name,style: TextStyle(
            color: themeProvider.isDarkMode ? Colors.white : AppColor.blueColor,
            fontWeight: FontWeight.bold,
            fontFamily: 'Quicksand',
            fontSize: 22.0,
          ),),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Calories: ${filteredFoodItems[index].calories}',      style: TextStyle(
            color: themeProvider.isDarkMode ? Colors.white : Colors.black87,
            fontWeight: FontWeight.bold,
            fontFamily: 'Quicksand',
            fontSize: 15.0,
          ),),
            Text('Carbs: ${filteredFoodItems[index].carbs} grams',      style: TextStyle(
            color: themeProvider.isDarkMode ? Colors.white : Colors.black87,
            fontWeight: FontWeight.bold,
            fontFamily: 'Quicksand',
            fontSize: 15.0,
          ),),
            Text('Fat: ${filteredFoodItems[index].fat} grams',      style: TextStyle(
            color: themeProvider.isDarkMode ? Colors.white : Colors.black87,
            fontWeight: FontWeight.bold,
            fontFamily: 'Quicksand',
            fontSize: 15.0,
          ),),
            Text('Protein: ${filteredFoodItems[index].protein} grams',      style: TextStyle(
            color: themeProvider.isDarkMode ? Colors.white : Colors.black87,
            fontWeight: FontWeight.bold,
            fontFamily: 'Quicksand',
            fontSize: 15.0,
          ),),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Close'),
          ),
        ],
      );
    },
  );
},

                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
