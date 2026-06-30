import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../cubit/news_cubit.dart';
import '../cubit/news_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DigiNews'), // PERBAIKAN: Bersih tanpa teks environment
        actions: [
          IconButton(
            icon: const Icon(Icons.person), 
            onPressed: () => context.push('/profile')
          ),
          IconButton(
            icon: const Icon(Icons.refresh), 
            onPressed: () => context.read<NewsCubit>().syncNews()
          ),
        ]
      ),
      body: BlocConsumer<NewsCubit, NewsState>(
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
            return Center(child: Text(state.message));
          } else if (state is NewsLoaded) {
            final articles = state.articles;
            if (articles.isEmpty) return const Center(child: Text('Belum ada berita.'));
            
            return ListView.builder(
              itemCount: articles.length,
              itemBuilder: (context, index) {
                final item = articles[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    onTap: () => context.push('/detail', extra: item),
                    leading: const Icon(Icons.article, size: 50),
                    title: Text(item.title ?? 'Tanpa Judul', maxLines: 2),
                    trailing: IconButton(
                      icon: Icon(
                        item.isBookmarked ? Icons.bookmark : Icons.bookmark_border, 
                        color: item.isBookmarked ? Colors.blue : Colors.grey
                      ),
                      // PERBAIKAN: Mengirim status boolean kebalikan untuk ditoggle
                      onPressed: () {
                        context.read<NewsCubit>().toggleBookmark(item.id, !item.isBookmarked);
                        // Trigger re-sync ringan jika UI tidak otomatis merender
                        context.read<NewsCubit>().syncNews(); 
                      },
                    ),
                  ),
                );
              }
            );
          }
          return const SizedBox.shrink();
        }
      ),
    );
  }
}