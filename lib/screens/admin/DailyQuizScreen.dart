import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:ammar_quiz_admin/main.dart';
import 'package:ammar_quiz_admin/models/CategoryData.dart';
import 'package:ammar_quiz_admin/models/QuestionData.dart';
import 'package:ammar_quiz_admin/models/QuizData.dart';
import 'package:ammar_quiz_admin/models/QuizQuestionListData.dart';
import 'package:ammar_quiz_admin/utils/Colors.dart';
import 'package:ammar_quiz_admin/utils/Common.dart';
import 'package:ammar_quiz_admin/utils/Constants.dart';

class DailyQuizScreen extends StatefulWidget {
  final QuizData? quizData;

  DailyQuizScreen({this.quizData});

  @override
  DailyQuizScreenState createState() => DailyQuizScreenState();
}

class DailyQuizScreenState extends State<DailyQuizScreen> {
  AsyncMemoizer categoryMemoizer = AsyncMemoizer<List<CategoryData>>();
  AsyncMemoizer questionListMemoizer = AsyncMemoizer<List<QuestionData>>();
  var formKey = GlobalKey<FormState>();

  final dateController = TextEditingController();
  final pointController = TextEditingController();
  final titleController = TextEditingController();
  final imageUrlController = TextEditingController();
  final descriptionController = TextEditingController();

  FocusNode pointFocus = FocusNode();
  FocusNode dateFocus = FocusNode();
  FocusNode imageUrlFocus = FocusNode();
  FocusNode descriptionFocus = FocusNode();

  ScrollController controller = ScrollController();

  bool? _isChecked = false;
  int? selectedTime;

  DateTime? selectedDateQuiz;

  QuizQuestionListData mQuestion = QuizQuestionListData();

  List<QuestionData> questionList = [];
  List<QuestionData> selectedQuestionList = [];
  List<CategoryData> categoriesFilter = [];
  List<CategoryData> categories = [];

  late CategoryData selectedCategory;

  CategoryData? selectedCategoryForFilter;

//  CategoryData selectedCategoryForCategory;

  bool isLoading = true;
  bool mIsUpdate = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    loadQuestion();

    categoryService.categoriesFuture().then((value) async {
      categoriesFilter.add(CategoryData(name: 'All Categories'));

      categories.addAll(value);
      categoriesFilter.addAll(value);

      selectedCategoryForFilter = categoriesFilter.first;

      setState(() {});

      /// Load categories
      categories = await categoryService.categoriesFuture();

      if (categories.isNotEmpty) {
        if (mIsUpdate) {
          try {
            selectedCategory = await categoryService.getCategoryById(widget.quizData!.categoryId);

            log(selectedCategory.name);
          } catch (e) {
            print(e);
          }
        } else {
          selectedCategory = categories.first;
        }
      }

      setState(() {});
    }).catchError((e) {
      //
    });
  }

  Future<void> save() async {
    if (getBoolAsync(IS_TEST_USER)) return toast(mTestUserMsg);

    if (dateController.text.isEmpty) {
      return toast('Please Select Quiz Date');
    }
    if (selectedTime == null) {
      return toast('Please Select Quiz time');
    }
    if (formKey.currentState!.validate()) {
      QuizData quizData = QuizData();

      quizData.questionRef = selectedQuestionList.map((e) => e.id).toList();
      quizData.quizTitle = titleController.text.trim();
      quizData.imageUrl = imageUrlController.text.trim();
      quizData.description = descriptionController.text.trim();
      quizData.quizTime = selectedTime;

      String dateId = dateController.text;
      quizData.updatedAt = DateTime.now();

      await dailyQuizServices.dailyQuestionListFuture(dateId).then(
        (value) async {
          log(value.createdAt);

          /// Update
          ///
          quizData.createdAt = value.createdAt;

          await dailyQuizServices.updateDocument(quizData.toJson(), dateId).then(
            (value) {
              //
            },
          ).catchError(
            (e) {
              toast(e.toString());
            },
          );
        },
      ).catchError(
        (e) async {
          log(e);

          /// Create
          ///
          quizData.createdAt = DateTime.now();

          await dailyQuizServices.addDocumentWithCustomId(dateId, quizData.toJson()).then(
            (value) {
              toast('Add Daily Quiz Successfully');

              dateController.clear();
              pointController.clear();
              titleController.clear();
              imageUrlController.clear();
              descriptionController.clear();
              selectedQuestionList.clear();
              _isChecked = false;
              questionList.forEach(
                (element) {
                  element.isChecked = false;
                },
              );
              setState(() {});
            },
          ).catchError(
            (e) {
              log(e);
            },
          );
        },
      );
    }
  }

  Future<void> loadQuestion({DocumentReference? categoryRef}) async {
    questionServices.questionListFuture(categoryRef: categoryRef).then(
      (value) {
        isLoading = false;
        questionList.clear();
        questionList.addAll(value);

        setState(() {});
      },
    ).catchError(
      (e) {
        isLoading = false;
        setState(() {});
        toast(e.toString());
      },
    );
  }

  Future<void> updateSelectedQuestion(QuestionData data, bool? value) async {
    // if (selectedQuestionList.length >= DailyQuestionLimit && !value) return toast('Select Total number of question Limit');

    data.isChecked = value;

    if (selectedQuestionList.contains(data)) {
      selectedQuestionList.remove(data);
    } else {
      selectedQuestionList.add(data);
    }

    setState(() {});
  }

  @override
  void dispose() {
    dateController.dispose();
    controller.dispose();
    super.dispose();
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
            Text(appStore.translate("lbl_filter_question_by_category"), style: boldTextStyle()),
            8.height,
            Row(
              children: [
                if (categories.isNotEmpty)
                  Container(
                    padding: EdgeInsets.only(left: 8, right: 8),
                    decoration: BoxDecoration(
                      borderRadius: radius(),
                      color: Colors.grey.shade200,
                    ),
                    child: DropdownButton(
                      underline: Offstage(),
                      hint: Text('Please choose a category'),
                      items: categoriesFilter.map((e) {
                        return DropdownMenuItem(
                          child: Text(e.name.validate()),
                          value: e,
                        );
                      }).toList(),
                      isExpanded: true,
                      value: selectedCategoryForFilter,
                      onChanged: (dynamic c) {
                        selectedCategoryForFilter = c;

                        setState(() {});

                        if (selectedCategoryForFilter!.id == null) {
                          loadQuestion();
                        } else {
                          loadQuestion(categoryRef: categoryService.ref.doc(selectedCategoryForFilter!.id));
                        }
                      },
                    ),
                  ).expand(),
                16.width,
                AppButton(
                  padding: EdgeInsets.all(16),
                  color: colorPrimary,
                  child: Text(appStore.translate("lbl_Clear"), style: primaryTextStyle(color: white)),
                  onTap: () {
                    _isChecked = false;
                    selectedCategoryForFilter = categoriesFilter.first;
                    // selectedQuestionList.clear();
                    loadQuestion();
                  },
                ),
              ],
            ),
            16.height,
            Divider(thickness: 0.5),
            8.height,
            Align(
              alignment: Alignment.topRight,
              child: AppButton(
                padding: EdgeInsets.all(16),
                color: colorPrimary,
                child: Text(appStore.translate("lbl_save"), style: primaryTextStyle(color: white)),
                onTap: () {
                  save();
                },
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(appStore.translate("lbl_select_questions_daily_quiz"), style: boldTextStyle()),
                    16.height,
                    Container(
                      width: context.width() * 0.55,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: gray.withOpacity(0.5), width: 0.3),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: _isChecked,
                                activeColor: orange,
                                onChanged: (bool? newValue) {
                                  questionList.forEach((element) {
                                    element.isChecked = !_isChecked!;
                                  });

                                  if (_isChecked!) {
                                    selectedQuestionList.clear();
                                  } else {
                                    selectedQuestionList.clear();
                                    selectedQuestionList.addAll(questionList);
                                  }

                                  _isChecked = newValue;

                                  setState(() {});
                                },
                              ),
                              8.width,
                              Text(appStore.translate("lbl_Question"), style: boldTextStyle()),
                            ],
                          ).paddingAll(8),
                          Divider(thickness: 0.5, height: 0),
                          SingleChildScrollView(
                            child: Container(
                              decoration: BoxDecoration(color: gray.withOpacity(0.1)),
                              height: context.height() * 0.5,
                              child: Scrollbar(
                                thickness: 5.0,
                                isAlwaysShown: false,
                                controller: controller,
                                radius: Radius.circular(16),
                                child: ListView.separated(
                                  shrinkWrap: true,
                                  itemCount: questionList.length,
                                  // physics: NeverScrollableScrollPhysics(),
                                  separatorBuilder: (_, i) => Divider(height: 0),
                                  itemBuilder: (_, index) {
                                    QuestionData data = questionList[index];

                                    return Row(
                                      children: [
                                        Checkbox(
                                          activeColor: orange,
                                          value: data.isChecked.validate(),
                                          onChanged: (newValue) {
                                            updateSelectedQuestion(data, newValue);
                                          },
                                        ),
                                        8.width,
                                        Text(data.questionTitle.toString(), style: secondaryTextStyle()).expand(),
                                      ],
                                    ).paddingAll(8).onTap(
                                      () {
                                        updateSelectedQuestion(data, !data.isChecked!);
                                      },
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ).expand(flex: 4),
                16.width,
                Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(appStore.translate("lbl_selected_question_list"), style: boldTextStyle()),
                      16.height,
                      AppTextField(
                        controller: titleController,
                        textFieldType: TextFieldType.NAME,
                        decoration: inputDecoration(labelText: appStore.translate("lbl_title")),
                        nextFocus: dateFocus,
                        validator: (s) {
                          if (s!.trim().isEmpty) return errorThisFieldRequired;
                          return null;
                        },
                      ),
                      16.height,
                      Row(
                        children: [
                          AppTextField(
                            readOnly: true,
                            controller: dateController,
                            textFieldType: TextFieldType.OTHER,
                            nextFocus: pointFocus,
                            focus: dateFocus,
                            decoration: inputDecoration(labelText: appStore.translate("lbl_pick_your_date")),
                            onTap: () {
                              showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2021),
                                lastDate: DateTime(2022),
                                currentDate: selectedDateQuiz,
                              ).then((date) {
                                if (date != null) {
                                  selectedDateQuiz = date;

                                  dateController.text = DateFormat(CurrentDateFormat).format(date);
                                }
                              }).catchError((e) {
                                log(e);
                              });
                            },
                            validator: (s) {
                              if (s!.trim().isEmpty) return errorThisFieldRequired;
                              return null;
                            },
                          ).expand(),
                          16.width,
                          DropdownButtonFormField(
                            hint: Text(appStore.translate("lbl_Quiz_Time"), style: secondaryTextStyle()),
                            value: selectedTime,
                            items: List.generate(
                              12,
                              (index) {
                                return DropdownMenuItem(
                                  value: (index + 1) * 5,
                                  child: Text('${(index + 1) * 5} Minutes', style: primaryTextStyle()),
                                );
                              },
                            ),
                            onChanged: (dynamic value) {
                              selectedTime = value;
                            },
                            decoration: inputDecoration(),
                          ).expand(),
                        ],
                      ),
                      16.height,
                      AppTextField(
                        controller: imageUrlController,
                        textFieldType: TextFieldType.NAME,
                        decoration: inputDecoration(labelText: appStore.translate("lbl_image_uRL")),
                        focus: imageUrlFocus,
                        nextFocus: descriptionFocus,
                        validator: (s) {
                          if (s!.isEmpty) return errorThisFieldRequired;
                          if (!s.validateURL()) return 'URL is invalid';
                          return null;
                        },
                      ),
                      16.height,
                      AppTextField(
                        controller: descriptionController,
                        textFieldType: TextFieldType.NAME,
                        maxLines: 3,
                        minLines: 3,
                        decoration: inputDecoration(labelText: appStore.translate("lbl_description")),
                        focus: descriptionFocus,
                        isValidationRequired: false,
                      ),
                      8.height,
                      Container(
                        width: context.width() * 0.5,
                        child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: selectedQuestionList.length,
                          itemBuilder: (_, index) {
                            QuestionData data = selectedQuestionList[index];

                            return Stack(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(16),
                                  margin: EdgeInsets.symmetric(vertical: 2),
                                  decoration: BoxDecoration(color: gray.withOpacity(0.1)),
                                  child: Row(
                                    children: [
                                      8.width,
                                      Text('${index + 1}', style: secondaryTextStyle()),
                                      16.width,
                                      Text(
                                        data.questionTitle!,
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style: secondaryTextStyle(),
                                      ).expand(),
                                    ],
                                  ),
                                ),
                                Align(
                                  child: Container(
                                    height: 30,
                                    width: 30,
                                    margin: EdgeInsets.only(right: 16, top: 4),
                                    decoration: boxDecorationWithRoundedCorners(
                                      borderRadius: BorderRadius.circular(8),
                                      backgroundColor: appButtonColor,
                                    ),
                                    child: IconButton(
                                      icon: Icon(Icons.clear, size: 16, color: white),
                                      onPressed: () {
                                        updateSelectedQuestion(data, !data.isChecked!);
                                        if (selectedQuestionList.contains(data)) {
                                          selectedQuestionList.remove(data);
                                        }
                                        setState(() {});
                                      },
                                    ),
                                  ),
                                  alignment: Alignment.centerRight,
                                ).paddingOnly(top: 8),
                              ],
                            );
                          },
                        ),
                      )
                    ],
                  ).expand(flex: 6),
                )
              ],
            ),
            16.height,
          ],
        ).paddingAll(16),
      ),
    ).cornerRadiusWithClipRRect(16);
  }
}
