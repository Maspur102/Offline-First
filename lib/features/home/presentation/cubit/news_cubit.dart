import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'news_state.dart';
import '../../domain/news_service.dart';

class NewsCubit extends Cubit<NewsState> {
  final NewsService _service;
  StreamSubscription? _articleSubscription;

  NewsCubit(this._service) : super(NewsLoading()) {
    _init();
  }

  void _init() {
    _articleSubscription = _service.getArticlesStream().listen((articles) {
      if (state is NewsLoaded) {
        final currentState = state as NewsLoaded;
        emit(NewsLoaded(
          articles, 
          isSyncing: currentState.isSyncing, 
          syncErrorMessage: currentState.syncErrorMessage
        ));
      } else {
        emit(NewsLoaded(articles));
      }
    });

    syncNews();
  }

  Future<void> syncNews() async {
    if (state is NewsLoaded) {
      final currentState = state as NewsLoaded;
      emit(NewsLoaded(currentState.articles, isSyncing: true));
    } else {
      emit(NewsLoading());
    }

    try {
      await _service.syncLatestNews();
      if (state is NewsLoaded) {
        final currentState = state as NewsLoaded;
        emit(NewsLoaded(currentState.articles, isSyncing: false));
      }
    } catch (e) {
      if (state is NewsLoaded) {
        final currentState = state as NewsLoaded;
        emit(NewsLoaded(currentState.articles, isSyncing: false, syncErrorMessage: e.toString()));
      } else {
        emit(NewsError("Koneksi gagal: $e"));
      }
    }
  }

  Future<void> toggleBookmark(int id, bool currentStatus) async {
    await _service.toggleBookmark(id, currentStatus);
  }

  @override
  Future<void> close() {
    _articleSubscription?.cancel();
    return super.close();
  }
}