import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:async';
import 'machine.dart';

//globally declaring variable
bool isConnected = false;
bool isStartPressed = false;
bool isStopPressed = false;
DateTime _startTime = DateTime.now();
Duration elapsedTime = DateTime.now().difference(_startTime!);

Machine machine1 = Machine(
  serialNumber: '1234',
  voltage: '220V',
  scibInfo: '100',
  password: '0000',
);

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
  String inclineAngle = "0°";
  String temperature = "N/A";
  String error = "None";

  void disconnect() {
    setState(() {
      isConnected = false;
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
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AccessPointSetScreen()),
                );
              },
              child: Text("Connect to Machine"),
            ),
            ElevatedButton(
              onPressed: disconnect,
              child: Text("Disconnect"),
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

class AccessPointSetScreen extends StatefulWidget {
  @override
  State<AccessPointSetScreen> createState() => _AccessPointSetScreenState();
}

class _AccessPointSetScreenState extends State<AccessPointSetScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Access Point Set Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('List of Avaliable Machines'),
            Text('Serial Number: ${machine1.serialNumber}'),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserInputScreen()),
                );
              },
              child: Text("Enter to Connect to Machine"),
            ),
            ElevatedButton(
              onPressed: () {
                if (isConnected) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UserInputScreen2()),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('Please connect to the machine first.')),
                  );
                }
              },
              child: Text("Enter to Change the password"),
            ),
          ],
        ),
      ),
    );
  }
}

class UserInputScreen2 extends StatefulWidget {
  @override
  State<UserInputScreen2> createState() => _UserInputScreen2State();
}

class _UserInputScreen2State extends State<UserInputScreen2> {
  final TextEditingController _serialController = TextEditingController();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  String _displaySerial = '';
  String _displayOldPassword = '';
  String _displayNewPassword = '';

  String _message = '';

  void _checkAndSetPassword() {
    setState(() {
      _displaySerial = _serialController.text;
      _displayOldPassword = _oldPasswordController.text;
      _displayNewPassword = _newPasswordController.text;
    });

    if (_displayOldPassword == machine1.password) {
      machine1.setPassword(_displayNewPassword); //
      isConnected = true;
      _message = 'Password changed successfully';
    } else {
      isConnected = false;
      _message = 'Incorrect old password. Please try again.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter Serial and Password:'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _serialController,
              decoration: InputDecoration(
                labelText: 'Enter Serial Number',
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _oldPasswordController,
              decoration: InputDecoration(
                labelText: 'Enter Old Password',
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            TextField(
              controller: _newPasswordController,
              decoration: InputDecoration(
                labelText: 'Enter New Password',
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _checkAndSetPassword,
              child: Text('Submit'),
            ),
            SizedBox(height: 20),
            Text(
              _message,
              style: TextStyle(
                  fontSize: 18, color: isConnected ? Colors.green : Colors.red),
            )
          ],
        ),
      ),
    );
  }
}

class UserInputScreen extends StatefulWidget {
  @override
  _UserInputScreenState createState() => _UserInputScreenState();
}

class _UserInputScreenState extends State<UserInputScreen> {
  final TextEditingController _serialController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _displaySerial = '';
  String _displayPassword = '';

  void _check_password() {
    if (machine1.password == _displayPassword) {}
  }

  String _message = '';

  void _checkPassword() {
    if (_displayPassword == machine1.password) {
      isConnected = true;
      _message = 'Connected Successfully';
    } else {
      isConnected = false;
      _message = 'Incorrect password. Please try again.';
    }
  }

  void _updateText() {
    setState(() {
      _displaySerial = _serialController.text;
      _displayPassword = _passwordController.text;
    });
    _checkPassword();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter Serial and Password:'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _serialController,
              decoration: InputDecoration(
                labelText: 'Enter Serial Number',
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Enter Password',
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateText,
              child: Text('Submit'),
            ),
            SizedBox(height: 20),
            Text(
              _message,
              style: TextStyle(
                  fontSize: 18, color: isConnected ? Colors.green : Colors.red),
            )
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
        title: Text('Machine Operating  Screen'),
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
  void handleStopPress() {
    setState(() {
      isStopPressed = true;
      isStartPressed = false;
      elapsedTime = Duration.zero;
    });

    Timer(Duration(seconds: 2), () {
      setState(() {
        isStopPressed = false;
      });
    });
  }

  void handleStartPress() {
    setState(() {
      isStopPressed = false;
      isStartPressed = true;
      _startTime = DateTime.now();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Engine Operation Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Machine  Operation Screen"),
            ),
          ],
        ),
      ),
    );
  }
}

class MachineInfoScreen extends StatefulWidget {
  @override
  State<MachineInfoScreen> createState() => _MachineInfoScreenState();
}

class _MachineInfoScreenState extends State<MachineInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Machine Information'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Voltage : ${machine1.voltage}'),
            Text('SCIB information : ${machine1.scibInfo}'),
            Text('Running hours : ${elapsedTime}'),
            Text('Serial Number : ${machine1.serialNumber}'),
          ],
        ),
      ),
    );
    ;
  }
}

class ErrorInfoScreen extends StatefulWidget {
  @override
  State<ErrorInfoScreen> createState() => _ErrorInfoScreenState();
}

class _ErrorInfoScreenState extends State<ErrorInfoScreen> {
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
