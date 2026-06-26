import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import '../config/env_config.dart';
import '../network/api_client.dart';

import '../../features/home/data/isar_service.dart';
import '../../features/home/data/news_repository.dart';
import '../../features/home/domain/news_service.dart';
import '../../features/home/presentation/cubit/news_cubit.dart';

final locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton<ApiClient>(() => ApiClient());
  locator.registerLazySingleton<IsarService>(() => IsarService());
  locator.registerLazySingleton<NewsRepository>(() => NewsRepository());
  locator.registerFactory<NewsService>(() => NewsService(locator()));
  locator.registerFactory<NewsCubit>(() => NewsCubit(locator()));
}
