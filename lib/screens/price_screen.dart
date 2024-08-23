import 'dart:io';
import 'package:bitcoin_ticker/services/crypto_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../utilities/coin_data.dart';
import '../services/get_exchangeRate.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String _currencyValue = 'USD';
  Map<String, String> _rates = {};
  bool _isWaiting = true;

  @override
  void initState() {
    super.initState();
    updateRate();
  }

  void updateRate() async {
    setState(() {
      _isWaiting = true;
    });

    try {
      Map<String, String> _currentRates = await getExchangeRate(_currencyValue);

      setState(() {
        _rates = _currentRates;
        _isWaiting = false;
      });
    } catch (e) {
    
      print('Error fetching exchange rates: $e');
      setState(() {
        _isWaiting = false;
      });
    }
  }

  DropdownButton<String> androidDropdownButton() {
    return DropdownButton<String>(
      value: _currencyValue,
      items: [
        for (String currency in currenciesList)
          DropdownMenuItem<String>(
            child: Text(currency),
            value: currency,
          ),
      ],
      onChanged: (value) {
        setState(
          () {
            _currencyValue = value!;
            updateRate();
          },
        );
      },
    );
  }

  CupertinoPicker iosDropdownButton() {
    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32,
      onSelectedItemChanged: (selectedIndex) {
        setState(
          () {
            _currencyValue = currenciesList[selectedIndex];
            updateRate();
          },
        );
      },
      children: [
        for (String currency in currenciesList) Center(child: Text(currency)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Column(
              children: [
                for (String crypto in cryptoList)
                  cryptoCart(
                    crypto,
                    _currencyValue,
                    _isWaiting ? '?' : _rates[crypto]!,
                    _isWaiting,
                  ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child:
                Platform.isIOS ? iosDropdownButton() : androidDropdownButton(),
          ),
        ],
      ),
    );
  }
}
