import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import '../config/env_config.dart';

final locator = GetIt.instance;

void setupLocator() {
  // 1. Register Dio (Network)
  locator.registerLazySingleton<Dio>(() {
    final dio = Dio(BaseOptions(baseUrl: EnvConfig.baseUrl));
    
    // Kita tambahkan logger interseptor standar
    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
    return dio;
  });

  // Nanti Anda tambahkan pendaftaran Repository dan Cubit di sini!
}
