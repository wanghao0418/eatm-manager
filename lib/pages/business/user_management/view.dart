/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-09-05 14:35:13
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-09-06 10:46:26
 * @FilePath: /eatm_manager/lib/pages/business/user_management/view.dart
 * @Description: 用户管理视图层
 */
import 'package:eatm_manager/common/components/filled_icon_button.dart';
import 'package:eatm_manager/common/components/line_form_label.dart';
import 'package:eatm_manager/common/components/themed_text.dart';
import 'package:eatm_manager/common/components/title_card.dart';
import 'package:eatm_manager/common/models/userInfo.dart';
import 'package:eatm_manager/common/style/global_theme.dart';
import 'package:eatm_manager/common/utils/popup_message.dart';
import 'package:eatm_manager/pages/business/user_management/widgets/update_user_form.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:styled_widget/styled_widget.dart';

import 'index.dart';

class UserManagementPage extends StatefulWidget {
  const UserManagementPage({Key? key}) : super(key: key);

  @override
  State<UserManagementPage> createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const _UserManagementViewGetX();
  }
}

class _UserManagementViewGetX extends GetView<UserManagementController> {
  const _UserManagementViewGetX({Key? key}) : super(key: key);
  GlobalTheme get globalTheme => GlobalTheme.instance;

  // 打开编辑信息弹窗
  void openDialog({isEdit = false}) {
    GlobalKey key = GlobalKey();

    SmartDialog.show(
      tag: 'update_user',
      bindPage: true,
      keepSingle: true,
      builder: (context) {
        return ContentDialog(
          title: Text(isEdit ? '修改' : '新增').fontSize(18),
          constraints: const BoxConstraints(maxWidth: 600, maxHeight: 300),
          content: UpdateUserForm(
            key: key,
            updateUserInfo: isEdit
                ? controller
                    .rows[controller.selectedRowIndex!].cells['data']!.value
                : null,
          ),
          actions: [
            Button(
                child: const Text('取消'),
                onPressed: () => SmartDialog.dismiss(tag: 'update_user')),
            FilledButton(
                child: const Text('确定'),
                onPressed: () {
                  var state = key.currentState as UpdateUserFormState;
                  if (state.userInfoEdit.userName != null &&
                      state.userInfoEdit.userId != null &&
                      state.userInfoEdit.nickName != null) {
                    SmartDialog.dismiss(tag: 'update_user');
                    controller.updateUser(state.userInfoEdit);
                  } else {
                    PopupMessage.showWarningInfoBar('请确认必填项');
                  }
                })
          ],
        );
      },
    );
  }

  // 操作栏
  Widget _buildOperateBar() {
    var formRow = Row(
      children: [
        LineFormLabel(
            label: '用户名',
            width: 250,
            isExpanded: true,
            child: TextBox(
              controller: controller.userNameController,
              placeholder: '用户名',
            ))
      ],
    );

    var buttons = Row(
      children: [
        Expanded(
            child: Wrap(
          spacing: 10,
          runSpacing: 10,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            FilledIconButton(
                icon: FluentIcons.search,
                label: '查询',
                onPressed: controller.query),
            FilledIconButton(
                icon: FluentIcons.sync_occurence,
                label: '重置',
                onPressed: () {
                  controller.userNameController.clear();
                  controller.query();
                  controller.update(['user_management']);
                }),
            FilledIconButton(
                icon: FluentIcons.add, label: '增加', onPressed: openDialog),
            FilledIconButton(
                icon: FluentIcons.edit,
                label: '修改',
                onPressed: controller.selectedRowIndex != null
                    ? () => openDialog(isEdit: true)
                    : null),
            FilledIconButton(
                icon: FluentIcons.delete,
                label: '删除',
                onPressed: controller.selectedRowIndex != null
                    ? () {
                        controller.deleteUser(controller
                            .stateManager.checkedRows
                            .map((e) => e.cells['data']!.value as UserInfo)
                            .toList());
                      }
                    : null),
          ],
        ))
      ],
    );

    return Container(
      padding: globalTheme.contentPadding,
      decoration: globalTheme.contentDecoration,
      child: Column(children: [formRow, 10.verticalSpace, buttons]),
    );
  }

  // 用户表格
  Widget _buildUserTable() {
    var table = PlutoGrid(
      columns: [
        PlutoColumn(
            title: '勾选',
            field: 'index',
            type: PlutoColumnType.text(),
            width: 85,
            frozen: PlutoColumnFrozen.start,
            enableEditingMode: false,
            renderer: (rendererContext) {
              var rowIndex = rendererContext.cell.value;

              return Center(
                child: SizedBox(
                  width: 20.0,
                  height: 20,
                  child: Checkbox(
                      checked: controller.selectedRowIndex == rowIndex,
                      onChanged: (val) {
                        controller.selectedRowIndex =
                            val == true ? rowIndex : null;
                        controller.stateManager.toggleAllRowChecked(false);
                        controller.stateManager.setRowChecked(
                            rendererContext.row, val!,
                            notify: true);
                        controller.update(['user_management']);
                      }),
                ),
              );
            }),
        PlutoColumn(
          title: 'id',
          field: 'id',
          width: 50,
          enableEditingMode: false,
          type: PlutoColumnType.text(),
        ),
        PlutoColumn(
          title: '用户名',
          field: 'userName',
          enableEditingMode: false,
          type: PlutoColumnType.text(),
        ),
        PlutoColumn(
          title: '权限',
          field: 'userId',
          type: PlutoColumnType.text(),
          enableEditingMode: false,
          renderer: (rendererContext) {
            var text = '一级权限';
            switch (rendererContext.cell.value) {
              case '1':
                text = '一级权限';
                break;
              case '2':
                text = '二级权限';
                break;
              case '3':
                text = '三级权限';
                break;
              case '4':
                text = '四级权限';
                break;
              default:
                text = '';
                break;
            }
            return ThemedText(text);
          },
        ),
        PlutoColumn(
          title: '密码',
          field: 'password',
          enableEditingMode: false,
          type: PlutoColumnType.text(),
        ),
        PlutoColumn(
          title: '创建时间',
          field: 'createTime',
          enableEditingMode: false,
          type: PlutoColumnType.text(),
        ),
        PlutoColumn(
          title: '更新时间',
          field: 'updateTime',
          enableEditingMode: false,
          type: PlutoColumnType.text(),
        )
      ],
      rows: controller.rows,
      onLoaded: (event) {
        controller.stateManager = event.stateManager;
        controller.query();
      },
      configuration: globalTheme.plutoGridConfig.copyWith(
          columnSize: const PlutoGridColumnSizeConfig(
              autoSizeMode: PlutoAutoSizeMode.scale)),
    );

    return Container(
      decoration: globalTheme.contentDecoration,
      child: TitleCard(
        title: '用户列表',
        cardBackgroundColor: globalTheme.pageContentBackgroundColor,
        containChild: table,
      ),
    );
  }

  // 主视图
  Widget _buildView() {
    return Container(
      padding: globalTheme.pagePadding,
      child: Column(
        children: [
          _buildOperateBar(),
          globalTheme.contentDistance.verticalSpace,
          Expanded(child: _buildUserTable())
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserManagementController>(
      init: UserManagementController(),
      id: "user_management",
      builder: (_) {
        return ScaffoldPage(
          padding: EdgeInsets.zero,
          content: _buildView(),
        );
      },
    );
  }
}
