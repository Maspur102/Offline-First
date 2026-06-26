import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/config/env_config.dart';
import '../cubit/news_cubit.dart';
import '../cubit/news_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Portal Berita [${EnvConfig.environment}]'),
        backgroundColor: EnvConfig.isProduction ? Colors.green : Colors.blueGrey,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh), 
            onPressed: () => context.read<NewsCubit>().syncNews()
          ),
        ]
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
            width: double.infinity,
            color: Theme.of(context).cardColor,
            child: const Column(
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.blueAccent,
                  child: Icon(Icons.person, size: 40, color: Colors.white),
                ),
                SizedBox(height: 12),
                Text('UTD Store', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text('Rifky Raihan - 20123021', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                SizedBox(height: 2),
                Text('Tugas Individu', style: TextStyle(fontSize: 14, color: Colors.grey)),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1),
          
          Expanded(
            child: BlocConsumer<NewsCubit, NewsState>(
              listener: (context, state) {
                if (state is NewsLoaded && state.syncErrorMessage != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.syncErrorMessage!), backgroundColor: Colors.red)
                  );
                }
              },
              builder: (context, state) {
                if (state is NewsLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is NewsError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.wifi_off, size: 60, color: Colors.red),
                        const SizedBox(height: 16),
                        Text(state.message, textAlign: TextAlign.center),
                      ]
                    )
                  );
                } else if (state is NewsLoaded) {
                  final articles = state.articles;
                  if (articles.isEmpty) {
                    return const Center(child: Text('Belum ada berita. Menarik data dari API...'));
                  }
                  
                  return Stack(
                    children: [
                      ListView.builder(
                        itemCount: articles.length,
                        itemBuilder: (context, index) {
                          final item = articles[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: ListTile(
                              leading: item.urlToImage != null && item.urlToImage!.isNotEmpty
                                  ? Image.network(
                                      item.urlToImage!, 
                                      width: 80, height: 80, fit: BoxFit.cover, 
                                      errorBuilder: (_,__,___) => const Icon(Icons.image_not_supported)
                                    )
                                  : const Icon(Icons.article, size: 50),
                              title: Text(item.title ?? 'Tanpa Judul', maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text(item.author ?? 'Unknown', maxLines: 1),
                              trailing: IconButton(
                                icon: Icon(
                                  item.isBookmarked ? Icons.bookmark : Icons.bookmark_border, 
                                  color: item.isBookmarked ? Colors.blue : Colors.grey
                                ),
                                onPressed: () => context.read<NewsCubit>().toggleBookmark(item.id, item.isBookmarked),
                              ),
                            ),
                          );
                        }
                      ),
                      if (state.isSyncing)
                        const Positioned(
                          top: 0, left: 0, right: 0,
                          child: LinearProgressIndicator()
                        )
                    ]
                  );
                }
                return const SizedBox.shrink();
              }
            ),
          ),
        ],
      ),
    );
  }
}
