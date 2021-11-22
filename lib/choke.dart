import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class chokePage extends StatelessWidget {
  const chokePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Stop Choking"),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: InteractiveViewer(
              //padding: EdgeInsets.all(20.0),
              child: ListView(
                children: <Widget>[
                  Image(
                    image: AssetImage("Assets/images/choke1.png"),
                    width: MediaQuery.of(context).size.width / 1.2,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 150,
                  ),
                  Image(
                    image: AssetImage("Assets/images/choke2.png"),
                    width: MediaQuery.of(context).size.width / 1.2,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 150,
                  ),
                  Image(
                    image: AssetImage("Assets/images/choke3.png"),
                    width: MediaQuery.of(context).size.width / 1.2,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 150,
                  ),
                  Image(
                    image: AssetImage("Assets/images/choke4.png"),
                    width: MediaQuery.of(context).size.width / 1.2,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
