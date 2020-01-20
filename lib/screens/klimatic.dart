import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:klima/util/utils.dart' as utils;
import 'dart:convert';

class Klimatic extends StatefulWidget {
  @override
  _KlimaticState createState() => _KlimaticState();
}

class _KlimaticState extends State<Klimatic> {
  String _enterCityName;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text("Klima"),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              _goToNextScreen(context);
            },
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          Center(
            child: Image.asset(
              "images/umbrella.png",
              width: 490,
              height: 1200,
              fit: BoxFit.fill,
            ),
          ),
          Container(
            alignment: Alignment.topRight,
            margin: const EdgeInsets.fromLTRB(0, 10.9, 20.0, 0),
            child: Text(
              "${_enterCityName == null ? utils.defaultCity : _enterCityName}",
              style: cityStyle(),
            ),
          ),
          new Container(
            alignment: Alignment.center,
            child: Image.asset("images/light_rain.png"),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(30, 290.0, 0, 0),
            child: updateTempWidget(_enterCityName),
          )
        ],
      ),
    );
  }

  Future _goToNextScreen(BuildContext context) async {
    Map results = await Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) {
      return new ChangeCity();
    }));
    if (results != null && results.containsKey("enter")) {
      print(results['enter'].toString());
      _enterCityName = results['enter'];
    }
  }

  void showStaff() async {
    Map data = await getWeather(utils.defaultCity, utils.appId);
    print(data.toString());
  }

  Widget updateTempWidget(String city) {
    return FutureBuilder(
      future: getWeather(city == null ? utils.defaultCity : city, utils.appId),
      builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
        if (snapshot.hasData) {
          Map content = snapshot.data;
          return Container(
            child: Column(
              children: <Widget>[
                ListTile(
                  title: Text(
                    content['main']['temp'].toString(),
                    style: TextStyle(
                        fontStyle: FontStyle.normal,
                        fontSize: 49.9,
                        color: Colors.white,
                        fontWeight: FontWeight.w500),
                  ),
                )
              ],
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  Future<Map> getWeather(String city, String appId) async {
    String apiUrl =
        "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$appId";
    Response response = await get(apiUrl);
    return jsonDecode(response.body);
  }
}

class ChangeCity extends StatelessWidget {
  final TextEditingController _cityNameController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text("Change City"),
        centerTitle: true,
      ),
      body: Stack(
        children: <Widget>[
          new Center(
            child: Image.asset(
              'images/white_snow.png',
              width: 490.0,
              height: 1200,
              fit: BoxFit.fill,
            ),
          ),
          ListView(
            children: <Widget>[
              TextField(
                controller: _cityNameController,
                decoration: InputDecoration(
                  hintText: "Enter your city name",
                ),
              ),
              RaisedButton(
                color: Colors.redAccent,
                child: Text(
                  "Change City",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context, {'enter': _cityNameController.text});
                },
              )
            ],
          )
        ],
      ),
    );
  }
}

TextStyle cityStyle() {
  return TextStyle(
    color: Colors.white,
    fontSize: 22.9,
    fontStyle: FontStyle.italic,
  );
}

TextStyle weatherTemp() {
  return TextStyle(
      color: Colors.white,
      fontSize: 49.9,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w500);
}
