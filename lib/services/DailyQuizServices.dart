import 'dart:async';

import 'package:ammar_quiz_admin/main.dart';
import 'package:ammar_quiz_admin/models/QuizData.dart';
import 'package:ammar_quiz_admin/services/BaseService.dart';

class DailyQuizServices extends BaseService {
  DailyQuizServices() {
    ref = db.collection('dailyQuiz');
  }

  Future<QuizData> dailyQuestionListFuture(String id) async {
    return QuizData.fromJson(await ref.doc(id).get().then((value) => value.data() as FutureOr<Map<String, dynamic>>));
  }
}
