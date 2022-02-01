import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:ammar_quiz_admin/main.dart';
import 'package:ammar_quiz_admin/models/CategoryData.dart';
import 'package:ammar_quiz_admin/utils/Common.dart';
import 'package:ammar_quiz_admin/utils/Constants.dart';

class NewSubCategoryDialog extends StatefulWidget {
  static String tag = '/NewCategoryDialog';
  final CategoryData? subCategoryData;

  // final String categoryId;

  NewSubCategoryDialog({this.subCategoryData});

  @override
  _NewCategoryDialogState createState() => _NewCategoryDialogState();
}

class _NewCategoryDialogState extends State<NewSubCategoryDialog> {
  AsyncMemoizer<List<CategoryData>> categoryMemoizer = AsyncMemoizer<List<CategoryData>>();

  var formKey = GlobalKey<FormState>();

  TextEditingController nameCont = TextEditingController();
  TextEditingController imageCont = TextEditingController();

  FocusNode imageFocus = FocusNode();

  CategoryData? selectCategoryId;

  bool isUpdate = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    isUpdate = widget.subCategoryData != null;

    if (isUpdate) {
      nameCont.text = widget.subCategoryData!.name.validate();
      imageCont.text = widget.subCategoryData!.image.validate();
    }
  }

  Future<void> save() async {
    if (getBoolAsync(IS_TEST_USER)) return toast(mTestUserMsg);

    if (selectCategoryId == null) {
      return toast('Please Select Category');
    }
    if (formKey.currentState!.validate()) {
      CategoryData categoryData = CategoryData();

      categoryData.parentCategoryId = selectCategoryId!.id!;
      categoryData.name = nameCont.text.trim();
      categoryData.image = imageCont.text.trim();
      categoryData.updatedAt = DateTime.now();

      ///Add New Code
      ///
      if (isUpdate) {
        categoryData.createdAt = widget.subCategoryData!.createdAt;
      } else {
        categoryData.createdAt = DateTime.now();
      }

      if (isUpdate) {
        categoryData.id = widget.subCategoryData!.id;
        categoryData.createdAt = widget.subCategoryData!.createdAt;
        await categoryService.updateDocument(categoryData.toJson(), categoryData.id).then(
          (value) {
            finish(context);
          },
        ).catchError(
          (e) {
            toast(e.toString());
          },
        );
      } else {
        await categoryService.addDocument(categoryData.toJson()).then(
          (value) {
            finish(context);
          },
        ).catchError(
          (e) {
            toast(e.toString());
          },
        );
      }
    }
  }

  Future<void> delete() async {
    if (getBoolAsync(IS_TEST_USER)) return toast(mTestUserMsg);

    await categoryService.removeDocument(widget.subCategoryData!.id).then(
      (value) {
        finish(context);
      },
    ).catchError(
      (e) {
        toast(e.toString());
      },
    );
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Container(
        width: 500,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder<List<CategoryData>>(
                future: categoryMemoizer.runOnce(() => categoryService.categoriesFuture()),
                builder: (_, snap) {
                  if (snap.hasData) {
                    if (snap.data!.isEmpty) return SizedBox();

                    if (selectCategoryId == null) {
                      if (isUpdate) {
                        selectCategoryId = snap.data!.firstWhere((element) => element.id == widget.subCategoryData!.parentCategoryId);
                      } else {
                        //  selectCategoryId = snap.data.first;
                      }
                    }

                    return Container(
                      decoration: BoxDecoration(borderRadius: radius(), color: Colors.grey.shade200),
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: DropdownButton(
                        hint: Text('Select Category'),
                        underline: Offstage(),
                        items: snap.data!.map((e) {
                          return DropdownMenuItem(
                            child: Text(e.name.validate()),
                            value: e,
                          );
                        }).toList(),
                        isExpanded: true,
                        value: selectCategoryId,
                        onChanged: (c) {
                          selectCategoryId = c as CategoryData?;

                          setState(() {});
                        },
                      ),
                    );
                  } else {
                    return snapWidgetHelper(snap);
                  }
                },
              ),
              16.height,
              AppTextField(
                controller: nameCont,
                textFieldType: TextFieldType.NAME,
                nextFocus: imageFocus,
                decoration: inputDecoration(labelText: appStore.translate("lbl_sub_category_name")),
                autoFocus: true,
              ),
              16.height,
              AppTextField(
                controller: imageCont,
                textFieldType: TextFieldType.URL,
                focus: imageFocus,
                decoration: inputDecoration(labelText: appStore.translate("lbl_image_uRL")),
                keyboardType: TextInputType.url,
                validator: (s) {
                  if (s!.isEmpty) return errorThisFieldRequired;
                  if (!s.validateURL()) return 'URL is invalid';
                  return null;
                },
              ),
              16.height,
              AppButton(
                text: appStore.translate("lbl_delete"),
                padding: EdgeInsets.all(20),
                onTap: () {
                  showConfirmDialog(context, appStore.translate("lbl_delete_subcategory_dialog")).then(
                    (value) {
                      if (value ?? false) {
                        delete();
                      }
                    },
                  ).catchError(
                    (e) {
                      toast(e.toString());
                    },
                  );
                },
              ).visible(isUpdate),
              16.height,
              AppButton(
                text: appStore.translate("lbl_save"),
                width: context.width(),
                padding: EdgeInsets.all(20),
                onTap: () {
                  save();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
