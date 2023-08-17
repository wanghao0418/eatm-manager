/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-08-16 15:08:21
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-08-17 17:38:44
 * @FilePath: /eatm_manager/lib/pages/business/reporting/controller.dart
 * @Description: 报工逻辑层
 */
import 'package:eatm_manager/common/api/line_body_api.dart';
import 'package:eatm_manager/common/api/reporting_api.dart';
import 'package:eatm_manager/common/models/machineInfo.dart';
import 'package:eatm_manager/common/models/selectOption.dart';
import 'package:eatm_manager/common/utils/http.dart';
import 'package:eatm_manager/common/utils/popup_message.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'dart:convert';

class ReportingController extends GetxController {
  ReportingController();
  ReportingSearch search = ReportingSearch();
  Reporting reporting = Reporting();
  List<PlutoRow> rows = [];
  late PlutoGridStateManager stateManager;

  // 工件类型
  List<SelectOption> get workpieceTypeList => [
        SelectOption(label: '全部', value: 0),
        SelectOption(label: '电极', value: 1),
        SelectOption(label: '钢件', value: 2),
      ];

  // 报工类型
  List<SelectOption> get reportingTypeList => [
        SelectOption(label: '开始', value: 1),
        SelectOption(label: '暂停', value: 2),
        SelectOption(label: '继续', value: 3),
        SelectOption(label: '完工', value: 4)
      ];

  // 机床编号
  List<SelectOption> get machineList => [];

  // 人员
  List<SelectOption> get personList => [];

  // 选中模号
  List<String> selectedMouldSNList = [];

  List<ReportData> reportDataList = [];

  // 模号列表
  List<String> get mouldSNList =>
      reportDataList.map((e) => e.mouldnums!).toSet().toList();

  _initData() {
    update(["reporting"]);
  }

  // 获取人员列表
  void getPersonList() async {
    PopupMessage.showLoading();
    ResponseApiBody res = await ReportingApi.getPersonList({});
    PopupMessage.closeLoading();
    if (res.success!) {
      List<SelectOption> data = (res.data as List)
          .map((e) => SelectOption(label: e, value: e))
          .toList();
      personList.clear();
      personList.addAll(data);
      _initData();
    } else {
      PopupMessage.showFailInfoBar(res.message as String);
    }
  }

  // 获取机床列表
  void getMachineList() async {
    PopupMessage.showLoading();
    ResponseApiBody res = await LineBodyApi.getMachineList({});
    PopupMessage.closeLoading();
    if (res.success!) {
      List<SelectOption> data = (res.data as List)
          .map((e) => MachineInfo.fromJson(e))
          .map((e) => SelectOption(label: e.machineName, value: e.machineName))
          .toList();
      machineList.clear();
      machineList.addAll(data);
      _initData();
    } else {
      PopupMessage.showFailInfoBar(res.message as String);
    }
  }

  // 查询
  void query() async {
    PopupMessage.showLoading();
    ResponseApiBody res = await ReportingApi.query({"params": search.toJson()});
    PopupMessage.closeLoading();
    if (res.success!) {
      List<ReportData> data =
          (res.data as List).map((e) => ReportData.fromJson(e)).toList();
      reportDataList = data;
      updateRows();
      _initData();
    } else {
      PopupMessage.showFailInfoBar(res.message as String);
    }
  }

  // 更新表格
  void updateRows() {
    // 重置表格
    selectedMouldSNList = [];
    stateManager.setFilter(null);
    rows.clear();
    for (var e in reportDataList) {
      var index = reportDataList.indexOf(e);
      stateManager.appendRows([
        PlutoRow(cells: {
          'number': PlutoCell(value: index + 1),
          'workpieceType': PlutoCell(value: e.bomtype),
          'mouldSN': PlutoCell(value: e.mouldbasenums),
          'partSN': PlutoCell(value: e.partnums),
          'mwpieceCode': PlutoCell(value: e.mwpiececode),
          'mwpieceName': PlutoCell(value: e.mwpiecename),
          // 'resoucenamedept': PlutoCell(value: e.resoucenamedept),
          'spec': PlutoCell(value: e.standard),
          'data': PlutoCell(value: e),
        })
      ]);
    }
    _initData();
  }

  // 报工
  void report() async {
    if (!reporting.validate()) {
      return;
    }
    PopupMessage.showLoading();
    ResponseApiBody res =
        await ReportingApi.reporting({"params": reporting.toJson()});
    PopupMessage.closeLoading();
    if (res.success!) {
      PopupMessage.showSuccessInfoBar("报工成功");
      query();
    } else {
      PopupMessage.showFailInfoBar(res.message as String);
    }
  }

  // @override
  // void onInit() {
  //   super.onInit();
  // }

  @override
  void onReady() {
    super.onReady();
    getPersonList();
    getMachineList();
    _initData();
  }

  // @override
  // void onClose() {
  //   super.onClose();
  // }
}

class ReportingSearch {
  int? workpieceType;
  String? mouldsn;
  String? partsn;
  String? mwpiececode;
  String? barcode;

  ReportingSearch(
      {this.workpieceType,
      this.mouldsn,
      this.partsn,
      this.mwpiececode,
      this.barcode});

  ReportingSearch.fromJson(Map<String, dynamic> json) {
    workpieceType = json['workpieceType'];
    mouldsn = json['mouldSN'];
    partsn = json['partSN'];
    mwpiececode = json['mwpiececode'];
    barcode = json['barcode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['workpieceType'] = workpieceType;
    data['mouldSN'] = mouldsn;
    data['partSN'] = partsn;
    data['mwpiececode'] = mwpiececode;
    data['barcode'] = barcode;
    return data;
  }
}

class Reporting {
  String? person;
  String? machineSn;
  int? reportType;

  Reporting({this.person, this.machineSn, this.reportType});

  Reporting.fromJson(Map<String, dynamic> json) {
    person = json['person'];
    machineSn = json['mouldSN'];
    reportType = json['reportType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['person'] = person;
    data['mouldSN'] = machineSn;
    data['reportType'] = reportType;
    return data;
  }

  // 校验
  bool validate() {
    if (person == null || person!.isEmpty) {
      PopupMessage.showFailInfoBar("请选择人员");
      return false;
    }
    if (machineSn == null || machineSn!.isEmpty) {
      PopupMessage.showFailInfoBar("请选择机床");
      return false;
    }
    if (reportType == null) {
      PopupMessage.showFailInfoBar("请选择报工类型");
      return false;
    }
    return true;
  }
}

///报工信息
class ReportData {
  ReportData({
    this.actresourceid,
    this.actresourcenames,
    this.bindstate,
    this.blanknorms,
    this.bomtype,
    this.carrytoline,
    this.checkresultname,
    this.code,
    this.designgroup,
    this.endtime,
    this.freewprocess,
    this.identnumber,
    this.judgestatename,
    this.lastresid,
    this.lastresname,
    this.lastuserid,
    this.mouldbasenums,
    this.mouldnums,
    this.mwnums,
    this.mwpiececode,
    this.mwpieceid,
    this.mwpiecename,
    this.mwpieceremainhours,
    this.mwpiecesumhours,
    this.nextprocedurename,
    this.nextwpresourceids,
    this.nextwpresourcename,
    this.norms,
    this.partnums,
    this.preprocedurename,
    this.prestate,
    this.prewpstate,
    this.procedurename,
    this.proceremark,
    this.pstephours,
    this.pstepid,
    this.pstepname,
    this.psteprejob,
    this.pstepstate,
    this.ready,
    this.resourceids,
    this.resourcenames,
    this.resourcetypename,
    this.result,
    this.schedulingstatus,
    this.schedulingstatuserror,
    this.standard,
    this.submittime,
    this.taskstate,
    this.trayrequest,
    this.traystandard,
    this.traytype,
    this.wphours,
    this.wpordernums,
    this.wpresourceids,
    this.wpresourcename,
    this.wprocesscount,
    this.wprocessid,
    this.wpstate,
  });

  ///实际资源id，(多个逗号拼接)
  String? actresourceid;

  ///实际资源
  String? actresourcenames;

  ///实际资源，(0:未绑定,1:已绑定)
  String? bindstate;

  ///零件对应BOM的毛坯规格
  String? blanknorms;

  ///是否电极，(1:电极,2非电极)
  String? bomtype;

  ///AGV是否线体搬运，（0其他地方(货架) 1处理中 2线体)
  String? carrytoline;

  ///上道工序检测结果，(1:合格,2不合格,3未处理)
  int? checkresultname;

  ///接驳站编码
  String? code;

  ///钳工班组
  String? designgroup;

  ///工序实际完成时间，非自由为0，自由为1
  String? endtime;

  ///是否自由工序
  String? freewprocess;

  ///上道工序检测结果是否处理，上道工序检测结果是否处理
  String? identnumber;

  ///最近一次刷卡资源ID
  int? judgestatename;

  ///最近一次刷卡资源名称
  String? lastresid;

  ///最近一次刷卡人ID
  String? lastresname;

  ///对返回码的文本描述内容
  String? lastuserid;

  ///模具编号
  String? mouldbasenums;

  ///生产任务号
  String? mouldnums;

  ///工件编号
  String? mwnums;

  ///工件监控编号
  int? mwpiececode;

  ///工件id
  int? mwpieceid;

  ///工件名称
  String? mwpiecename;

  ///零件未开工工时
  String? mwpieceremainhours;

  ///零件总工时
  String? mwpiecesumhours;

  ///下工序
  String? nextprocedurename;

  ///下一个工艺对应资源id，多个逗号分隔
  String? nextwpresourceids;

  ///下一个工艺资源，（多个逗号分隔）
  String? nextwpresourcename;

  ///零件对应BOM的规格
  String? norms;

  ///工件件号
  String? partnums;

  ///上工序
  String? preprocedurename;

  ///前置任务，(all:所有,1:已完成,0:未完成)
  String? prestate;

  ///上工序状态，（0:未开工,1:加工中,2:暂停,3:加工中,4:完工）
  String? prewpstate;

  ///工序名称
  String? procedurename;

  ///工序内容
  String? proceremark;

  ///工步工时
  int? pstephours;

  ///工步id
  int? pstepid;

  ///工步名称
  String? pstepname;

  ///工步内容
  String? psteprejob;

  ///工步加工状态，0未开工、1，3正在加工、2暂停、4完成
  int? pstepstate;

  ///准备就绪状态，(0:NG,1:OK)
  int? ready;

  ///资源名称对应id
  int? resourceids;

  ///资源名称
  String? resourcenames;

  ///生产资源类型
  String? resourcetypename;

  ///返回状态
  String? result;

  ///AGV调度状态
  String? schedulingstatus;

  ///错误码
  String? schedulingstatuserror;

  ///规格
  String? standard;

  ///提交时间
  String? submittime;

  ///程式状态，(0:无,1未完成,2:部分完成,3:已完成)
  int? taskstate;

  ///托盘标识id，托盘标识id
  String? trayrequest;

  ///托盘规格
  String? traystandard;

  ///托盘类型
  String? traytype;

  ///工序工时
  int? wphours;

  ///工序顺序
  String? wpordernums;

  ///工艺对应资源id，多个逗号分隔，与工艺资源名称顺序保持一致
  String? wpresourceids;

  ///工艺资源，（多个逗号分隔）
  String? wpresourcename;

  ///工序总数
  String? wprocesscount;

  ///工序id
  int? wprocessid;

  ///工序状态，(0:未开工,1:加工中,2:暂停,3:加工中,4:完工)
  String? wpstate;

  factory ReportData.fromRawJson(String str) =>
      ReportData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ReportData.fromJson(Map<String, dynamic> json) => ReportData(
        actresourceid: json["actresourceid"],
        actresourcenames: json["actresourcenames"],
        bindstate: json["bindstate"],
        blanknorms: json["blanknorms"],
        bomtype: json["bomtype"],
        carrytoline: json["carrytoline"],
        checkresultname: json["checkresultname"],
        code: json["code"],
        designgroup: json["designgroup"],
        endtime: json["endtime"],
        freewprocess: json["freewprocess"],
        identnumber: json["identnumber"],
        judgestatename: json["judgestatename"],
        lastresid: json["lastresid"],
        lastresname: json["lastresname"],
        lastuserid: json["lastuserid"],
        mouldbasenums: json["mouldbasenums"],
        mouldnums: json["mouldnums"],
        mwnums: json["mwnums"],
        mwpiececode: json["mwpiececode"],
        mwpieceid: json["mwpieceid"],
        mwpiecename: json["mwpiecename"],
        mwpieceremainhours: json["mwpieceremainhours"],
        mwpiecesumhours: json["mwpiecesumhours"],
        nextprocedurename: json["nextprocedurename"],
        nextwpresourceids: json["nextwpresourceids"],
        nextwpresourcename: json["nextwpresourcename"],
        norms: json["norms"],
        partnums: json["partnums"],
        preprocedurename: json["preprocedurename"],
        prestate: json["prestate"],
        prewpstate: json["prewpstate"],
        procedurename: json["procedurename"],
        proceremark: json["proceremark"],
        pstephours: json["pstephours"],
        pstepid: json["pstepid"],
        pstepname: json["pstepname"],
        psteprejob: json["psteprejob"],
        pstepstate: json["pstepstate"],
        ready: json["ready"],
        resourceids: json["resourceids"],
        resourcenames: json["resourcenames"],
        resourcetypename: json["resourcetypename"],
        result: json["result"],
        schedulingstatus: json["schedulingstatus"],
        schedulingstatuserror: json["schedulingstatuserror"],
        standard: json["standard"],
        submittime: json["submittime"],
        taskstate: json["taskstate"],
        trayrequest: json["trayrequest"],
        traystandard: json["traystandard"],
        traytype: json["traytype"],
        wphours: json["wphours"],
        wpordernums: json["wpordernums"],
        wpresourceids: json["wpresourceids"],
        wpresourcename: json["wpresourcename"],
        wprocesscount: json["wprocesscount"],
        wprocessid: json["wprocessid"],
        wpstate: json["wpstate"],
      );

  Map<String, dynamic> toJson() => {
        "actresourceid": actresourceid,
        "actresourcenames": actresourcenames,
        "bindstate": bindstate,
        "blanknorms": blanknorms,
        "bomtype": bomtype,
        "carrytoline": carrytoline,
        "checkresultname": checkresultname,
        "code": code,
        "designgroup": designgroup,
        "endtime": endtime,
        "freewprocess": freewprocess,
        "identnumber": identnumber,
        "judgestatename": judgestatename,
        "lastresid": lastresid,
        "lastresname": lastresname,
        "lastuserid": lastuserid,
        "mouldbasenums": mouldbasenums,
        "mouldnums": mouldnums,
        "mwnums": mwnums,
        "mwpiececode": mwpiececode,
        "mwpieceid": mwpieceid,
        "mwpiecename": mwpiecename,
        "mwpieceremainhours": mwpieceremainhours,
        "mwpiecesumhours": mwpiecesumhours,
        "nextprocedurename": nextprocedurename,
        "nextwpresourceids": nextwpresourceids,
        "nextwpresourcename": nextwpresourcename,
        "norms": norms,
        "partnums": partnums,
        "preprocedurename": preprocedurename,
        "prestate": prestate,
        "prewpstate": prewpstate,
        "procedurename": procedurename,
        "proceremark": proceremark,
        "pstephours": pstephours,
        "pstepid": pstepid,
        "pstepname": pstepname,
        "psteprejob": psteprejob,
        "pstepstate": pstepstate,
        "ready": ready,
        "resourceids": resourceids,
        "resourcenames": resourcenames,
        "resourcetypename": resourcetypename,
        "result": result,
        "schedulingstatus": schedulingstatus,
        "schedulingstatuserror": schedulingstatuserror,
        "standard": standard,
        "submittime": submittime,
        "taskstate": taskstate,
        "trayrequest": trayrequest,
        "traystandard": traystandard,
        "traytype": traytype,
        "wphours": wphours,
        "wpordernums": wpordernums,
        "wpresourceids": wpresourceids,
        "wpresourcename": wpresourcename,
        "wprocesscount": wprocesscount,
        "wprocessid": wprocessid,
        "wpstate": wpstate,
      };
}
