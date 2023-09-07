import 'dart:async';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class TimeNow extends StatefulWidget {
  const TimeNow({Key? key}) : super(key: key);

  @override
  State<TimeNow> createState() => _TimeNowState();
}

class _TimeNowState extends State<TimeNow> {
  String _nowTimeStr = '';
  late Timer _timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    _timer = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      setState(() {
        _nowTimeStr = formatter.format(DateTime.now());
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _nowTimeStr,
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xff01FFFD)),
    );
  }
}
