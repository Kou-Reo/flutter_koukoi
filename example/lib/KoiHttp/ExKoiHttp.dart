import 'package:flutter/material.dart';
import 'package:flutter_koukoi/Http/KoiHttp.dart';

class ExKoiHttp extends StatefulWidget {
  const ExKoiHttp({super.key});

  @override
  State<ExKoiHttp> createState() => _ExKoiHttpState();
}

class _ExKoiHttpState extends State<ExKoiHttp> {

  KoiHttp getSingleObject = KoiHttp(path: 'objects/7');
  String getSingleObjectStr = "";

  KoiHttp postAddObject = KoiHttp(path: 'objects');
  String postAddObjectStr = "";

  KoiHttp getOtherUrl = KoiHttp(baseUrl: "https://official-joke-api.appspot.com/", path: 'random_joke');
  String getOtherUrlStr = "";

  KoiHttp getTestFallbackUrl = KoiHttp(baseUrl: "https://abcdefgsadsadsduahdi.com", baseFallbackUrl: "https://official-joke-api.appspot.com/random_joke", path: '');
  String getTestFallbackUrlStr = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    KoiHttp.BaseUrl = "https://api.restful-api.dev";

    postAddObject.addBody.addRaw(json: {
      "name": "Apple MacBook Pro 16x",
      "data": {
        "year": 2019,
        "price": 1849.99,
        "CPU model": "Intel Core i9",
        "Hard disk size": "1 TB"
      }
    });

    getSingleObject.sendGet().then((adata){
      setState(() {
        getSingleObjectStr = adata.body;
      });
    });
    postAddObject.sendPost().then((adata){
      setState(() {
        postAddObjectStr = adata.body;
      });
    });

    getOtherUrl.sendGet().then((adata){
      setState(() {
        getOtherUrlStr = adata.body;
      });
    });

    getTestFallbackUrl.sendGet().then((adata){
      setState(() {
        getTestFallbackUrlStr = adata.body;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Example KotHttp"),
      ),
      body: ListView(
        children: [
          Text(getSingleObjectStr),
          Divider(),
          Text(postAddObjectStr),
          Divider(),
          Text(getOtherUrlStr),
          Divider(),
          Text(getTestFallbackUrlStr),
        ],
      ),
    );
  }
}
