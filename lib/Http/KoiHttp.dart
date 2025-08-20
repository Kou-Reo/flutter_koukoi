import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class KoiHttp {
  KoiHttp({String? baseUrl, String? baseFallbackUrl, required this.path})
      : _baseUrl = baseUrl,
        _baseFallbackUrl = baseFallbackUrl;

  //start-url🔗🔗🔗🔗🔗🔗🔗🔗🔗🔗🔗🔗🔗🔗🔗🔗🔗🔗🔗🔗🔗🔗🔗🔗🔗🔗🔗🔗🔗🔗
  static String? BaseUrl;
  String? _baseUrl;

  String? get baseUrl => _baseUrl ?? BaseUrl;

  /// full url = baseUrl+path
  String? path;

  /// full url yang digunakan un tuk request
  /// return error kalo url yang dibentuk tidak valid
  ///
  /// **NOTE** otomatis meremove "/" dari akhir [baseUrl] dan awal [path]. jadi url **example.com/** dan path **/example** akan mereturn **example.com/example**
  ///
  /// TERMASUK URL PARAM KALO ADA
  String? get url {
    String buildUrl =
        "${baseUrl?.replaceAll(RegExp(r'/+$'), '') ?? ""}/${path?.replaceAll(RegExp(r'^/+'), '') ?? ""}";

    if (param != null) {
      buildUrl = "${buildUrl}?${param}";
    }

    final uri = Uri.tryParse(buildUrl);
    if (uri != null && uri.hasScheme && uri.hasAuthority) {
      // url valid, bisa di return
      return buildUrl;
    }

    throw Exception("url: ${buildUrl} tidak valid");
  }

  //end---url🔗🔗🔗🔗🔗🔗🔗🔗🔗🔗🔗🔗🔗🔗🔗🔗🔗🔗🔗🔗🔗🔗🔗🔗🔗🔗🔗🔗🔗🔗

  //start-url🔗🔗🔗🔗🔗🔗🔗🔗🔗🔗🔗🔗🔗🔗🔗🔗🔗🔗🔗🔗🔗🔗🔗🔗🔗🔗🔗🔗🔗🔗
  static String? BaseFallbackUrl;
  String? _baseFallbackUrl;

  String? get baseFallbackUrl => _baseFallbackUrl ?? BaseFallbackUrl;

  /// sama dengan [url] tapi mengendung url backup
  ///
  /// misalnya [url] tidak bisa dihubungi, maka library ini akan mengulangi request tapi ke [fallbackUrl]
  String? get fallbackUrl {
    String buildUrl =
        "${baseFallbackUrl?.replaceAll(RegExp(r'/+$'), '') ?? ""}/${path?.replaceAll(RegExp(r'^/+'), '') ?? ""}";

    if (param != null) {
      buildUrl = "${buildUrl}?${param}";
    }

    final uri = Uri.tryParse(buildUrl);
    if (uri != null && uri.hasScheme && uri.hasAuthority) {
      // url valid, bisa di return
      return buildUrl;
    }

    throw Exception("url: ${buildUrl} tidak valid");
  }

  //end---url🔗🔗🔗🔗🔗🔗🔗🔗🔗🔗🔗🔗🔗🔗🔗🔗🔗🔗🔗🔗🔗🔗🔗🔗🔗🔗🔗🔗🔗🔗

  //start-addHeader🎃🎃🎃🎃🎃🎃🎃🎃🎃🎃🎃🎃🎃🎃🎃🎃🎃🎃🎃🎃🎃🎃🎃🎃🎃🎃🎃🎃
  static Map<String, String> _Header = {};
  Map<String, String> _header = {};

  Map<String, String> get header {
    Map<String, String> ret = {};
    ret.addAll(_Header);
    ret.addAll(_header);

    if (ret.containsKey("Content-Type") == false) {
      // otomatis tambah Content-Type kalau ada body [raw]
      if (raw != null) {
        if (raw_Type == _RawType.json) {
          ret["Content-Type"] = "application/json";
        } else if (raw_Type == _RawType.text) {
          ret["Content-Type"] = "text/plain";
        } else {
          throw AssertionError("_RawType ini belum diimplementasikan");
        }
      }
    }

    return ret;
  }

  static void AddHeader(String key, String value) {
    _Header[key] = value;
  }

  KoiHttp addHeader(String key, String value) {
    _header[key] = value;
    return this;
  }

  //end---addHeader🎃🎃🎃🎃🎃🎃🎃🎃🎃🎃🎃🎃🎃🎃🎃🎃🎃🎃🎃🎃🎃🎃🎃🎃🎃🎃🎃🎃

  //start-addParam🤓🤓🤓🤓🤓🤓🤓🤓🤓🤓🤓🤓🤓🤓🤓🤓🤓🤓🤓🤓🤓🤓🤓🤓🤓🤓🤓🤓
  static Map<String, String> _Param = {};
  Map<String, String> _param = {};

  /// tidak termasuk **?** di depan
  /// return null kalau tidak ada param yang dimasukkan
  String? get param {
    if (_Param.isEmpty && _param.isEmpty) {
      return null;
    }

    String ret = "";
    _Param.forEach((key, value) {
      ret += "$key=$value&";
    });
    _param.forEach((key, value) {
      ret += "$key=$value&";
    });
    return ret;
  }

  static void AddParam(String key, String value) {
    _Param[key] = value;
  }

  KoiHttp addParam(String key, String value) {
    _param[key] = value;
    return this;
  }

  //end---addParam🤓🤓🤓🤓🤓🤓🤓🤓🤓🤓🤓🤓🤓🤓🤓🤓🤓🤓🤓🤓🤓🤓🤓🤓🤓🤓🤓🤓

  //start-addBody🤰🤰🤰🤰🤰🤰🤰🤰🤰🤰🤰🤰🤰🤰🤰🤰🤰🤰🤰🤰🤰🤰🤰🤰🤰🤰🤰🤰🤰🤰🤰🤰🤰🤰🤰🤰🤰🤰🤰🤰🤰🤰🤰🤰🤰🤰

  // body tipe form-data😋
  static Map<String, String> _Form_Data = {};
  Map<String, String> _form_data = {};
  static Map<String, File> _Form_File = {};
  Map<String, File> _form_file = {};

  /// key value. value bisa string bisa juga file
  Map<String, dynamic> get form_data {
    Map<String, dynamic> ret = {};
    ret.addAll(_Form_Data);
    ret.addAll(_form_data);
    ret.addAll(_Form_File);
    ret.addAll(_form_file);
    return ret;
  }

  Map<String, String> get form_data_without_file {
    Map<String, String> ret = {};
    ret.addAll(_Form_Data);
    ret.addAll(_form_data);
    return ret;
  }

  List<http.MultipartFile> get form_data_just_file {
    List<http.MultipartFile> ret = [];
    KoiHttp._Form_File.forEach((key, val) {
      ret.add(http.MultipartFile.fromBytes(key, val.readAsBytesSync(),
          filename: val.path.split('/').last));
    });
    _form_file.forEach((key, val) {
      ret.add(http.MultipartFile.fromBytes(key, val.readAsBytesSync(),
          filename: val.path.split('/').last));
    });

    return ret;
  }

  // body tipe x_www_form_urlencoded😒
  static Map<String, String> _X_www_form_urlencoded = {};
  Map<String, String> _x_www_form_urlencoded = {};

  Map<String, String> get x_www_form_urlencoded {
    Map<String, String> ret = {};
    ret.addAll(_X_www_form_urlencoded);
    ret.addAll(_x_www_form_urlencoded);
    return ret;
  }

  // body tipe raw😣
  static String? _Raw = null;
  String? _raw;

  /// [_Raw] atau [_raw] hanya salahsatu yang boleh diisi. variable ini mengikuti isi dari yang diisi
  static _RawType? _Raw_Type;
  _RawType? _raw_Type;

  String? get raw => _raw ?? _Raw;

  _RawType? get raw_Type => _raw_Type ?? _Raw_Type;

  /// pakai ini untuk body ke request
  ///
  /// note, kalau masukkan jenis body berbeda, jenis body lain akan di clear
  /// - misalnya pertama panggil [formData()]
  /// - terus panggil [xWwwFormUrlencoded()]
  /// - pas panggil [xWwwFormUrlencoded()], data yang sebelumnya dimasukkan pakai [formData()] akan di clear
  static _BodyAdd get AddBody {
    return _BodyAdd(mainClass: KoiHttp(path: null), isStatic: true);
  }

  /// pakai ini untuk body ke request
  ///
  /// note, kalau masukkan jenis body berbeda, jenis body lain akan di clear
  /// - misalnya pertama panggil [formData()]
  /// - terus panggil [xWwwFormUrlencoded()]
  /// - pas panggil [xWwwFormUrlencoded()], data yang sebelumnya dimasukkan pakai [formData()] akan di clear
  _BodyAdd get addBody {
    return _BodyAdd(mainClass: this, isStatic: false);
  }

  //end---addBody🤰🤰🤰🤰🤰🤰🤰🤰🤰🤰🤰🤰🤰🤰🤰🤰🤰🤰🤰🤰🤰🤰🤰🤰🤰🤰🤰🤰🤰🤰🤰🤰🤰🤰🤰🤰🤰🤰🤰🤰🤰🤰🤰🤰🤰🤰

  //start-send request🚝🚝🚝🚝🚝🚝🚝🚝🚝🚝🚝🚝🚝🚝🚝🚝🚝🚝🚝🚝🚝🚝🚝🚝🚝🚝

  Future<http.Response> sendPost() {
    // kalo body bertipe form-data(ada file), kirim multipart request
    // selain itu kirim request biasa
    if (form_data.isNotEmpty) {
      return _sendMultipartRequest(url, _RequestMethod.POST);
    }
    return _sendRequest(url, _RequestMethod.POST);
  }

  Future<http.Response> sendGet() {
    return _sendRequest(url, _RequestMethod.GET);
  }

  Future<http.Response> sendDelete() {
    // kalo body bertipe form-data(ada file), kirim multipart request
    // selain itu kirim request biasa
    if (form_data.isNotEmpty) {
      return _sendMultipartRequest(url, _RequestMethod.DELETE);
    }
    return _sendRequest(url, _RequestMethod.DELETE);
  }

  Future<http.Response> sendHead() {
    return _sendRequest(url, _RequestMethod.HEAD);
  }

  Future<http.Response> sendPatch() {
    // kalo body bertipe form-data(ada file), kirim multipart request
    // selain itu kirim request biasa
    if (form_data.isNotEmpty) {
      return _sendMultipartRequest(url, _RequestMethod.PATCH);
    }
    return _sendRequest(url, _RequestMethod.PATCH);
  }

  Future<http.Response> sendPut() {
    // kalo body bertipe form-data(ada file), kirim multipart request
    // selain itu kirim request biasa
    if (form_data.isNotEmpty) {
      return _sendMultipartRequest(url, _RequestMethod.PUT);
    }
    return _sendRequest(url, _RequestMethod.PUT);
  }

  Future<http.Response> _sendRequest(String? urlRequest, _RequestMethod requestMethod) async {
    //start-periksa apa request valid🚲
    if (urlRequest == null) {
      throw AssertionError("tidak ada url dimasukkan");
    }
    List<_RequestMethod> requestTanpaBody = [
      _RequestMethod.GET,
      _RequestMethod.HEAD
    ];
    if (requestTanpaBody.contains(requestMethod) &&
        x_www_form_urlencoded.isNotEmpty &&
        raw != null) {
      throw AssertionError(
          "${requestMethod.name} request tidak bisa punya body. gunakan query untuk mengirim data ke server");
    }
    //end---periksa apa request valid🚲

    dynamic err = null;
    try {
      // build url
      var uri = Uri.parse(urlRequest);

      // send request
      if (requestMethod == _RequestMethod.POST) {
        return await http.post(
          uri,
          headers: header,
          body: raw ?? x_www_form_urlencoded,
        );
      } else if (requestMethod == _RequestMethod.DELETE) {
        return await http.delete(
          uri,
          headers: header,
          body: raw ?? x_www_form_urlencoded,
        );
      } else if (requestMethod == _RequestMethod.GET) {
        return await http.get(uri, headers: header);
      } else if (requestMethod == _RequestMethod.HEAD) {
        return await http.head(uri, headers: header);
      } else if (requestMethod == _RequestMethod.PATCH) {
        return await http.patch(
          uri,
          headers: header,
          body: raw ?? x_www_form_urlencoded,
        );
      } else if (requestMethod == _RequestMethod.PUT) {
        return await http.put(
          uri,
          headers: header,
          body: raw ?? x_www_form_urlencoded,
        );
      }
    } on SocketException catch (e) {
      print('Primary URL network error (SocketException): $e. Falling back...');
      err = e;
    } on http.ClientException catch (e) {
      print('Primary URL client error (ClientException): $e. Falling back...');
      err = e;
    } on HttpException catch (e) {
      print('Primary URL HTTP error (HttpException): $e. Falling back...');
      err = e;
    } catch (e) {
      print('An unexpected error occurred with primary URL: $e. Falling back...');
      err = e;
    }

    if(err != null && fallbackUrl != urlRequest){
      return await _sendRequest(fallbackUrl, requestMethod);
    }

    if(err != null){
      return http.Response('Error: $err', 500);
    }

    throw AssertionError("request method ini belum diimplementasikan");
  }

  Future<http.Response> _sendMultipartRequest(String? urlRequest, _RequestMethod requestMethod) async {
    if (urlRequest == null) {
      throw AssertionError("tidak ada url dimasukkan");
    }

    dynamic err = null;
    try {
      // build url
      var uri = Uri.parse(urlRequest);
      var request = http.MultipartRequest(requestMethod.name, uri);

      // build header
      request.headers.addAll(header);

      // build body
      request.fields.addAll(form_data_without_file);
      request.files.addAll(form_data_just_file);

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      return http.Response(
        responseBody,
        response.statusCode,
        headers: response.headers,
        request: response.request,
      );
    } on SocketException catch (e) {
      print('Primary URL network error (SocketException): $e. Falling back...');
      err = e;
    } on http.ClientException catch (e) {
      print('Primary URL client error (ClientException): $e. Falling back...');
      err = e;
    } on HttpException catch (e) {
      print('Primary URL HTTP error (HttpException): $e. Falling back...');
      err = e;
    } catch (e) {
      print('An unexpected error occurred with primary URL: $e. Falling back...');
      err = e;
    }

    if(err != null && fallbackUrl != urlRequest){
      // send request ke fallback url
      return await _sendMultipartRequest(fallbackUrl, requestMethod);
    }

    return http.Response('Error: $err', 500);
  }
//end---send request🚝🚝🚝🚝🚝🚝🚝🚝🚝🚝🚝🚝🚝🚝🚝🚝🚝🚝🚝🚝🚝🚝🚝🚝🚝🚝
}

class _BodyAdd {
  KoiHttp _mainClass;
  bool _isStatic;

  _BodyAdd({required KoiHttp mainClass, required bool isStatic})
      : _mainClass = mainClass,
        _isStatic = isStatic;

  void _removeFormData() {
    KoiHttp._Form_Data.clear();
    KoiHttp._Form_File.clear();
    _mainClass._form_data.clear();
    _mainClass._form_file.clear();
  }

  void _removeXWwwFormUrlencoded() {
    KoiHttp._X_www_form_urlencoded.clear();
    _mainClass._x_www_form_urlencoded.clear();
  }

  void _removeRaw() {
    KoiHttp._Raw = null;
    KoiHttp._Raw_Type = null;
    _mainClass._raw = null;
    _mainClass._raw_Type = null;
  }

  KoiHttp addFormData(String key, {String? value, File? file}) {
    //clear data lain kek xWwwFormUrlencoded

    if (value == null && file == null) {
      throw AssertionError("value atau file harus ada salah satunya");
    }

    if (value != null && file != null) {
      throw AssertionError(
          "value atau file harus diisi salahsatu jangan keduanya");
    }

    if (_isStatic) {
      if (value != null) {
        KoiHttp._Form_Data[key] = value;
      }
      if (file != null) {
        KoiHttp._Form_File[key] = file;
      }
    } else {
      if (value != null) {
        _mainClass._form_data[key] = value;
      }
      if (file != null) {
        _mainClass._form_file[key] = file;
      }
    }

    _removeRaw();
    _removeXWwwFormUrlencoded();

    return _mainClass;
  }

  KoiHttp addXWwwFormUrlencoded(String key, String value) {
    if (_isStatic) {
      KoiHttp._X_www_form_urlencoded[key] = value;
    } else {
      _mainClass._x_www_form_urlencoded[key] = value;
    }

    //clear data lain kek formData
    _removeRaw();
    _removeFormData();

    return _mainClass;
  }

  KoiHttp addRaw({String? text, Map<String, dynamic>? json}) {
    if (text == null && json == null) {
      throw AssertionError("text atau json harus ada salah satunya");
    } else if (text != null && json != null) {
      throw AssertionError(
          "text atau json harus diisi salahsatu jangan keduanya");
    }

    if (text != null) {
      if (_isStatic) {
        KoiHttp._Raw = text;
        KoiHttp._Raw_Type = _RawType.text;
      } else {
        _mainClass._raw = text;
        _mainClass._raw_Type = _RawType.text;
      }
    } else if (json != null) {
      if (_isStatic) {
        KoiHttp._Raw = jsonEncode(json);
        KoiHttp._Raw_Type = _RawType.json;
      } else {
        _mainClass._raw = jsonEncode(json);
        _mainClass._raw_Type = _RawType.json;
      }
    } else {
      throw AssertionError("tipe body ini belum diimpleentasikan");
    }

    _removeXWwwFormUrlencoded();
    _removeFormData();

    return _mainClass;
  }
}

enum _RawType { text, json }

enum _RequestMethod {
  GET,
  POST,
  PUT,
  PATCH,
  DELETE,
  HEAD,
  OPTIONS,
  TRACE,
  CONNECT
}
