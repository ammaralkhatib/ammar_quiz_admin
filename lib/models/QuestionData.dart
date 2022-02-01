import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ammar_quiz_admin/utils/ModelKeys.dart';

class QuestionData {
  String? id;
  String? questionType;
  String? correctAnswer;
  String? note;
  String? questionTitle;
  bool? isChecked;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<String>? optionList;
  String? image;
  bool? isMultipleChoice;
  List<String>? answerList;

  DocumentReference? categoryRef;
  String? subcategoryId;

  QuestionData({
    this.id,
    this.questionType,
    this.correctAnswer,
    this.note,
    this.questionTitle,
    this.categoryRef,
    this.isChecked = false,
    this.createdAt,
    this.updatedAt,
    this.optionList,
    this.subcategoryId,
    this.image,
    this.isMultipleChoice,
    this.answerList,
  });

  factory QuestionData.fromJson(Map<String, dynamic> json) {
    return QuestionData(
      id: json[CommonKeys.id],
      questionType: json[QuestionKeys.questionType],
      correctAnswer: json[QuestionKeys.correctAnswer],
      note: json[QuestionKeys.note],
      questionTitle: json[QuestionKeys.addQuestion],
      categoryRef: json[NewsKeys.categoryRef] != null ? (json[NewsKeys.categoryRef] as DocumentReference?) : null,
      createdAt: json[CommonKeys.createdAt] != null ? (json[CommonKeys.createdAt] as Timestamp).toDate() : null,
      updatedAt: json[CommonKeys.updatedAt] != null ? (json[CommonKeys.updatedAt] as Timestamp).toDate() : null,
      optionList: json[QuestionKeys.optionList].cast<String>(),
      subcategoryId: json[QuestionKeys.subcategoryId],
      image: json[CategoryKeys.image],
      isMultipleChoice: json[QuestionKeys.isMultipleChoice],
      answerList: (json[QuestionKeys.answerList] ?? []).cast<String>(),
    );
  }

  Map<String, dynamic> toJson({bool toStore = true}) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[CommonKeys.id] = this.id;
    data[QuestionKeys.questionType] = this.questionType;
    data[QuestionKeys.correctAnswer] = this.correctAnswer;
    data[QuestionKeys.note] = this.note;
    data[QuestionKeys.addQuestion] = this.questionTitle;
    if (toStore) data[NewsKeys.categoryRef] = this.categoryRef;
    data[CommonKeys.createdAt] = this.createdAt;
    data[CommonKeys.updatedAt] = this.updatedAt;
    data[QuestionKeys.optionList] = this.optionList;
    data[QuestionKeys.subcategoryId] = this.subcategoryId;
    data[CategoryKeys.image] = this.image;
    data[QuestionKeys.isMultipleChoice] = this.isMultipleChoice;
    data[QuestionKeys.answerList] = this.answerList;
    return data;
  }
}
