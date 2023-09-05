/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-08-29 09:41:15
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-08-30 13:42:14
 * @FilePath: /eatm_manager/lib/pages/business/programming/model.dart
 * @Description:  结构体
 */
import 'dart:convert';

// 钢件EDM数据
class SteelEDMData {
  String? steelMouldSN;
  String? steelPartSN;
  String? steelSN;
  String? steelBarcode;
  String? steelSPEC;
  int? oilTankHeight;
  String? beginPoint;
  String? steelProceduName;
  int? steelPstepid;

  SteelEDMData(
      {this.steelMouldSN,
      this.steelPartSN,
      this.steelSN,
      this.steelBarcode,
      this.steelSPEC,
      this.oilTankHeight,
      this.beginPoint,
      this.steelProceduName,
      this.steelPstepid});

  SteelEDMData.fromJson(Map<String, dynamic> json) {
    steelMouldSN = json['SteelMOULDSN'];
    steelPartSN = json['SteelPARTSN'];
    steelSN = json['STEELSN'];
    steelBarcode = json['SteelBARCODE'];
    steelSPEC = json['SteelSPEC'];
    oilTankHeight = json['OilTankHeight'];
    beginPoint = json['BeginPoint'];
    steelProceduName = json['SteelProceduName'];
    steelPstepid = json['SteelPstepid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['SteelMOULDSN'] = this.steelMouldSN;
    data['SteelPARTSN'] = this.steelPartSN;
    data['STEELSN'] = this.steelSN;
    data['SteelBARCODE'] = this.steelBarcode;
    data['SteelSPEC'] = this.steelSPEC;
    data['OilTankHeight'] = this.oilTankHeight;
    data['BeginPoint'] = this.beginPoint;
    data['SteelProceduName'] = this.steelProceduName;
    data['SteelPstepid'] = this.steelPstepid;
    return data;
  }
}

///放电信息
class EdmElecInfo {
  EdmElecInfo({
    this.beginPoint,
    this.cAxisRotationAngle1,
    this.cAxisRotationAngle2,
    this.cAxisRotationAngle3,
    this.cAxisRotationAngle4,
    this.cAxisRotationAngle5,
    this.cAxisRotationAngle6,
    this.cAxisRotationAngle7,
    this.cAxisRotationAngle8,
    this.elecBarcode,
    this.elecedmtype,
    this.elecMouldsn,
    this.elecNodeMark,
    this.elecPartsn,
    this.elecProceduName,
    this.elecPstepid,
    this.elecsn,
    this.elecSpec,
    this.elecTexture,
    this.frienum,
    this.oilTankHeight,
    this.runningPosX1,
    this.runningPosX2,
    this.runningPosX3,
    this.runningPosX4,
    this.runningPosX5,
    this.runningPosX6,
    this.runningPosX7,
    this.runningPosX8,
    this.runningPosY1,
    this.runningPosY2,
    this.runningPosY3,
    this.runningPosY4,
    this.runningPosY5,
    this.runningPosY6,
    this.runningPosY7,
    this.runningPosY8,
    this.runningPosZ1,
    this.runningPosZ2,
    this.runningPosZ3,
    this.runningPosZ4,
    this.runningPosZ5,
    this.runningPosZ6,
    this.runningPosZ7,
    this.runningPosZ8,
    this.shakingmode,
    this.steelBarcode,
    this.steelMouldsn,
    this.steelPartsn,
    this.steelProceduName,
    this.steelPstepid,
    this.steelsn,
    this.steelSpec,
    this.steelTexture,
  });

  String? beginPoint;
  num? cAxisRotationAngle1;
  num? cAxisRotationAngle2;
  num? cAxisRotationAngle3;
  num? cAxisRotationAngle4;
  num? cAxisRotationAngle5;
  num? cAxisRotationAngle6;
  num? cAxisRotationAngle7;
  num? cAxisRotationAngle8;
  String? elecBarcode;
  String? elecedmtype;
  String? elecMouldsn;
  String? elecNodeMark;
  String? elecPartsn;
  String? elecProceduName;
  int? elecPstepid;
  String? elecsn;
  String? elecSpec;
  String? elecTexture;
  int? frienum;
  num? oilTankHeight;
  num? runningPosX1;
  num? runningPosX2;
  num? runningPosX3;
  num? runningPosX4;
  num? runningPosX5;
  num? runningPosX6;
  num? runningPosX7;
  num? runningPosX8;
  num? runningPosY1;
  num? runningPosY2;
  num? runningPosY3;
  num? runningPosY4;
  num? runningPosY5;
  num? runningPosY6;
  num? runningPosY7;
  num? runningPosY8;
  num? runningPosZ1;
  num? runningPosZ2;
  num? runningPosZ3;
  num? runningPosZ4;
  num? runningPosZ5;
  num? runningPosZ6;
  num? runningPosZ7;
  num? runningPosZ8;
  String? shakingmode;
  String? steelBarcode;
  String? steelMouldsn;
  String? steelPartsn;
  String? steelProceduName;
  int? steelPstepid;
  String? steelsn;
  String? steelSpec;
  String? steelTexture;

  factory EdmElecInfo.fromRawJson(String str) =>
      EdmElecInfo.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory EdmElecInfo.fromJson(Map<String, dynamic> json) => EdmElecInfo(
        beginPoint: json["BeginPoint"],
        cAxisRotationAngle1: json["CAxisRotationAngle_1"],
        cAxisRotationAngle2: json["CAxisRotationAngle_2"],
        cAxisRotationAngle3: json["CAxisRotationAngle_3"],
        cAxisRotationAngle4: json["CAxisRotationAngle_4"],
        cAxisRotationAngle5: json["CAxisRotationAngle_5"],
        cAxisRotationAngle6: json["CAxisRotationAngle_6"],
        cAxisRotationAngle7: json["CAxisRotationAngle_7"],
        cAxisRotationAngle8: json["CAxisRotationAngle_8"],
        elecBarcode: json["ElecBARCODE"],
        elecedmtype: json["ELECEDMTYPE"],
        elecMouldsn: json["ElecMOULDSN"],
        elecNodeMark: json["ElecNodeMark"],
        elecPartsn: json["ElecPARTSN"],
        elecProceduName: json["ElecProceduName"],
        elecPstepid: json["ElecPstepid"],
        elecsn: json["ELECSN"],
        elecSpec: json["ElecSPEC"],
        elecTexture: json["ElecTexture"],
        frienum: json["FRIENUM"],
        oilTankHeight: json["OilTankHeight"],
        runningPosX1: json["RunningPosX_1"],
        runningPosX2: json["RunningPosX_2"],
        runningPosX3: json["RunningPosX_3"],
        runningPosX4: json["RunningPosX_4"],
        runningPosX5: json["RunningPosX_5"],
        runningPosX6: json["RunningPosX_6"],
        runningPosX7: json["RunningPosX_7"],
        runningPosX8: json["RunningPosX_8"],
        runningPosY1: json["RunningPosY_1"],
        runningPosY2: json["RunningPosY_2"],
        runningPosY3: json["RunningPosY_3"],
        runningPosY4: json["RunningPosY_4"],
        runningPosY5: json["RunningPosY_5"],
        runningPosY6: json["RunningPosY_6"],
        runningPosY7: json["RunningPosY_7"],
        runningPosY8: json["RunningPosY_8"],
        runningPosZ1: json["RunningPosZ_1"],
        runningPosZ2: json["RunningPosZ_2"],
        runningPosZ3: json["RunningPosZ_3"],
        runningPosZ4: json["RunningPosZ_4"],
        runningPosZ5: json["RunningPosZ_5"],
        runningPosZ6: json["RunningPosZ_6"],
        runningPosZ7: json["RunningPosZ_7"],
        runningPosZ8: json["RunningPosZ_8"],
        shakingmode: json["SHAKINGMODE"],
        steelBarcode: json["SteelBARCODE"],
        steelMouldsn: json["SteelMOULDSN"],
        steelPartsn: json["SteelPARTSN"],
        steelProceduName: json["SteelProceduName"],
        steelPstepid: json["SteelPstepid"],
        steelsn: json["STEELSN"],
        steelSpec: json["SteelSPEC"],
        steelTexture: json["SteelTexture"],
      );

  Map<String, dynamic> toJson() => {
        "BeginPoint": beginPoint,
        "CAxisRotationAngle_1": cAxisRotationAngle1,
        "CAxisRotationAngle_2": cAxisRotationAngle2,
        "CAxisRotationAngle_3": cAxisRotationAngle3,
        "CAxisRotationAngle_4": cAxisRotationAngle4,
        "CAxisRotationAngle_5": cAxisRotationAngle5,
        "CAxisRotationAngle_6": cAxisRotationAngle6,
        "CAxisRotationAngle_7": cAxisRotationAngle7,
        "CAxisRotationAngle_8": cAxisRotationAngle8,
        "ElecBARCODE": elecBarcode,
        "ELECEDMTYPE": elecedmtype,
        "ElecMOULDSN": elecMouldsn,
        "ElecNodeMark": elecNodeMark,
        "ElecPARTSN": elecPartsn,
        "ElecProceduName": elecProceduName,
        "ElecPstepid": elecPstepid,
        "ELECSN": elecsn,
        "ElecSPEC": elecSpec,
        "ElecTexture": elecTexture,
        "FRIENUM": frienum,
        "OilTankHeight": oilTankHeight,
        "RunningPosX_1": runningPosX1,
        "RunningPosX_2": runningPosX2,
        "RunningPosX_3": runningPosX3,
        "RunningPosX_4": runningPosX4,
        "RunningPosX_5": runningPosX5,
        "RunningPosX_6": runningPosX6,
        "RunningPosX_7": runningPosX7,
        "RunningPosX_8": runningPosX8,
        "RunningPosY_1": runningPosY1,
        "RunningPosY_2": runningPosY2,
        "RunningPosY_3": runningPosY3,
        "RunningPosY_4": runningPosY4,
        "RunningPosY_5": runningPosY5,
        "RunningPosY_6": runningPosY6,
        "RunningPosY_7": runningPosY7,
        "RunningPosY_8": runningPosY8,
        "RunningPosZ_1": runningPosZ1,
        "RunningPosZ_2": runningPosZ2,
        "RunningPosZ_3": runningPosZ3,
        "RunningPosZ_4": runningPosZ4,
        "RunningPosZ_5": runningPosZ5,
        "RunningPosZ_6": runningPosZ6,
        "RunningPosZ_7": runningPosZ7,
        "RunningPosZ_8": runningPosZ8,
        "SHAKINGMODE": shakingmode,
        "SteelBARCODE": steelBarcode,
        "SteelMOULDSN": steelMouldsn,
        "SteelPARTSN": steelPartsn,
        "SteelProceduName": steelProceduName,
        "SteelPstepid": steelPstepid,
        "STEELSN": steelsn,
        "SteelSPEC": steelSpec,
        "SteelTexture": steelTexture,
      };
}

class RunningPos {
  num? runningPosX;
  num? runningPosY;
  num? runningPosZ;
  num? cAxisRotationAngle;

  RunningPos(
      {this.runningPosX,
      this.runningPosY,
      this.runningPosZ,
      this.cAxisRotationAngle});

  RunningPos.fromJson(Map<String, dynamic> json) {
    runningPosX = json['RunningPosX'];
    runningPosY = json['RunningPosY'];
    runningPosZ = json['RunningPosZ'];
    cAxisRotationAngle = json['CAxisRotationAngle'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RunningPosX'] = this.runningPosX;
    data['RunningPosY'] = this.runningPosY;
    data['RunningPosZ'] = this.runningPosZ;
    data['CAxisRotationAngle'] = this.cAxisRotationAngle;
    return data;
  }

  // 非原点
  bool get isNotOrigin =>
      runningPosX != 0 ||
      runningPosY != 0 ||
      runningPosZ != 0 ||
      cAxisRotationAngle != 0;
}

class EdmTaskData {
  String? elecSN;
  int? edmTaskId;
  String? elecMOULDSN;
  String? elecPARTSN;
  String? steelMOULDSN;
  String? steelPARTSN;
  String? steelSN;
  int? edmOrder;

  EdmTaskData(
      {this.elecSN,
      this.edmTaskId,
      this.elecMOULDSN,
      this.elecPARTSN,
      this.steelMOULDSN,
      this.steelPARTSN,
      this.steelSN,
      this.edmOrder});

  EdmTaskData.fromJson(Map<String, dynamic> json) {
    elecSN = json['ELECSN'];
    edmTaskId = json['EdmTaskId'];
    elecMOULDSN = json['ElecMOULDSN'];
    elecPARTSN = json['ElecPARTSN'];
    steelMOULDSN = json['SteelMOULDSN'];
    steelPARTSN = json['SteelPARTSN'];
    steelSN = json['STEELSN'];
    edmOrder = json['EdmOrder'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ELECSN'] = this.elecSN;
    data['EdmTaskId'] = this.edmTaskId;
    data['ElecMOULDSN'] = this.elecMOULDSN;
    data['ElecPARTSN'] = this.elecPARTSN;
    data['SteelMOULDSN'] = this.steelMOULDSN;
    data['SteelPARTSN'] = this.steelPARTSN;
    data['STEELSN'] = this.steelSN;
    data['EdmOrder'] = this.edmOrder;
    return data;
  }
}
