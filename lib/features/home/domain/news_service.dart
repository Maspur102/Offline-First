import '../data/news_repository.dart';

class NewsService {
  final NewsRepository repository;

  NewsService(this.repository);

  // Fungsi yang nantinya akan dipanggil secara diam-diam oleh Cubit
  Future<void> syncLatestNews() async {
    await repository.fetchAndSaveTopHeadlines();
  }
}
