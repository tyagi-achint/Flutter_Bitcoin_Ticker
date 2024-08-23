import 'dart:io';
import 'package:bitcoin_ticker/crypto_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'get_exchangeRate.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String _currencyValue = 'USD';
  double _btcRate = 0.0;
  double _ethRate = 0.0;
  double _ltcRate = 0.0;

  @override
  void initState() {
    super.initState();
    updateRate();
  }

  void updateRate() async {
    double btcRate = await getExchangeRate('BTC', _currencyValue);
    double ethRate = await getExchangeRate('ETH', _currencyValue);
    double ltcRate = await getExchangeRate('LTC', _currencyValue);

    setState(() {
      _btcRate = btcRate;
      _ethRate = ethRate;
      _ltcRate = ltcRate;
    });
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
        for (String currency in currenciesList)
          DropdownMenuItem<String>(
            child: Center(child: Text(currency)),
            value: currency,
          ),
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
                cryptoCart('BTC', _currencyValue, _btcRate),
                SizedBox(
                  height: 10,
                ),
                cryptoCart('ETH', _currencyValue, _ethRate),
                SizedBox(
                  height: 10,
                ),
                cryptoCart('LTC', _currencyValue, _ltcRate),
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
