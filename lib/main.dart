import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'Currency.dart';

const request_url = "https://api.hgbrasil.com/finance?format=json&key=9a332fc0";

void main() async {
  List<Currency> currency = await getData();

  runApp(MaterialApp(
      home: Home(),
      theme: ThemeData(hintColor: Colors.amber, primaryColor: Colors.white)));
}

Future<List<Currency>> getData() async {
  http.Response response = await http.get(request_url);
  Currency currency_usd = Currency.fromJson(
      json.decode(response.body)["results"]["currencies"]["USD"]);

  Currency currency_euro = Currency.fromJson(
      json.decode(response.body)["results"]["currencies"]["EUR"]);

  return [currency_usd, currency_euro];
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final RealController = TextEditingController();
  final DolarController = TextEditingController();
  final EuroController = TextEditingController();

  double dolar;
  double euro;

  void _clearAll(){
    RealController.text = "";
    DolarController.text = "";
    EuroController.text  ="";
  }
  void _realChangedText(String text){

    if(text.isEmpty) {
      _clearAll();
      return;
    }

    double real = double.parse(text);
    DolarController.text = (real/ dolar).toStringAsFixed(2);
    EuroController.text = (real/euro).toStringAsFixed(2);

  }


  void _dolarChangedText(String text){

    if(text.isEmpty) {
      _clearAll();
      return;
    }
     double _dolar = double.parse(text);
     RealController.text = (dolar * _dolar).toStringAsFixed(2);
     EuroController.text = (dolar * _dolar / euro).toStringAsFixed(2);

  }


  void _euroChangedText(String text){

    if(text.isEmpty) {
      _clearAll();
      return;
    }
    double _euro = double.parse(text);
    RealController.text = (euro * _euro).toStringAsFixed(2);
    DolarController.text = (euro * _euro / dolar).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Conversor de Moedas"),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: FutureBuilder<List<Currency>>(
          future: getData(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                    child: Text(
                  "Loading...",
                  style: TextStyle(color: Colors.amber, fontSize: 25.0),
                  textAlign: TextAlign.center,
                ));
              default:
                if (snapshot.hasError) {
                  return Center(
                      child: Text(
                    "Erro ao carregar dados :(",
                    style: TextStyle(color: Colors.amber, fontSize: 25.0),
                    textAlign: TextAlign.center,
                  ));
                } else {
                  dolar = snapshot.data[0].price;
                  euro = snapshot.data[1].price;

                  print(dolar);
                  print(euro);
                  return SingleChildScrollView(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Icon(Icons.monetization_on,
                            size: 150.0, color: Colors.amber),
                        buildTextField("Reais", "R\$", RealController, _realChangedText),
                        Divider(),
                        buildTextField("Dolar", "\$", DolarController, _dolarChangedText),
                        Divider(),
                        buildTextField("Euros", "€", EuroController, _euroChangedText)

                      ],
                    ),
                  );
                }
            }
          }),
    );
  }
}

Widget buildTextField(String Label, String Prefix, TextEditingController textEdit, Function fn){
  return    TextField(
    controller: textEdit,
    decoration: InputDecoration(
        labelText: Label,
        labelStyle: TextStyle(color: Colors.amber),
        border: OutlineInputBorder(),
        prefixText: Prefix),
    style: TextStyle(color: Colors.amber, fontSize: 25.9),
    onChanged: fn,
    keyboardType: TextInputType.numberWithOptions(decimal: true),
  );

}