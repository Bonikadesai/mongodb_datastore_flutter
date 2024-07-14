import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as MongoDB;
import 'package:mongodb_flutter_app/helper/db_hepler.dart';
import 'package:mongodb_flutter_app/model/db_model.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  TextEditingController fnameController = TextEditingController();

  TextEditingController lnameController = TextEditingController();

  TextEditingController depatrtNameController = TextEditingController();
  String checkInsertUpdate = "Insert";

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments;
    MongoDbModel? recievedData;

    if (arguments != null) {
      recievedData = arguments as MongoDbModel;
      fnameController.text = recievedData.firstName ?? '';
      lnameController.text = recievedData.lastName ?? '';
      depatrtNameController.text = recievedData.department ?? '';
      checkInsertUpdate = "Update";
    }

    // MongoDbModel recievedData =
    //     ModalRoute.of(context)!.settings.arguments as MongoDbModel;

    // if (recievedData != null) {
    //   fnameController.text = recievedData.firstName ?? '';
    //   lnameController.text = recievedData.lastName ?? '';
    //   depatrtNameController.text = recievedData.department ?? '';
    //   checkInsertUpdate = "Update";
    // }
    return Scaffold(
      appBar: AppBar(
        title: Text(checkInsertUpdate),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed('detail');
            },
            icon: Icon(
              Icons.details,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextFormField(
              controller: fnameController,
              decoration: InputDecoration(
                labelText: "Enter First Name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: lnameController,
              decoration: InputDecoration(
                labelText: "Enter Last Name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: depatrtNameController,
              decoration: InputDecoration(
                labelText: "Enter Department Name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                if (checkInsertUpdate == "Update") {
                  updateData(
                      recievedData!.id,
                      fnameController.text,
                      lnameController.text,
                      depatrtNameController.text,
                      context);
                } else {
                  insertData(
                    fnameController.text,
                    lnameController.text,
                    depatrtNameController.text,
                  );
                }

                // Navigator.of(context).pushNamed('detail');
              },
              child: Text(checkInsertUpdate),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> insertData(
      String firstName, String lastName, String department) async {
    var _id = MongoDB.ObjectId(); //THIS WILL USE FOR UNIQUE ID
    final data = MongoDbModel(
      id: _id,
      firstName: firstName,
      lastName: lastName,
      department: department,
    );
    var result = await MongoDBHelper.insertData(data);
    log("=======================");
    log(_id.toString());
    log(firstName);
    log(lastName);
    log(department);
    log("=======================");
    clearAll();
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //     content: Text("Inserted ID" + id.$oid),
    //   ),
    // );
  }

  // static Future<void> updateData(
  //     String firstName, String lastName, String department) async {
  //   var _id = MongoDB.ObjectId();
  //   final updateData = MongoDbModel(
  //     id: _id,
  //     firstName: firstName,
  //     lastName: lastName,
  //     department: department,
  //   );
  //   var result = await MongoDBHelper.update(updateData);
  // }
  Future<void> updateData(MongoDB.ObjectId id, String firstName,
      String lastName, String department, context) async {
    final updateData = {
      r'$set': {
        'firstName': firstName,
        'lastName': lastName,
        'department': department,
      }
    };
    log("=======================");
    log(id.toString());
    log(firstName);
    log(lastName);
    log(department);
    log("=======================");
    var result = await MongoDBHelper.update(id, updateData).then(
      (value) => Navigator.pushNamed(context, 'detail'),
    );
    //  Navigator.pushNamed(context, 'detail');
  }

  void clearAll() {
    fnameController.clear();
    lnameController.clear();
    depatrtNameController.clear();
  }
}
