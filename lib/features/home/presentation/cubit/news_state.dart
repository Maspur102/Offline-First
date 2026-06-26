import 'package:equatable/equatable.dart';
import '../../domain/article_model.dart';

abstract class NewsState extends Equatable {
  const NewsState();

  @override
  List<Object> get props => [];
}

class NewsLoading extends NewsState {}

class NewsLoaded extends NewsState {
  final List<ArticleModel> articles;
  final bool isSyncing; 
  final String? syncErrorMessage; 

  const NewsLoaded(this.articles, {this.isSyncing = false, this.syncErrorMessage});

  @override
  List<Object> get props => [articles, isSyncing, syncErrorMessage ?? ''];
}

class NewsError extends NewsState {
  final String message;

  const NewsError(this.message);

  @override
  List<Object> get props => [message];
}