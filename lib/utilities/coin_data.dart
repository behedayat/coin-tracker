import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/coin_model.dart';

const List<String> currenciesList = [
  'AUD','BRL','CAD','CNY','EUR','GBP','HKD','IDR',
  'ILS','INR','JPY','MXN','NOK','NZD','PLN','RON',
  'RUB','SEK','SGD','USD','ZAR'
];

const List<Map<String, String>> cryptoList = [
  {'id': 'bitcoin', 'name': 'Bitcoin', 'icon': 'btc'},
  {'id': 'ethereum', 'name': 'Ethereum', 'icon': 'eth'},
  {'id': 'litecoin', 'name': 'Litecoin', 'icon': 'ltc'},
];

class CoinData {
  Future<List<CoinModel>> getCoinData(String currency) async {
    List<CoinModel> cryptoPrices = [];

    for (var crypto in cryptoList) {
      try {
        String id = crypto['id']!;

        String url =
            'https://api.coingecko.com/api/v3/simple/price?ids=$id&vs_currencies=${currency.toLowerCase()}';

        http.Response response = await http.get(Uri.parse(url));

        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);

          double price =
          data[id][currency.toLowerCase()].toDouble();

          cryptoPrices.add(
            CoinModel(
              icon: crypto['icon']!,
              name: crypto['name']!,
              price: price,
            ),
          );
        } else {
          print("HTTP Error: ${response.statusCode}");
        }
      } catch (e) {
        print("Exception: $e");
      }
    }

    return cryptoPrices;
  }
}