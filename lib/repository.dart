import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:livproducts/domain.dart';

class ProductRepository {
  Future<List<Record>> getProducts(String searchTerm,
      {String sortOption = 'Relevancia|0'}) async {
    const baseUrl = 'shopappst.liverpool.com.mx';

    final response = await http.get(
      Uri.https(baseUrl,
          '/appclienteservices/services/v6/plp/sf?page-number=1&search-string=$searchTerm&sort-option=$sortOption&force-plp=false&number-of-items-per-page=40&cleanProductName=false'),
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Methods": "GET, POST, OPTIONS",
        "Access-Control-Allow-Headers": "*",
        "Access-Control-Allow-Credentials": "true",
        "Content-Type": "application/json",
        "Accept": "*/*",
      },
    );
    if (response.statusCode == 200) {
      final jsonMap = json.decode(response.body);
      final productsJson = jsonMap['plpResults']['records'];
      return productsJson
          .map<Record>((productJson) => Record.fromJson(productJson))
          .toList();
    } else {
      throw Exception('Failed to load products');
    }
  }
}
