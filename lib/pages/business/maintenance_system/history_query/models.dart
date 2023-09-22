class HistoryQuery {
  // 维保类别
  int? maintenanceType;
  // 设备编号
  String? deviceNum;
  // 维保项目
  String? item;
  // 维保人员
  String? name;
  // 完成时间
  String? finishTime;

  HistoryQuery(
      {this.maintenanceType,
      this.deviceNum,
      this.item,
      this.name,
      this.finishTime});

  HistoryQuery.fromJson(Map<String, dynamic> json) {
    maintenanceType = json['maintenanceType'];
    deviceNum = json['deviceNum'];
    item = json['item'];
    name = json['name'];
    finishTime = json['finishTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['MaintenanceType'] = this.maintenanceType;
    data['DeviceNum'] = this.deviceNum ?? "";
    data['Item'] = this.item ?? "";
    data['Name'] = this.name ?? "";
    data['FinishTime'] = this.finishTime ?? "";
    return data;
  }
}

class TaskHistory {
  int? id;
  int? maintenanceType;
  String? equipmentNo;
  String? maintenanceProject;
  String? maintenancePosition;
  String? maintenanceContent;
  String? maintenancePersonnel;
  String? exceptionDescription;
  int? maintenanceStatus;
  String? startTime;
  String? endTime;

  TaskHistory(
      {this.id,
      this.maintenanceType,
      this.equipmentNo,
      this.maintenanceProject,
      this.maintenancePosition,
      this.maintenanceContent,
      this.maintenancePersonnel,
      this.exceptionDescription,
      this.maintenanceStatus,
      this.startTime,
      this.endTime});

  TaskHistory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    maintenanceType = json['maintenanceType'] ?? 0;
    equipmentNo = json['equipmentNo'] ?? '';
    maintenanceProject = json['maintenanceProject'] ?? '';
    maintenancePosition = json['maintenancePosition'] ?? '';
    maintenanceContent = json['maintenanceContent'] ?? '';
    maintenancePersonnel = json['maintenancePersonnel'] ?? '';
    exceptionDescription = json['exceptionDescription'] ?? '';
    maintenanceStatus = json['maintenanceStatus'] ?? 0;
    startTime = json['startTime'] ?? '';
    endTime = json['endTime'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['maintenanceType'] = this.maintenanceType;
    data['equipmentNo'] = this.equipmentNo;
    data['maintenanceProject'] = this.maintenanceProject;
    data['maintenancePosition'] = this.maintenancePosition;
    data['maintenanceContent'] = this.maintenanceContent;
    data['maintenancePersonnel'] = this.maintenancePersonnel;
    data['exceptionDescription'] = this.exceptionDescription;
    data['maintenanceStatus'] = this.maintenanceStatus;
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    return data;
  }
}
