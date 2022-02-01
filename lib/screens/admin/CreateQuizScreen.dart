import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:ammar_quiz_admin/main.dart';
import 'package:ammar_quiz_admin/models/CategoryData.dart';
import 'package:ammar_quiz_admin/models/QuestionData.dart';
import 'package:ammar_quiz_admin/models/QuizData.dart';
import 'package:ammar_quiz_admin/utils/Colors.dart';
import 'package:ammar_quiz_admin/utils/Common.dart';
import 'package:ammar_quiz_admin/utils/Constants.dart';

class CreateQuizScreen extends StatefulWidget {
  final QuizData? quizData;

  CreateQuizScreen({this.quizData});

  @override
  CreateQuizScreenState createState() => CreateQuizScreenState();
}

class CreateQuizScreenState extends State<CreateQuizScreen> {
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

  bool isLoading = true;

  List<QuestionData> questionList = [];
  List<QuestionData> selectedQuestionList = [];

  CategoryData? selectedCategoryForFilter;

  CategoryData? selectedCategory;

  //Add Line
  CategoryData? selectedSubCategory;

  bool isUpdate = false;

  List<CategoryData> categoriesFilter = [];
  List<CategoryData> categories = [];

  //Add Line
  List<CategoryData> subCategories = [];

  bool mIsUpdate = false;
  bool selectSubCategoryValue = false;
  bool? sendNotification = true;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    mIsUpdate = widget.quizData != null;

    // Don't send push notifications when updating by default.
    sendNotification = !isUpdate;

    if (mIsUpdate) {
      dateController.text = DateFormat(CurrentDateFormat).format(widget.quizData!.createdAt!);
      pointController.text = widget.quizData!.minRequiredPoint.toString();
      titleController.text = widget.quizData!.quizTitle.validate();
      imageUrlController.text = widget.quizData!.imageUrl.validate();
      descriptionController.text = widget.quizData!.description.validate();

      selectedTime = widget.quizData!.quizTime.validate(value: 5);
    }

    loadQuestion();

    categoryService.categoriesFuture().then(
      (value) async {
        categoriesFilter.add(CategoryData(name: 'All Categories'));

        categories.addAll(value);
        categoriesFilter.addAll(value);

        selectedCategoryForFilter = categoriesFilter.first;

        setState(() {});

        /// Load categories
        categories = await categoryService.categoriesFuture();

        if (categories.isNotEmpty) {
          if (isUpdate) {
            try {
              selectedCategory = await categoryService.getCategoryById(widget.quizData!.categoryId);

              log(selectedCategory!.name);
            } catch (e) {
              print(e);
            }
          } else {
            selectedCategory = categories.first;
          }
        }

        setState(() {});
      },
    ).catchError(
      (e) {
        //
      },
    );
  }

  Future<void> loadSubCategories(String catId) async {
    subCategories = await categoryService.subCategoriesFuture(parentCategoryId: catId);

    if (subCategories.isNotEmpty) {
      selectedSubCategory = subCategories.first;
    } else {
      selectedSubCategory = null;
    }
    setState(() {});
  }

  Future<void> save() async {
    if (getBoolAsync(IS_TEST_USER)) return toast(mTestUserMsg);

    if (selectedTime == null) {
      return toast('Please Select Quiz time');
    }
    if (formKey.currentState!.validate()) {
      QuizData quizData = QuizData();

      quizData.questionRef = selectedQuestionList.map((e) => e.id).toList();
      quizData.minRequiredPoint = pointController.text.toInt();
      quizData.quizTitle = titleController.text.trim();
      quizData.imageUrl = imageUrlController.text.trim();
      quizData.quizTime = selectedTime;
      quizData.description = descriptionController.text.trim();
      quizData.updatedAt = DateTime.now();

      if (selectedCategory != null) {
        quizData.categoryId = selectedCategory!.id;
      }

      if (selectSubCategoryValue == true) {
        if (selectedSubCategory != null) {
          quizData.subCategoryId = selectedSubCategory!.id;
        }
      } else {
        if (selectedSubCategory != null) {
          quizData.subCategoryId = '';
        }
      }

      if (mIsUpdate) {
        /// Update
        quizData.createdAt = widget.quizData!.createdAt;

        await quizServices.updateDocument(quizData.toJson(), widget.quizData!.id).then((value) {
          toast('Updated');

          finish(context);
        }).catchError((e) {
          toast(e.toString());
        });
      } else {
        ///Create quiz
        quizData.createdAt = DateTime.now();

        await quizServices.addDocument(quizData.toJson()).then(
          (value) {
            toast('Quiz Added');

            if (sendNotification!) {
              //Send push notification

              sendPushNotifications('New Quiz Added', parseHtmlString(titleController.text.trim()), id: value.id);
            }

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
      }
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
      appBar: mIsUpdate ? appBarWidget(widget.quizData!.quizTitle.validate()) : null,
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
                      items: categoriesFilter.map(
                        (e) {
                          return DropdownMenuItem(
                            child: Text(e.name.validate()),
                            value: e,
                          );
                        },
                      ).toList(),
                      isExpanded: true,
                      value: selectedCategoryForFilter,
                      onChanged: (dynamic c) {
                        selectedCategoryForFilter = c;
                        //  catRef = categoryService.ref!.doc(c!.id);

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
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (categories.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(appStore.translate("lbl_select_category"), style: boldTextStyle()),
                      8.height,
                      Container(
                        width: context.width() * 0.45,
                        decoration: BoxDecoration(borderRadius: radius(), color: Colors.grey.shade200),
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        child: DropdownButton(
                          underline: Offstage(),
                          items: categories.map(
                            (e) {
                              return DropdownMenuItem(child: Text(e.name.validate()), value: e);
                            },
                          ).toList(),
                          isExpanded: true,
                          value: selectedCategory,
                          onChanged: (dynamic c) {
                            selectedCategory = c;
                            loadSubCategories(selectedCategory!.id!);
                          },
                        ),
                      ),
                    ],
                  ).expand(),
                16.width,
                selectedSubCategory != null && subCategories.isNotEmpty
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Select Sub Category', style: boldTextStyle()),
                          8.height,
                          Container(
                            width: context.width() * 0.45,
                            margin: EdgeInsets.only(bottom: 23),
                            decoration: BoxDecoration(borderRadius: radius(), color: Colors.grey.shade200),
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                            child: DropdownButton<CategoryData>(
                              value: selectedSubCategory,
                              underline: Offstage(),
                              hint: Text('Select Sub Category', style: secondaryTextStyle()),
                              items: subCategories.map<DropdownMenuItem<CategoryData>>((e) {
                                return DropdownMenuItem(
                                  child: Text(e.name.validate()),
                                  value: e,
                                );
                              }).toList(),
                              isExpanded: true,
                              onChanged: (c) {
                                selectedSubCategory = c;
                                selectSubCategoryValue = true;
                                setState(() {});
                              },
                            ),
                          ),
                        ],
                      ).expand()
                    : Text(
                        appStore.translate("lbl_not_subcategory"),
                        style: boldTextStyle(),
                        textAlign: TextAlign.start,
                      ).paddingOnly(top: 40, right: 30),
                8.width,
                AppButton(
                  padding: EdgeInsets.all(16),
                  color: colorPrimary,
                  child: Text(appStore.translate("lbl_save"), style: primaryTextStyle(color: white)),
                  onTap: () {
                    save();
                  },
                ).paddingOnly(top: 34),
              ],
            ),
            16.height,
            Divider(thickness: 0.5),
            16.height,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(appStore.translate("lbl_select_questions"), style: boldTextStyle()),
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
                                  questionList.forEach(
                                    (element) {
                                      element.isChecked = !_isChecked!;
                                    },
                                  );

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
                          Divider(color: gray, thickness: 0.5, height: 0),
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
                            controller: pointController,
                            textFieldType: TextFieldType.PHONE,
                            decoration: inputDecoration(labelText: appStore.translate("lbl_Required_point")),
                            focus: pointFocus,
                            nextFocus: imageUrlFocus,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
