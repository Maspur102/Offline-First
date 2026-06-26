import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import '../config/env_config.dart';
import '../network/api_client.dart';

// Import file-file baru kita
import '../../features/home/data/isar_service.dart';
import '../../features/home/data/news_repository.dart';
import '../../features/home/domain/news_service.dart';

final locator = GetIt.instance;

void setupLocator() {
  // 1. Register API Client (Jaringan)
  locator.registerLazySingleton<ApiClient>(() => ApiClient());

  // 2. Register Isar Service (Database Lokal)
  locator.registerLazySingleton<IsarService>(() => IsarService());

  // 3. Register Repository
  locator.registerLazySingleton<NewsRepository>(() => NewsRepository());

  // 4. Register Service
  locator.registerFactory<NewsService>(() => NewsService(locator()));
}
