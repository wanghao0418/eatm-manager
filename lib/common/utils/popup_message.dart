/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-06-14 14:48:08
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-08-15 11:37:56
 * @FilePath: /eatm_ini_config/lib/common/utils/popup_message.dart
 * @Description: 弹窗消息
 */
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class PopupMessage {
  // 显示成功消息
  static void showSuccessInfoBar(String message) {
    SmartDialog.show(
        displayTime: Duration(seconds: 3),
        debounce: true,
        alignment: Alignment.topCenter,
        maskColor: Colors.transparent,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(top: 10),
            child: InfoBar(
              title: const Text('成功'),
              content: Text(message),
              action: IconButton(
                icon: const Icon(FluentIcons.clear),
                onPressed: () {
                  SmartDialog.dismiss();
                },
              ),
              severity: InfoBarSeverity.success,
            ),
          );
        });
  }

  // 显示失败消息
  static void showFailInfoBar(String message) {
    SmartDialog.show(
        displayTime: Duration(seconds: 3),
        debounce: true,
        alignment: Alignment.topCenter,
        maskColor: Colors.transparent,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(top: 10),
            child: InfoBar(
              title: const Text('失败'),
              content: Text(message),
              action: IconButton(
                icon: const Icon(FluentIcons.clear),
                onPressed: () {
                  SmartDialog.dismiss();
                },
              ),
              severity: InfoBarSeverity.error,
            ),
          );
        });
  }

  // 显示警告消息
  static void showWarningInfoBar(String message) {
    SmartDialog.show(
        displayTime: Duration(seconds: 3),
        debounce: true,
        alignment: Alignment.topCenter,
        maskColor: Colors.transparent,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(top: 10),
            child: InfoBar(
              title: const Text('提示'),
              content: Text(message),
              action: IconButton(
                icon: const Icon(FluentIcons.clear),
                onPressed: () {
                  SmartDialog.dismiss();
                },
              ),
              severity: InfoBarSeverity.warning,
            ),
          );
        });
  }

  // 显示loading
  static void showLoading({String? message}) {
    SmartDialog.showLoading(
        alignment: Alignment.center,
        // usePenetrate: true,
        builder: (context) {
          return Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              ProgressRing(),
              SizedBox(height: 10),
              Text(
                message != null ? message : '加载中，请稍候...',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ]),
          );
        });
  }

  // 关闭loading
  static void closeLoading() {
    SmartDialog.dismiss(status: SmartStatus.loading);
  }

  // 显示确认框
  static void showConfirmDialog(
      {required String title,
      required String message,
      required Function onConfirm}) {
    SmartDialog.show(
        alignment: Alignment.center,
        debounce: true,
        builder: (context) {
          return ContentDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              Button(
                child: const Text('取消'),
                onPressed: () {
                  SmartDialog.dismiss();
                },
              ),
              FilledButton(
                child: const Text('确定'),
                onPressed: () {
                  SmartDialog.dismiss();
                  onConfirm();
                },
              ),
            ],
          );
        });
  }
}
