import 'package:dio/dio.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/network/api_client.dart';
import '../domain/article_model.dart';
import 'isar_service.dart';

class NewsRepository {
  final ApiClient _apiClient = locator<ApiClient>();
  final IsarService _isarService = locator<IsarService>();

  Future<void> fetchAndSaveTopHeadlines() async {
    try {
      final response = await _apiClient.dio.get(
        'top-headlines',
        queryParameters: {
          'country': 'us',
          'category': 'technology',
        },
      );

      final List<dynamic> articlesJson = response.data['articles'];
      
      final List<ArticleModel> articles = articlesJson
          .map((json) => ArticleModel.fromJson(json))
          .where((article) => article.title != null && article.title != '[Removed]')
          .toList();

      await _isarService.saveArticles(articles);
    } on DioException catch (e) {
      throw Exception('Gagal menyambung ke internet: ${e.message}');
    } catch (e) {
      throw Exception('Terjadi kesalahan sistem: $e');
    }
  }

  Stream<List<ArticleModel>> getArticlesStream() {
    return _isarService.listenToArticles();
  }

  Future<void> toggleBookmark(int id, bool isBookmarked) async {
    await _isarService.toggleBookmark(id, isBookmarked);
  }
}
