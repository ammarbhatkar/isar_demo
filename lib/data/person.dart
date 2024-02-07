import 'package:isar/isar.dart';

part 'person.g.dart';

@Collection()
class Person {
  Id id = Isar.autoIncrement;
  String? name;
}
