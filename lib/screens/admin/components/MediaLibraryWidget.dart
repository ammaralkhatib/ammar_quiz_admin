import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:ammar_quiz_admin/services/FileStorageService.dart';

class MediaLibraryWidget extends StatefulWidget {
  static String tag = '/MediaLibraryWidget';

  @override
  MediaLibraryWidgetState createState() => MediaLibraryWidgetState();
}

class MediaLibraryWidgetState extends State<MediaLibraryWidget> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: FutureBuilder(
        future: listOfFileFromFirebaseStorage(),
        builder: (_, snap) {
          log(snap.error);

          return Offstage();
        },
      ),
    );
  }
}
