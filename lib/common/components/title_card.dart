import 'package:fluent_ui/fluent_ui.dart';

class TitleCard extends StatefulWidget {
  final String title;
  final Widget containChild;
  final Color cardBackgroundColor;
  final Color headBorderColor;
  final Widget? titleRight;
  final Color? headTextColor;
  const TitleCard(
      {Key? key,
      this.title = "",
      required this.containChild,
      required this.cardBackgroundColor,
      this.headBorderColor = const Color(0xffDCDFE6),
      this.titleRight,
      this.headTextColor})
      : super(key: key);

  @override
  State<TitleCard> createState() => _MyCardState();
}

class _MyCardState extends State<TitleCard> {
  // GlobalTheme get globalTheme => GlobalTheme.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Widget renderContainer(
      BuildContext context,
      String title,
      Widget containChild,
      Color headBorderColor,
      Widget? titleRight,
      Color? headTextColor) {
    return title == ''
        ? SizedBox(
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    child: containChild,
                  ),
                )
              ],
            ),
          )
        : SizedBox(
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      border: Border(
                          bottom:
                              BorderSide(width: 1, color: headBorderColor))),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: headTextColor ??
                                  FluentTheme.of(context)
                                      .typography
                                      .body
                                      ?.color),
                        ),
                        Container(
                          child: titleRight,
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    child: containChild,
                  ),
                )
              ],
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
          color: widget.cardBackgroundColor,
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          boxShadow: const [
            BoxShadow(
                color: Color.fromARGB(20, 0, 0, 0),
                offset: Offset(2, 2),
                blurRadius: 5),
          ]),
      child: renderContainer(context, widget.title, widget.containChild,
          widget.headBorderColor, widget.titleRight, widget.headTextColor),
    );
  }
}
