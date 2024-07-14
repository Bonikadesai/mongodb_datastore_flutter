// user="demo_user";
// password="nZT8WIyssho3jZ71";

import 'dart:developer';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:mongodb_flutter_app/model/db_model.dart';

class MongoDBHelper {
  static const MONGO_CONN_URL =
      "mongodb+srv://demo_user:nZT8WIyssho3jZ71@atlascluster.daladmg.mongodb.net/todo?retryWrites=true&w=majority&appName=AtlasCluster"; // MONO CONNECTION URL
  static const USER_COLLECTION =
      "developer"; // OUR COLLECTION NAME IS developer

  static var db, userCollection;
  static connect() async {
    db = await Db.create(MONGO_CONN_URL);
    await db.open();
    inspect(db);
    print(db);
    userCollection = db.collection(USER_COLLECTION);
    print(userCollection);
  }

  static Future<String> insertData(MongoDbModel data) async {
    try {
      var result = await userCollection.insertOne(data.toJson());
      if (result.isSuccess) {
        return "Data Inserted";
      } else {
        return "Data Not Inserted";
        // return result;
      }
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
  }

  static Future<List<Map<String, dynamic>>> getData() async {
    final arrData = await userCollection.find().toList();
    return arrData;
  }

  static Future<void> deleteData(MongoDbModel data) async {
    await userCollection.remove(where.id(data.id));
  }

  //
  // static Future<void> update(MongoDbModel data) async {
  //   log("======================");
  //   log(data.id.toString());
  //   log("======================");
  //   // var result = await userCollection.updateOne(where.eq('', data.id), data.toJson());
  //
  //   // var result = await userCollection.findOne({"_id": data.id});
  // }
  static Future<void> update(
      ObjectId id, Map<String, dynamic> updateData) async {
    await connect();
    await userCollection.update(
      where.eq('_id', id),
      updateData,
    );
  }

  // static Future<List<Map<String, dynamic>>> getQueryData(
  //     {required String query}) async {
  //   final data =
  //       await userCollection.find(where.eq('department', 'Flutter')).toList();
  //   return data;
  // }
  // Method to fetch data based on a query parameter
// Method to fetch data based on a query parameter
  static Future<List<Map<String, dynamic>>> getQueryData(
      {required String firstName}) async {
    List<Map<String, dynamic>> result;

    if (firstName.isEmpty) {
      // If no query, fetch all data
      result = await userCollection.find().toList();
    } else {
      // If there's a query, search by the first name
      result =
          await userCollection.find(where.eq('firstName', firstName)).toList();
    }

    // Debug log to inspect the results
    print('firstName: $firstName');
    print('Result: $result');
    print('Result count: ${result.length}');
    for (var doc in result) {
      print(doc);
    }

    return result;
  }

  // static Future<List<Map<String, dynamic>>> getQueryData(
  //     [String query = '']) async {
  //   if (query.isEmpty) {
  //     // If no query, fetch all data
  //     return await userCollection.find().toList();
  //   } else {
  //     // If there's a query, search by the first name
  //     return await userCollection.find(where.eq('firstName', query)).toList();
  //   }
  // }
}
