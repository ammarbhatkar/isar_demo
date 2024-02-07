import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:isar/isar.dart';
import 'package:isar_demo/data/person.dart';
import 'package:isar_demo/services/isar_service.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormBuilderState>();
  final isarService = IsarService();

  List fetching = [];
  @override
  void initState() {
    super.initState();
    _checkPermision();
  }

  void _checkPermision() async {
    if (await Permission.storage.request().isGranted) {
      // Already have permission
    } else {
      await Permission.storage.request();
      // Open database after permission is granted
      await isarService.openDB();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FormBuilder(
          key: _formKey,
          child: Column(
            children: [
              FormBuilderTextField(
                name: 'name',
                decoration: const InputDecoration(
                  label: Text('full name'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.saveAndValidate()) {
                      var submittedData = _formKey.currentState!.value['name'];
                      print(submittedData);
                      isarService.addPerson(Person()..name = submittedData);
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('added $submittedData')));
                    }
                  },
                  child: const Text("Submit"),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  var results = await isarService.getPeople();
                  var allPeople = results.map((person) => person.name);

                  print(results.map((person) => person.name));
                },
                child: const Text("Get all"),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
