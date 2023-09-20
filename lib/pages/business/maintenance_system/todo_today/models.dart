class MaintenanceTasksSearch {
  String? deviceNum;
  String? name;
  int? maintenanceType;
  String? item;

  MaintenanceTasksSearch(
      {this.deviceNum, this.name, this.maintenanceType, this.item});

  MaintenanceTasksSearch.fromJson(Map<String, dynamic> json) {
    deviceNum = json['DeviceNum'];
    name = json['Name'];
    maintenanceType = json['MaintenanceType'];
    item = json['Item'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DeviceNum'] = this.deviceNum;
    data['Name'] = this.name;
    data['MaintenanceType'] = this.maintenanceType;
    data['Item'] = this.item;
    return data;
  }

  reset() {
    deviceNum = null;
    name = null;
    maintenanceType = null;
    item = null;
  }
}

// 维保任务

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
  int? maintenanceStatus;
  String? maintenanceTime;
  bool? isAbnormal;
  String? exceptionDescription;

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
      this.maintenanceStatus,
      this.maintenanceTime,
      this.isAbnormal,
      this.exceptionDescription});

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
    maintenanceStatus = json['maintenanceStatus'];
    maintenanceTime = json['maintenanceTime'];
    isAbnormal = json['isAbnormal'];
    exceptionDescription = json['exceptionDescription'];
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
    data['maintenanceStatus'] = this.maintenanceStatus;
    data['maintenanceTime'] = this.maintenanceTime;
    data['isAbnormal'] = this.isAbnormal;
    data['exceptionDescription'] = this.exceptionDescription;
    return data;
  }
}
