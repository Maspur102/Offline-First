import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../config/env_config.dart';

class ApiClient {
  final Dio dio;
  final Logger logger = Logger();

  ApiClient() : dio = Dio() {
    dio.options.baseUrl = EnvConfig.baseUrl;
    dio.options.connectTimeout = const Duration(seconds: 15);
    dio.options.receiveTimeout = const Duration(seconds: 15);

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.queryParameters['apiKey'] = EnvConfig.apiKey;
          logger.i('MENGIRIM REQUEST: [${options.method}] ${options.uri}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          // PERBAIKAN: Mengganti logger.s menjadi logger.i
          logger.i('BERHASIL [${response.statusCode}]: ${response.requestOptions.uri}');
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          logger.e('ERROR JARINGAN [${e.response?.statusCode}]: ${e.requestOptions.uri}\nPESAN: ${e.message}');
          return handler.next(e);
        },
      ),
    );
  }
}
