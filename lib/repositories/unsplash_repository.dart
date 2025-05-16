import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants/app_constants.dart';
import '../models/photo_model.dart';

class UnsplashRepository {
  final _baseUrl = AppConstants.unsplashBaseUrl;
  final _accessKey = AppConstants.unsplashAccessKey;

  Future<List<PhotoModel>> fetchPhotos(int page, int perPage) async {
    final response = await http.get(Uri.parse(
        '$_baseUrl/photos?page=$page&per_page=$perPage&client_id=$_accessKey'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map<PhotoModel>((json) => PhotoModel.fromJson(json)).toList();
    } else {
      throw Exception('Erreur lors du chargement des photos');
    }
  }
}
