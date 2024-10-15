import 'dart:convert';
import 'package:moboom/Features/Home/models/api_response.dart';
import 'package:http/http.dart' as http;

class HomeRepository {
  static const String _baseUrl = 'https://dummyjson.com/';
  static const String _productsUrl = '${_baseUrl}products/';
  static const String _searchProductsUrl = '${_productsUrl}search';
  static const String _categoriesUrl = '${_productsUrl}categories';
  static const String _categoryProductsUrl = '${_productsUrl}category/';

  //FETCH THE NO OF ITEMS TO SHOW ON PAGE
  static const int _limit = 6;

  static Future<ApiResponse> getCategoriesList() async {
    String url = _categoriesUrl;

    final request = await http.get(Uri.parse(url));

    if (request.statusCode == 200) {
      return ApiResponse(success: true, data: json.decode(request.body));
    } else {
      return ApiResponse(success: false, data: null);
    }
  }

  static Future<ApiResponse> getAllProducts({required int pageNo}) async {
    String url =
        '$_productsUrl?limit=$_limit&skip=${_limit * pageNo}'; //MULTIPLYING THE NO OF ITEMS WITH PAGE NO TO AVOID DUPLICATIONS

    final request = await http.get(Uri.parse(url));

    if (request.statusCode == 200) {
      return ApiResponse(success: true, data: json.decode(request.body));
    } else {
      return ApiResponse(success: false, data: null);
    }
  }

  static Future<ApiResponse> getCategoryProducts(
      {required String slug, required int pageNo}) async {
    String url =
        '$_categoryProductsUrl$slug?limit=$_limit&skip=${_limit * pageNo}';

    final request = await http.get(Uri.parse(url));

    if (request.statusCode == 200) {
      return ApiResponse(success: true, data: json.decode(request.body));
    } else {
      return ApiResponse(success: false, data: null);
    }
  }

  static Future<ApiResponse> getSearchedProducts(
      {required String keyword, required int pageNo}) async {
    String url =
        '$_searchProductsUrl?q=$keyword&limit=$_limit&skip=${_limit * pageNo}';

    final request = await http.get(Uri.parse(url));

    if (request.statusCode == 200) {
      return ApiResponse(success: true, data: json.decode(request.body));
    } else {
      return ApiResponse(success: false, data: null);
    }
  }
}
