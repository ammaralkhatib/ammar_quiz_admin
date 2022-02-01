import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:ammar_quiz_admin/models/QuizData.dart';
import 'package:ammar_quiz_admin/screens/admin/CreateQuizScreen.dart';
import 'package:ammar_quiz_admin/screens/admin/components/QuizDetailWidget.dart';

class QuizItemWidget extends StatefulWidget {
  static String tag = '/QuizItemWidget';
  final QuizData data;

  QuizItemWidget(this.data);

  @override
  _QuizItemWidgetState createState() => _QuizItemWidgetState();
}

class _QuizItemWidgetState extends State<QuizItemWidget> {
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
    return Container(
      width: 200,
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(8),
      decoration: boxDecorationWithRoundedCorners(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(blurRadius: 5, spreadRadius: 1, color: gray.withOpacity(0.2)),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Stack(
            children: [
              Image.network(
                widget.data.imageUrl!,
                height: 180,
                fit: BoxFit.cover,
              ).cornerRadiusWithClipRRect(16),
              Positioned(
                right: 0,
                child: IconButton(
                  icon: Icon(Icons.edit, color: Colors.white),
                  onPressed: () {
                    CreateQuizScreen(quizData: widget.data).launch(context);
                  },
                ),
              ),
            ],
          ),
          16.height,
          Text(widget.data.quizTitle!, style: boldTextStyle()),
        ],
      ),
    ).onTap(
      () {
        showInDialog(
          context,
          child: Container(
            width: context.width() * 0.65,
            height: 500,
            child: QuizDetailWidget(data: widget.data),
          ),
        );
      },
    );
  }
}
