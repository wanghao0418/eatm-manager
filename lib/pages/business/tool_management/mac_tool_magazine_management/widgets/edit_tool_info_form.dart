/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-07-07 15:42:26
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-09-12 10:39:17
 * @FilePath: /flutter-mesui/lib/pages/tool_management/mac_tool_magazine_management/widgets/edit_tool_info_form.dart
 */
import 'package:eatm_manager/common/api/tool_management/standard_tool_management_api.dart';
import 'package:eatm_manager/common/utils/http.dart';
import 'package:eatm_manager/pages/business/tool_management/mac_tool_magazine_management/controller.dart';
import 'package:flutter/material.dart';
import 'package:fluent_ui/fluent_ui.dart' as FluentUI;
import 'package:styled_widget/styled_widget.dart';

import '../../standard_tool_management/controller.dart';

class EditToolInfoForm extends StatefulWidget {
  const EditToolInfoForm(
      {Key? key, this.editToolInfo, required this.machineList})
      : super(key: key);
  final EditToolInfo? editToolInfo;
  final List<MacToolInfo> machineList;

  @override
  EditToolInfoFormState createState() => EditToolInfoFormState();
}

class EditToolInfoFormState extends State<EditToolInfoForm> {
  late EditToolInfo editToolInfo;
  List<StandardToolData> standardToolList = [];
  late TextEditingController _ratedLifeController;
  var toolMaxNum = 60;
  late TextEditingController _toolController;
  final toolTypeList = [
    '1-钻头',
    '2-丝锥',
    '3-盘刀(直径>12)',
    '4-铣刀(通用)',
    '5-点钻',
    '6-球刀',
    '7-探头'
  ];

  // 获取标准刀具列表
  queryStandardToolList() async {
    ResponseApiBody res = await StandardToolManagementApi.query({
      "params": {
        "toolName": '',
      }
    });
    if (res.success == true) {
      standardToolList.clear();
      standardToolList.addAll(
          (res.data as List).map((e) => StandardToolData.fromJson(e)).toList());
      updateToolMaxNum();
      setState(() {});
    }
  }

  updateToolMaxNum() {
    if (editToolInfo.machineName == null || editToolInfo.machineName!.isEmpty) {
      return;
    }
    var currentMac = widget.machineList.firstWhere(
        (element) => element.machineName == editToolInfo.machineName);
    toolMaxNum = int.parse(currentMac.magazineToolMaxNum ?? '60');
    // setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    editToolInfo = widget.editToolInfo ?? EditToolInfo();
    _ratedLifeController =
        TextEditingController(text: editToolInfo.realToolRatedLife);
    _toolController = TextEditingController(text: editToolInfo.toolName);
    // updateToolMaxNum();
    queryStandardToolList();
  }

  // 基础参数
  Widget _buildBase() {
    return Container(
      padding: EdgeInsets.all(10),
      width: double.infinity,
      child: Column(children: [
        SizedBox(
          width: double.infinity,
          child: Text(
            '基础参数',
          ).fontWeight(FontWeight.bold),
        ),
        Divider(),
        Expanded(
            child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 6.5,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 80.0,
                  child: RichText(
                      text: TextSpan(
                    text: '*',
                    style: TextStyle(color: Colors.redAccent),
                    children: [
                      TextSpan(
                          text: '机床:', style: TextStyle(color: Colors.black))
                    ],
                  )),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Expanded(
                    child: FluentUI.ComboBox<String>(
                  isExpanded: true,
                  value: editToolInfo.machineName,
                  placeholder: Text('请选择'),
                  items: widget.machineList
                      .map((e) => FluentUI.ComboBoxItem(
                          value: e.machineName,
                          child: Tooltip(
                            message: e.machineName,
                            child: Text(
                              e.machineName ?? '',
                              overflow: TextOverflow.ellipsis,
                            ),
                          )))
                      .toList(),
                  onChanged: (val) {
                    editToolInfo.machineName = val;
                    updateToolMaxNum();
                    setState(() {});
                  },
                ))
              ],
            ),
            Row(
              children: [
                SizedBox(
                  width: 80.0,
                  child: RichText(
                      text: TextSpan(
                    // text: '*',
                    // style: TextStyle(color: Colors.redAccent),
                    children: [
                      TextSpan(
                          text: '刀具代码:', style: TextStyle(color: Colors.black))
                    ],
                  )),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  child: FluentUI.TextFormBox(
                    placeholder: '请输入',
                    initialValue: editToolInfo.toolCode,
                    onSaved: (newValue) {
                      editToolInfo.toolCode = newValue;
                    },
                    onChanged: (value) {
                      editToolInfo.toolCode = value;
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
                      text: TextSpan(
                    text: '*',
                    style: TextStyle(color: Colors.redAccent),
                    children: [
                      TextSpan(
                          text: '刀具:', style: TextStyle(color: Colors.black))
                    ],
                  )),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Expanded(
                    child: FluentUI.AutoSuggestBox<StandardToolData>(
                  maxPopupHeight: 300,
                  controller: _toolController,
                  placeholder: '请输入',
                  items: standardToolList.map((tool) {
                    return FluentUI.AutoSuggestBoxItem<StandardToolData>(
                        value: tool,
                        label: tool.toolName!,
                        onFocusChange: (focused) {
                          if (focused) {
                            print('Focused: $tool');
                          }
                        });
                  }).toList(),
                  onChanged: (value, reason) {
                    editToolInfo.toolName = _toolController.text;
                    // var id = value;
                    // editToolInfo.toolId = id;
                    // var standardTool = standardToolList
                    //     .firstWhere((element) => element.id == id);
                    // editToolInfo.toolName = standardTool.toolName;
                    // _ratedLifeController.text = standardTool.ratedLife ?? '';
                    // editToolInfo.realToolRatedLife =
                    //     standardTool.ratedLife ?? '';
                    // setState(() {});
                  },
                  onSelected: (value) {
                    print('Selected: $value');
                    var id = value.value!.id;
                    editToolInfo.toolId = id;
                    editToolInfo.toolName = value.value!.toolName;
                    _ratedLifeController.text = value.value!.ratedLife ?? '';
                    editToolInfo.realToolRatedLife =
                        value.value!.ratedLife ?? '';
                    setState(() {});
                  },
                )),
                // Expanded(
                //     child: FluentUI.ComboBox<String>(
                //   isExpanded: true,
                //   value: editToolInfo.toolId,
                //   placeholder: Text('请选择'),
                //   items: standardToolList
                //       .map((e) => FluentUI.ComboBoxItem(
                //           value: e.id,
                //           child: Tooltip(
                //             message: e.toolName,
                //             child: Text(
                //               e.toolName ?? '',
                //               overflow: TextOverflow.ellipsis,
                //             ),
                //           )))
                //       .toList(),
                //   onChanged: (val) {
                //     var id = val;
                //     editToolInfo.toolId = id;
                //     var standardTool = standardToolList
                //         .firstWhere((element) => element.id == id);
                //     editToolInfo.toolName = standardTool.toolName;
                //     _ratedLifeController.text = standardTool.ratedLife ?? '';
                //     editToolInfo.realToolRatedLife =
                //         standardTool.ratedLife ?? '';
                //     setState(() {});
                //   },
                // ))
              ],
            ),
            Row(
              children: [
                SizedBox(
                  width: 80.0,
                  child: RichText(
                      text: TextSpan(
                    // text: '*',
                    // style: TextStyle(color: Colors.redAccent),
                    children: [
                      TextSpan(
                          text: '探出长度:', style: TextStyle(color: Colors.black))
                    ],
                  )),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  child: FluentUI.NumberBox<double>(
                    smallChange: 0.1,
                    mode: FluentUI.SpinButtonPlacementMode.none,
                    placeholder: '请输入',
                    value: (editToolInfo.protrudingLength != null &&
                            editToolInfo.protrudingLength!.isNotEmpty)
                        ? double.tryParse(editToolInfo.protrudingLength!)
                        : null,
                    onChanged: (value) {
                      editToolInfo.protrudingLength =
                          value != null ? value.toString() : '';
                      // setState(() {});
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
                      text: TextSpan(
                    text: '*',
                    style: TextStyle(color: Colors.redAccent),
                    children: [
                      TextSpan(
                          text: '库号:', style: TextStyle(color: Colors.black))
                    ],
                  )),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Expanded(
                    child: FluentUI.ComboBox<String>(
                  isExpanded: true,
                  value: editToolInfo.magazineNo,
                  placeholder: Text('请选择'),
                  items: editToolInfo.machineName != null
                      ? List.generate(
                          toolMaxNum,
                          (index) => FluentUI.ComboBoxItem(
                              value: 'T${index + 1}',
                              child: Tooltip(
                                message: 'T${index + 1}',
                                child: Text(
                                  'T${index + 1}',
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )))
                      : [],
                  onChanged: (val) {
                    editToolInfo.magazineNo = val;
                    setState(() {});
                  },
                ))
              ],
            ),
            Row(
              children: [
                SizedBox(
                  width: 80.0,
                  child: RichText(
                      text: TextSpan(
                    // text: '*',
                    // style: TextStyle(color: Colors.redAccent),
                    children: [
                      TextSpan(
                          text: '刀柄代码:', style: TextStyle(color: Colors.black))
                    ],
                  )),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  child: FluentUI.TextFormBox(
                    placeholder: '请输入',
                    initialValue: editToolInfo.toolCode,
                    onSaved: (newValue) {
                      editToolInfo.toolCode = newValue;
                    },
                    onChanged: (value) {
                      editToolInfo.toolCode = value;
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
                      text: TextSpan(
                    // text: '*',
                    // style: TextStyle(color: Colors.redAccent),
                    children: [
                      TextSpan(
                          text: '额定寿命:', style: TextStyle(color: Colors.black))
                    ],
                  )),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  child: FluentUI.NumberBox<double>(
                    smallChange: 0.1,
                    mode: FluentUI.SpinButtonPlacementMode.none,
                    placeholder: '请输入',
                    value: (editToolInfo.realToolRatedLife != null &&
                            editToolInfo.realToolRatedLife!.isNotEmpty)
                        ? double.tryParse(editToolInfo.realToolRatedLife!)
                        : null,
                    onChanged: (value) {
                      editToolInfo.realToolRatedLife =
                          value != null ? value.toString() : '';
                      // setState(() {});
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
                      text: TextSpan(
                    // text: '*',
                    // style: TextStyle(color: Colors.redAccent),
                    children: [
                      TextSpan(
                          text: '已使用寿命:', style: TextStyle(color: Colors.black))
                    ],
                  )),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  child: FluentUI.NumberBox<double>(
                    smallChange: 0.1,
                    mode: FluentUI.SpinButtonPlacementMode.none,
                    placeholder: '请输入',
                    value: (editToolInfo.realToolUsedLife != null &&
                            editToolInfo.realToolUsedLife!.isNotEmpty)
                        ? double.tryParse(editToolInfo.realToolUsedLife!)
                        : null,
                    onChanged: (value) {
                      editToolInfo.realToolUsedLife =
                          value != null ? value.toString() : '';
                      // setState(() {});
                    },
                  ),
                )
              ],
            ),
          ],
        ))
      ]),
    ).border(all: 1, color: Colors.grey);
  }

  // 工艺参数
  Widget _buildCraft() {
    return Container(
      padding: EdgeInsets.all(10),
      width: double.infinity,
      child: Column(children: [
        SizedBox(
          width: double.infinity,
          child: Text(
            '工艺参数',
          ).fontWeight(FontWeight.bold),
        ),
        Divider(),
        Expanded(
            child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 6.5,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 80.0,
                  child: RichText(
                      text: TextSpan(
                    // text: '*',
                    // style: TextStyle(color: Colors.redAccent),
                    children: [
                      TextSpan(
                          text: '长度磨损:', style: TextStyle(color: Colors.black))
                    ],
                  )),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  child: FluentUI.NumberBox<double>(
                    smallChange: 0.1,
                    mode: FluentUI.SpinButtonPlacementMode.none,
                    placeholder: '请输入',
                    value: (editToolInfo.lengthWear != null &&
                            editToolInfo.lengthWear!.isNotEmpty)
                        ? double.tryParse(editToolInfo.realToolUsedLife!)
                        : null,
                    onChanged: (value) {
                      editToolInfo.lengthWear =
                          value != null ? value.toString() : '';
                      // setState(() {});
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
                      text: TextSpan(
                    // text: '*',
                    // style: TextStyle(color: Colors.redAccent),
                    children: [
                      TextSpan(
                          text: '半径磨损:', style: TextStyle(color: Colors.black))
                    ],
                  )),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  child: FluentUI.NumberBox<double>(
                    smallChange: 0.1,
                    mode: FluentUI.SpinButtonPlacementMode.none,
                    placeholder: '请输入',
                    value: (editToolInfo.radiusWear != null &&
                            editToolInfo.radiusWear!.isNotEmpty)
                        ? double.tryParse(editToolInfo.radiusWear!)
                        : null,
                    onChanged: (value) {
                      editToolInfo.radiusWear =
                          value != null ? value.toString() : '';
                      // setState(() {});
                    },
                  ),
                )
              ],
            ),
          ],
        ))
      ]),
    ).border(all: 1, color: Colors.grey);
  }

  // 对刀参数
  Widget _buildToolParams() {
    return Container(
      padding: EdgeInsets.all(10),
      width: double.infinity,
      child: Column(children: [
        SizedBox(
          width: double.infinity,
          child: Text(
            '对刀参数',
          ).fontWeight(FontWeight.bold),
        ),
        Divider(),
        Expanded(
            child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 6.5,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 80.0,
                  child: RichText(
                      text: TextSpan(
                    text: '*',
                    style: TextStyle(color: Colors.redAccent),
                    children: [
                      TextSpan(
                          text: '长度公差:', style: TextStyle(color: Colors.black))
                    ],
                  )),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  child: FluentUI.NumberBox<double>(
                    smallChange: 0.1,
                    mode: FluentUI.SpinButtonPlacementMode.none,
                    placeholder: '请输入',
                    value: (editToolInfo.lengthTolerance != null &&
                            editToolInfo.lengthTolerance!.isNotEmpty)
                        ? double.tryParse(editToolInfo.lengthTolerance!)
                        : null,
                    onChanged: (value) {
                      editToolInfo.lengthTolerance =
                          value != null ? value.toString() : '';
                      // setState(() {});
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
                      text: TextSpan(
                    // text: '*',
                    // style: TextStyle(color: Colors.redAccent),
                    children: [
                      TextSpan(
                          text: '半径公差:', style: TextStyle(color: Colors.black))
                    ],
                  )),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  child: FluentUI.NumberBox<double>(
                    smallChange: 0.1,
                    mode: FluentUI.SpinButtonPlacementMode.none,
                    placeholder: '请输入',
                    value: (editToolInfo.radiusTolerance != null &&
                            editToolInfo.radiusTolerance!.isNotEmpty)
                        ? double.tryParse(editToolInfo.radiusTolerance!)
                        : null,
                    onChanged: (value) {
                      editToolInfo.radiusTolerance =
                          value != null ? value.toString() : '';
                      // setState(() {});
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
                      text: TextSpan(
                    text: '*',
                    style: TextStyle(color: Colors.redAccent),
                    children: [
                      TextSpan(
                          text: '刀具类型:', style: TextStyle(color: Colors.black))
                    ],
                  )),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Expanded(
                    child: FluentUI.ComboBox<String>(
                  // value: controller.currentMachine,
                  isExpanded: true,
                  value: editToolInfo.toolType,
                  placeholder: Text('请选择'),
                  items: toolTypeList
                      .map((e) => FluentUI.ComboBoxItem(
                          value: e,
                          child: Tooltip(
                            message: e,
                            child: Text(
                              e,
                              overflow: TextOverflow.ellipsis,
                            ),
                          )))
                      .toList(),

                  onChanged: (val) {
                    editToolInfo.toolType = val;
                    setState(() {});
                  },
                ))
              ],
            ),
            Row(
              children: [
                SizedBox(
                  width: 80.0,
                  child: RichText(
                      text: TextSpan(
                    // text: '*',
                    // style: TextStyle(color: Colors.redAccent),
                    children: [
                      TextSpan(
                          text: '刀具半径:', style: TextStyle(color: Colors.black))
                    ],
                  )),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  child: FluentUI.NumberBox<double>(
                    smallChange: 0.1,
                    mode: FluentUI.SpinButtonPlacementMode.none,
                    placeholder: '请输入',
                    value: (editToolInfo.toolRadius != null &&
                            editToolInfo.toolRadius!.isNotEmpty)
                        ? double.tryParse(editToolInfo.toolRadius!)
                        : null,
                    onChanged: (value) {
                      editToolInfo.toolRadius =
                          value != null ? value.toString() : '';
                      // setState(() {});
                    },
                  ),
                )
              ],
            ),
            // Row(
            //   children: [
            //     SizedBox(
            //       width: 80.0,
            //       child: RichText(
            //           text: TextSpan(
            //         text: '*',
            //         style: TextStyle(color: Colors.redAccent),
            //         children: [
            //           TextSpan(
            //               text: '对刀模式:', style: TextStyle(color: Colors.black))
            //         ],
            //       )),
            //     ),
            //     SizedBox(
            //       width: 10.0,
            //     ),
            //     Expanded(
            //         child: FluentUI.ComboBox<String>(
            //       isExpanded: true,
            //       value: editToolInfo.toolSettingMode,
            //       placeholder: Text('请选择'),
            //       items: [
            //         FluentUI.ComboBoxItem(
            //             value: '1',
            //             child: Tooltip(
            //               message: '1',
            //               child: Text(
            //                 '对刀1',
            //                 overflow: TextOverflow.ellipsis,
            //               ),
            //             ))
            //       ],
            //       onChanged: (val) {
            //         editToolInfo.toolSettingMode = val;
            //         setState(() {});
            //       },
            //     ))
            //   ],
            // ),
            Row(
              children: [
                SizedBox(
                  width: 80.0,
                  child: RichText(
                      text: TextSpan(
                    // text: '*',
                    // style: TextStyle(color: Colors.redAccent),
                    children: [
                      TextSpan(
                          text: '测量深度:', style: TextStyle(color: Colors.black))
                    ],
                  )),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  child: FluentUI.NumberBox<double>(
                    smallChange: 0.1,
                    mode: FluentUI.SpinButtonPlacementMode.none,
                    placeholder: '请输入',
                    value: (editToolInfo.measuringDepth != null &&
                            editToolInfo.measuringDepth!.isNotEmpty)
                        ? double.tryParse(editToolInfo.measuringDepth!)
                        : null,
                    onChanged: (value) {
                      editToolInfo.measuringDepth =
                          value != null ? value.toString() : '';
                      // setState(() {});
                    },
                  ),
                )
              ],
            ),
          ],
        ))
      ]),
    ).border(all: 1, color: Colors.grey);
  }

  // 说明参数
  Widget _buildDescParams() {
    return Container(
      padding: EdgeInsets.all(10),
      width: double.infinity,
      child: Column(children: [
        SizedBox(
          width: double.infinity,
          child: Text(
            '说明参数',
          ).fontWeight(FontWeight.bold),
        ),
        Divider(),
        Expanded(
            child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 6.5,
          children: [
            // Row(
            //   children: [
            //     SizedBox(
            //       width: 80.0,
            //       child: RichText(
            //           text: TextSpan(
            //         // text: '*',
            //         // style: TextStyle(color: Colors.redAccent),
            //         children: [
            //           TextSpan(
            //               text: '用途参数1:', style: TextStyle(color: Colors.black))
            //         ],
            //       )),
            //     ),
            //     SizedBox(
            //       width: 10.0,
            //     ),
            //     Expanded(
            //       child: FluentUI.TextFormBox(
            //         placeholder: '请输入',
            //         onSaved: (newValue) {},
            //         onChanged: (value) {},
            //         validator: (text) {
            //           if (text == null || text.isEmpty) {
            //             return '必填';
            //           }
            //           return null;
            //         },
            //       ),
            //     )
            //   ],
            // ),
            // Row(
            //   children: [
            //     SizedBox(
            //       width: 80.0,
            //       child: RichText(
            //           text: TextSpan(
            //         // text: '*',
            //         // style: TextStyle(color: Colors.redAccent),
            //         children: [
            //           TextSpan(
            //               text: '用途参数2:', style: TextStyle(color: Colors.black))
            //         ],
            //       )),
            //     ),
            //     SizedBox(
            //       width: 10.0,
            //     ),
            //     Expanded(
            //       child: FluentUI.TextFormBox(
            //         placeholder: '请输入',
            //         onSaved: (newValue) {},
            //         onChanged: (value) {},
            //         validator: (text) {
            //           if (text == null || text.isEmpty) {
            //             return '必填';
            //           }
            //           return null;
            //         },
            //       ),
            //     )
            //   ],
            // ),
            // Row(
            //   children: [
            //     SizedBox(
            //       width: 80.0,
            //       child: RichText(
            //           text: TextSpan(
            //         // text: '*',
            //         // style: TextStyle(color: Colors.redAccent),
            //         children: [
            //           TextSpan(
            //               text: '用途参数3:', style: TextStyle(color: Colors.black))
            //         ],
            //       )),
            //     ),
            //     SizedBox(
            //       width: 10.0,
            //     ),
            //     Expanded(
            //       child: FluentUI.TextFormBox(
            //         placeholder: '请输入',
            //         onSaved: (newValue) {},
            //         onChanged: (value) {},
            //         validator: (text) {
            //           if (text == null || text.isEmpty) {
            //             return '必填';
            //           }
            //           return null;
            //         },
            //       ),
            //     )
            //   ],
            // ),
            // Row(
            //   children: [
            //     SizedBox(
            //       width: 80.0,
            //       child: RichText(
            //           text: TextSpan(
            //         // text: '*',
            //         // style: TextStyle(color: Colors.redAccent),
            //         children: [
            //           TextSpan(
            //               text: '用途参数4:', style: TextStyle(color: Colors.black))
            //         ],
            //       )),
            //     ),
            //     SizedBox(
            //       width: 10.0,
            //     ),
            //     Expanded(
            //       child: FluentUI.TextFormBox(
            //         placeholder: '请输入',
            //         onSaved: (newValue) {},
            //         onChanged: (value) {},
            //         validator: (text) {
            //           if (text == null || text.isEmpty) {
            //             return '必填';
            //           }
            //           return null;
            //         },
            //       ),
            //     )
            //   ],
            // ),
            Row(
              children: [
                SizedBox(
                  width: 80.0,
                  child: RichText(
                      text: TextSpan(
                    // text: '*',
                    // style: TextStyle(color: Colors.redAccent),
                    children: [
                      TextSpan(
                          text: '备注:', style: TextStyle(color: Colors.black))
                    ],
                  )),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  child: FluentUI.TextFormBox(
                    placeholder: '请输入',
                    initialValue: editToolInfo.remark,
                    onSaved: (newValue) {
                      editToolInfo.remark = newValue;
                    },
                    onChanged: (value) {
                      editToolInfo.remark = value;
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
        ))
      ]),
    ).border(all: 1, color: Colors.grey);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        Expanded(
            child: Row(
          children: [
            Expanded(child: _buildBase()),
            SizedBox(
              width: 10.0,
            ),
            Expanded(child: _buildCraft()),
          ],
        )),
        SizedBox(
          height: 10.0,
        ),
        Expanded(
            child: Row(
          children: [
            Expanded(child: _buildToolParams()),
            SizedBox(
              width: 10.0,
            ),
            Expanded(child: _buildDescParams()),
          ],
        )),
      ],
    ));
  }
}

class EditToolInfo {
  String? toolId;
  String? machineName;
  String? toolCode;
  String? toolName;
  String? protrudingLength;
  String? magazineNo;
  String? handleCode;
  String? realToolRatedLife;
  String? realToolUsedLife;
  String? lengthWear;
  String? radiusWear;
  String? toolType;
  String? toolRadius;
  String? toolSettingMode;
  String? measuringDepth;
  String? lengthTolerance;
  String? radiusTolerance;
  String? remark;
  String? useParam1;
  String? useParam2;
  String? useParam3;
  String? useParam4;

  EditToolInfo({
    this.toolId,
    this.machineName,
    this.toolCode,
    this.toolName,
    this.protrudingLength,
    this.magazineNo,
    this.handleCode,
    this.realToolRatedLife,
    this.realToolUsedLife,
    this.lengthWear,
    this.radiusWear,
    this.toolType,
    this.toolRadius,
    this.toolSettingMode,
    this.measuringDepth,
    this.lengthTolerance,
    this.radiusTolerance,
    this.remark,
    this.useParam1,
    this.useParam2,
    this.useParam3,
    this.useParam4,
  });

  EditToolInfo.fromJson(Map<String, dynamic> json) {
    toolId = json['toolId'];
    machineName = json['machineName'];
    toolCode = json['toolCode'];
    toolName = json['toolName'];
    protrudingLength = json['protrudingLength'];
    magazineNo = json['magazineNo'];
    handleCode = json['handleCode'];
    realToolRatedLife = json['realToolRatedLife'];
    realToolUsedLife = json['realToolUsedLife'];
    lengthWear = json['lengthWear'];
    radiusWear = json['radiusWear'];
    toolType = json['toolType'];
    toolRadius = json['toolRadius'];
    toolSettingMode = json['toolSettingMode'];
    measuringDepth = json['measuringDepth'];
    lengthTolerance = json['lengthTolerance'];
    radiusTolerance = json['radiusTolerance'];
    remark = json['remark'];
    useParam1 = json['useParam1'];
    useParam2 = json['useParam2'];
    useParam3 = json['useParam3'];
    useParam4 = json['useParam4'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['toolId'] = this.toolId;
    data['machineName'] = this.machineName;
    data['toolCode'] = this.toolCode;
    data['toolName'] = this.toolName;
    data['protrudingLength'] = this.protrudingLength;
    data['magazineNo'] = this.magazineNo;
    data['handleCode'] = this.handleCode;
    data['realToolRatedLife'] = this.realToolRatedLife;
    data['realToolUsedLife'] = this.realToolUsedLife;
    data['lengthWear'] = this.lengthWear;
    data['radiusWear'] = this.radiusWear;
    data['toolType'] = this.toolType;
    data['toolRadius'] = this.toolRadius;
    data['toolSettingMode'] = this.toolSettingMode;
    data['measuringDepth'] = this.measuringDepth;
    data['lengthTolerance'] = this.lengthTolerance;
    data['radiusTolerance'] = this.radiusTolerance;
    data['remark'] = this.remark;
    data['useParam1'] = this.useParam1;
    data['useParam2'] = this.useParam2;
    data['useParam3'] = this.useParam3;
    data['useParam4'] = this.useParam4;
    return data;
  }

  bool validator() {
    var fields = [
      machineName,
      toolName,
      magazineNo,
      lengthTolerance,
      toolType,
      // toolSettingMode
    ];
    return fields.every((element) => element != null && element.isNotEmpty);
  }
}
