import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:ammar_quiz_admin/main.dart';
import 'package:ammar_quiz_admin/models/QuestionData.dart';
import 'package:ammar_quiz_admin/models/QuizData.dart';
import 'package:ammar_quiz_admin/utils/Colors.dart';
import 'package:ammar_quiz_admin/utils/Common.dart';

class QuizDetailWidget extends StatefulWidget {
  final QuizData? data;

  QuizDetailWidget({this.data});

  @override
  QuizDetailWidgetState createState() => QuizDetailWidgetState();
}

class QuizDetailWidgetState extends State<QuizDetailWidget> {
  List<QuestionData> quizQuestionsList = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    widget.data!.questionRef!.forEach(
      (e) async {
        await questionServices.questionById(e).then(
          (value) {
            quizQuestionsList.add(value);
            setState(() {});
          },
        ).catchError(
          (e) {
            throw e.toString();
          },
        );
      },
    );
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(appStore.translate("lbl_quiz_title"), style: boldTextStyle(size: 18)),
                16.width,
                Text(widget.data!.quizTitle!, style: primaryTextStyle()),
              ],
            ),
            16.height,
            Wrap(
              runSpacing: 16,
              spacing: 16,
              children: [
                itemWidget(colorPrimary, white, appStore.translate("lbl_quiz_time"), '${widget.data!.quizTime.validate()} minutes")'),
                itemWidget(colorPrimary, white, appStore.translate("lbl_required_point"), widget.data!.minRequiredPoint.toString()),
                if (widget.data!.createdAt != null)
                  itemWidget(
                    colorPrimary,
                    white,
                    appStore.translate("lbl_quiz_date"),
                    DateFormat('dd-MM-yyyy').format(widget.data!.createdAt!),
                  ),
              ],
            ),
            16.height,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: quizQuestionsList
                  .map(
                    (e) => Container(
                      padding: EdgeInsets.all(16),
                      margin: EdgeInsets.only(top: 8, bottom: 8),
                      decoration: boxDecorationWithRoundedCorners(border: Border.all(color: gray.withOpacity(0.5), width: 0.1)),
                      child: Row(
                        children: [
                          Text("${quizQuestionsList.indexOf(e) + 1}", style: primaryTextStyle()),
                          16.width,
                          Text(e.questionTitle!, style: primaryTextStyle(color: salmon)).expand(),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ).paddingAll(8),
      ),
    );
  }
}
