import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:convert';

void main()=>runApp(MyHomePage());



class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  var location = "San Fransisco";
  String temp;
  var woeid = 2487956;
  var weather = "w4";
  String abbreviation = "";
  String errormsg = '';
  var min_temp;
  var max_temp;
  var humidity;
  var wind_speed;

  String searchApiUrl = "https://www.metaweather.com/api/location/search/?query=";
  String locationsearchUrl = "https://www.metaweather.com/api/location/";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchlocation(woeid);
  }

  void searchwoeid(String input) async{
    try {
      var searchResult = await http.get(searchApiUrl + input);
      var result = json.decode(searchResult.body)[0];

      setState(() {
        location = result["title"];
        woeid = result["woeid"];
        errormsg = '';
      });
    }catch(error){
      setState(() {
        errormsg = "We don't have data about this location,Sorry";
        print(errormsg);
      });
    }

  }

  void fetchlocation(int woeid) async {
    var locationResult = await http.get(locationsearchUrl+woeid.toString());
    var result = json.decode(locationResult.body);

    setState(() {
      var t = result['consolidated_weather'][0]['the_temp'].round();
      this.temp = t.toString();
      this.weather = result['consolidated_weather'][0]['weather_state_name'].replaceAll(' ','').toLowerCase();
      this.abbreviation = result['consolidated_weather'][0]['weather_state_abbr'];
      this.min_temp = result['consolidated_weather'][0]['min_temp'].round();
      this.max_temp = result['consolidated_weather'][0]['max_temp'].round();
      this.wind_speed = result['consolidated_weather'][0]['wind_speed'].round();
      this.humidity = result['consolidated_weather'][0]['humidity'].round();
    });

  }

  void onTextFieldSubmitted(String input) async{
   await searchwoeid(input);
   await fetchlocation(woeid);
  }

  Widget description_box(){
    return Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(205,212,228,0.3),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                Text("\t\t\t\t\t"),
                FaIcon(FontAwesomeIcons.temperatureLow,
                  color: Colors.red,
                ),
                Text("\t\t\t\t\t\tMin Temperature\t\t\t\t\t\t",
                  style: TextStyle(color: Colors.white,fontSize: 24.0,fontWeight: FontWeight.bold),
                ),
                Text("\t\t\t\t"+min_temp.toString()+"\u2103",
                  style: TextStyle(color: Colors.white,fontSize: 24.0,fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                Text("\t\t\t\t\t"),
                FaIcon(FontAwesomeIcons.temperatureHigh,
                  color: Colors.red,
                ),
                Text("\t\t\t\t\t\tMax Temperature\t\t\t\t\t\t",
                  style: TextStyle(color: Colors.white,fontSize: 24.0,fontWeight: FontWeight.bold),
                ),
                Text("\t\t\t"+max_temp.toString()+"\u2103",
                  style: TextStyle(color: Colors.white,fontSize: 24.0,fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                Text("\t\t\t\t\t"),
                FaIcon(FontAwesomeIcons.wind,
                  color: Colors.white,
                ),
                Text("\t\t\t\t\t\tWind Speed\t\t\t\t\t\t\t\t\t\t\t\t\t",
                  style: TextStyle(color: Colors.white,fontSize: 24.0,fontWeight: FontWeight.bold),
                ),
                Text("\t\t\t\t\t\t\t"+wind_speed.toString(),
                  style: TextStyle(color: Colors.white,fontSize: 24.0,fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                Text("\t\t\t\t\t"),
                FaIcon(FontAwesomeIcons.sun,
                  color: Colors.yellow,
                ),
                Text("\t\t\t\t\t\tHumidity\t\t\t\t\t\t\t\t\t\t\t\t\t",
                  style: TextStyle(color: Colors.white,fontSize: 24.0,fontWeight: FontWeight.bold),
                ),
                Text("\t\t\t\t\t\t\t\t\t\t\t\t\t"+humidity.toString(),
                  style: TextStyle(color: Colors.white,fontSize: 24.0,fontWeight: FontWeight.bold),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/$weather.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.6), BlendMode.dstATop),
          )
        ),
        child: temp == null? Center(child: CircularProgressIndicator(),): Scaffold(
           resizeToAvoidBottomInset: false,
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              centerTitle: true,
              title: Text("Weather App",
              style: TextStyle(color: Colors.white,fontSize: 30),),
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(45.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(left: 12.0,bottom: 8.0,right: 12.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                        child: TextField(
                          onSubmitted: (String input){
                             onTextFieldSubmitted(input);
                          },
                          style: TextStyle(color: Colors.black,fontSize: 20),
                          decoration: InputDecoration(
                            hintText: "Enter Location",
                            contentPadding: const EdgeInsets.only(left: 24.0),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
              backgroundColor: Colors.transparent,

            ),
            body: Column(
              children: [
                Text(
                    location,
                    style: TextStyle(color: Colors.white,fontSize: 25.0,),

                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Image.network('https://www.metaweather.com/static/img/weather/png/'+abbreviation+'.png',
                        width: 100,
                      ),
                    ),

                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        temp+"\u2103",
                        style: TextStyle(color: Colors.white,fontSize: 80.0,),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Text(
                        weather,
                        style: TextStyle(color: Colors.white,fontSize: 25.0,),
                      ),
                    ),
                  ],
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      Text(
                        errormsg,
                        style: TextStyle(color: Colors.redAccent,fontSize: 25.0,fontWeight: FontWeight.bold),
                      ),
                      description_box(),
                    ],
                  ),
                )
              ],
            ) ,
            )
          ),
    );
  }
}



