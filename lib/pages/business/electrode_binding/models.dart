/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-09-01 17:38:54
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-09-04 11:27:27
 * @FilePath: /eatm_manager/lib/pages/business/electrode_binding/models.dart
 * @Description: 结构体集合
 */
import 'dart:convert';

class ChipBindData {
  final int? nAction;
  final int? nCurLocationId;
  final int? nFasciaId;
  final int? nIsOk;
  final String? strChipClampId;
  final String? strChipFascia;
  final String? strElectrodeNo;
  final String? strFixture;
  final String? strPresetHeight;
  final String? strSpecifications;
  final String? strTextureMaterial;
  final String? strX;
  final String? strY;
  final String? strZ;

  ChipBindData({
    this.nAction,
    this.nCurLocationId,
    this.nFasciaId,
    this.nIsOk,
    this.strChipClampId,
    this.strChipFascia,
    this.strElectrodeNo,
    this.strFixture,
    this.strPresetHeight,
    this.strSpecifications,
    this.strTextureMaterial,
    this.strX,
    this.strY,
    this.strZ,
  });

  factory ChipBindData.fromJson(String str) =>
      ChipBindData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ChipBindData.fromMap(Map<String, dynamic> json) => ChipBindData(
        nAction: json["nAction"],
        nCurLocationId: json["nCurLocationId"],
        nFasciaId: json["nFasciaId"],
        nIsOk: json["nIsOk"],
        strChipClampId: json["strChipClampId"],
        strChipFascia: json["strChipFascia"],
        strElectrodeNo: json["strElectrodeNo"],
        strFixture: json["strFixture"],
        strPresetHeight: json["strPresetHeight"],
        strSpecifications: json["strSpecifications"],
        strTextureMaterial: json["strTextureMaterial"],
        strX: json["strX"],
        strY: json["strY"],
        strZ: json["strZ"],
      );

  Map<String, dynamic> toMap() => {
        "nAction": nAction,
        "nCurLocationId": nCurLocationId,
        "nFasciaId": nFasciaId,
        "nIsOk": nIsOk,
        "strChipClampId": strChipClampId,
        "strChipFascia": strChipFascia,
        "strElectrodeNo": strElectrodeNo,
        "strFixture": strFixture,
        "strPresetHeight": strPresetHeight,
        "strSpecifications": strSpecifications,
        "strTextureMaterial": strTextureMaterial,
        "strX": strX,
        "strY": strY,
        "strZ": strZ,
      };
}
