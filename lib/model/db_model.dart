import 'package:mongo_dart/mongo_dart.dart';

class MongoDbModel {
  ObjectId id;
  String firstName;
  String lastName;
  String department;

  MongoDbModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.department,
  });

  factory MongoDbModel.fromJson(Map<String, dynamic> json) => MongoDbModel(
        id: json["_id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        department: json["department"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "firstName": firstName,
        "lastName": lastName,
        "department": department,
      };
}
