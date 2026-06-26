import '../data/news_repository.dart';
import 'article_model.dart'; 

class NewsService {
  final NewsRepository repository;

  NewsService(this.repository);

  Future<void> syncLatestNews() async {
    await repository.fetchAndSaveTopHeadlines();
  }

  Stream<List<ArticleModel>> getArticlesStream() {
    return repository.getArticlesStream();
  }

  Future<void> toggleBookmark(int id, bool currentStatus) async {
    await repository.toggleBookmark(id, currentStatus);
  }
}
