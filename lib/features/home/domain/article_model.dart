import 'package:isar/isar.dart';

// Baris gaib yang dibutuhkan oleh Isar (Akan error merah sementara, biarkan saja)
part 'article_model.g.dart';

@collection
class ArticleModel {
  // ID wajib untuk Isar Database
  Id id = Isar.autoIncrement;

  // Kita jadikan URL berita sebagai Index unik. 
  // Jika ada berita yang sama ditarik dari internet, Isar akan me-replace (menimpa) yang lama.
  @Index(unique: true, replace: true)
  String? url;

  String? title;
  String? author;
  String? description;
  String? urlToImage;
  String? publishedAt;
  String? content;

  // Penanda untuk fitur Bookmark (Baca Nanti)
  bool isBookmarked = false;

  ArticleModel({
    this.title,
    this.author,
    this.description,
    this.url,
    this.urlToImage,
    this.publishedAt,
    this.content,
    this.isBookmarked = false,
  });

  // Fungsi sakti untuk menerjemahkan JSON dari NewsAPI ke Objek Dart
  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      title: json['title'] as String?,
      author: json['author'] as String?,
      description: json['description'] as String?,
      url: json['url'] as String?,
      urlToImage: json['urlToImage'] as String?,
      publishedAt: json['publishedAt'] as String?,
      content: json['content'] as String?,
    );
  }
}
