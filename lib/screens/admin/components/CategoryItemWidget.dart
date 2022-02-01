import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:ammar_quiz_admin/models/CategoryData.dart';
import 'package:ammar_quiz_admin/screens/admin/SubCategoryListScreen.dart';

import 'NewCategoryDialog.dart';

class CategoryItemWidget extends StatefulWidget {
  static String tag = '/CategoryItemWidget';
  final CategoryData? data;

  CategoryItemWidget({this.data});

  @override
  _CategoryItemWidgetState createState() => _CategoryItemWidgetState();
}

class _CategoryItemWidgetState extends State<CategoryItemWidget> {
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
    return Stack(
      children: [
        Container(
          width: 200,
          height: 200,
          margin: EdgeInsets.all(16),
          padding: EdgeInsets.all(16),
          decoration: boxDecorationWithRoundedCorners(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(widget.data!.image.toString(), height: 90, width: 90, fit: BoxFit.cover),
              30.height,
              Text(widget.data!.name.toString(), style: boldTextStyle(), maxLines: 2, textAlign: TextAlign.center),
            ],
          ),
        ),
        Positioned(
          right: 16,
          top: 16,
          child: IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              showInDialog(context, child: NewCategoryDialog(categoryData: widget.data)).then(
                (value) {
                  //
                },
              );
            },
          ),
        ),
      ],
    ).onTap(
      () {
        SubCategoryListScreen(showAppBar: true, categoryId: widget.data!.id, categoryName: widget.data!.name).launch(context);
      },
    );
  }
}
