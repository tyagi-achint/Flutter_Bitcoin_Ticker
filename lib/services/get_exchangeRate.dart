import '../utilities/api_Key.dart';
import 'package:dio/dio.dart';

getExchangeRate(String crypto, String currency) async {
  String rateUrl =
      'https://pro-api.coinmarketcap.com/v1/cryptocurrency/quotes/latest';

  final dio = Dio();

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
  String formattedRate = _rate.toStringAsFixed(1);
  double rate = double.parse(formattedRate);

  return rate;
}
