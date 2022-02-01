import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:ammar_quiz_admin/screens/admin/AdminDashboardScreen.dart';
import 'package:ammar_quiz_admin/services/AuthService.dart';
import 'package:ammar_quiz_admin/utils/Colors.dart';
import 'package:ammar_quiz_admin/utils/Common.dart';

import '../../main.dart';

class AdminLoginScreen extends StatefulWidget {
  @override
  AdminDashboardScreenState createState() => AdminDashboardScreenState();
}

class AdminDashboardScreenState extends State<AdminLoginScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  var formKey1 = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  FocusNode passFocus = FocusNode();
  FocusNode emailFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  Future<void> signIn() async {
    if (formKey1.currentState!.validate()) {
      formKey1.currentState!.save();
      appStore.setLoading(true);

      await signInWithEmail(emailController.text, passwordController.text).then(
        (user) {
          log(user.toJson());
          if (user.isAdmin.validate() || user.isTestUser.validate()) {
            AdminDashboardScreen().launch(context, isNewTask: true);
          } else {
            logout(context);
            toast('You are not allowed to login');
          }
        },
      ).catchError(
        (e) {
          log(e);
          toast(e.toString().splitAfter(']').trim());
        },
      );
      appStore.setLoading(false);
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: formKey,
      body: Container(
        alignment: Alignment.center,
        width: 500,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Form(
              key: formKey1,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: <Widget>[
                    Image.asset('assets/splash_app_logo.png', height: 100),
                    16.height,
                    Text(appStore.translate("lbl_login_to_continue"), style: boldTextStyle(size: 22)),
                    20.height,
                    AppTextField(
                      controller: emailController,
                      textFieldType: TextFieldType.EMAIL,
                      decoration: inputDecoration(labelText: appStore.translate("lbl_email")),
                      nextFocus: passFocus,
                      autoFocus: true,
                    ),
                    8.height,
                    AppTextField(
                      controller: passwordController,
                      textFieldType: TextFieldType.PASSWORD,
                      focus: passFocus,
                      decoration: inputDecoration(labelText: appStore.translate("lbl_password")),
                      onFieldSubmitted: (s) {
                        signIn();
                      },
                    ),
                    8.height,
                    AppButton(
                      text: appStore.translate("lbl_login"),
                      textStyle: boldTextStyle(color: white),
                      color: colorPrimary,
                      onTap: () {
                        signIn();
                      },
                      width: context.width(),
                    ),
                    16.height,
                  ],
                ),
              ),
            ),
            Observer(builder: (_) => Loader().visible(appStore.isLoading)),
          ],
        ),
      ).center(),
    );
  }
}
