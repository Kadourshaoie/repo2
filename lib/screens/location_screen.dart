import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:project_name/models/weather_model.dart';
import 'package:project_name/services/location_service.dart';

class location_screen extends StatefulWidget {
  const location_screen({super.key});

  @override
  State<location_screen> createState() => _location_screenState();
}

class _location_screenState extends State<location_screen> {
  String? data;
  WeatherModel? weatherModel;
  TextStyle style = TextStyle(fontSize: 45, fontWeight: FontWeight.w400);
  void getlocation_weather() async {
    try {
      Position position = await location_service.determinePosition();
      print(
        position.toString(),
      );
      http.Response response = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?lat=${position.latitude}&lon=${position.longitude}&appid=1a012a8f36109bd653cd94a4089e056b'));
      if (response.statusCode == 200) {
        print(
          response.body,
        );

        Map map = jsonDecode(response.body);

        weatherModel = WeatherModel.fromjason(map);

        setState(() {});
      } else {
        throw 'faild to load data';
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Widget GetBody() {
    if (weatherModel == null) {
      return CircularProgressIndicator();
    } else {
      return Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/photo2.jpg"),
                colorFilter:
                    ColorFilter.mode(Colors.white24, BlendMode.srcOver),
                fit: BoxFit.cover)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              children: [
                Text("${weatherModel!.temp?.round() ?? ""}", style: style),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(padding: EdgeInsets.symmetric(vertical: 1)),
                    CircleAvatar(
                      radius: 15,
                    ),
                    Container(
                      margin: EdgeInsets.all(8),
                      height: 5,
                      width: 15,
                      color: const Color.fromARGB(255, 56, 181, 114),
                    ),
                    Text("now",
                        style: style.copyWith(letterSpacing: 10, fontSize: 30))
                  ],
                )
              ],
            ),
            Text("${weatherModel!.description}", style: style),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            getlocation_weather();
          },
          icon: Icon(
            Icons.send,
            size: 50,
          ),
        ),
        actions: [Icon(Icons.location_city)],
      ),
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: Center(child: GetBody()),
      bottomNavigationBar: weatherModel == null
          ? null
          : Padding(
              child: Text(
                '${weatherModel!.locationName}',
                style: style,
              ),
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20)),
    );
  }
}
