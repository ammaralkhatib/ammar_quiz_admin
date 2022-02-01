import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:html/parser.dart';

import 'Constants.dart';

InputDecoration inputDecoration({String? labelText, String? hintText}) {
  return InputDecoration(
    labelText: labelText,
    labelStyle: secondaryTextStyle(),
    hintText: hintText,
    hintStyle: secondaryTextStyle(),
    border: OutlineInputBorder(),
    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: gray.withOpacity(0.4), width: 0.3)),
    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: gray.withOpacity(0.4), width: 0.3)),
    focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red.withOpacity(0.3), width: 0.3)),
    errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red.withOpacity(0.3), width: 0.3)),
    alignLabelWithHint: true,
  );
}

void setTheme() {
  // int themeModeIndex = getIntAsync(THEME_MODE_INDEX);

  /*if (themeModeIndex == ThemeModeLight) {
    appStore.setDarkMode(false);
  } else if (themeModeIndex == ThemeModeDark) {
    appStore.setDarkMode(true);
  }*/
}

String get getTodayQuizDate => DateFormat(CurrentDateFormat).format(DateTime.now());

Widget itemWidget(Color bgColor, Color textColor, String title, String desc) {
  return Container(
    width: 300,
    height: 130,
    decoration: BoxDecoration(border: Border.all(color: gray), borderRadius: radius(8), color: bgColor),
    padding: EdgeInsets.all(24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(title, style: primaryTextStyle(color: textColor, size: 30)),
        16.height,
        Text(desc, style: primaryTextStyle(size: 24, color: textColor)),
      ],
    ),
  );
}

// Send Notification Code

Future<bool> sendPushNotifications(String title, String content, {String? id, String? image}) async {
  Map req = {
    'headings': {
      'en': title,
    },
    'contents': {
      'en': content,
    },
    //  'big_picture': image.validate().isNotEmpty ? image.validate() : '',
    // 'large_icon': image.validate().isNotEmpty ? image.validate() : '',
    // 'small_icon': 'assets/splash_app_logo.png',
    'data': {
      'id': id,
    },
    'app_id': mOneSignalAppId,
    // 'android_channel_id': mOneSignalChannelId,
    'included_segments': ['All'],
  };
  var header = {
    HttpHeaders.authorizationHeader: 'Basic $mOneSignalRestKey',
    HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
  };

  Response res = await post(
    Uri.parse('https://onesignal.com/api/v1/notifications'),
    body: jsonEncode(req),
    headers: header,
  );

  log(res.statusCode);
  log(res.body);

  if (res.statusCode.isSuccessful()) {
    return true;
  } else {
    throw errorSomethingWentWrong;
  }
}

String parseHtmlString(String? htmlString) {
  return parse(parse(htmlString).body!.text).documentElement!.text;
}

/*// ignore: non_constant_identifier_names
BorderRadiusGeometry(int index){
  return BoxDecoration(
   index-1 ?BorderRadius.only()
  }

  );
}*/
