// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AppStore.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$AppStore on _AppStore, Store {
  final _$isLoggedInAtom = Atom(name: '_AppStore.isLoggedIn');

  @override
  bool get isLoggedIn {
    _$isLoggedInAtom.reportRead();
    return super.isLoggedIn;
  }

  @override
  set isLoggedIn(bool value) {
    _$isLoggedInAtom.reportWrite(value, super.isLoggedIn, () {
      super.isLoggedIn = value;
    });
  }

  final _$isAdminAtom = Atom(name: '_AppStore.isAdmin');

  @override
  bool get isAdmin {
    _$isAdminAtom.reportRead();
    return super.isAdmin;
  }

  @override
  set isAdmin(bool value) {
    _$isAdminAtom.reportWrite(value, super.isAdmin, () {
      super.isAdmin = value;
    });
  }

  final _$isTesterAtom = Atom(name: '_AppStore.isTester');

  @override
  bool get isTester {
    _$isTesterAtom.reportRead();
    return super.isTester;
  }

  @override
  set isTester(bool value) {
    _$isTesterAtom.reportWrite(value, super.isTester, () {
      super.isTester = value;
    });
  }

  final _$isSuperAdminAtom = Atom(name: '_AppStore.isSuperAdmin');

  @override
  bool get isSuperAdmin {
    _$isSuperAdminAtom.reportRead();
    return super.isSuperAdmin;
  }

  @override
  set isSuperAdmin(bool value) {
    _$isSuperAdminAtom.reportWrite(value, super.isSuperAdmin, () {
      super.isSuperAdmin = value;
    });
  }

  final _$isNotificationOnAtom = Atom(name: '_AppStore.isNotificationOn');

  @override
  bool get isNotificationOn {
    _$isNotificationOnAtom.reportRead();
    return super.isNotificationOn;
  }

  @override
  set isNotificationOn(bool value) {
    _$isNotificationOnAtom.reportWrite(value, super.isNotificationOn, () {
      super.isNotificationOn = value;
    });
  }

  final _$isDarkModeAtom = Atom(name: '_AppStore.isDarkMode');

  @override
  bool get isDarkMode {
    _$isDarkModeAtom.reportRead();
    return super.isDarkMode;
  }

  @override
  set isDarkMode(bool value) {
    _$isDarkModeAtom.reportWrite(value, super.isDarkMode, () {
      super.isDarkMode = value;
    });
  }

  final _$isLoadingAtom = Atom(name: '_AppStore.isLoading');

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  final _$selectedLanguageCodeAtom =
      Atom(name: '_AppStore.selectedLanguageCode');

  @override
  String get selectedLanguageCode {
    _$selectedLanguageCodeAtom.reportRead();
    return super.selectedLanguageCode;
  }

  @override
  set selectedLanguageCode(String value) {
    _$selectedLanguageCodeAtom.reportWrite(value, super.selectedLanguageCode,
        () {
      super.selectedLanguageCode = value;
    });
  }

  final _$userProfileImageAtom = Atom(name: '_AppStore.userProfileImage');

  @override
  String? get userProfileImage {
    _$userProfileImageAtom.reportRead();
    return super.userProfileImage;
  }

  @override
  set userProfileImage(String? value) {
    _$userProfileImageAtom.reportWrite(value, super.userProfileImage, () {
      super.userProfileImage = value;
    });
  }

  final _$userFullNameAtom = Atom(name: '_AppStore.userFullName');

  @override
  String? get userFullName {
    _$userFullNameAtom.reportRead();
    return super.userFullName;
  }

  @override
  set userFullName(String? value) {
    _$userFullNameAtom.reportWrite(value, super.userFullName, () {
      super.userFullName = value;
    });
  }

  final _$userEmailAtom = Atom(name: '_AppStore.userEmail');

  @override
  String? get userEmail {
    _$userEmailAtom.reportRead();
    return super.userEmail;
  }

  @override
  set userEmail(String? value) {
    _$userEmailAtom.reportWrite(value, super.userEmail, () {
      super.userEmail = value;
    });
  }

  final _$userIdAtom = Atom(name: '_AppStore.userId');

  @override
  String? get userId {
    _$userIdAtom.reportRead();
    return super.userId;
  }

  @override
  set userId(String? value) {
    _$userIdAtom.reportWrite(value, super.userId, () {
      super.userId = value;
    });
  }

  final _$appLocaleAtom = Atom(name: '_AppStore.appLocale');

  @override
  AppLocalizations? get appLocale {
    _$appLocaleAtom.reportRead();
    return super.appLocale;
  }

  @override
  set appLocale(AppLocalizations? value) {
    _$appLocaleAtom.reportWrite(value, super.appLocale, () {
      super.appLocale = value;
    });
  }

  final _$setLoggedInAsyncAction = AsyncAction('_AppStore.setLoggedIn');

  @override
  Future<void> setLoggedIn(bool val) {
    return _$setLoggedInAsyncAction.run(() => super.setLoggedIn(val));
  }

  final _$setDarkModeAsyncAction = AsyncAction('_AppStore.setDarkMode');

  @override
  Future<void> setDarkMode(bool aIsDarkMode) {
    return _$setDarkModeAsyncAction.run(() => super.setDarkMode(aIsDarkMode));
  }

  final _$_AppStoreActionController = ActionController(name: '_AppStore');

  @override
  void setAppLocalization(BuildContext context) {
    final _$actionInfo = _$_AppStoreActionController.startAction(
        name: '_AppStore.setAppLocalization');
    try {
      return super.setAppLocalization(context);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setLanguage(String val) {
    final _$actionInfo =
        _$_AppStoreActionController.startAction(name: '_AppStore.setLanguage');
    try {
      return super.setLanguage(val);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setUserProfile(String? image) {
    final _$actionInfo = _$_AppStoreActionController.startAction(
        name: '_AppStore.setUserProfile');
    try {
      return super.setUserProfile(image);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setUserId(String? val) {
    final _$actionInfo =
        _$_AppStoreActionController.startAction(name: '_AppStore.setUserId');
    try {
      return super.setUserId(val);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setUserEmail(String? email) {
    final _$actionInfo =
        _$_AppStoreActionController.startAction(name: '_AppStore.setUserEmail');
    try {
      return super.setUserEmail(email);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setFullName(String? name) {
    final _$actionInfo =
        _$_AppStoreActionController.startAction(name: '_AppStore.setFullName');
    try {
      return super.setFullName(name);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setLoading(bool val) {
    final _$actionInfo =
        _$_AppStoreActionController.startAction(name: '_AppStore.setLoading');
    try {
      return super.setLoading(val);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setAdmin(bool val) {
    final _$actionInfo =
        _$_AppStoreActionController.startAction(name: '_AppStore.setAdmin');
    try {
      return super.setAdmin(val);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSuperAdmin(bool val) {
    final _$actionInfo = _$_AppStoreActionController.startAction(
        name: '_AppStore.setSuperAdmin');
    try {
      return super.setSuperAdmin(val);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setTester(bool val) {
    final _$actionInfo =
        _$_AppStoreActionController.startAction(name: '_AppStore.setTester');
    try {
      return super.setTester(val);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setNotification(bool val) {
    final _$actionInfo = _$_AppStoreActionController.startAction(
        name: '_AppStore.setNotification');
    try {
      return super.setNotification(val);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLoggedIn: ${isLoggedIn},
isAdmin: ${isAdmin},
isTester: ${isTester},
isSuperAdmin: ${isSuperAdmin},
isNotificationOn: ${isNotificationOn},
isDarkMode: ${isDarkMode},
isLoading: ${isLoading},
selectedLanguageCode: ${selectedLanguageCode},
userProfileImage: ${userProfileImage},
userFullName: ${userFullName},
userEmail: ${userEmail},
userId: ${userId},
appLocale: ${appLocale}
    ''';
  }
}
