import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:path/path.dart' as path;
import 'package:ammar_quiz_admin/utils/Constants.dart';

Future<String> uploadFile(File file, {String prefix = mFirebaseStorageFilePath}) async {
  if (prefix.isNotEmpty && !prefix.endsWith('/')) {
    prefix = '$prefix/';
  }
  Reference storageReference = FirebaseStorage.instance.ref().child('$prefix${path.basename(file.path)}');
  UploadTask uploadTask = storageReference.putFile(file);

  log('File Uploading');

  return await uploadTask.then(
    (v) async {
      log('File Uploaded');

      if (v.state == TaskState.success) {
        String url = await storageReference.getDownloadURL();

        log(url);

        return url;
      } else {
        throw errorSomethingWentWrong;
      }
    },
  ).catchError(
    (error) {
      throw error;
    },
  );
}

Future<List<String>> listOfFileFromFirebaseStorage({String? path}) async {
  List<String> list = [];

  var ref = FirebaseStorage.instance.ref(mFirebaseStorageFilePath);
  log(ref);

  var listResult = await ref.listAll();
  log(listResult);

  listResult.prefixes.forEach(
    (element) {
      log(element.fullPath);
    },
  );
  listResult.items.forEach(
    (element) {
      log(element.fullPath);

      list.add(element.fullPath);
    },
  );
  return list;
}
