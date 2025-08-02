class KoiLiveResult<T>{
  KoiLiveResultStatus status;
  String message;
  List<Error> errors;
  T? data;

  KoiLiveResult({required this.status, required this.message, required this.errors, this.data});
}

enum KoiLiveResultStatus{
  Loading, Success, Error, Warning, Info
}