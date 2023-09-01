/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-09-01 18:04:30
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-09-01 18:42:14
 * @FilePath: /eatm_manager/lib/pages/business/electrode_binding/widgets/clip_binding_table.dart
 * @Description: 电极绑定表格
 */
import 'package:eatm_manager/common/style/global_theme.dart';
import 'package:eatm_manager/pages/business/electrode_binding/models.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:pluto_grid/pluto_grid.dart';

class ClipBindingTable extends StatefulWidget {
  const ClipBindingTable({Key? key, required this.chipBindDataList})
      : super(key: key);
  final List<ChipBindData> chipBindDataList;
  @override
  _ClipBindingTableState createState() => _ClipBindingTableState();
}

class _ClipBindingTableState extends State<ClipBindingTable> {
  GlobalTheme get globalTheme => GlobalTheme.instance;
  late PlutoGridStateManager stateManager;
  List<PlutoRow> rows = [];
  int? selectIndex;

  // 更新表格
  void updateRows() {
    rows.clear();
    for (var rowData in widget.chipBindDataList) {
      var index = widget.chipBindDataList.indexOf(rowData);
      var row = PlutoRow(cells: {
        'index': PlutoCell(value: index + 1),
        'chipId': PlutoCell(value: rowData.strChipFascia),
        'electrodeNo': PlutoCell(value: rowData.strElectrodeNo),
        'specifications': PlutoCell(value: rowData.strSpecifications),
        'materialQuality': PlutoCell(value: rowData.strTextureMaterial),
        'preHeightAdjustment': PlutoCell(value: rowData.strPresetHeight),
        'clamp': PlutoCell(value: rowData.strFixture),
        'X': PlutoCell(value: rowData.strX),
        'Y': PlutoCell(value: rowData.strY),
        'Z': PlutoCell(value: rowData.strZ),
        'data': PlutoCell(value: rowData)
      });
      stateManager.appendRows([row]);
    }
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PlutoGrid(
      columns: [
        PlutoColumn(
            title: '勾选',
            field: 'index',
            type: PlutoColumnType.number(),
            readOnly: true,
            // enableRowChecked: true,
            minWidth: 85,
            width: 85,
            enableEditingMode: false,
            frozen: PlutoColumnFrozen.start,
            renderer: (rendererContext) {
              var rowIndex = rendererContext.cell.value;

              return Center(
                child: SizedBox(
                  width: 20.0,
                  height: 20,
                  child: Checkbox(
                      checked: selectIndex == rowIndex,
                      onChanged: (val) {
                        selectIndex = val == true ? rowIndex : null;
                        stateManager.toggleAllRowChecked(false);

                        if (val == true) {
                          stateManager.setRowChecked(rendererContext.row, val!,
                              notify: true);
                        }
                        setState(() {});
                      }),
                ),
              );
            }),
        PlutoColumn(
          title: '芯片Id',
          field: 'chipId',
          type: PlutoColumnType.text(),
          readOnly: true,
        ),
        PlutoColumn(
          title: '工件编号',
          field: 'electrodeNo',
          type: PlutoColumnType.text(),
          readOnly: true,
        ),
        PlutoColumn(
          title: '尺寸',
          field: 'specifications',
          type: PlutoColumnType.text(),
          readOnly: true,
        ),
        PlutoColumn(
          title: '类型',
          field: 'materialQuality',
          type: PlutoColumnType.text(),
          readOnly: true,
        ),
        PlutoColumn(
          title: '预调高度',
          field: 'preHeightAdjustment',
          type: PlutoColumnType.text(),
          readOnly: true,
        ),
        PlutoColumn(
          title: '夹具',
          field: 'clamp',
          type: PlutoColumnType.text(),
          readOnly: true,
        ),
        PlutoColumn(
          title: 'X',
          field: 'X',
          type: PlutoColumnType.text(),
          readOnly: true,
        ),
        PlutoColumn(
          title: 'Y',
          field: 'Y',
          type: PlutoColumnType.text(),
          readOnly: true,
        ),
        PlutoColumn(
          title: 'Z',
          field: 'Z',
          type: PlutoColumnType.text(),
          readOnly: true,
        ),
        PlutoColumn(
          title: '',
          field: 'data',
          type: PlutoColumnType.text(),
          readOnly: true,
          hide: true,
        ),
      ],
      rows: rows,
      onLoaded: (event) {
        stateManager = event.stateManager;
        updateRows();
      },
      configuration: globalTheme.plutoGridConfig,
    );
  }
}
