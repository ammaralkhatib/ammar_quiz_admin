import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:ammar_quiz_admin/main.dart';
import 'package:ammar_quiz_admin/models/CategoryData.dart';
import 'package:ammar_quiz_admin/models/QuestionData.dart';
import 'package:ammar_quiz_admin/models/QuizData.dart';
import 'package:ammar_quiz_admin/screens/admin/components/QuestionsPaginationWidget.dart';
import 'package:ammar_quiz_admin/utils/Colors.dart';

class AllQuestionsListWidget extends StatefulWidget {
  final QuizData? quizData;

  AllQuestionsListWidget({this.quizData});

  @override
  AllQuestionsListWidgetState createState() => AllQuestionsListWidgetState();
}

class AllQuestionsListWidgetState extends State<AllQuestionsListWidget> {
  Query questionQuery = questionServices.getQuestions();
  UniqueKey uniqueKey = UniqueKey();

  //List<CategoryData> categories = [];
  List<CategoryData> categoriesFilter = [];
  List<QuestionData> questionList = [];

  CategoryData? selectedCategoryForFilter;
  bool isLoading = true;
  bool isUpdate = false;
  late CategoryData selectedCategory;

  ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    /// Load categories
    categoryService.categoriesFuture().then((value) async {
      categoriesFilter.add(CategoryData(name: 'All Categories'));
      categoriesFilter.addAll(value);

      selectedCategoryForFilter = categoriesFilter.first;

      if (categoriesFilter.isNotEmpty) {
        if (isUpdate) {
          try {
            selectedCategory = await categoryService.getCategoryById(widget.quizData!.categoryId);
          } catch (e) {
            log(e);
          }
        } else {
          selectedCategory = categoriesFilter.first;
        }
      }

      setState(() {});
    }).catchError((e) {
      //
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        title: Container(
          height: 150,
          child: Row(
            children: [
              Text(appStore.translate("lbl_all_questions"), style: boldTextStyle()),
              16.width,
              Row(
                children: [
                  if (categoriesFilter.isNotEmpty)
                    Container(
                      padding: EdgeInsets.only(left: 8, right: 8),
                      decoration: BoxDecoration(borderRadius: radius(), color: Colors.grey.shade200),
                      child: DropdownButton(
                        underline: Offstage(),
                        hint: Text('Please choose a category'),
                        items: categoriesFilter.map((e) {
                          return DropdownMenuItem(child: Text(e.name.validate()), value: e);
                        }).toList(),
                        // isExpanded: true,
                        value: selectedCategoryForFilter,
                        onChanged: (dynamic c) {
                          selectedCategoryForFilter = c;
                          if (selectedCategoryForFilter!.name == 'All Categories') {
                            questionQuery = questionServices.getQuestions();
                          } else {
                            questionQuery = questionServices.getQuestions(categoryRef: categoryService.ref.doc(selectedCategoryForFilter!.id));
                          }

                          uniqueKey = UniqueKey();
                          setState(() {});
                        },
                      ),
                    ),
                  16.width,
                  AppButton(
                    padding: EdgeInsets.all(16),
                    color: colorPrimary,
                    child: Text(appStore.translate("lbl_Clear"), style: primaryTextStyle(color: white)),
                    onTap: () {
                      selectedCategoryForFilter = categoriesFilter.first;

                      questionQuery = questionServices.getQuestions();

                      uniqueKey = UniqueKey();
                      setState(() {});
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: Scrollbar(
        thickness: 5.0,
        controller: controller,
        radius: Radius.circular(16),
        child: QuestionsPaginationWidget(uniqueKey, questionQuery),
      ),
    ).cornerRadiusWithClipRRect(16);
  }
}
