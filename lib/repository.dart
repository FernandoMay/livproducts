import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:livproducts/domain.dart';

class ProductRepository {
  Future<List<Record>> getProducts(String searchTerm,
      {String sortOption = 'Relevancia|0'}) async {
    final url =
        'https://shopappst.liverpool.com.mx/appclienteservices/services/v6/plp/sf?page-number=1&search-string=$searchTerm&sort-option=$sortOption&force-plp=false&number-of-items-per-page=40&cleanProductName=false';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final jsonMap = json.decode(response.body);
      final productsJson = jsonMap['plpResults']['records'];
      List<Record> products = [];
      for (var productData in productsJson) {
        final product = Record.fromJson(productData);
        products.add(product);
      }
      return products;
      // return productsJson
      //     .map<Record>((productJson) => Record.fromJson(productJson))
      //     .toList();
    } else {
      throw Exception('Failed to load products');
    }
  }
}
