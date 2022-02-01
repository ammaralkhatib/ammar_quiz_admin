import 'package:nb_utils/nb_utils.dart';
import 'package:ammar_quiz_admin/models/CategoryData.dart';

import '../main.dart';
import 'BaseService.dart';

class CategoryService extends BaseService {
  CategoryService() {
    ref = db.collection('categories');
  }

  /* Stream<List<CategoryData>> categories() {
     return ref!.snapshots().map((x) => x.docs.map((y) => CategoryData.fromJson(y.data() as Map<String, dynamic>)).toList());
  }*/

  //Add New Line
  Stream<List<CategoryData>> categories({String parentCategoryId = ''}) {
    return parentCategoryId.isNotEmpty
        ? ref.where('parentCategoryId', isEqualTo: parentCategoryId).snapshots().map(
              (x) => x.docs.map((y) => CategoryData.fromJson(y.data() as Map<String, dynamic>)).toList(),
            )
        : ref.where('parentCategoryId', isEqualTo: '').snapshots().map(
              (x) => x.docs.map((y) => CategoryData.fromJson(y.data() as Map<String, dynamic>)).toList(),
            );
  }

  Future<List<CategoryData>> categoriesFuture({String? parentCategoryId = ''}) async {
    return await ref.where('parentCategoryId', isEqualTo: '').get().then(
          (x) => x.docs.map((y) => CategoryData.fromJson(y.data() as Map<String, dynamic>)).toList(),
        );
  }

  Future<CategoryData> getCategoryById(String? id) async {
    return await ref.where('id', isEqualTo: id).get().then(
      (x) {
        if (x.docs.isNotEmpty) {
          log(x.docs.first.id);
          return CategoryData.fromJson(x.docs.first.data() as Map<String, dynamic>);
        } else {
          throw '';
        }
      },
    ).catchError(
      (e) {
        throw e;
      },
    );
  }

  Future<List<CategoryData>> subCategoriesFuture({String? parentCategoryId}) async {
    return await ref.where('parentCategoryId', isEqualTo: parentCategoryId).get().then(
          (x) => x.docs.map((y) => CategoryData.fromJson(y.data() as Map<String, dynamic>)).toList(),
        );
  }
}
