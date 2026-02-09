import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables.dart';

part 'parent_child_dao.g.dart';

@DriftAccessor(tables: [ParentChildren])
class ParentChildDao extends DatabaseAccessor<AppDatabase> with _$ParentChildDaoMixin {
  ParentChildDao(AppDatabase db) : super(db);

  Future<List<ParentChild>> getChildrenForParent(int parentUserId) {
    return (select(parentChildren)..where((p) => p.parentUserId.equals(parentUserId))).get();
  }

  Future<int> insertParentChild(ParentChildrenCompanion entry) =>
      into(parentChildren).insert(entry);
}
