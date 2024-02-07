import 'package:isar/isar.dart';
import 'package:isar_demo/data/person.dart';
import 'package:path_provider/path_provider.dart';

class IsarService {
  late Future<Isar> db;
  IsarService() {
    db = openDB();
  }
  Future<void> addPerson(Person person) async {
    final isar = await db;
    isar.writeTxnSync(() => isar.persons.putSync(person));
  }

  Future<List<Person>> getPeople() async {
    final isar = await db;
    return isar.persons.where().findAll();
  }

  Future<Isar> openDB() async {
    if (Isar.instanceNames.isEmpty) {
      final directory = await getApplicationDocumentsDirectory();
      return await Isar.open(
        [PersonSchema],
        directory: directory.path,
      );
    }
    return await Future.value(Isar.getInstance());
  }
}
