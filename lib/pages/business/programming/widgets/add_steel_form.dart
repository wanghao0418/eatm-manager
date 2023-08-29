/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-08-29 13:38:30
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-08-29 15:36:24
 * @FilePath: /eatm_manager/lib/pages/business/programming/widgets/add_steel_form.dart
 * @Description:  添加钢件表单
 */
import 'package:eatm_manager/common/components/line_form_label.dart';
import 'package:eatm_manager/common/models/selectOption.dart';
import 'package:eatm_manager/pages/business/programming/model.dart';
import 'package:fluent_ui/fluent_ui.dart';

class AddSteelForm extends StatefulWidget {
  const AddSteelForm({Key? key, required this.steelEDMDataList})
      : super(key: key);
  final List<SteelEDMData> steelEDMDataList;

  @override
  AddSteelFormState createState() => AddSteelFormState();
}

class AddSteelFormState extends State<AddSteelForm> {
  // 模号集合
  Map<String, List> steelMouldSNMap = {};
  // 当前钢件EDM数据
  SteelEDMData? currentSteel;
  // 钢件识别码输入控制器
  TextEditingController steelBarcodeController = TextEditingController();
  // 模具编号输入控制器
  TextEditingController mouldSNController = TextEditingController();

  List<SelectOption> get steelSNOptions => (steelMouldSNMap.isNotEmpty ||
          currentSteel == null)
      ? steelMouldSNMap[currentSteel?.steelMouldSN]!
          .map(
              (e) => SelectOption(label: (e as SteelEDMData).steelSN, value: e))
          .toList()
      : [];

  // 起始坐标下拉选项
  List<SelectOption> beginPointOptions = [
    SelectOption(label: 'G34', value: 'G34'),
    SelectOption(label: 'G35', value: 'G35'),
    SelectOption(label: 'G36', value: 'G36'),
  ];

  // 初始化
  void init() {
    for (var steel in widget.steelEDMDataList) {
      if (!steelMouldSNMap.containsKey(steel.steelMouldSN)) {
        steelMouldSNMap[steel.steelMouldSN!] = [steel];
      } else {
        steelMouldSNMap[steel.steelMouldSN!]!.add(steel);
      }
    }
    // 默认选择
    var list =
        steelMouldSNMap.values.isNotEmpty ? steelMouldSNMap.values.first : [];
    currentSteel = list.isNotEmpty ? list.first : null;
    onCurrentSteelChange();
  }

  onCurrentSteelChange() {
    if (currentSteel != null) {
      steelBarcodeController.text = currentSteel!.steelBarcode ?? '';
      mouldSNController.text = currentSteel!.steelMouldSN ?? '';
      setState(() {});
    }
  }

  // 匹配识别码 如果相同则选中钢件
  onBarcodeMatch(String code) {
    for (var steel in widget.steelEDMDataList) {
      if (code == steel.steelBarcode) {
        currentSteel = steel;
        onCurrentSteelChange();
        return;
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 400,
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Row(
          children: [
            Expanded(
                child: LineFormLabel(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              label: '钢件模号',
              child: SizedBox(
                width: 350.0,
                child: ComboBox<String?>(
                  placeholder: const Text('请选择'),
                  value: currentSteel?.steelMouldSN,
                  items: steelMouldSNMap.keys
                      .map((e) => ComboBoxItem<String?>(
                          value: e,
                          child: Tooltip(
                            message: e,
                            child: Text(
                              e,
                              overflow: TextOverflow.ellipsis,
                            ),
                          )))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      currentSteel = (steelMouldSNMap[value] as List).isNotEmpty
                          ? (steelMouldSNMap[value] as List).first
                          : null;
                      onCurrentSteelChange();
                    });
                  },
                ),
              ),
            )),
          ],
        ),
        Row(
          children: [
            Expanded(
                child: LineFormLabel(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              label: '钢件识别码',
              child: SizedBox(
                width: 350,
                child: TextBox(
                  controller: steelBarcodeController,
                  placeholder: '钢件识别码',
                  onChanged: onBarcodeMatch,
                ),
              ),
            )),
          ],
        ),
        Row(
          children: [
            Expanded(
                child: LineFormLabel(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              label: '模具编号',
              child: SizedBox(
                width: 350,
                child: TextBox(
                  controller: mouldSNController,
                  enabled: false,
                  placeholder: '模具编号',
                  onChanged: (value) {},
                ),
              ),
            )),
          ],
        ),
        Row(
          children: [
            Expanded(
                child: LineFormLabel(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              label: '钢件编号',
              child: SizedBox(
                width: 350.0,
                child: ComboBox<SteelEDMData?>(
                  value: currentSteel,
                  placeholder: const Text('请选择'),
                  items: steelSNOptions
                      .map((e) => ComboBoxItem<SteelEDMData?>(
                          value: e.value,
                          child: Tooltip(
                            message: e.label,
                            child: Text(
                              e.label!,
                              overflow: TextOverflow.ellipsis,
                            ),
                          )))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      currentSteel = value;
                      onCurrentSteelChange();
                    });
                  },
                ),
              ),
            )),
          ],
        ),
        Row(
          children: [
            Expanded(
                child: LineFormLabel(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              label: '升油高度',
              child: SizedBox(
                width: 350.0,
                child: NumberBox(
                  value: currentSteel?.oilTankHeight,
                  mode: SpinButtonPlacementMode.none,
                  onChanged: (value) {
                    setState(() {
                      currentSteel!.oilTankHeight = value;
                    });
                  },
                ),
              ),
            )),
          ],
        ),
        Row(
          children: [
            Expanded(
                child: LineFormLabel(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              label: '起始坐标',
              child: SizedBox(
                width: 350.0,
                child: ComboBox<String?>(
                  value: currentSteel?.beginPoint,
                  placeholder: const Text('请选择'),
                  items: beginPointOptions
                      .map((e) => ComboBoxItem<String?>(
                          value: e.value,
                          child: Tooltip(
                            message: e.label,
                            child: Text(
                              e.label!,
                              overflow: TextOverflow.ellipsis,
                            ),
                          )))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      currentSteel!.beginPoint = value;
                    });
                  },
                ),
              ),
            )),
          ],
        ),
      ]),
    );
  }
}
