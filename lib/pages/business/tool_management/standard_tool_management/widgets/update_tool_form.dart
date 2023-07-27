/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-07-06 15:23:07
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-07-12 09:11:40
 * @FilePath: /flutter-mesui/lib/pages/tool_management/standard_tool_management/widgets/update_tool_form.dart
 */
import 'package:fluent_ui/fluent_ui.dart';

class UpdateToolForm extends StatefulWidget {
  const UpdateToolForm({Key? key, this.toolName, this.ratedLife})
      : super(key: key);
  final String? toolName;
  final String? ratedLife;

  @override
  UpdateToolFormState createState() => UpdateToolFormState();
}

class UpdateToolFormState extends State<UpdateToolForm> {
  final _formKey = GlobalKey<FormState>();
  late ToolInfo toolInfo;

  comfirm() => _formKey.currentState!.validate();

  init() {
    toolInfo = ToolInfo(
      toolName: widget.toolName ?? null,
      ratedLife: widget.ratedLife ?? null,
    );
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InfoLabel(
                label: '刀具名称:',
                child: TextFormBox(
                  initialValue: toolInfo.toolName,
                  placeholder: '请输入',
                  onChanged: (value) {
                    toolInfo.toolName = value;
                  },
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return '必填';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              InfoLabel(
                label: '额定寿命(分钟):',
                child: NumberBox<int>(
                  placeholder: '请输入',
                  // value: toolInfo.ratedLife != null
                  //     ? int.parse(toolInfo.ratedLife!).toString()
                  //     : null,
                  value: toolInfo.ratedLife != null
                      ? int.parse(toolInfo.ratedLife!)
                      : null,
                  mode: SpinButtonPlacementMode.inline,
                  onChanged: (val) {
                    toolInfo.ratedLife = val != null ? val.toString() : '';
                  },
                  // validator: (text) {
                  //   if (text == null || text.isEmpty) {
                  //     return '必填';
                  //   }
                  //   return null;
                  // },
                ),
              ),
              // NumberFormBox(
              //   value: toolInfo.ratedLife != null
              //       ? int.parse(toolInfo.ratedLife!)
              //       : null,
              //   onChanged: (val) {
              //     toolInfo.ratedLife = val != null ? val.toString() : '0';
              //   },
              //   autovalidateMode: AutovalidateMode.always,
              //   validator: (v) {
              //     if (v == null || int.tryParse(v) == null) {
              //       return '必填';
              //     }

              //     return null;
              //   },
              // ),
            ],
          )),
    );
  }
}

class ToolInfo {
  String? toolName;
  String? ratedLife;

  ToolInfo({this.toolName, this.ratedLife});

  ToolInfo.fromJson(Map<String, dynamic> json) {
    toolName = json['toolName'];
    ratedLife = json['ratedLife'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['toolName'] = toolName;
    data['ratedLife'] = ratedLife;
    return data;
  }

  bool validator() {
    var fields = [toolName, ratedLife];
    return fields.every((element) => element != null && element.isNotEmpty);
  }
}
