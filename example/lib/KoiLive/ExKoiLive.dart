import 'package:flutter/material.dart';
import 'package:flutter_koukoi/Live/KoiLive.dart';
import 'package:flutter_koukoi/Live/KoiLiveResult.dart';
import 'package:http/http.dart' as http;

class ExKoiLive extends StatefulWidget {
  const ExKoiLive({super.key});

  @override
  State<ExKoiLive> createState() => _ExKoiLiveState();
}

class _ExKoiLiveState extends State<ExKoiLive> {

  KoiLive<String> _data = KoiLive.run(request: ()async{
    return http.get(Uri.parse('http://localhost/my_web/mobileApp/public/api/test'));
  }, resultTransformer: (realData){
    return KoiLiveResult(
        status: KoiLiveResultStatus.Success,
        message: 'request sukse dilakukan',
        errors: [],
        data: realData.body
    );
  });


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(child:Center(
            child: _data.render((adata){
              return Text(adata);
            }),
          )),

          ElevatedButton(onPressed: (){_data.requestRun();}, child: Text("Reload"))
        ],
      ),
    );
  }
}
