import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:coin_tracker_challenge/models/coin_model.dart';
import 'package:coin_tracker_challenge/utilities/coin_data.dart';

class PriceScreen extends StatefulWidget {
  const PriceScreen({super.key});

  @override
  State<PriceScreen> createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';
  List<CoinModel> coinsList = [];

  @override
  void initState() {
    super.initState();
    getCoinsValue();
  }

  Future<void> getCoinsValue() async {
    var data = await CoinData().getCoinData(selectedCurrency);

    setState(() {
      coinsList = data;
    });
  }

  CupertinoPicker getCupertinoPicker() {
    return CupertinoPicker(
      itemExtent: 32,
      onSelectedItemChanged: (index) {
        selectedCurrency = currenciesList[index];
        getCoinsValue();
      },
      children: currenciesList.map((e) => Text(e)).toList(),
    );
  }

  DropdownButton<String> getDropdownButton() {
    return DropdownButton<String>(
      value: selectedCurrency,
      isExpanded: true,
      items: currenciesList
          .map((value) => DropdownMenuItem(
        value: value,
        child: Text(value),
      ))
          .toList(),
      onChanged: (value) {
        setState(() {
          selectedCurrency = value!;
        });
        getCoinsValue();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Expanded(
              flex: 5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.currency_bitcoin, size: 80),
                  SizedBox(height: 10),
                  Text("Coin Tracker", style: TextStyle(fontSize: 24)),
                ],
              ),
            ),

            Expanded(
              flex: 6,
              child: coinsList.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.separated(
                itemCount: coinsList.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Image.asset(
                      'images/${coinsList[index].icon}.png',
                      width: 50,
                    ),
                    title: Text(coinsList[index].name),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          NumberFormat("#,###.0")
                              .format(coinsList[index].price),
                        ),
                        Text(selectedCurrency),
                      ],
                    ),
                  );
                },
              ),
            ),

            SizedBox(
              height: kIsWeb ? 60 : 120,
              child: kIsWeb
                  ? getDropdownButton()
                  : getCupertinoPicker(),
            ),
          ],
        ),
      ),
    );
  }
}