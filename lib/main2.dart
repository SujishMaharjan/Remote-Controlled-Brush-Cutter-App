import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Machine Control App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool isConnected = false;
  String inclineAngle = "0°";
  String temperature = "N/A";
  String error = "None";

  void connect() {
    setState(() {
      isConnected = !isConnected;
      // Add actual connection logic here
    });
  }

  void startOperation() {
    if (isConnected) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => OperationScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please connect to the machine first.')),
      );
    }
  }

  void showMachineInfo() {
    if (isConnected) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MachineInfoScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please connect to the machine first.')),
      );
    }
  }

  void showErrorInfo() {
    if (isConnected) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ErrorInfoScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please connect to the machine first.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Remote Controlled Brush Cutter App'),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: connect,
              child: Text(isConnected ? "Disconnect" : "Connect"),
            ),
            ElevatedButton(
              onPressed: startOperation,
              child: Text("Start Operation"),
            ),
            ElevatedButton(
              onPressed: showMachineInfo,
              child: Text("Machine Info"),
            ),
            ElevatedButton(
              onPressed: showErrorInfo,
              child: Text("Error Info"),
            ),
            SizedBox(height: 20),
            Text("Incline Angle: $inclineAngle"),
            Text("Temperature: $temperature"),
            Text("Error: $error"),
          ],
        ),
      ),
    );
  }
}

class OperationScreen extends StatefulWidget {
  @override
  State<OperationScreen> createState() => _OperationScreenState();
}

class _OperationScreenState extends State<OperationScreen> {
  double speed = 128;
  double turn = 128;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Operation Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Left Right Operation"),
            Slider(
              value: turn,
              min: 1,
              max: 255,
              onChanged: (double value) {
                setState(() {
                  turn = value;
                });
              },
            ),
            SizedBox(height: 32.0), // Add some spacing between sliders
            Text("Forward Reverse Operation"),
            SizedBox(height: 32.0),
            Transform.rotate(
              angle: 4.71,
              child: Container(
                height:
                    300, // Ensure there's enough space for the slider to be fully displayed
                child: Slider(
                  value: speed,
                  min: 1,
                  max: 255,
                  onChanged: (double value) {
                    setState(() {
                      speed = value;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 32.0), // Add some spacing before the buttons
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SpeedSettingScreen()),
                );
              },
              child: Text("Set High speed"),
            ),
            SizedBox(height: 16.0), // Add spacing between buttons
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EnOperationScreen()),
                );
              },
              child: Text("Engine Operation Screen"),
            ),
            SizedBox(height: 16.0), // Add spacing between buttons
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Stop Operation"),
            ),
          ],
        ),
      ),
    );
  }
}

class SpeedSettingScreen extends StatefulWidget {
  @override
  State<SpeedSettingScreen> createState() => _SpeedSettingScreenState();
}

class _SpeedSettingScreenState extends State<SpeedSettingScreen> {
  double maxSpeedSet = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Maximum Speed Setting Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Slider(
              value: maxSpeedSet,
              min: 1,
              max: 3.1,
              onChanged: (double value) {
                setState(() {
                  maxSpeedSet = value;
                });
              },
            ),
            Text(
              'Max Speed Set: ${maxSpeedSet.toStringAsFixed(1)} km/h',
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}

class EnOperationScreen extends StatefulWidget {
  @override
  State<EnOperationScreen> createState() => _EnOperationScreenState();
}

class _EnOperationScreenState extends State<EnOperationScreen> {
  bool isStartPressed = false;
  bool isStopPressed = false;

  void handleStopPress() {
    setState(() {
      isStopPressed = true;
      isStartPressed = false;
    });

    Timer(Duration(seconds: 2), () {
      setState(() {
        isStopPressed = false;
      });
    });
  }

  bool isActive = false;
  void handleStartPress() {
    setState(() {
      isStopPressed = false;
      isStartPressed = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Engine Operation Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: handleStartPress,
              child: Text(isStartPressed ? 'Engine Started' : 'Start Engine'),
              style: ElevatedButton.styleFrom(
                backgroundColor: isStartPressed ? Colors.green : Colors.white,
              ),
            ),
            ElevatedButton(
              onPressed: handleStopPress,
              child: Text(isStopPressed ? 'Engine Stopped' : 'Stop Engine'),
              style: ElevatedButton.styleFrom(
                backgroundColor: isStopPressed ? Colors.green : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MachineInfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Machine Information'),
      ),
      body: Center(
        child: Text('Machine Information Screen'),
      ),
    );
  }
}

class ErrorInfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Error Information'),
      ),
      body: Center(
        child: Text('Error Information Screen'),
      ),
    );
  }
}
