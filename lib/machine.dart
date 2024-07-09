import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:async';

class Machine {
  final String serialNumber;
  final String voltage;
  final String scibInfo;
  String password;

  Machine({
    required this.serialNumber,
    required this.voltage,
    required this.scibInfo,
    required this.password,
  });

  void setPassword(String newPassword) {
    this.password = newPassword;
  }
}
