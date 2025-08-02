import 'package:flutter/material.dart';
import 'package:flutter_koukoi/Logic/KoiLogic.dart';
import 'package:flutter_koukoi/Logic/KoiLogicObserver.dart';

class ExKoiLogicObserver extends StatefulWidget {
  const ExKoiLogicObserver({super.key});

  @override
  State<ExKoiLogicObserver> createState() => _ExKoiLogicObserverState();
}

class _ExKoiLogicObserverState extends State<ExKoiLogicObserver> {

  KoiLogic<int> num = KoiLogic(0);

  late KoiLogicObserver<int> myobserver;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myobserver = num.observe(onUpdate: (KoiLogic<int> logic){
      setState(() {});
    });
  }

  @override
  void dispose() {
    num.observerRemove(myobserver);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("aaa"),),
      body: Row(
        children: [
          Expanded(child: Text(num.data.toString())),
          Expanded(child: ElevatedButton(onPressed: (){
            num.data = num.data+1;
          }, child: Text("add")))
        ],
      ),
    );
  }
}
