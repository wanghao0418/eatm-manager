// 设备
class Equipment {
  int? id;
  String? equipmentNo;
  String? equipmentName;
  String? equipmentType;
  String? equipmentModel;
  String? userDepartment;
  String? equipmentPosition;

  Equipment(
      {this.id,
      this.equipmentNo,
      this.equipmentName,
      this.equipmentType,
      this.equipmentModel,
      this.userDepartment,
      this.equipmentPosition});

  Equipment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    equipmentNo = json['equipmentNo'];
    equipmentName = json['equipmentName'];
    equipmentType = json['equipmentType'];
    equipmentModel = json['equipmentModel'];
    userDepartment = json['userDepartment'];
    equipmentPosition = json['equipmentPosition'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['equipmentNo'] = this.equipmentNo;
    data['equipmentName'] = this.equipmentName;
    data['equipmentType'] = this.equipmentType;
    data['equipmentModel'] = this.equipmentModel;
    data['userDepartment'] = this.userDepartment;
    data['equipmentPosition'] = this.equipmentPosition;
    return data;
  }
}

// 新增设备表单
class AddEquipment {
  String? deviceNum;
  String? devicePos;
  String? deviceName;
  String? deviceType;
  String? deviceModel;
  String? userDepartment;
  AddEquipment({
    this.deviceNum,
    this.devicePos,
    this.deviceName,
    this.deviceType,
    this.deviceModel,
    this.userDepartment,
  });

  AddEquipment.fromJson(Map<String, dynamic> json) {
    deviceNum = json['DeviceNum'];
    devicePos = json['DevicePos'];
    deviceName = json['DeviceName'];
    deviceType = json['DeviceType'];
    deviceModel = json['DeviceModel'];
    userDepartment = json['UserDepartment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DeviceNum'] = this.deviceNum;
    data['DevicePos'] = this.devicePos;
    data['DeviceName'] = this.deviceName;
    data['DeviceType'] = this.deviceType;
    data['DeviceModel'] = this.deviceModel;
    data['UserDepartment'] = this.userDepartment;
    return data;
  }

  bool validate() {
    return deviceNum != null && deviceType != null;
  }
}
