import 'dart:convert';

///工艺流程信息
class WorkProcessData {
  WorkProcessData({
    this.barCode,
    this.bomType,
    this.clamptype,
    this.curprocorder,
    this.curprocstate,
    this.machineSn,
    this.mouldsn,
    this.mwcount,
    this.mwpiececode,
    this.mwpiecename,
    this.partsn,
    this.procedurename,
    this.processroute,
    this.procetotal,
    this.pstePid,
    this.recordtime,
    this.resoucenamedept,
    this.resourceName,
    this.sn,
    this.spec,
    this.trayType,
    this.workpieceType,
    this.wpstate,
    this.offsetX,
    this.offsetY,
    this.offsetZ,
  });

  ///芯片Id
  String? barCode;
  String? bomType;
  String? clamptype;
  int? curprocorder;
  int? curprocstate;

  ///机床编号
  String? machineSn;

  ///模号
  String? mouldsn;
  String? mwcount;

  ///监控编号
  String? mwpiececode;

  ///工件名称
  String? mwpiecename;

  ///件号
  String? partsn;
  String? procedurename;
  String? processroute;
  int? procetotal;
  int? pstePid;
  String? recordtime;

  ///资源名称
  String? resoucenamedept;

  ///资源名称
  String? resourceName;

  ///编号
  String? sn;

  ///规格
  String? spec;
  String? trayType;

  ///工件类型
  String? workpieceType;
  String? wpstate;

  num? offsetX;
  num? offsetY;
  num? offsetZ;

  factory WorkProcessData.fromRawJson(String str) =>
      WorkProcessData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory WorkProcessData.fromJson(Map<String, dynamic> json) =>
      WorkProcessData(
        barCode: json["BarCode"],
        bomType: json["bomType"],
        clamptype: json["clamptype"],
        curprocorder: json["CURPROCORDER"],
        curprocstate: json["CURPROCSTATE"],
        machineSn: json["MachineSn"],
        mouldsn: json["MOULDSN"],
        mwcount: json["mwcount"],
        mwpiececode: json["Mwpiececode"],
        mwpiecename: json["mwpiecename"],
        partsn: json["PARTSN"],
        procedurename: json["procedurename"],
        processroute: json["PROCESSROUTE"],
        procetotal: json["PROCETOTAL"],
        pstePid: json["PstePid"],
        recordtime: json["RECORDTIME"],
        resoucenamedept: json["resoucenamedept"],
        resourceName: json["ResourceName"],
        sn: json["SN"],
        spec: json["SPEC"],
        trayType: json["TrayType"],
        workpieceType: json["WorkpieceType"],
        wpstate: json["wpstate"],
        offsetX: json["offsetx"],
        offsetY: json["offsety"],
        offsetZ: json["offsetz"],
      );

  Map<String, dynamic> toJson() => {
        "BarCode": barCode,
        "bomType": bomType,
        "clamptype": clamptype,
        "CURPROCORDER": curprocorder,
        "CURPROCSTATE": curprocstate,
        "MachineSn": machineSn,
        "MOULDSN": mouldsn,
        "mwcount": mwcount,
        "Mwpiececode": mwpiececode,
        "mwpiecename": mwpiecename,
        "PARTSN": partsn,
        "procedurename": procedurename,
        "PROCESSROUTE": processroute,
        "PROCETOTAL": procetotal,
        "PstePid": pstePid,
        "RECORDTIME": recordtime,
        "resoucenamedept": resoucenamedept,
        "ResourceName": resourceName,
        "SN": sn,
        "SPEC": spec,
        "TrayType": trayType,
        "WorkpieceType": workpieceType,
        "wpstate": wpstate,
        "offsetx": offsetX,
        "offsety": offsetY,
        "offsetz": offsetZ,
      };
}

class WorkProcessSearch {
  int? workmanship;
  int? workpiecetype;
  String? mouldsn;
  String? partsn;
  String? startTime;
  String? endTime;
  String? barcode;
  String? mwpiececode;
  bool? isSelect;
  int? querySource;

  WorkProcessSearch(
      {this.workmanship,
      this.workpiecetype,
      this.mouldsn,
      this.partsn,
      this.startTime,
      this.endTime,
      this.barcode,
      this.mwpiececode,
      this.isSelect,
      this.querySource});

  WorkProcessSearch.fromJson(Map<String, dynamic> json) {
    workmanship = json['workmanship'];
    workpiecetype = json['workpiecetype'];
    mouldsn = json['mouldsn'];
    partsn = json['partsn'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    barcode = json['barcode'];
    mwpiececode = json['Mwpiececode'];
    isSelect = json['isSelect'];
    querySource = json['querySource'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['workmanship'] = this.workmanship;
    data['workpiecetype'] = this.workpiecetype;
    data['mouldsn'] = this.mouldsn;
    data['partsn'] = this.partsn;
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    data['barcode'] = this.barcode;
    data['Mwpiececode'] = this.mwpiececode;
    data['isSelect'] = this.isSelect;
    data['querySource'] = this.querySource;
    return data;
  }
}
