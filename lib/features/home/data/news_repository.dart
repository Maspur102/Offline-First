import 'package:dio/dio.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/network/api_client.dart';
import '../domain/article_model.dart';
import 'isar_service.dart';

class NewsRepository {
  // Panggil Dio dan Isar lewat pelayan GetIt
  final ApiClient _apiClient = locator<ApiClient>();
  final IsarService _isarService = locator<IsarService>();

  // Fungsi sinkronisasi berita dari Internet ke Lokal
  Future<void> fetchAndSaveTopHeadlines() async {
    try {
      // Menarik berita teknologi dari NewsAPI
      final response = await _apiClient.dio.get(
        'top-headlines',
        queryParameters: {
          'country': 'us',
          'category': 'technology',
        },
      );

      // Mengambil daftar berita JSON
      final List<dynamic> articlesJson = response.data['articles'];
      
      // Mengubah JSON menjadi Objek Dart
      final List<ArticleModel> articles = articlesJson
          .map((json) => ArticleModel.fromJson(json))
          // Menyaring (filter) berita yang terhapus atau tanpa judul
          .where((article) => article.title != null && article.title != '[Removed]')
          .toList();

      // PARADIGMA OFFLINE-FIRST: Simpan data dari API langsung ke Database Lokal!
      await _isarService.saveArticles(articles);

    } on DioException catch (e) {
      throw Exception('Gagal menyambung ke internet: ${e.message}');
    } catch (e) {
      throw Exception('Terjadi kesalahan sistem: $e');
    }
  }
}
