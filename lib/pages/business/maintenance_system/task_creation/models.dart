class MaintenanceTaskSearch {
  // 维保人员
  String? name;
  // 设备编号
  String? deviceNum;
  // 维保项目
  String? item;
  // 维保类型
  int? maintenanceType;
  // 点检周期
  String? inspectionCycle;
  String? startTime;
  String? endTime;

  MaintenanceTaskSearch({
    this.name,
    this.deviceNum,
    this.item,
    this.maintenanceType,
    this.inspectionCycle,
    this.startTime,
    this.endTime,
  });

  Map<String, dynamic> toMap() {
    return {
      "Name": name ?? '',
      "DeviceNum": deviceNum ?? '',
      "Item": item ?? '',
      "MaintenanceType": maintenanceType ?? 0,
      "StartTime": startTime ?? '',
      "EndTime": endTime ?? '',
      "InspectionCycle": inspectionCycle ?? "",
    };
  }
}

class MaintenanceTask {
  int? id;
  int? maintenanceType;
  String? maintenanceProject;
  String? equipmentNo;
  String? maintenancePosition;
  String? maintenanceContent;
  String? maintenanceStandard;
  String? maintenanceCycle;
  String? maintenancePersonnel;
  int? timeInterval;

  MaintenanceTask(
      {this.id,
      this.maintenanceType,
      this.maintenanceProject,
      this.equipmentNo,
      this.maintenancePosition,
      this.maintenanceContent,
      this.maintenanceStandard,
      this.maintenanceCycle,
      this.maintenancePersonnel,
      this.timeInterval});

  MaintenanceTask.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    maintenanceType = json['maintenanceType'];
    maintenanceProject = json['maintenanceProject'];
    equipmentNo = json['equipmentNo'];
    maintenancePosition = json['maintenancePosition'];
    maintenanceContent = json['maintenanceContent'];
    maintenanceStandard = json['maintenanceStandard'];
    maintenanceCycle = json['maintenanceCycle'];
    maintenancePersonnel = json['maintenancePersonnel'];
    timeInterval = json['timeInterval'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['maintenanceType'] = this.maintenanceType;
    data['maintenanceProject'] = this.maintenanceProject;
    data['equipmentNo'] = this.equipmentNo;
    data['maintenancePosition'] = this.maintenancePosition;
    data['maintenanceContent'] = this.maintenanceContent;
    data['maintenanceStandard'] = this.maintenanceStandard;
    data['maintenanceCycle'] = this.maintenanceCycle;
    data['maintenancePersonnel'] = this.maintenancePersonnel;
    data['timeInterval'] = this.timeInterval;
    return data;
  }
}

class MaintenanceTaskAdd {
  // 设备编号
  String? deviceNum;
  // 维保人员
  String? name;
  // 提醒时间
  num? reminderInterval;
  // 保养周期
  String? inspectionCycle;
  // 创建时间
  String? createTime;
  // 备注
  String? notes;
  // 关联项目ID
  String? projectID;
  // // 保养项目id
  // String? maintenanceID;
  // // 点检项目id
  // String? spotCheckID;

  MaintenanceTaskAdd({
    this.name,
    this.reminderInterval,
    this.inspectionCycle,
    this.createTime,
    this.deviceNum,
    this.notes,
    this.projectID,
  });

  Map<String, dynamic> toMap() {
    return {
      "DeviceNum": deviceNum ?? '',
      "Name": name ?? '',
      "InspectionCycle": inspectionCycle ?? '',
      "ReminderInterval": reminderInterval ?? 5,
      "CreateTime": createTime ?? '',
      "Notes": notes ?? '',
      "ProjectID": projectID ?? '',
    };
  }

  bool validate() {
    return name != null && inspectionCycle != null;
  }
}
