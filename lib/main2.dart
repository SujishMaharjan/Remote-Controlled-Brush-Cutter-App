import 'package:flutter/material.dart';

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
        title: Text('Machine Control App'),
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

class OperationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Operation Screen'),
      ),
      body: Center(
        child: Text('Operation Screen'),
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
