import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mongodb_flutter_app/helper/db_hepler.dart';

import '../model/db_model.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  TextEditingController searchController = TextEditingController();
  String firstName = '';
  List<MongoDbModel> developers = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  // void fetchData() async {
  //   List<Map<String, dynamic>> allData = await MongoDBHelper.getQueryData();
  //   setState(() {
  //     developers = allData.map((e) => MongoDbModel.fromJson(e)).toList();
  //   });
  // }
  // void fetchAllData() {
  //   MongoDBHelper.getData();
  // }
  void fetchData({String fName = ''}) async {
    log("fName: $fName");
    log("========================");
    List<Map<String, dynamic>> allData =
        await MongoDBHelper.getQueryData(firstName: fName);

    log("========================");
    log("All data: $allData");
    log("========================");
    setState(() {
      developers = allData.map((e) => MongoDbModel.fromJson(e)).toList();
    });
    log("========================");
    log("Developers: $developers");
    log("========================");
  }

  // void fetchData([String query = '']) async {
  //   List<Map<String, dynamic>> allData =
  //       await MongoDBHelper.getQueryData(query);
  //   setState(() {
  //     developers = allData.map((e) => MongoDbModel.fromJson(e)).toList();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail page"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextFormField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: "Enter Name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onChanged: (value) {
                fetchData(fName: value);
                setState(() {});
              },
              // onFieldSubmitted: (value) {
              //   setState(() {
              //     MongoDBHelper.getData();
              //   });
              //   fetchData();
              // },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: developers.length,
                itemBuilder: (context, i) {
                  MongoDbModel data = developers[i];
                  return Card(
                    child: ListTile(
                      leading: Text("${i + 1}"),
                      title: Text("${data.firstName}"
                          " "
                          "${data.lastName}"),
                      subtitle: Text(data.department),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                              onTap: () {
                                // Navigator.pushNamed(context, '/',
                                //     arguments: data);
                                Navigator.pushNamed(context, '/',
                                        arguments: data)
                                    .then((value) => fetchData());
                                setState(() {});
                              },
                              child: const Icon(Icons.edit)),
                          const SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                            onTap: () async {
                              await MongoDBHelper.deleteData(data);
                              fetchData();
                              setState(() {});
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Data Deletion Successful"),
                                ),
                              );
                            },
                            child: const Icon(Icons.delete),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            // Expanded(
            //   child: FutureBuilder(
            //     future: MongoDBHelper.getData(),
            //     builder: (context, snapshot) {
            //       if (snapshot.connectionState == ConnectionState.waiting) {
            //         return const Center(child: CircularProgressIndicator());
            //       } else {
            //         if (snapshot.hasData) {
            //           List<Map<String, dynamic>> allData = snapshot.data ?? [];
            //           List<MongoDbModel> developers = allData
            //               .map(
            //                 (e) => MongoDbModel.fromJson(e),
            //               )
            //               .toList();
            //           return ListView.builder(
            //             itemCount: developers.length,
            //             itemBuilder: (context, i) {
            //               MongoDbModel data = developers[i];
            //               return Card(
            //                 child: ListTile(
            //                   leading: Text("${i + 1}"),
            //                   title: Text("${data.firstName}"
            //                       " "
            //                       "${data.lastName}"),
            //                   subtitle: Text(data.department),
            //                   trailing: Row(
            //                     mainAxisSize: MainAxisSize.min,
            //                     children: [
            //                       GestureDetector(
            //                           onTap: () {
            //                             // Navigator.pushNamed(context, '/',
            //                             //     arguments: data);
            //                             Navigator.pushNamed(context, '/',
            //                                     arguments: data)
            //                                 .then((value) => fetchData());
            //                             setState(() {});
            //                           },
            //                           child: const Icon(Icons.edit)),
            //                       const SizedBox(
            //                         width: 10,
            //                       ),
            //                       GestureDetector(
            //                         onTap: () async {
            //                           await MongoDBHelper.deleteData(data);
            //                           fetchData();
            //                           setState(() {});
            //                           ScaffoldMessenger.of(context)
            //                               .showSnackBar(
            //                             const SnackBar(
            //                               content:
            //                                   Text("Data Deletion Successful"),
            //                             ),
            //                           );
            //                         },
            //                         child: const Icon(Icons.delete),
            //                       ),
            //                     ],
            //                   ),
            //                 ),
            //               );
            //             },
            //           );
            //         } else {
            //           return const Center(
            //             child: Text("No data available"),
            //           );
            //         }
            //       }
            //       return const Center(
            //         child: Text("data"),
            //       );
            //     },
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
