part of 'home_bloc.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

//-----------CATEGORIES STATE----------//

class CategoryState extends HomeState {}

final class CategoriesLoadingState extends CategoryState {}

final class CategoriesLoadedState extends CategoryState {
  final List<Category> categories;

  CategoriesLoadedState({required this.categories});
}

final class CategoriesErrorState extends CategoryState {}

//-----------PRODUCT STATE----------//

final class ProductsLoadingState extends HomeState {}

final class ProductsLoadedState extends HomeState {
  final List<Product> products;
  final int totalProductsCount;
  final int productsLimitOnPage;

  ProductsLoadedState(
      {required this.products,
      required this.totalProductsCount,
      required this.productsLimitOnPage});
}

final class ProductsErrorState extends HomeState {
  final String error;

  ProductsErrorState({required this.error});
}
