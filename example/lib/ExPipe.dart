import 'package:flutter/material.dart';
import 'package:flutter_koukoi/Pipes/Pipe.dart';
import 'package:flutter_koukoi/Pipes/Pump.dart';

class ExPipe extends StatelessWidget {
  const ExPipe({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class MyPump extends Pump{
  @override
  void next(Pipe nextPipe) {
    // TODO: implement next
  }

}