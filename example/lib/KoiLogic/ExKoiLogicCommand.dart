import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_koukoi/Logic/KoiLogic.dart';
import 'package:flutter_koukoi/Logic/KoiLogicObserverUI.dart';
import 'package:flutter_koukoi/Logic/KoiLogicStrategy.dart';

class ExKoiLogicCommand extends StatefulWidget {
  const ExKoiLogicCommand({super.key});

  @override
  State<ExKoiLogicCommand> createState() => _ExKoiLogicCommandState();
}

class _ExKoiLogicCommandState extends State<ExKoiLogicCommand> {

  KoiLogic<int> data = KoiLogic(0);


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    data.strategy = KurangSatu();
    data.execute();
    data.execute();
    data.execute();
    data.execute();
    data.execute();
    data.execute();
    data.execute();
    data.execute();
    data.execute();
    data.execute();
    data.execute();
  }

  @override
  Widget build(BuildContext context) {

    /*data.strategy = KurangSatu();
    data.execute();
    data.execute();
    data.execute();
    data.execute();
    data.undo();
    data.undo();
    data.redo();
    data.undo();
    data.execute();
    data.undo();

    data.strategy = DelayedTambahSeratus();
    data.execute().then((retres){
      data.undo();
    });*/

    return Scaffold(
      appBar: AppBar(
        title: Text("Command Design pattern"),
        actions: [
          IconButton(onPressed: data.canUndo() ? (){
            data.undo();
            setState(() {});
          } : null, icon: Icon(Icons.undo)),
          IconButton(onPressed: data.canRedo() ? (){
            data.redo();
            setState(() {});
          } : null, icon: Icon(Icons.redo),)
        ],
      ),
      body: Center(
        child: KoiLogicObserverUI(logic: data, builder: (cntx, adata, child){
          return Text(adata.toString());
        }),
      ),
    );
  }
}

class KurangSatu implements KoiLogicStrategy<int>{
  @override
  int execute(data) {
    return data-1;
  }
}

class TambahSatu implements KoiLogicStrategyUndoable<int>{
  @override
  int execute(data) {
    return data+1;
  }

  @override
  int undo(int data) {
    return data-1;
  }
}

class DelayedTambahSeratus implements KoiLogicStrategyUndoable<int>{
  @override
  Future<int> execute(int data) async{
    await Future.delayed(Duration(seconds: 10));
    return data+100;
  }

  @override
  Future<int> undo(int data)async {
    await Future.delayed(Duration(seconds: 10));
    return data-100;
  }

}