import 'package:example/KoiLive/ExKoiLive.dart';
import 'package:flutter/material.dart';

import 'KoiHttp/ExKoiHttp.dart';
import 'KoiLogic/ExKoiLogicCommand.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ExKoiHttp(),
    );
  }
}