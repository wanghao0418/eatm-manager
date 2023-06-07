import 'package:fluent_ui/fluent_ui.dart';

class Ceshi extends StatefulWidget {
  const Ceshi({Key? key}) : super(key: key);

  @override
  _CeshiState createState() => _CeshiState();
}

class _CeshiState extends State<Ceshi> with AutomaticKeepAliveClientMixin {
  int count = 0;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
        child: Center(
      child: TextButton(
        onPressed: () {
          setState(() {
            count++;
          });
        },
        child: Text('点击了$count次'),
      ),
    ));
  }
}
