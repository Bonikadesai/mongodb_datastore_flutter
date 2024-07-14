import 'package:flutter/material.dart';
import 'package:mongodb_flutter_app/helper/db_hepler.dart';
import 'package:mongodb_flutter_app/screen/detail_screen.dart';
import 'package:mongodb_flutter_app/screen/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MongoDBHelper.connect();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MongoDB Flutter',
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => HomeScreen(),
        'detail': (context) => DetailScreen(),
      },
    );
  }
}
