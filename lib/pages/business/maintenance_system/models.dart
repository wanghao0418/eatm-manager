class MaintenanceProgram {
  int? id;
  int? maintenanceType;
  String? maintenanceProgram;
  String? maintenancePosition;
  String? maintenanceContent;
  String? maintenanceStandard;
  String? remarks;

  MaintenanceProgram(
      {this.id,
      this.maintenanceType,
      this.maintenanceProgram,
      this.maintenancePosition,
      this.maintenanceContent,
      this.maintenanceStandard,
      this.remarks});

  MaintenanceProgram.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    maintenanceType = json['maintenanceType'];
    maintenanceProgram = json['maintenanceProgram'];
    maintenancePosition = json['maintenancePosition'];
    maintenanceContent = json['maintenanceContent'];
    maintenanceStandard = json['maintenanceStandard'];
    remarks = json['remarks'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['maintenanceType'] = this.maintenanceType;
    data['maintenanceProgram'] = this.maintenanceProgram;
    data['maintenancePosition'] = this.maintenancePosition;
    data['maintenanceContent'] = this.maintenanceContent;
    data['maintenanceStandard'] = this.maintenanceStandard;
    data['remarks'] = this.remarks;
    return data;
  }

  void setValue(String columnName, dynamic value) {
    switch (columnName) {
      case 'id':
        id = value;
        break;
      case 'maintenanceType':
        maintenanceType = value;
        break;
      case 'maintenanceProgram':
        maintenanceProgram = value;
        break;
      case 'maintenancePosition':
        maintenancePosition = value;
        break;
      case 'maintenanceContent':
        maintenanceContent = value;
        break;
      case 'maintenanceStandard':
        maintenanceStandard = value;
        break;
      case 'remarks':
        remarks = value;
        break;
    }
  }
}
