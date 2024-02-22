import 'package:flutter/material.dart';
import 'package:health/health.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Step Counter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StepCounterScreen(),
    );
  }
}

class StepCounterScreen extends StatefulWidget {
  @override
  _StepCounterScreenState createState() => _StepCounterScreenState();
}

class _StepCounterScreenState extends State<StepCounterScreen> {
  List<HealthDataPoint> _stepData = [];
  HealthFactory health = HealthFactory(useHealthConnectIfAvailable: true);

  @override
  void initState() {
    super.initState();
    _fetchStepData();
  }

  Future<void> _fetchStepData() async {
    try {
      List<HealthDataType> types = [HealthDataType.STEPS];
      DateTime now = DateTime.now();
      DateTime start = DateTime(now.year, now.month, now.day, 0, 0, 0);
    List<HealthDataPoint> healthData =
          await health.getHealthDataFromTypes(start, now, types);
       setState(() {
        _stepData = healthData;
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Step Counter'),
      ),
      body: ListView.builder(
        itemCount: _stepData.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Steps: ${_stepData[index].value}'),
            subtitle: Text('Date: ${_stepData[index].dateTo}'),
          );
        },
      ),
    );
  }
}