import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:ammar_quiz_admin/main.dart';
import 'package:ammar_quiz_admin/models/QuizData.dart';
import 'package:ammar_quiz_admin/screens/admin/components/AppWidgets.dart';
import 'package:ammar_quiz_admin/screens/admin/components/QuizItemWidget.dart';

class QuizListScreen extends StatefulWidget {
  static String tag = '/QuizListScreen';

  @override
  _QuizListScreenState createState() => _QuizListScreenState();
}

class _QuizListScreenState extends State<QuizListScreen> {
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
      body: FutureBuilder<List<QuizData>>(
        future: quizServices.quizList,
        builder: (_, snap) {
          if (snap.hasData) {
            if (snap.data!.isEmpty) return noDataWidget();

            return SingleChildScrollView(
              padding: EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 60),
              child: Wrap(
                children: snap.data!.map((e) => QuizItemWidget(e)).toList(),
              ),
            );
          } else {
            return snapWidgetHelper(snap);
          }
        },
      ),
    ).cornerRadiusWithClipRRect(16);
  }
}
