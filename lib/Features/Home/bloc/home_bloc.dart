import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moboom/Features/Home/models/category.dart';
import 'package:moboom/Features/Home/models/product.dart';
import 'package:moboom/Features/Home/repo/home_repository.dart';
part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<GetCategoriesEvent>(_getCategories);

    on<GetAllProductsEvent>(_getAllProducts);

    on<GetCategoryProductsEvent>(_getCategoryProducts);

    on<SearchProductsEvent>(_searchProducts);
  }

  FutureOr<void> _getCategories(
      GetCategoriesEvent event, Emitter<HomeState> emit) async {
    emit(CategoriesLoadingState());
    try {
      final apiRequest = await HomeRepository.getCategoriesList();

      if (apiRequest.success) {
        List categoriesList = apiRequest.data ?? [];
        emit(CategoriesLoadedState(categories: [
          for (final category in categoriesList) Category.fromJson(category)
        ]));
      } else {
        emit(CategoriesErrorState());
      }
    } catch (e) {
      emit(CategoriesErrorState());
    }
  }

  FutureOr<void> _getAllProducts(
      GetAllProductsEvent event, Emitter<HomeState> emit) async {
    emit(ProductsLoadingState());

    try {
      final apiRequest =
          await HomeRepository.getAllProducts(pageNo: event.pageNo);

      if (apiRequest.success) {
        List productsList = apiRequest.data?['products'] ?? [];
        emit(ProductsLoadedState(
          products: [
            for (final product in productsList) Product.fromJson(product)
          ],
          totalProductsCount: apiRequest.data?['total'] ?? 0,
          productsLimitOnPage: apiRequest.data?['limit'] ?? 0,
        ));
      } else {
        emit(ProductsErrorState(error: 'Failed to load products'));
      }
    } catch (e) {
      emit(ProductsErrorState(error: e.toString()));
    }
  }

  FutureOr<void> _getCategoryProducts(
      GetCategoryProductsEvent event, Emitter<HomeState> emit) async {
    emit(ProductsLoadingState());

    try {
      final apiRequest = await HomeRepository.getCategoryProducts(
          slug: event.category, pageNo: event.pageNo);

      if (apiRequest.success) {
        emit(ProductsLoadedState(
          products: [
            for (final product in apiRequest.data?['products'] ?? [])
              Product.fromJson(product)
          ],
          totalProductsCount: apiRequest.data?['total'] ?? 0,
          productsLimitOnPage: apiRequest.data?['limit'] ?? 0,
        ));
      } else {
        emit(ProductsErrorState(error: 'Failed to load products'));
      }
    } catch (e) {
      emit(ProductsErrorState(error: e.toString()));
    }
  }

  FutureOr<void> _searchProducts(
      SearchProductsEvent event, Emitter<HomeState> emit) async {
    emit(ProductsLoadingState());

    try {
      final apiRequest = await HomeRepository.getSearchedProducts(
          keyword: event.keyword, pageNo: event.pageNo);

      if (apiRequest.success) {
        emit(ProductsLoadedState(
          products: [
            for (final product in apiRequest.data?['products'] ?? [])
              Product.fromJson(product)
          ],
          totalProductsCount: apiRequest.data?['total'] ?? 0,
          productsLimitOnPage: apiRequest.data?['limit'] ?? 0,
        ));
      } else {
        emit(ProductsErrorState(error: 'Failed to load products'));
      }
    } catch (e) {
      emit(ProductsErrorState(error: e.toString()));
    }
  }
}
