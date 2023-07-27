/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-05-31 17:45:37
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-07-26 18:43:38
 * @FilePath: /eatm_manager/lib/common/store/user.dart
 * @Description:  用户信息
 */
import 'package:eatm_manager/common/api/user.dart';
import 'package:eatm_manager/common/routers/names.dart';
import 'package:eatm_manager/common/utils/http.dart';
import 'package:eatm_manager/common/utils/popup_message.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:convert';

class UserStore extends GetxController {
  static UserStore get instance => Get.find();
  final GetStorage _storage = GetStorage('user');
  // 是否登录
  final _isLogin = true.obs;
  // 令牌 token
  String token = '';

  bool get isLogin => _isLogin.value;
  bool get hasToken => token.isNotEmpty;

  @override
  void onInit() {
    init();
    super.onInit();
  }

  // 初始化
  Future<void> init() async {
    token = _storage.read('token') ?? '';
    _isLogin.value = token.isNotEmpty;
  }

  // 保存用户信息
  Future<void> setUserInfo(Map<String, dynamic> userInfo) async {
    _storage.write('userInfo', userInfo);
  }

  UserInfo getCurrentUserInfo() {
    var userInfo = _storage.read('userInfo');
    return userInfo == null ? UserInfo() : UserInfo.fromMap(userInfo);
  }

  // 保存 token
  Future<void> setToken(String value) async {
    token = value;
    _storage.write('token', value);
    _isLogin.value = true;
  }

  // 注销
  Future<void> onLogout() async {
    _isLogin.value = false;
    _storage.remove('token');
    token = '';
    Get.offAndToNamed(RouteNames.systemLogin);
  }

  // 保存用户名密码
  Future<void> rememberAccount(
      bool isRemember, String userName, String password) async {
    _storage.write('login_remember', isRemember);
    _storage.write('login_userName', userName);
    _storage.write('login_password', password);
  }
}

class UserInfo {
  bool? selected;
  String? id;
  String? userId;
  String? nickName;
  String? avatarUrl;
  String? gender;
  String? country;
  String? province;
  String? city;
  String? name;
  String? school;
  String? major;
  String? birthday;
  String? entrance;
  String? hometown;
  String? memo;
  String? deptId;
  String? deptName;
  String? createTime;
  String? updateTime;
  String? userName;

  UserInfo({
    this.selected,
    this.id,
    this.userId,
    this.nickName,
    this.avatarUrl,
    this.gender,
    this.country,
    this.province,
    this.city,
    this.name,
    this.school,
    this.major,
    this.birthday,
    this.entrance,
    this.hometown,
    this.memo,
    this.deptId,
    this.deptName,
    this.createTime,
    this.updateTime,
    this.userName,
  });

  UserInfo copyWith({
    bool? selected,
    String? id,
    String? userId,
    String? nickName,
    String? avatarUrl,
    String? gender,
    String? country,
    String? province,
    String? city,
    String? name,
    String? school,
    String? major,
    String? birthday,
    String? entrance,
    String? hometown,
    String? memo,
    String? deptId,
    String? deptName,
    String? createTime,
    String? updateTime,
    String? userName,
  }) {
    return UserInfo(
      selected: selected ?? this.selected,
      id: id ?? this.id,
      userId: userId ?? this.userId,
      nickName: nickName ?? this.nickName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      gender: gender ?? this.gender,
      country: country ?? this.country,
      province: province ?? this.province,
      city: city ?? this.city,
      name: name ?? this.name,
      school: school ?? this.school,
      major: major ?? this.major,
      birthday: birthday ?? this.birthday,
      entrance: entrance ?? this.entrance,
      hometown: hometown ?? this.hometown,
      memo: memo ?? this.memo,
      deptId: deptId ?? this.deptId,
      deptName: deptName ?? this.deptName,
      createTime: createTime ?? this.createTime,
      updateTime: updateTime ?? this.updateTime,
      userName: userName ?? this.userName,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'selected': selected,
      'id': id,
      'userId': userId,
      'nickName': nickName,
      'avatarUrl': avatarUrl,
      'gender': gender,
      'country': country,
      'province': province,
      'city': city,
      'name': name,
      'school': school,
      'major': major,
      'birthday': birthday,
      'entrance': entrance,
      'hometown': hometown,
      'memo': memo,
      'deptId': deptId,
      'deptName': deptName,
      'createTime': createTime,
      'updateTime': updateTime,
      'userName': userName,
    };
  }

  factory UserInfo.fromMap(Map<String?, dynamic> map) {
    return UserInfo(
      selected: map['selected'],
      id: map['id'],
      userId: map['userId'],
      nickName: map['nickName'],
      avatarUrl: map['avatarUrl'],
      gender: map['gender'],
      country: map['country'],
      province: map['province'],
      city: map['city'],
      name: map['name'],
      school: map['school'],
      major: map['major'],
      birthday: map['birthday'],
      entrance: map['entrance'],
      hometown: map['hometown'],
      memo: map['memo'],
      deptId: map['deptId'],
      deptName: map['deptName'],
      createTime: map['createTime'],
      updateTime: map['updateTime'],
      userName: map['userName'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserInfo.fromJson(String source) =>
      UserInfo.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserInfo(selected: $selected, id: $id, userId: $userId, nickName: $nickName, avatarUrl: $avatarUrl, gender: $gender, country: $country, province: $province, city: $city, name: $name, school: $school, major: $major, birthday: $birthday, entrance: $entrance, hometown: $hometown, memo: $memo, deptId: $deptId, deptName: $deptName, createTime: $createTime, updateTime: $updateTime, userName: $userName)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is UserInfo &&
        o.selected == selected &&
        o.id == id &&
        o.userId == userId &&
        o.nickName == nickName &&
        o.avatarUrl == avatarUrl &&
        o.gender == gender &&
        o.country == country &&
        o.province == province &&
        o.city == city &&
        o.name == name &&
        o.school == school &&
        o.major == major &&
        o.birthday == birthday &&
        o.entrance == entrance &&
        o.hometown == hometown &&
        o.memo == memo &&
        o.deptId == deptId &&
        o.deptName == deptName &&
        o.createTime == createTime &&
        o.updateTime == updateTime &&
        o.userName == userName;
  }

  @override
  int get hashCode {
    return selected.hashCode ^
        id.hashCode ^
        userId.hashCode ^
        nickName.hashCode ^
        avatarUrl.hashCode ^
        gender.hashCode ^
        country.hashCode ^
        province.hashCode ^
        city.hashCode ^
        name.hashCode ^
        school.hashCode ^
        major.hashCode ^
        birthday.hashCode ^
        entrance.hashCode ^
        hometown.hashCode ^
        memo.hashCode ^
        deptId.hashCode ^
        deptName.hashCode ^
        createTime.hashCode ^
        updateTime.hashCode ^
        userName.hashCode;
  }
}
