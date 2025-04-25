import 'package:flutter/material.dart';
import 'package:flutter_koukoi/Logic/KoiLogic.dart';
import 'package:flutter_koukoi/Logic/KoiLogicStrategy.dart';

class ExKoiLogicStrategy extends StatelessWidget {
  const ExKoiLogicStrategy({super.key});
  
  @override
  Widget build(BuildContext context) {
    
    KoiLogic<int> num = KoiLogic(0);
    num.strategy = PanggilSub();
    num.execute();
    num.execute();
    num.execute();
    num.execute();

    num.strategy = KurangSatu();
    num.execute();
    
    return Scaffold(
      appBar: AppBar(title: Text("cccc"),),
      body: Center(child: Text(num.data.toString()),),
    );
  }
}

class PanggilSub implements KoiLogicStrategy<int>{
  @override
  int execute(data) {

    _SubTambahSatu sub1 = _SubTambahSatu();
    _SubTambahTiga sub2 = _SubTambahTiga();

    data = sub1.execute(data);
    data = sub2.execute(data);

    return data;
  }
}

class KurangSatu implements KoiLogicStrategy<int>{
  @override
  int execute(data) {
    return data-1;
  }
}

class _SubTambahSatu implements KoiLogicStrategy<int>{
  @override
  int execute(data) {
    return data+1;
  }
}

class _SubTambahTiga implements KoiLogicStrategy<int>{
  @override
  int execute(data) {
    return data+3;
  }
}
