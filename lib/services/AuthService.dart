import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:ammar_quiz_admin/main.dart';
import 'package:ammar_quiz_admin/models/UserModel.dart';
import 'package:ammar_quiz_admin/utils/Common.dart';
import 'package:ammar_quiz_admin/utils/Constants.dart';
import 'package:ammar_quiz_admin/utils/ModelKeys.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();

Future<void> signInWithGoogle() async {
  GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

  if (googleSignInAccount != null) {
    //region Google Sign In
    final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final UserCredential authResult = await auth.signInWithCredential(credential);
    final User user = authResult.user!;

    assert(!user.isAnonymous);

    final User currentUser = auth.currentUser!;
    assert(user.uid == currentUser.uid);

    signOutGoogle();
    //endregion

    UserModel userModel = UserModel();

    if (await userService.isUserExist(currentUser.email, LoginTypeGoogle)) {
      //
      ///Return user data
      await userService.userByEmail(currentUser.email).then((user) async {
        userModel = user;

        await updateUserData(userModel);
      }).catchError((e) {
        throw e;
      });
    } else {
      /// Create user
      userModel.id = currentUser.uid;
      userModel.email = currentUser.email;
      userModel.name = currentUser.displayName;
      userModel.image = currentUser.photoURL;
      userModel.loginType = LoginTypeGoogle;
      userModel.updatedAt = DateTime.now();
      userModel.createdAt = DateTime.now();
      userModel.isTestUser = false;

      userModel.oneSignalPlayerId = getStringAsync(PLAYER_ID);

      await userService.addDocumentWithCustomId(currentUser.uid, userModel.toJson()).then(
        (value) {
          //
        },
      ).catchError(
        (e) {
          throw e;
        },
      );
    }

    await setValue(LOGIN_TYPE, LoginTypeGoogle);
    setUserDetailPreference(userModel);
  } else {
    throw errorSomethingWentWrong;
  }
}

Future<UserModel> signInWithEmail(String email, String password) async {
  if (await userService.isUserExist(email, LoginTypeApp)) {
    UserCredential userCredential = await auth.signInWithEmailAndPassword(email: email, password: password);

    if (userCredential.user != null) {
      UserModel userModel = UserModel();

      User user = userCredential.user!;

      return await userService.userByEmail(user.email).then((value) async {
        log('Signed in');

        userModel = value;

        await setValue(LOGIN_TYPE, LoginTypeApp);
        //
        await updateUserData(userModel);

        //
        await setUserDetailPreference(userModel);

        return userModel;
      }).catchError((e) {
        throw e;
      });
    } else {
      throw errorSomethingWentWrong;
    }
  } else {
    throw 'You are not registered with us';
  }
}

Future<void> signUpWithEmail(String name, String email, String password) async {
  UserCredential userCredential = await auth.createUserWithEmailAndPassword(email: email, password: password);

  if (userCredential.user != null) {
    User currentUser = userCredential.user!;
    UserModel userModel = UserModel();

    /// Create user
    userModel.id = currentUser.uid;
    userModel.email = currentUser.email;
    userModel.password = password;
    userModel.name = name;
    userModel.image = '';
    userModel.loginType = LoginTypeApp;
    userModel.isNotificationOn = true;
    userModel.appLanguage = defaultLanguage;
    userModel.themeIndex = 0;
    userModel.updatedAt = DateTime.now();
    userModel.createdAt = DateTime.now();
    userModel.isTestUser = false;

    userModel.oneSignalPlayerId = getStringAsync(PLAYER_ID);

    await userService.addDocumentWithCustomId(currentUser.uid, userModel.toJson()).then(
      (value) async {
        log('Signed up');
        await signInWithEmail(email, password).then(
          (value) {
            toast('Successfully');
          },
        );
      },
    ).catchError(
      (e) {
        throw e;
      },
    );
  } else {
    throw errorSomethingWentWrong;
  }
}

Future<void> logout(BuildContext context, {Function? onLogout}) async {
  await removeKey(IS_LOGGED_IN);
  await removeKey(IS_ADMIN);
  await removeKey(IS_SUPER_ADMIN);
  await removeKey(USER_ID);
  await removeKey(FULL_NAME);
  await removeKey(USER_EMAIL);
  await removeKey(USER_ROLE);
  await removeKey(PASSWORD);
  await removeKey(PROFILE_IMAGE);
  await removeKey(IS_NOTIFICATION_ON);
  await removeKey(IS_REMEMBERED);
  await removeKey(LANGUAGE);
  await removeKey(PLAYER_ID);
  await removeKey(IS_SOCIAL_LOGIN);
  await removeKey(LOGIN_TYPE);
  await removeKey(IS_TEST_USER);

  if (getBoolAsync(IS_SOCIAL_LOGIN) || getStringAsync(LOGIN_TYPE) == LoginTypeOTP || !getBoolAsync(IS_REMEMBERED)) {
    await removeKey(PASSWORD);
    await removeKey(USER_EMAIL);
  }

  appStore.setLoggedIn(false);
  appStore.setUserId('');
  appStore.setFullName('');
  appStore.setUserEmail('');
  appStore.setUserProfile('');

  onLogout?.call();
}

Future<void> signOutGoogle() async {
  await googleSignIn.signOut();
}

Future<void> changePassword(String newPassword) async {
  if (getBoolAsync(IS_TEST_USER)) return toast(mTestUserMsg);

  await FirebaseAuth.instance.currentUser!.updatePassword(newPassword).then(
    (value) async {
      await setValue(PASSWORD, newPassword);

      await userService.updateDocument({UserKeys.password: newPassword}, appStore.userId);
    },
  );
}

Future<void> updateUserData(UserModel user) async {
  //
  /// Update user data
  userService.updateDocument({
    UserKeys.oneSignalPlayerId: getStringAsync(PLAYER_ID),
    CommonKeys.updatedAt: DateTime.now(),
  }, user.id);

  // await setValue(THEME_MODE_INDEX, user.themeIndex.validate());

  appStore.setNotification(user.isNotificationOn.validate(value: true));
  appStore.setLanguage(user.appLanguage.validate(value: defaultLanguage));

  ///
  setTheme();
}

Future<void> setUserDetailPreference(UserModel userModel) async {
  await setValue(USER_ID, userModel.id.validate());
  await setValue(FULL_NAME, userModel.name.validate());
  await setValue(USER_EMAIL, userModel.email.validate());
  await setValue(PROFILE_IMAGE, userModel.image.validate());
  await setValue(IS_ADMIN, userModel.isAdmin.validate());
  await setValue(IS_SUPER_ADMIN, userModel.isSuperAdmin.validate());
  await setValue(IS_TEST_USER, userModel.isTestUser.validate());

  appStore.setLoggedIn(true);
  appStore.setUserId(userModel.id);
  appStore.setFullName(userModel.name);
  appStore.setUserEmail(userModel.email);
  appStore.setUserProfile(userModel.image);
}

// Add Function

Future<void> loginFromFirebaseUser(User currentUser, String loginType, {String? fullName}) async {
  UserModel userModel = UserModel();

  if (await userService.isUserExist(currentUser.email, loginType)) {
    //
    ///Return user data
    await userService.userByEmail(currentUser.email).then((user) async {
      userModel = user;

      await updateUserData(userModel);
    }).catchError((e) {
      throw e;
    });
  } else {
    /// Create user
    userModel.id = currentUser.uid;
    userModel.email = currentUser.email;
    userModel.name = (currentUser.displayName) ?? fullName;
    userModel.image = currentUser.photoURL;
    userModel.loginType = loginType;
    userModel.updatedAt = DateTime.now();
    userModel.createdAt = DateTime.now();

    userModel.isAdmin = false;
    userModel.isTestUser = false;
    userModel.isNotificationOn = true;

    userModel.oneSignalPlayerId = getStringAsync(PLAYER_ID);

    await userService.addDocumentWithCustomId(currentUser.uid, userModel.toJson()).then(
      (value) {
        //
      },
    ).catchError(
      (e) {
        throw e;
      },
    );
  }

  await setValue(LOGIN_TYPE, loginType);
  setUserDetailPreference(userModel);
}
