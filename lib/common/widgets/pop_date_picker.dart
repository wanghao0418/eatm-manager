/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-07-27 14:48:59
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-07-27 15:45:31
 * @FilePath: /eatm_manager/lib/common/widgets/pop_date_picker.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'package:eatm_manager/common/style/global_theme.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:get/get.dart';

class PopDatePicker extends StatefulWidget {
  const PopDatePicker(
      {Key? key, required this.onChange, this.placeholder, this.value})
      : super(key: key);
  final Function onChange;
  final String? placeholder;
  final String? value;

  @override
  _PopDatePickerState createState() => _PopDatePickerState();
}

class _PopDatePickerState extends State<PopDatePicker> {
  late TextEditingController _controller;

  get nowFormatDate => DateTime.now().toString().split(' ')[0];

  getNowDateStr() {
    var now = DateTime.now();
    return '${now.year}-${now.month < 10 ? '0${now.month}' : now.month}-${now.day < 10 ? '0${now.day}' : now.day}';
  }

  @override
  void initState() {
    _controller = TextEditingController(text: widget.value ?? nowFormatDate);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextBox(
      controller: _controller,
      prefix: Padding(
        padding: const EdgeInsets.only(left: 5),
        child: Icon(
          FluentIcons.calendar,
          size: 16,
          color: GlobalTheme.instance.buttonIconColor,
        ),
      ),
      placeholder: '开始时间',
      readOnly: true,
      onTap: () {
        material
            .showDatePicker(
                context: Get.context!,
                initialDate: DateTime.parse(_controller.text),
                firstDate: DateTime(1900),
                lastDate: DateTime(2100))
            .then((value) {
          if (value != null) {
            var formatDate = value.toString().split(' ')[0];
            _controller.text = formatDate;
            widget.onChange(formatDate);
          }
        });
      },
    );
  }
}
