/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-07-10 15:26:47
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-09-13 14:10:33
 * @FilePath: /flutter-mesui/lib/pages/tool_management/tool_magazine_outside_mac/widgets/add_tool_form.dart
 */

import 'package:eatm_manager/common/utils/popup_message.dart';
import 'package:eatm_manager/pages/business/tool_management/tool_magazine_outside_mac/controller.dart';
import 'package:fluent_ui/fluent_ui.dart' as FluentUI;
import 'package:flutter/material.dart';

class AddToolForm extends StatefulWidget {
  const AddToolForm(
      {Key? key,
      required this.minStorageNum,
      required this.maxStorageNum,
      required this.shelfNo,
      this.toolData})
      : super(key: key);
  final int minStorageNum;
  final int maxStorageNum;
  final int shelfNo;
  final Tool? toolData;

  @override
  AddToolFormState createState() => AddToolFormState();
}

class AddToolFormState extends State<AddToolForm> {
  late final ToolAdd toolAdd;
  late bool isEdit;

  bool confirm() {
    if (toolAdd.storageNum == null) {
      PopupMessage.showWarningInfoBar('请输入货位号');
      return false;
    } else if (toolAdd.storageNum! < widget.minStorageNum ||
        toolAdd.storageNum! > widget.maxStorageNum) {
      PopupMessage.showWarningInfoBar('货位号异常');

      return false;
    }
    return true;
  }

  @override
  void initState() {
    var tool = widget.toolData;
    toolAdd = tool != null
        ? ToolAdd(
            deviceName: widget.shelfNo.toString(),
            storageNum: tool.storageNum,
            toolNum: tool.toolNum,
            toolFullName: tool.toolFullName,
            toolLength: tool.toolLength,
            toolType: tool.toolType,
            toolHiltType: tool.toolHiltType,
            theoreticalLife: tool.theoreticalLife,
            usedLife: tool.usedLife)
        : ToolAdd(deviceName: widget.shelfNo.toString());
    isEdit = tool != null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 6,
        children: [
          Row(
            children: [
              SizedBox(
                width: 80.0,
                child: RichText(
                    text: const TextSpan(
                  text: '*',
                  style: TextStyle(color: Colors.redAccent),
                  children: [
                    TextSpan(
                        text: '货位号:', style: TextStyle(color: Colors.black))
                  ],
                )),
              ),
              const SizedBox(
                width: 10.0,
              ),
              Expanded(
                child: FluentUI.NumberBox<int>(
                  placeholder: '请输入',
                  value: toolAdd.storageNum,
                  mode: FluentUI.SpinButtonPlacementMode.inline,
                  min: widget.minStorageNum,
                  max: widget.maxStorageNum,
                  // onSaved: (newValue) {
                  //   toolAdd.storageNum = int.parse(newValue!);
                  // },
                  onChanged: !isEdit
                      ? (val) {
                          toolAdd.storageNum = val != null ? val.toInt() : 0;
                        }
                      : null,
                  // validator: (text) {
                  //   if (text == null || text.isEmpty) {
                  //     return '必填';
                  //   }
                  //   return null;
                  // },
                ),
              )
            ],
          ),
          Row(
            children: [
              SizedBox(
                width: 80.0,
                child: RichText(
                    text: const TextSpan(
                  // text: '*',
                  // style: TextStyle(color: Colors.redAccent),
                  children: [
                    TextSpan(
                        text: '货架号:', style: TextStyle(color: Colors.black))
                  ],
                )),
              ),
              const SizedBox(
                width: 10.0,
              ),
              Expanded(
                child: FluentUI.TextFormBox(
                  placeholder: '请输入',
                  readOnly: true,
                  initialValue: toolAdd.deviceName,
                  onSaved: (newValue) {
                    toolAdd.deviceName = newValue;
                  },
                  onChanged: !isEdit
                      ? (value) {
                          toolAdd.deviceName = value;
                          // setState(() {});
                        }
                      : null,
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return '必填';
                    }
                    return null;
                  },
                ),
              )
            ],
          ),
          Row(
            children: [
              SizedBox(
                width: 80.0,
                child: RichText(
                    text: const TextSpan(
                  // text: '*',
                  // style: TextStyle(color: Colors.redAccent),
                  children: [
                    TextSpan(
                        text: '刀具号:', style: TextStyle(color: Colors.black))
                  ],
                )),
              ),
              const SizedBox(
                width: 10.0,
              ),
              Expanded(
                child: FluentUI.TextFormBox(
                  placeholder: '请输入',
                  initialValue: toolAdd.toolNum,
                  onSaved: (newValue) {
                    toolAdd.toolNum = newValue;
                  },
                  onChanged: (value) {
                    toolAdd.toolNum = value;
                    // setState(() {});
                  },
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return '必填';
                    }
                    return null;
                  },
                ),
              )
            ],
          ),
          Row(
            children: [
              SizedBox(
                width: 80.0,
                child: RichText(
                    text: const TextSpan(
                  // text: '*',
                  // style: TextStyle(color: Colors.redAccent),
                  children: [
                    TextSpan(
                        text: '刀具名称:', style: TextStyle(color: Colors.black))
                  ],
                )),
              ),
              const SizedBox(
                width: 10.0,
              ),
              Expanded(
                child: FluentUI.TextFormBox(
                  placeholder: '请输入',
                  initialValue: toolAdd.toolFullName,
                  onSaved: (newValue) {
                    toolAdd.toolFullName = newValue;
                  },
                  onChanged: (value) {
                    toolAdd.toolFullName = value;
                    // setState(() {});
                  },
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return '必填';
                    }
                    return null;
                  },
                ),
              )
            ],
          ),
          Row(
            children: [
              SizedBox(
                width: 80.0,
                child: RichText(
                    text: const TextSpan(
                  // text: '*',
                  // style: TextStyle(color: Colors.redAccent),
                  children: [
                    TextSpan(
                        text: '刀具长度:', style: TextStyle(color: Colors.black))
                  ],
                )),
              ),
              const SizedBox(
                width: 10.0,
              ),
              Expanded(
                child: FluentUI.NumberFormBox<double>(
                  placeholder: '请输入',
                  // initialValue: toolAdd.toolLength,
                  mode: FluentUI.SpinButtonPlacementMode.none,
                  value: toolAdd.toolLength != null
                      ? double.tryParse(toolAdd.toolLength!)
                      : null,
                  onSaved: (newValue) {
                    toolAdd.toolLength = newValue.toString();
                  },
                  onChanged: (value) {
                    toolAdd.toolLength = value.toString();
                    // setState(() {});
                  },
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return '必填';
                    }
                    return null;
                  },
                ),
              )
            ],
          ),
          Row(
            children: [
              SizedBox(
                width: 80.0,
                child: RichText(
                    text: const TextSpan(
                  // text: '*',
                  // style: TextStyle(color: Colors.redAccent),
                  children: [
                    TextSpan(
                        text: '刀具类型:', style: TextStyle(color: Colors.black))
                  ],
                )),
              ),
              const SizedBox(
                width: 10.0,
              ),
              Expanded(
                child: FluentUI.TextFormBox(
                  placeholder: '请输入',
                  initialValue: toolAdd.toolType,
                  onSaved: (newValue) {
                    toolAdd.toolType = newValue;
                  },
                  onChanged: (value) {
                    toolAdd.toolType = value;
                    // setState(() {});
                  },
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return '必填';
                    }
                    return null;
                  },
                ),
              )
            ],
          ),
          Row(
            children: [
              SizedBox(
                width: 80.0,
                child: RichText(
                    text: const TextSpan(
                  // text: '*',
                  // style: TextStyle(color: Colors.redAccent),
                  children: [
                    TextSpan(
                        text: '刀柄类型:', style: TextStyle(color: Colors.black))
                  ],
                )),
              ),
              const SizedBox(
                width: 10.0,
              ),
              Expanded(
                child: FluentUI.TextFormBox(
                  placeholder: '请输入',
                  initialValue: toolAdd.toolHiltType,
                  onSaved: (newValue) {
                    toolAdd.toolHiltType = newValue;
                  },
                  onChanged: (value) {
                    toolAdd.toolHiltType = value;
                    // setState(() {});
                  },
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return '必填';
                    }
                    return null;
                  },
                ),
              )
            ],
          ),
          Row(
            children: [
              SizedBox(
                width: 80.0,
                child: RichText(
                    text: const TextSpan(
                  // text: '*',
                  // style: TextStyle(color: Colors.redAccent),
                  children: [
                    TextSpan(
                        text: '理论寿命:', style: TextStyle(color: Colors.black))
                  ],
                )),
              ),
              const SizedBox(
                width: 10.0,
              ),
              Expanded(
                child: FluentUI.NumberFormBox<double>(
                  placeholder: '请输入',
                  // initialValue: toolAdd.theoreticalLife,
                  mode: FluentUI.SpinButtonPlacementMode.none,
                  value: toolAdd.theoreticalLife != null
                      ? double.tryParse(toolAdd.theoreticalLife!)
                      : null,
                  onSaved: (newValue) {
                    toolAdd.theoreticalLife = newValue.toString();
                  },
                  onChanged: (value) {
                    toolAdd.theoreticalLife = value.toString();
                    // setState(() {});
                  },
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return '必填';
                    }
                    return null;
                  },
                ),
              )
            ],
          ),
          Row(
            children: [
              SizedBox(
                width: 80.0,
                child: RichText(
                    text: const TextSpan(
                  // text: '*',
                  // style: TextStyle(color: Colors.redAccent),
                  children: [
                    TextSpan(
                        text: '已用寿命:', style: TextStyle(color: Colors.black))
                  ],
                )),
              ),
              SizedBox(
                width: 10.0,
              ),
              Expanded(
                child: FluentUI.NumberFormBox<double>(
                  placeholder: '请输入',
                  // initialValue: toolAdd.usedLife,
                  mode: FluentUI.SpinButtonPlacementMode.none,

                  value: toolAdd.usedLife != null
                      ? double.tryParse(toolAdd.usedLife!)
                      : null,
                  onSaved: (newValue) {
                    toolAdd.usedLife = newValue.toString();
                  },
                  onChanged: (value) {
                    toolAdd.usedLife = value.toString();
                    // setState(() {});
                  },
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return '必填';
                    }
                    return null;
                  },
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class ToolAdd {
  String? deviceName;
  int? storageNum;
  String? toolNum;
  String? toolFullName;
  String? toolLength;
  String? toolType;
  String? toolHiltType;
  String? theoreticalLife;
  String? usedLife;

  ToolAdd(
      {this.deviceName,
      this.storageNum,
      this.toolNum,
      this.toolFullName,
      this.toolLength,
      this.toolType,
      this.toolHiltType,
      this.theoreticalLife,
      this.usedLife});

  Map<String, dynamic> toMap() {
    return {
      "ToolNum": toolNum,
      "DeviceName": deviceName,
      "StorageNum": storageNum,
      "ToolFullName": toolFullName,
      "ToolLength": toolLength,
      "ToolType": toolType,
      "ToolHiltType": toolHiltType,
      "TheoreticalLife": theoreticalLife,
      "UesdLife": usedLife
    };
  }

  clean() {
    toolNum = null;
    deviceName = null;
    storageNum = null;
    toolFullName = null;
    toolLength = null;
    toolType = null;
    toolHiltType = null;
    theoreticalLife = null;
    usedLife = null;
  }
}
