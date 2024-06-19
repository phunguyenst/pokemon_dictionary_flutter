import 'package:dio/dio.dart';

class HttpService {
  HttpService();
  final _dio = Dio();
  Future<Response?> get(String path) async {
    try {
      final response = await _dio.get(path);
      return response;
    } catch (e) {
      print(e);
    }
    return null;
  }
}
