part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}

class GetCategoriesEvent extends HomeEvent {}

class GetAllProductsEvent extends HomeEvent {
  final int pageNo;

  GetAllProductsEvent({required this.pageNo});
}

class GetCategoryProductsEvent extends HomeEvent {
  final String category;
  final int pageNo;

  GetCategoryProductsEvent({required this.category, required this.pageNo});
}

class SearchProductsEvent extends HomeEvent {
  final String keyword;
  final int pageNo;

  SearchProductsEvent({required this.keyword, required this.pageNo});
}
