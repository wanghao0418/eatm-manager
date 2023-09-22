import 'package:eatm_manager/common/utils/popup_message.dart';
import 'package:eatm_manager/pages/business/maintenance_system/maintenance_management/models.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:styled_widget/styled_widget.dart';

class AddEquipmentForm extends StatefulWidget {
  const AddEquipmentForm({Key? key}) : super(key: key);

  @override
  AddEquipmentFormState createState() => AddEquipmentFormState();
}

class AddEquipmentFormState extends State<AddEquipmentForm> {
  AddEquipment addForm = AddEquipment();

  bool confirm() {
    if (addForm.validate() == false) {
      PopupMessage.showWarningInfoBar('请确认必填项');
      return false;
    }
    return true;
  }

  Widget _buildFirstRow() {
    return Row(
      children: [
        Expanded(
            child: InfoLabel.rich(
          label: TextSpan(children: [
            TextSpan(text: '*').textColor(Colors.red),
            TextSpan(text: '设备编号:'),
          ]),
          child: TextBox(
            placeholder: '设备编号',
            onChanged: (value) {
              addForm.deviceNum = value;
            },
          ),
        )),
        10.horizontalSpace,
        Expanded(
            child: InfoLabel(
          label: '使用部门:',
          child: TextBox(
            placeholder: '使用部门',
            onChanged: (value) {
              addForm.userDepartment = value;
            },
          ),
        )),
        10.horizontalSpace,
        Expanded(
            child: InfoLabel(
          label: '设备名称:',
          child: TextBox(
            placeholder: '设备名称',
            onChanged: (value) {
              addForm.deviceName = value;
            },
          ),
        )),
      ],
    );
  }

  Widget _buildSecondRow() {
    return Row(
      children: [
        Expanded(
            child: InfoLabel.rich(
          label: TextSpan(children: [
            TextSpan(text: '*').textColor(Colors.red),
            TextSpan(text: '设备类型:'),
          ]),
          child: TextBox(
            placeholder: '设备类型',
            onChanged: (value) {
              addForm.deviceType = value;
            },
          ),
        )),
        10.horizontalSpace,
        Expanded(
            child: InfoLabel(
          label: '设备型号:',
          child: TextBox(
            placeholder: '设备型号',
            onChanged: (value) {
              addForm.deviceModel = value;
            },
          ),
        )),
        10.horizontalSpace,
        Expanded(
            child: InfoLabel(
          label: '设备位置:',
          child: TextBox(
            placeholder: '设备位置',
            onChanged: (value) {
              addForm.devicePos = value;
            },
          ),
        )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: _buildFirstRow(),
        ),
        Expanded(
          child: _buildSecondRow(),
        )
      ],
    );
  }
}
