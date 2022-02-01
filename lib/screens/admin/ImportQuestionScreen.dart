import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class ImportQuestionScreen extends StatefulWidget {
  @override
  ImportQuestionScreenState createState() => ImportQuestionScreenState();
}

class ImportQuestionScreenState extends State<ImportQuestionScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('Import Question', style: boldTextStyle()).center(),
    );
  }
}
