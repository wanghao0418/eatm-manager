/*
 * @Author: wanghao wanghao@oureman.com
 * @Date: 2023-09-01 14:41:28
 * @LastEditors: wanghao wanghao@oureman.com
 * @LastEditTime: 2023-09-01 15:15:19
 * @FilePath: /eatm_manager/lib/pages/business/electrode_binding/widgets/clip_details.dart
 * @Description: 夹位信息详情
 */
import 'package:eatm_manager/common/components/line_form_label.dart';
import 'package:eatm_manager/common/components/themed_text.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ClipDetails extends StatefulWidget {
  const ClipDetails({Key? key}) : super(key: key);

  @override
  _ClipDetailsState createState() => _ClipDetailsState();
}

class _ClipDetailsState extends State<ClipDetails> {
  // 电极编号
  Widget _buildClipNo() {
    return Row(
      children: [
        Expanded(
            child: LineFormLabel(
                label: '电极编号',
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                isExpanded: true,
                child: Tooltip(
                  message: '完整',
                  child: ThemedText(
                    '1',
                    style: TextStyle(overflow: TextOverflow.ellipsis),
                    textAlign: TextAlign.end,
                  ),
                )))
      ],
    );
  }

  // 详情
  Widget _buildDetails() {
    var row1 = Row(
      children: [
        Expanded(
          child: LineFormLabel(
              label: '规格',
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              isExpanded: true,
              child: Tooltip(
                message: '完整',
                child: ThemedText(
                  '11111111111111111111111111111111',
                  style: TextStyle(overflow: TextOverflow.ellipsis),
                  textAlign: TextAlign.end,
                ),
              )),
        ),
        10.horizontalSpace,
        Expanded(
          child: LineFormLabel(
              label: '材质',
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              isExpanded: true,
              child: Tooltip(
                message: '完整',
                child: ThemedText(
                  '11111111111111111111111111111111',
                  style: TextStyle(overflow: TextOverflow.ellipsis),
                  textAlign: TextAlign.end,
                ),
              )),
        ),
        10.horizontalSpace,
        Expanded(
          child: LineFormLabel(
              label: 'X',
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              isExpanded: true,
              child: Tooltip(
                message: '完整',
                child: ThemedText(
                  '11111111111111111111111111111111',
                  style: TextStyle(overflow: TextOverflow.ellipsis),
                  textAlign: TextAlign.end,
                ),
              )),
        )
      ],
    );

    var row2 = Row(
      children: [
        Spacer(
          flex: 2,
        ),
        20.horizontalSpace,
        Expanded(
          child: LineFormLabel(
              label: 'Y',
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              isExpanded: true,
              child: Tooltip(
                message: '完整',
                child: ThemedText(
                  '11111111111111111111111111111111',
                  style: TextStyle(overflow: TextOverflow.ellipsis),
                  textAlign: TextAlign.end,
                ),
              )),
        ),
      ],
    );

    var row3 = Row(
      children: [
        Expanded(
          child: LineFormLabel(
              label: '预调高度',
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              isExpanded: true,
              child: Tooltip(
                message: '完整',
                child: ThemedText(
                  '11111111111111111111111111111111',
                  style: TextStyle(overflow: TextOverflow.ellipsis),
                  textAlign: TextAlign.end,
                ),
              )),
        ),
        10.horizontalSpace,
        Expanded(
          child: LineFormLabel(
              label: '夹具',
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              isExpanded: true,
              child: Tooltip(
                message: '完整',
                child: ThemedText(
                  '11111111111111111111111111111111',
                  style: TextStyle(overflow: TextOverflow.ellipsis),
                  textAlign: TextAlign.end,
                ),
              )),
        ),
        10.horizontalSpace,
        Expanded(
          child: LineFormLabel(
              label: 'Z',
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              isExpanded: true,
              child: Tooltip(
                message: '完整',
                child: ThemedText(
                  '11111111111111111111111111111111',
                  style: TextStyle(overflow: TextOverflow.ellipsis),
                  textAlign: TextAlign.end,
                ),
              )),
        ),
      ],
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [_buildClipNo(), row1, row2, row3],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(10),
        child: _buildDetails());
  }
}
