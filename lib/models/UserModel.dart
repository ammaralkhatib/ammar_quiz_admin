import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ammar_quiz_admin/utils/ModelKeys.dart';

class UserModel {
  String? id;
  String? name;
  String? email;
  String? image;
  String? password;
  String? loginType;
  DateTime? createdAt;
  DateTime? updatedAt;
  bool? isNotificationOn;
  int? themeIndex;
  String? appLanguage;
  String? oneSignalPlayerId;
  bool? isAdmin;
  bool? isSuperAdmin;
  bool? isTestUser;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.image,
    this.password,
    this.loginType,
    this.createdAt,
    this.updatedAt,
    this.isNotificationOn,
    this.themeIndex,
    this.appLanguage,
    this.oneSignalPlayerId,
    this.isAdmin,
    this.isSuperAdmin,
    this.isTestUser,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json[CommonKeys.id],
      name: json[UserKeys.name],
      email: json[UserKeys.email],
      image: json[UserKeys.photoUrl],
      password: json[UserKeys.password],
      loginType: json[UserKeys.loginType],
      isNotificationOn: json[UserKeys.isNotificationOn],
      themeIndex: json[UserKeys.themeIndex],
      appLanguage: json[UserKeys.appLanguage],
      oneSignalPlayerId: json[UserKeys.oneSignalPlayerId],
      isAdmin: json[UserKeys.isAdmin],
      isSuperAdmin: json[UserKeys.isSuperAdmin],
      isTestUser: json[UserKeys.isTestUser],
      createdAt: json[CommonKeys.createdAt] != null ? (json[CommonKeys.createdAt] as Timestamp).toDate() : null,
      updatedAt: json[CommonKeys.updatedAt] != null ? (json[CommonKeys.updatedAt] as Timestamp).toDate() : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[CommonKeys.id] = this.id;
    data[UserKeys.name] = this.name;
    data[UserKeys.email] = this.email;
    data[UserKeys.photoUrl] = this.image;
    data[UserKeys.password] = this.password;
    data[UserKeys.loginType] = this.loginType;
    data[CommonKeys.createdAt] = this.createdAt;
    data[CommonKeys.updatedAt] = this.updatedAt;
    data[UserKeys.isNotificationOn] = this.isNotificationOn;
    data[UserKeys.themeIndex] = this.themeIndex;
    data[UserKeys.appLanguage] = this.appLanguage;
    data[UserKeys.oneSignalPlayerId] = this.oneSignalPlayerId;
    data[UserKeys.isAdmin] = this.isAdmin;
    data[UserKeys.isSuperAdmin] = this.isSuperAdmin;
    data[UserKeys.isTestUser] = this.isTestUser;
    return data;
  }
}
