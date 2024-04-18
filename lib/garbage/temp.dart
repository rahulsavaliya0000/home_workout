// import 'package:flutter/material.dart';
// import 'package:health/health.dart';

// class StepDashboard extends StatefulWidget {
//   @override
//   _StepDashboardState createState() => _StepDashboardState();
// }

// class _StepDashboardState extends State<StepDashboard> {
//   HealthFactory? health;
//   List<HealthDataPoint> stepData = [];
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     initHealth();
//   }

//   Future<void> initHealth() async {
//     try {
//       // Create a HealthFactory for use in the app, choose if HealthConnect should be used or not
//       health = HealthFactory(useHealthConnectIfAvailable: true);

//       // Request permission and fetch step count data
//       List<HealthDataType> types = [HealthDataType.STEPS];
//       bool granted = await health!.requestAuthorization(types);

//       if (granted) {
//         await fetchData();
//       } else {
//         print("Permission not granted");
//         setState(() {
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       print("Error initializing health: $e");
//       print("Health is not available");
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   Future<void> fetchData() async {
//     try {
//       // Fetch steps data
//       DateTime now = DateTime.now();
//       DateTime start = DateTime(now.year, now.month, now.day);
//       DateTime end = now;

//       stepData = await health!.getHealthDataFromTypes(start, end, [HealthDataType.STEPS]);
//       print("Fetched step data: $stepData");
//     } catch (e) {
//       print("Error fetching step data: $e");
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   Future<void> showEnableActivityMenu(BuildContext context) async {
//     return showMenu(
//       context: context,
//       position: RelativeRect.fromLTRB(0, 100, 0, 0),
//       items: [
//         PopupMenuItem(
//           child: ListTile(
//             leading: Icon(Icons.directions_walk),
//             title: Text('Enable Physical Activity'),
//             onTap: () {
//               Navigator.of(context).pop();
//               // Handle enabling physical activity
//             },
//           ),
//         ),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Step Dashboard'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Text(
//               'Steps Today',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 10),
//             isLoading
//                 ? CircularProgressIndicator()
//                 : Text(
//                     stepData.isNotEmpty ? stepData.last.value.toString() : 'No data available',
//                     style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
//                   ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 showEnableActivityMenu(context);
//               },
//               child: Text("Show Menu"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
