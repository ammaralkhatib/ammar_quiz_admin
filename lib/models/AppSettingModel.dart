import 'package:ammar_quiz_admin/utils/ModelKeys.dart';

class AppSettingModel {
  bool? disableAd;
  String? termCondition;
  String? privacyPolicy;
  String? contactInfo;

  AppSettingModel({
    this.disableAd,
    this.termCondition,
    this.privacyPolicy,
    this.contactInfo,
  });

  factory AppSettingModel.fromJson(Map<String, dynamic> json) {
    return AppSettingModel(
      disableAd: json[AppSettingKeys.disableAd],
      termCondition: json[AppSettingKeys.termCondition],
      privacyPolicy: json[AppSettingKeys.privacyPolicy],
      contactInfo: json[AppSettingKeys.contactInfo],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data[AppSettingKeys.disableAd] = this.disableAd;
    data[AppSettingKeys.termCondition] = this.termCondition;
    data[AppSettingKeys.privacyPolicy] = this.privacyPolicy;
    data[AppSettingKeys.contactInfo] = this.contactInfo;
    return data;
  }
}
