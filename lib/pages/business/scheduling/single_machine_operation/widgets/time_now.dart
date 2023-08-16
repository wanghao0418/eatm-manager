/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-08-16 14:30:56
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-08-16 14:37:27
 * @FilePath: /eatm_manager/lib/pages/business/scheduling/single_machine_operation/widgets/time_now.dart
 * @Description:  当前时间
 */
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
  String _nowDateStr = '';
  late Timer _timer;

  String getNowTime({bool onlyDate = false, bool onlyTime = false}) {
    DateTime dateTime = DateTime.now();
    var year = dateTime.year;
    var month = dateTime.month;
    var day = dateTime.day;
    var hour = dateTime.hour;
    var minute = dateTime.minute;
    var second = dateTime.second;
    var formatter = DateFormat('yyyy-MM-dd hh:mm:ss');
    var formatterDate = DateFormat('yyyy-MM-dd');
    var formatterTime = DateFormat('hh:mm:ss');
    if (onlyDate) {
      return "${formatterDate.format(dateTime)}";
    } else if (onlyTime) {
      return "${formatterTime.format(dateTime)}";
    }
    return "${formatter.format(dateTime)}";
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      setState(() {
        _nowDateStr = getNowTime(onlyDate: true);
        _nowTimeStr = getNowTime(onlyTime: true);
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
    return Column(
      children: [
        Text(
          _nowTimeStr,
          style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xff333333)),
        ),
        Text(_nowDateStr,
            style: const TextStyle(fontSize: 12, color: Color(0xff666666))),
      ],
    );
  }
}
