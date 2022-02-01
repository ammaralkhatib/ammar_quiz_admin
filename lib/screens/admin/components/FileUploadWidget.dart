import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:ammar_quiz_admin/main.dart';

class FileUploadWidget extends StatefulWidget {
  static String tag = '/FileUploadWidget';

  @override
  FileUploadWidgetState createState() => FileUploadWidgetState();
}

class FileUploadWidgetState extends State<FileUploadWidget> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  Future<void> pickFile() async {
    // html.File infos = await ImagePickerWeb.getImage(outputType: ImageType.file);
    // log(infos.name);

    // final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);

    /*if (pickedFile != null) {
      String url = await uploadFile(File(pickedFile.p));

      if (url.validate().isNotEmpty) {
        finish(context, url);
      }
    } else {
      toast('No image selected.');
    }
    setState(() {});*/
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppButton(
            text: appStore.translate("lbl_upload"),
            onTap: () {
              pickFile();
            },
          ),
        ],
      ),
    );
  }
}
