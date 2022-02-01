import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ammar_quiz_admin/models/UserModel.dart';

import '../main.dart';
import 'BaseService.dart';

class UserService extends BaseService {
  UserService() {
    ref = db.collection('users');
  }

  Stream<List<UserModel>> users() {
    /// return ref.orderBy('updatedAt', descending: true).snapshots().map((x) => x.docs.map((y) => UserModel.fromJson(y.data())).toList());
    return ref.snapshots().map((x) => x.docs.map((y) => UserModel.fromJson(y.data() as Map<String, dynamic>)).toList());
  }

  Query? getUserList() {
    return ref;
  }

  Future<List<UserModel>> usersFuture() async {
    return await ref.orderBy('updatedAt', descending: true).get().then(
          (x) => x.docs.map((y) => UserModel.fromJson(y.data() as Map<String, dynamic>)).toList(),
        );
  }

  Future<bool> isUserExist(String? email, String loginType) async {
    Query query = ref.limit(1).where('loginType', isEqualTo: loginType).where('email', isEqualTo: email);

    var res = await query.get();

    return res.docs.length == 1;
  }

  Future<UserModel> loginWithEmail(String email, String password) async {
    return await ref.where('email', isEqualTo: email).where('password', isEqualTo: password).limit(1).get().then(
      (value) {
        if (value.docs.isNotEmpty) {
          return UserModel.fromJson(value.docs.first.data() as Map<String, dynamic>);
        } else {
          throw 'No User Found';
        }
      },
    );
  }

  Future<UserModel> userByEmail(String? email) async {
    return await ref.where('email', isEqualTo: email).limit(1).get().then(
      (value) {
        if (value.docs.isNotEmpty) {
          return UserModel.fromJson(value.docs.first.data() as Map<String, dynamic>);
        } else {
          throw 'No User Found';
        }
      },
    );
  }
}
