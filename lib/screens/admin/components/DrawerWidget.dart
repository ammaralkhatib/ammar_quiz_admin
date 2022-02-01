import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:ammar_quiz_admin/models/ListModel.dart';
import 'package:ammar_quiz_admin/screens/admin/AddNewQuestionsScreen.dart';
import 'package:ammar_quiz_admin/screens/admin/AdminSettingScreen.dart';
import 'package:ammar_quiz_admin/screens/admin/CategoryListScreen.dart';
import 'package:ammar_quiz_admin/screens/admin/CreateQuizScreen.dart';
import 'package:ammar_quiz_admin/screens/admin/DailyQuizScreen.dart';
import 'package:ammar_quiz_admin/screens/admin/UserListScreen.dart';
import 'package:ammar_quiz_admin/screens/admin/components/AdminStatisticsWidget.dart';
import 'package:ammar_quiz_admin/utils/Colors.dart';
import 'package:ammar_quiz_admin/utils/String.dart';

import 'AllQuestionsListWidget.dart';
import 'QuizListScreen.dart';

class DrawerWidget extends StatefulWidget {
  static String tag = '/DrawerWidget';
  final Function(Widget?)? onWidgetSelected;

  DrawerWidget({this.onWidgetSelected});

  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  List<ListModel> list = [];

  int index = 0;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    list.add(ListModel(name: lbl_dashboard, widget: AdminStatisticsWidget(), iconData: AntDesign.dashboard));
    list.add(ListModel(name: lbl_category_list, widget: CategoryListScreen(), imageAsset: 'assets/category.png'));
    list.add(ListModel(name: lbl_add_question, widget: AddNewQuestionsScreen(), imageAsset: 'assets/addQuestion.png'));
    list.add(ListModel(name: lbl_question_list, widget: AllQuestionsListWidget(), imageAsset: 'assets/allquestion.png'));
    list.add(ListModel(name: lbl_daily_quiz, widget: DailyQuizScreen(), imageAsset: 'assets/dailyQuiz.png'));
    list.add(ListModel(name: lbl_quiz_list, widget: QuizListScreen(), imageAsset: 'assets/allQuiz.png'));
    list.add(ListModel(name: lbl_create_quiz, widget: CreateQuizScreen(), imageAsset: 'assets/createQuiz.png'));
    //list.add(ListModel(name: 'Import Question', widget: ImportQuestionScreen(), imageAsset: 'assets/import.png'));
    //list.add(ListModel(name: 'Notifications', widget: NotificationScreen(), iconData: AntDesign.bells));
    list.add(ListModel(name: lbl_manage_users, widget: UserListScreen(), iconData: Feather.users));
    list.add(ListModel(name: lbl_settings, widget: AdminSettingScreen(), iconData: Feather.settings));

    LiveStream().on(
      'selectItem',
      (index) {
        this.index = index as int;

        widget.onWidgetSelected?.call(list[this.index].widget);

        setState(() {});
      },
    );
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    LiveStream().dispose('selectItem');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 30),
        child: Wrap(
          children: list.map(
            (e) {
              int cIndex = list.indexOf(e);

              return SettingItemWidget(
                title: e.name!,
                leading: e.iconData != null
                    ? Icon(e.iconData, color: cIndex == index ? colorPrimary : Colors.white, size: 24)
                    : Image.asset(e.imageAsset!, color: cIndex == index ? colorPrimary : Colors.white, height: 24),
                titleTextColor: cIndex == index ? colorPrimary : Colors.white,
                decoration: BoxDecoration(
                  color: cIndex == index ? selectedDrawerItemColor : null,
                  //  border: Border.all(),
                  borderRadius: cIndex == index - 1
                      ? BorderRadius.only(bottomRight: Radius.circular(24), topLeft: Radius.circular(24), bottomLeft: Radius.circular(24))
                      : cIndex == index + 1
                          ? BorderRadius.only(topRight: Radius.circular(24), topLeft: Radius.circular(24), bottomLeft: Radius.circular(24))
                          : BorderRadius.only(topLeft: Radius.circular(24), bottomLeft: Radius.circular(24)),
                ),
                onTap: () {
                  index = list.indexOf(e);
                  widget.onWidgetSelected?.call(e.widget);
                },
              );
            },
          ).toList(),
        ),
      ),
    );
  }
}
