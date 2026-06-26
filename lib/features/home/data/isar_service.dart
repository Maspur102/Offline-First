import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../domain/article_model.dart';

class IsarService {
  late Future<Isar> db;

  IsarService() {
    db = openDB();
  }

  Future<Isar> openDB() async {
    if (Isar.instanceNames.isEmpty) {
      final dir = await getApplicationDocumentsDirectory();
      return await Isar.open(
        [ArticleModelSchema], // Memanggil skema pekerja gaib
        directory: dir.path,
      );
    }
    return Future.value(Isar.getInstance());
  }

  // Menyimpan berita baru dari internet ke memori lokal
  Future<void> saveArticles(List<ArticleModel> newArticles) async {
    final isar = await db;
    isar.writeTxnSync(() {
      // Karena kita pakai @Index(unique: true, replace: true) pada URL, 
      // Isar akan otomatis menimpa berita lama dan menambah yang baru
      isar.articleModels.putAllSync(newArticles);
    });
  }

  // Fitur Bookmark (Baca Nanti)
  Future<void> toggleBookmark(Id id, bool isBookmarked) async {
    final isar = await db;
    final article = await isar.articleModels.get(id);
    if (article != null) {
      article.isBookmarked = isBookmarked;
      isar.writeTxnSync(() => isar.articleModels.putSync(article));
    }
  }

  // REACTIVE STREAM: Memancarkan seluruh berita ke UI secara otomatis
  Stream<List<ArticleModel>> listenToArticles() async* {
    final isar = await db;
    yield* isar.articleModels.where().watch(fireImmediately: true);
  }
}
