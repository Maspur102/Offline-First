import 'package:flutter/material.dart';
import '../../domain/article_model.dart';

class ArticleDetailPage extends StatelessWidget {
  final ArticleModel article;

  const ArticleDetailPage({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Berita'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article.urlToImage != null && article.urlToImage!.isNotEmpty)
              Image.network(
                article.urlToImage!,
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 250, color: Colors.grey.shade800, child: const Icon(Icons.broken_image, size: 50)
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(article.title ?? 'Tanpa Judul', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.person_outline, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Expanded(child: Text(article.author ?? 'Penulis Tidak Diketahui', style: const TextStyle(color: Colors.grey))),
                    ],
                  ),
                  const Divider(height: 32, thickness: 1),
                  Text(
                    article.content ?? article.description ?? 'Tidak ada konten detail yang tersedia untuk berita ini.', 
                    style: const TextStyle(fontSize: 16, height: 1.6)
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}