import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'GetLocation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String apiKey = '1b750d72d503b025dd33cf05e23768b0';

  var description;
  var temp;
  String city;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: <Widget>[
            Container(
              child: displayImage(), //Image.asset('images/dayTime.jpg'),
            ),
            Container(
              margin: EdgeInsets.only(top: 20.0),
              child: Text(
                'You are in:',
                style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                children: <Widget>[
                  Container(
                    child: Text(
                      city.toString(),
                      style: TextStyle(
                        color: Colors.blue[500],
                        fontWeight: FontWeight.bold,
                        fontSize: 25.0,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Container(
                    child: Icon(
                      Icons.location_on,
                      color: Colors.red[500],
                      size: 35.0,
                    ),
                  )
                ],
              ),
            ),
            Card(
              elevation: 10,
              margin: EdgeInsets.symmetric(vertical: 17.0, horizontal: 25.0),
              color: Colors.white,
              child: ListTile(
                leading: displayIcon(),
                title: Text('Temperature: ${temp.toString()} C'),
                subtitle: Text('Status: ${description.toString()}'),
              ),
            ),
            Container(
                child: Center(
              child: FlatButton(
                child: Text('Get weather info'),
                color: Colors.blue[500],
                textColor: Colors.white,
                onPressed: () {
                  setState(() {
                    getLocation();
                  });
                },
              ),
            ))
          ],
        ),
      ),
    );
  }

  //display images on current time
  displayImage() {
    var now = DateTime.now();
    final currentTime = DateFormat.jm().format(now);

    print(currentTime);

    if (currentTime.contains('AM')) {
      return Image.asset('images/dayTime.jpg');
    } else if (currentTime.contains('PM')) {
      return Image.asset('images/nightTime.jpg');
    }
  }

  displayIcon() {
    var now = DateTime.now();
    final currentTime = DateFormat.jm().format(now);

    if (currentTime.contains('AM')) {
      return Icon(Icons.wb_sunny, color: Colors.amber);
    } else if (currentTime.contains('PM')) {
      return Icon(Icons.nightlight_round, color: Colors.black);
    }
  }

  //GetLocation
  void getLocation() async {
    Getlocation getlocation = Getlocation();
    await getlocation.getCurrentLocation();

    //print(getlocation.latitude);
    //print(getlocation.longitude);
    //print(getlocation.city);

    city = getlocation.city;

    getTemp(getlocation.latitude, getlocation.longitude);
  }

  //get current temp
  Future<void> getTemp(double lat, double lon) async {
    http.Response response = await http.get(
        'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric');
    //print(response.body);

    var dataDecoded = jsonDecode(response.body);
    description = dataDecoded['weather'][0]['description'];
    temp = dataDecoded['main']['temp'];
  }
}
