import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
class GetTime extends StatefulWidget {
  @override
  _GetTimeState createState() => _GetTimeState();
}

class _GetTimeState extends State<GetTime> {
  String _timeString;

  @override
  void initState() {
    _timeString = _formatDateTime(DateTime.now());
    Timer.periodic(Duration(seconds: 1), (Timer t){
      _getTime();
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("${_timeString}"));
  }

  void _getTime() {
    final DateTime now = DateTime.now();
    final String formattedDateTime = _formatDateTime(now);
    setState(() {
      _timeString = formattedDateTime;
    });
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('MM/dd/yyyy hh:mm:ss').format(dateTime);
  }
}