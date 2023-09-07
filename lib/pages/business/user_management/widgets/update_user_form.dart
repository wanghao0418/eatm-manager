/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-09-05 16:23:44
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-09-05 17:13:37
 * @FilePath: /eatm_manager/lib/pages/business/user_management/widgets/update_user_form.dart
 * @Description: 更新用户信息
 */
import 'package:eatm_manager/common/components/line_form_label.dart';
import 'package:eatm_manager/common/models/userInfo.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'dart:convert';

class UpdateUserForm extends StatefulWidget {
  const UpdateUserForm({Key? key, this.updateUserInfo}) : super(key: key);
  final UserInfo? updateUserInfo;

  @override
  UpdateUserFormState createState() => UpdateUserFormState();
}

class UpdateUserFormState extends State<UpdateUserForm> {
  late UserInfo userInfoEdit;

  @override
  void initState() {
    // TODO: implement initState
    userInfoEdit =
        widget.updateUserInfo != null ? widget.updateUserInfo! : UserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.all(10),
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Row(
          children: [
            Expanded(
                child: LineFormLabel(
              label: '用户名',
              isRequired: true,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              child: SizedBox(
                width: 300.0,
                child: TextFormBox(
                  placeholder: '用户名',
                  initialValue: userInfoEdit.userName,
                  onChanged: (value) {
                    userInfoEdit.userName = value;
                  },
                ),
              ),
            ))
          ],
        ),
        Row(
          children: [
            Expanded(
                child: LineFormLabel(
              label: '权限',
              isRequired: true,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              child: SizedBox(
                width: 300.0,
                child: ComboBox<String>(
                  placeholder: const Text('用户权限'),
                  items: const [
                    ComboBoxItem(
                      value: '1',
                      child: Text(
                        '一级权限',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    ComboBoxItem(
                      value: '2',
                      child: Text(
                        '二级权限',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    ComboBoxItem(
                      value: '3',
                      child: Text(
                        '三级权限',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    ComboBoxItem(
                      value: '4',
                      child: Text(
                        '四级权限',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                  value: userInfoEdit.userId,
                  onChanged: (value) {
                    userInfoEdit.userId = value;
                    setState(() {});
                  },
                ),
              ),
            ))
          ],
        ),
        Row(
          children: [
            Expanded(
                child: LineFormLabel(
              label: '密码',
              isRequired: true,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              child: SizedBox(
                width: 300.0,
                child: TextFormBox(
                  placeholder: '密码',
                  initialValue: userInfoEdit.nickName,
                  onChanged: (value) {
                    userInfoEdit.nickName = value;
                  },
                ),
              ),
            ))
          ],
        ),
      ]),
    );
  }
}

// class UserInfoEdit {
//   String? userName;
//   String? userId;
//   String? nickName;

//   UserInfoEdit({
//     this.userName,
//     this.userId,
//     this.nickName,
//   });

//   factory UserInfoEdit.fromJson(String str) =>
//       UserInfoEdit.fromMap(json.decode(str));

//   String toJson() => json.encode(toMap());

//   factory UserInfoEdit.fromMap(Map<String, dynamic> json) => UserInfoEdit(
//         userName: json["userName"],
//         userId: json["userId"],
//         nickName: json["nickName"],
//       );

//   Map<String, dynamic> toMap() => {
//         "userName": userName,
//         "userId": userId,
//         "nickName": nickName,
//       };

//   // 校验
//   bool validate() {
//     return userName != null && userId != null && nickName != null;
//   }
// }
