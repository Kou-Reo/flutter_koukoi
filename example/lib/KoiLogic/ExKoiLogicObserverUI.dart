import 'package:flutter/material.dart';
import 'package:flutter_koukoi/Logic/KoiLogic.dart';
import 'package:flutter_koukoi/Logic/KoiLogicObserverUI.dart';

class ExKoiLogicObserverUI extends StatelessWidget {
  const ExKoiLogicObserverUI({super.key});

  @override
  Widget build(BuildContext context) {

    KoiLogic<int> num = KoiLogic(0);

    return Scaffold(
      appBar: AppBar(title: Text("bbbb"),),
      body: Row(
        children: [
          Expanded(child:
          KoiLogicObserverUI(logic: num, builder: (BuildContext context, int data, Widget? child) {
            return Text(data.toString());
          },)
          ),
          Expanded(child: ElevatedButton(onPressed: (){
            num.data = num.data+1;
          }, child: Text("add")))
        ],
      ),
    );
  }
}
