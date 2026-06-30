import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/home/presentation/pages/article_detail_page.dart';
import '../../features/home/domain/article_model.dart';
import '../../features/home/presentation/cubit/news_cubit.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../di/injection.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => BlocProvider(
          create: (context) => locator<NewsCubit>(),
          child: const HomePage(),
        ),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const SettingsPage(),
      ),
      GoRoute(
        path: '/detail',
        builder: (context, state) {
          // Menerima data artikel yang dilempar dari HomePage
          final article = state.extra as ArticleModel;
          return ArticleDetailPage(article: article);
        },
      ),
    ],
  );
}