import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables.dart';

part 'contact_dao.g.dart';

@DriftAccessor(tables: [Contacts])
class ContactDao extends DatabaseAccessor<AppDatabase> with _$ContactDaoMixin {
  ContactDao(AppDatabase db) : super(db);

  Future<List<Contact>> getContactsByType(String type) {
    return (select(contacts)..where((c) => c.type.equals(type))).get();
  }

  Future<int> insertContact(ContactsCompanion entry) => into(contacts).insert(entry);
}
