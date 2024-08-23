import '../utilities/api_Key.dart';
import 'package:dio/dio.dart';

import '../utilities/coin_data.dart';

Map<String, String> cryptoPrices = {};

getExchangeRate(String currency) async {
  String rateUrl =
      'https://pro-api.coinmarketcap.com/v1/cryptocurrency/quotes/latest';

  final dio = Dio();

  for (String crypto in cryptoList) {
    final response = await dio.get(
      rateUrl,
      queryParameters: {
        'symbol': crypto,
        'convert': currency,
      },
      options: Options(
        headers: {
          'X-CMC_PRO_API_KEY': CoinMarketCapAPI,
          'Accept': 'application/json',
        },
      ),
    );

    var data = response.data;
    double _rate = data['data'][crypto]['quote'][currency]['price'];
    String formattedRate = _rate.toStringAsFixed(0);
    cryptoPrices[crypto] = formattedRate;
  }

  return cryptoPrices;
}
