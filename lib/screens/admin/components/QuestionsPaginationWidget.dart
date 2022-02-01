import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:ammar_quiz_admin/models/QuestionData.dart';
import 'package:ammar_quiz_admin/utils/Colors.dart';
import 'package:ammar_quiz_admin/utils/Constants.dart';

import '../../../main.dart';
import '../AddNewQuestionsScreen.dart';
import 'AppWidgets.dart';

class QuestionsPaginationWidget extends StatefulWidget {
  final Query questionQuery;
  final UniqueKey uniqueKey;

  QuestionsPaginationWidget(this.uniqueKey, this.questionQuery);

  @override
  _QuestionsPaginationWidgetState createState() => _QuestionsPaginationWidgetState();
}

class _QuestionsPaginationWidgetState extends State<QuestionsPaginationWidget> {
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
    return PaginateFirestore(
      key: widget.uniqueKey,
      query: widget.questionQuery,
      itemBuilderType: PaginateBuilderType.listView,
      itemBuilder: (index, context, documentSnapshot) {
        QuestionData data = QuestionData.fromJson(documentSnapshot.data() as Map<String, dynamic>);

        return Container(
          decoration: BoxDecoration(boxShadow: defaultBoxShadow(), color: Colors.white, borderRadius: radius()),
          margin: EdgeInsets.only(bottom: 16, top: 16, right: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
                    margin: EdgeInsets.only(top: 8, bottom: 8),
                    decoration: boxDecorationWithRoundedCorners(border: Border.all(color: gray.withOpacity(0.4), width: 0.1)),
                    child: Text('${index + 1}. ${data.questionTitle}', style: boldTextStyle(color: colorPrimary, size: 18)),
                  ).expand(),
                  16.width,
                  IconButton(
                    icon: Icon(Icons.edit, color: black),
                    onPressed: () {
                      AddNewQuestionsScreen(data: data).launch(context);
                    },
                  )
                ],
              ),
              16.height,
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Wrap(
                  direction: Axis.horizontal,
                  children: data.optionList!.map(
                    (e) {
                      return Container(
                        padding: EdgeInsets.all(8),
                        margin: EdgeInsets.only(right: 16),
                        //  width: 100,
                        alignment: Alignment.center,
                        decoration: boxDecorationWithRoundedCorners(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: gray.withOpacity(0.4), width: 0.1),
                        ),
                        child: Text(e, style: secondaryTextStyle(color: black)),
                      );
                    },
                  ).toList(),
                ),
              ),
              16.height,
              Row(
                children: [
                  Text(appStore.translate("lbl_correct_answer"), style: boldTextStyle(size: 18)),
                  8.width,
                  data.isMultipleChoice!
                      ? Row(
                          children: data.answerList!.map((data) {
                            return Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(8),
                              margin:EdgeInsets.only(right: 8),
                              decoration: boxDecorationWithRoundedCorners(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: gray.withOpacity(0.4), width: 0.1),
                              ),
                              child: Text(data, style: boldTextStyle()),
                            );
                          }).toList(),
                        )
                      : Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(8),
                          decoration: boxDecorationWithRoundedCorners(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: gray.withOpacity(0.4), width: 0.1),
                          ),
                          child: Text(data.correctAnswer!, style: boldTextStyle()),
                        )
                ],
              ),
            ],
          ).paddingSymmetric(horizontal: 16, vertical: 16),
        );
      },
      shrinkWrap: true,
      padding: EdgeInsets.all(8),
      itemsPerPage: DocLimit,
      bottomLoader: Loader(),
      initialLoader: Loader(),
      isLive: false,
      emptyDisplay: noDataWidget(),
      onError: (e) => Text(e.toString(), style: primaryTextStyle()).center(),
    );
  }
}
