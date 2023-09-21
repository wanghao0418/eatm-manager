/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-07-27 14:48:59
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-09-21 13:47:19
 * @FilePath: /eatm_manager/lib/common/widgets/pop_date_picker.dart
 * @Description: 日期时间picker组件
 */
import 'package:date_format/date_format.dart';
import 'package:eatm_manager/common/style/global_theme.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PopDatePicker extends StatefulWidget {
  const PopDatePicker(
      {Key? key,
      required this.onChange,
      this.placeholder,
      this.value,
      this.dateFormat,
      this.pickTime = false})
      : super(key: key);
  final Function onChange;
  final String? placeholder;
  final String? value;
  // 格式化 默认 yyyy-mm-dd
  final List<String>? dateFormat;
  // 是否精确到时分
  final bool? pickTime;

  @override
  _PopDatePickerState createState() => _PopDatePickerState();
}

class _PopDatePickerState extends State<PopDatePicker> {
  late TextEditingController _controller;
  List<String> dateLocale = [yyyy, '-', mm, '-', dd];
  get nowFormatDate => formatDate(DateTime.now(), dateLocale);

  @override
  void initState() {
    if (widget.dateFormat != null) {
      dateLocale = widget.dateFormat!;
    }
    _controller = TextEditingController(text: widget.value ?? nowFormatDate);
    // TODO: implement initState
    super.initState();
  }

  @override
  void didUpdateWidget(covariant PopDatePicker oldWidget) {
    if (widget.value != _controller.text) {
      setState(() {
        _controller =
            TextEditingController(text: widget.value ?? nowFormatDate);
      });
    }
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120.0,
      child: TextBox(
        controller: _controller,
        prefix: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Icon(
            FluentIcons.calendar,
            size: 16,
            color: GlobalTheme.instance.buttonIconColor,
          ),
        ),
        placeholder: widget.placeholder ?? '请选择日期',
        readOnly: true,
        // textAlign: TextAlign.center,
        onTap: () {
          material
              .showDatePicker(
                  context: Get.context!,
                  initialDate: DateTime.parse(_controller.text),
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2100))
              .then((date) async {
            if (date != null) {
              if (widget.pickTime == false) {
                var dateString = formatDate(date, dateLocale);
                _controller.text = dateString;
                widget.onChange(dateString);
              } else {
                var time = await material.showTimePicker(
                    context: Get.context!,
                    initialTime: TimeOfDay.fromDateTime(
                        DateTime.parse(_controller.text)));
                if (time != null) {
                  var dateTime = DateTime(
                      date.year, date.month, date.day, time.hour, time.minute);
                  var dateTimeString = formatDate(dateTime, dateLocale);
                  _controller.text = dateTimeString;
                  widget.onChange(dateTimeString);
                }
              }
            }
          });
        },
      ),
    );
  }
}
