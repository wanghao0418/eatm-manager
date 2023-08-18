class SingleMacSchedulingData {
  List<DeviceResources>? deviceResources;
  List<String>? allMachineName;

  SingleMacSchedulingData({this.deviceResources, this.allMachineName});

  SingleMacSchedulingData.fromJson(Map<String, dynamic> json) {
    if (json['deviceResources'] != null) {
      deviceResources = <DeviceResources>[];
      json['deviceResources'].forEach((v) {
        deviceResources!.add(new DeviceResources.fromJson(v));
      });
    }
    allMachineName = json['AllMachineName'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.deviceResources != null) {
      data['deviceResources'] =
          this.deviceResources!.map((v) => v.toJson()).toList();
    }
    data['AllMachineName'] = this.allMachineName;
    return data;
  }
}

class DeviceResources {
  String? allRunTimes;
  String? chuckCraftLimit;
  int? pictureStatus;
  int? colorStatus;
  String? systemType;
  int? utilizationRate;
  List<ChipRemoval>? chipRemoval;
  String? curStatus;
  List<CuttingFluid>? cuttingFluid;
  List<DeviceAlarmToolNoArr>? deviceAlarmToolNoArr;
  int? deviceId;
  String? deviceName;
  List<DeviceToolNoArr>? deviceToolNoArr;
  String? planRunTime;
  String? planStatus;
  List<ProductionOrders>? productionOrders;
  String? statusReason;
  int? useStatus;
  String? todayOnlineTimes;
  String? types;

  DeviceResources(
      {this.allRunTimes,
      this.chuckCraftLimit,
      this.pictureStatus,
      this.colorStatus,
      this.systemType,
      this.utilizationRate,
      this.chipRemoval,
      this.curStatus,
      this.cuttingFluid,
      this.deviceAlarmToolNoArr,
      this.deviceId,
      this.deviceName,
      this.deviceToolNoArr,
      this.planRunTime,
      this.planStatus,
      this.productionOrders,
      this.statusReason,
      this.useStatus,
      this.todayOnlineTimes,
      this.types});

  DeviceResources.fromJson(Map<String, dynamic> json) {
    allRunTimes = json['AllRunTimes'];
    chuckCraftLimit = json['ChuckCraftLimit'];
    pictureStatus = json['PictureStatus'];
    colorStatus = json['ColorStatus'];
    systemType = json['SystemType'];
    utilizationRate = json['UtilizationRate'];
    if (json['chipRemoval'] != null) {
      chipRemoval = <ChipRemoval>[];
      json['chipRemoval'].forEach((v) {
        chipRemoval!.add(new ChipRemoval.fromJson(v));
      });
    }
    curStatus = json['curStatus'];
    if (json['cuttingFluid'] != null) {
      cuttingFluid = <CuttingFluid>[];
      json['cuttingFluid'].forEach((v) {
        cuttingFluid!.add(new CuttingFluid.fromJson(v));
      });
    }
    if (json['deviceAlarmToolNoArr'] != null) {
      deviceAlarmToolNoArr = <DeviceAlarmToolNoArr>[];
      json['deviceAlarmToolNoArr'].forEach((v) {
        deviceAlarmToolNoArr!.add(new DeviceAlarmToolNoArr.fromJson(v));
      });
    }
    deviceId = json['deviceId'];
    deviceName = json['deviceName'];
    if (json['deviceToolNoArr'] != null) {
      deviceToolNoArr = <DeviceToolNoArr>[];
      json['deviceToolNoArr'].forEach((v) {
        deviceToolNoArr!.add(new DeviceToolNoArr.fromJson(v));
      });
    }
    planRunTime = json['planRunTime'];
    planStatus = json['planStatus'];
    if (json['productionOrders'] != null) {
      productionOrders = <ProductionOrders>[];
      json['productionOrders'].forEach((v) {
        productionOrders!.add(new ProductionOrders.fromJson(v));
      });
    }
    statusReason = json['statusReason'];
    useStatus = json['useStatus'];
    todayOnlineTimes = json['todayOnlineTimes'];
    types = json['types'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['AllRunTimes'] = this.allRunTimes;
    data['ChuckCraftLimit'] = this.chuckCraftLimit;
    data['PictureStatus'] = this.pictureStatus;
    data['ColorStatus'] = this.colorStatus;
    data['SystemType'] = this.systemType;
    data['UtilizationRate'] = this.utilizationRate;
    if (this.chipRemoval != null) {
      data['chipRemoval'] = this.chipRemoval!.map((v) => v.toJson()).toList();
    }
    data['curStatus'] = this.curStatus;
    if (this.cuttingFluid != null) {
      data['cuttingFluid'] = this.cuttingFluid!.map((v) => v.toJson()).toList();
    }
    if (this.deviceAlarmToolNoArr != null) {
      data['deviceAlarmToolNoArr'] =
          this.deviceAlarmToolNoArr!.map((v) => v.toJson()).toList();
    }
    data['deviceId'] = this.deviceId;
    data['deviceName'] = this.deviceName;
    if (this.deviceToolNoArr != null) {
      data['deviceToolNoArr'] =
          this.deviceToolNoArr!.map((v) => v.toJson()).toList();
    }
    data['planRunTime'] = this.planRunTime;
    data['planStatus'] = this.planStatus;
    if (this.productionOrders != null) {
      data['productionOrders'] =
          this.productionOrders!.map((v) => v.toJson()).toList();
    }
    data['statusReason'] = this.statusReason;
    data['useStatus'] = this.useStatus;
    data['todayOnlineTimes'] = this.todayOnlineTimes;
    data['types'] = this.types;
    return data;
  }
}

class ChipRemoval {
  int? theoreticalTime;
  int? usedTime;

  ChipRemoval({this.theoreticalTime, this.usedTime});

  ChipRemoval.fromJson(Map<String, dynamic> json) {
    theoreticalTime = json['theoreticalTime'];
    usedTime = json['usedTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['theoreticalTime'] = this.theoreticalTime;
    data['usedTime'] = this.usedTime;
    return data;
  }
}

class CuttingFluid {
  int? usedTime;
  int? theoreticalTime;

  CuttingFluid({usedTime, theoreticalTime});

  CuttingFluid.fromJson(Map<String, dynamic> json) {
    usedTime = json['usedTime'];
    theoreticalTime = json['theoreticalTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['usedTime'] = usedTime;
    data['theoreticalTime'] = theoreticalTime;
    return data;
  }
}

class DeviceAlarmToolNoArr {
  String? alarmTip;
  int? theoreticalTime;
  String? toolTypeNo;
  int? usedTime;

  DeviceAlarmToolNoArr(
      {this.alarmTip, this.theoreticalTime, this.toolTypeNo, this.usedTime});

  DeviceAlarmToolNoArr.fromJson(Map<String, dynamic> json) {
    alarmTip = json['AlarmTip'];
    theoreticalTime = json['theoreticalTime'];
    toolTypeNo = json['toolTypeNo'];
    usedTime = json['usedTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['AlarmTip'] = this.alarmTip;
    data['theoreticalTime'] = this.theoreticalTime;
    data['toolTypeNo'] = this.toolTypeNo;
    data['usedTime'] = this.usedTime;
    return data;
  }
}

class DeviceToolNoArr {
  int? leftTime;
  int? theoreticalTime;
  String? toolTypeNo;
  int? usedTime;

  DeviceToolNoArr(
      {this.leftTime, this.theoreticalTime, this.toolTypeNo, this.usedTime});

  DeviceToolNoArr.fromJson(Map<String, dynamic> json) {
    leftTime = json['leftTime'];
    theoreticalTime = json['theoreticalTime'];
    toolTypeNo = json['toolTypeNo'];
    usedTime = json['usedTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['leftTime'] = this.leftTime;
    data['theoreticalTime'] = this.theoreticalTime;
    data['toolTypeNo'] = this.toolTypeNo;
    data['usedTime'] = this.usedTime;
    return data;
  }
}

class ProductionOrders {
  int? colorNum;
  String? curCraftData;
  String? endTime;
  String? hasWorkTime;
  String? item;
  String? leftWorkTime;
  String? mouldSn;
  String? partSn;
  String? planMachineName;
  int? processFenmu;
  int? processFenzi;
  int? quantity;
  String? specifications;
  String? startTime;
  String? tipContext;
  String? workpieceRoute;
  String? workpieceSn;

  ProductionOrders(
      {this.colorNum,
      this.curCraftData,
      this.endTime,
      this.hasWorkTime,
      this.item,
      this.leftWorkTime,
      this.mouldSn,
      this.partSn,
      this.planMachineName,
      this.processFenmu,
      this.processFenzi,
      this.quantity,
      this.specifications,
      this.startTime,
      this.tipContext,
      this.workpieceRoute,
      this.workpieceSn});

  ProductionOrders.fromJson(Map<String, dynamic> json) {
    colorNum = json['colorNum'];
    curCraftData = json['curCraftData'];
    endTime = json['endTime'];
    hasWorkTime = json['hasWorkTime'];
    item = json['item'];
    leftWorkTime = json['leftWorkTime'];
    mouldSn = json['mouldSn'];
    partSn = json['partSn'];
    planMachineName = json['planMachineName'];
    processFenmu = json['processFenmu'];
    processFenzi = json['processFenzi'];
    quantity = json['quantity'];
    specifications = json['specifications'];
    startTime = json['startTime'];
    tipContext = json['tipContext'];
    workpieceRoute = json['workpieceRoute'];
    workpieceSn = json['workpieceSn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['colorNum'] = this.colorNum;
    data['curCraftData'] = this.curCraftData;
    data['endTime'] = this.endTime;
    data['hasWorkTime'] = this.hasWorkTime;
    data['item'] = this.item;
    data['leftWorkTime'] = this.leftWorkTime;
    data['mouldSn'] = this.mouldSn;
    data['partSn'] = this.partSn;
    data['planMachineName'] = this.planMachineName;
    data['processFenmu'] = this.processFenmu;
    data['processFenzi'] = this.processFenzi;
    data['quantity'] = this.quantity;
    data['specifications'] = this.specifications;
    data['startTime'] = this.startTime;
    data['tipContext'] = this.tipContext;
    data['workpieceRoute'] = this.workpieceRoute;
    data['workpieceSn'] = this.workpieceSn;
    return data;
  }
}
