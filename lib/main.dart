import 'dart:io';
import 'dart:math';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:first_aid_app/choke.dart';
import 'package:first_aid_app/command/voice_command.dart';
import 'package:flutter_speech/flutter_speech.dart';
import 'package:first_aid_app/emergency_list.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
//import 'dart:convert';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'cpr.dart';
import 'aed.dart';
import 'number.dart';
import 'emergency_list.dart';

void main() => runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "First Aid App",
        home: Home(),
      ),
    );

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

/*class Number {
  var City;
  var ZipCode;
  var name;
  var phone;

  Number({this.City, this.ZipCode, this.name, this.phone});
}*/

class _HomeState extends State<Home> {
  /*void getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);
    print(position);
  }*/

  bool _speechRecognitionAvailable = false;
  late SpeechRecognition _speech;
  bool _isListening = false;
  String transcription = '';

  DeviceInfoPlugin plugin = DeviceInfoPlugin();
  bool isSimulator = false;

  var lat;
  var long;
  var zip;
  var loc;
  var theNum;
  List temp = [];

  Future getZipCode() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);
    List<Placemark> placemark =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    this.lat = (position.latitude).toString();
    this.long = (position.longitude).toString();
    this.zip = (placemark[0].postalCode).toString();
    this.loc = (placemark[0].locality).toString();

    double lat1 = double.parse(lat);
    double long1 = double.parse(long);
    print(position);
    print(placemark[0].postalCode);
    print(placemark[0].locality);
    //print(lat1);

    var num;
    for (int i = 0; i < test().length; i++) {
      var pos = (Geolocator.distanceBetween(
            lat1,
            long1,
            test()[i].Lat,
            test()[i].Long,
          ) *
          0.00062137);
      this.temp += [pos];
    }
    //print(temp);
    var min = temp[0];
    var place;
    for (int i = 0; i < temp.length; i++) {
      if (min > temp[i]) {
        min = temp[i];
        this.theNum = test()[i].Num;
        place = test()[i].Name;
      }
    }
    print(temp);
    print(theNum);
    print(place);
  }

  void customLaunch(command) async {
    if (await canLaunch(command)) {
      await launch(command);
    } else {
      print("Could not call $command");
    }
  }

  @override
  void initState() {
    super.initState();
    DeviceInfoPlugin().iosInfo.then((v) {
      isSimulator = (v.isPhysicalDevice == false);
    });
    //this.getLocation();
    activateSpeechRecognizer();
    this.getZipCode();
    //this.getNumber('85374');
  }

  void activateSpeechRecognizer() {
    print('_MyAppState.activateSpeechRecognizer... ');
    _speech = SpeechRecognition();
    _speech.setAvailabilityHandler(onSpeechAvailability);
    _speech.setRecognitionStartedHandler(onRecognitionStarted);
    _speech.setRecognitionResultHandler(onRecognitionResult);
    _speech.setRecognitionCompleteHandler(onRecognitionComplete);
    _speech.setErrorHandler(errorHandler);
    _speech.activate('en_US').then((res) {
      setState(() => _speechRecognitionAvailable = res);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height / 3.5,
            width: MediaQuery.of(context).size.width,
            color: Colors.blueAccent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Stay Calm",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 0.0),
                  child: Text(
                    "We're Here To Help",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height / 40),
          MaterialButton(
            height: 75,
            minWidth: MediaQuery.of(context).size.width / 1.1,
            //color: Theme.of(context).primaryColor,
            color: Colors.grey,
            textColor: Colors.white,
            child: new Text(
              "CPR Instruction",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            onPressed: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => cprPage()),
              ),
              print('CPR Instructions'),
            },
          ),
          SizedBox(height: MediaQuery.of(context).size.height / 40),
          MaterialButton(
            height: 75,
            minWidth: MediaQuery.of(context).size.width / 1.1,
            color: Colors.green,
            textColor: Colors.white,
            child: new Text(
              "AED Instruction",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            onPressed: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => aedPage()),
              ),
              print('AED Instructions'),
            },
          ),
          SizedBox(height: MediaQuery.of(context).size.height / 40),
          MaterialButton(
            height: 75,
            minWidth: MediaQuery.of(context).size.width / 1.1,
            //color: Theme.of(context).primaryColor,
            color: Colors.orange,
            textColor: Colors.white,
            child: new Text(
              "Stop Choking",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            onPressed: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => chokePage()),
              ),
              print('Choking Guidelines'),
            },
          ),
          SizedBox(height: MediaQuery.of(context).size.height / 40),
          /*RaisedButton(
            padding: EdgeInsets.symmetric(
              //horizontal: MediaQuery.of(context).size.width / 2.77,
              horizontal: 90,
              vertical: MediaQuery.of(context).size.height / 30,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => emergencyPage()),
              );
              print('Nearby Emergency Services');
            },
            color: Colors.blue,
            child: Text("Nearby Emergency Services"),
          ),*/
          MaterialButton(
            height: 75,
            minWidth: MediaQuery.of(context).size.width / 1.1,
            //color: Theme.of(context).primaryColor,
            color: Colors.blue,
            textColor: Colors.white,
            child: new Text(
              "Arizona Emergency Services",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            onPressed: () => {
              //sleep(Duration(seconds: 2)),
              if (lat != null && long != null)
                {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => emergencyPage(
                              lat: lat,
                              long: long,
                              lst: temp,
                            )),
                  ),
                },
              print('Nearby Emergency Services'),
            },
          ),
          /*Expanded(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: ListView(
                children: <Widget>[
                  ListTile(
                    leading: FaIcon(FontAwesomeIcons.thermometerHalf),
                    title: Text("Temperature"),
                    trailing: Text(temperature != null
                        ? temperature.toString() + "\u2109"
                        : "..."),
                  ),
                  ListTile(
                    leading: FaIcon(FontAwesomeIcons.cloud),
                    title: Text("Weather"),
                    trailing: Text(
                        description != null ? description.toString() : "..."),
                  ),
                  ListTile(
                    leading: FaIcon(FontAwesomeIcons.sun),
                    title: Text("Humidity"),
                    trailing:
                        Text(humidity != null ? humidity.toString() : "..."),
                  ),
                  ListTile(
                    leading: FaIcon(FontAwesomeIcons.wind),
                    title: Text("Wind Speed"),
                    trailing:
                        Text(windSpeed != null ? windSpeed.toString() : "..."),
                  ),
                ],
              ),
            ),
          ),*/
          SizedBox(
            height: MediaQuery.of(context).size.height / 30,
          ),
          FloatingActionButton(
            onPressed: _speechRecognitionAvailable && !_isListening
                ? () => start()
                : null,
            child: _isListening
                ? Stack(
                    alignment: Alignment.center,
                    children: const [
                      FaIcon(FontAwesomeIcons.microphoneAlt),
                      CircularProgressIndicator(
                        strokeWidth: 2.0,
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                    ],
                  )
                : FaIcon(FontAwesomeIcons.microphone),
            /*onPressed: () async {
              /*customLaunch("tel:2036045406"); //it works
              getZipCode();
              List i = test();*/
              //print(i[1].ZipCode);
              //print(lat + long + zip + loc);

            },
            child: FaIcon(FontAwesomeIcons.microphone),*/
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                text: "\nNeed Local Emergency Service?\nCall: ",
              ),
              TextSpan(
                style: TextStyle(
                  color: Colors.lightBlue,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    customLaunch("tel:" + theNum);
                  },
                text: theNum != null
                    ? "(" +
                        theNum.toString().substring(0, 3) +
                        ") " +
                        theNum.toString().substring(3, 6) +
                        "-" +
                        theNum.toString().substring(6, 10)
                    : "Local Service",
              ),
              TextSpan(
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                text: " or ",
              ),
              TextSpan(
                style: TextStyle(
                  color: Colors.lightBlue,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                text: "911",
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    customLaunch("tel:911");
                  },
              ),
            ],
          ),
        ),
        /*child: Text(
          "\nNeed Local Emergency Service:\nDial: ___-___-____ or 911\n",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),*/
      ),
    );
  }

  void start() => _speech.activate("en_US").then((_) {
        return _speech.listen().then((result) {
          print('_MyAppState.start => result $result');
          setState(() {
            _isListening = result;
          });
        });
      });

  void cancel() =>
      _speech.cancel().then((_) => setState(() => _isListening = false));

  void stop() => _speech.stop().then((_) {
        setState(() => _isListening = false);
      });

  void onSpeechAvailability(bool result) =>
      setState(() => _speechRecognitionAvailable = result);

  // void onCurrentLocale(String locale) {
  //   print('_MyAppState.onCurrentLocale... $locale');
  //   setState(
  //       () => selectedLang = languages.firstWhere((l) => l.code == locale));
  // }

  void onRecognitionStarted() {
    setState(() => _isListening = true);
  }

  void onRecognitionResult(String text) {
    print('_MyAppState.onRecognitionResult... $text');
    setState(() => transcription = text);
  }

  void onRecognitionComplete(String text) {
    print('_MyAppState.onRecognitionComplete... $text');
    _speech.stop().then((_) {
      if (_isListening != false) {
        execVoiceCommand();
      }
      setState(() => _isListening = false);
    });
  }

  void execVoiceCommand() {
    String text = transcription;
    // voice command
    if (text.toLowerCase().startsWith("call")) {
      VoiceCommand.call(context: context, text: text, isSimulator: isSimulator);
      return;
    }
    if (text.toLowerCase() == "chorking") {
      VoiceCommand.showChorking(context: context);
      return;
    }
    VoiceCommand.showAnswer(context: context, kw: text);
    VoiceCommand.jump(context: context, text: text);
  }

  void errorHandler() => activateSpeechRecognizer();
}
