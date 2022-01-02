import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class aedPage extends StatelessWidget {
  const aedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AED Instruction"),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: InteractiveViewer(
              //padding: EdgeInsets.all(20.0),
              maxScale: 4,
              child: ListView(
                children: <Widget>[
                  Image(
                    image: AssetImage("Assets/images/aed1.png"),
                    //height: MediaQuery.of(context).size.height / 3,
                    width: MediaQuery.of(context).size.width / 1.2,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 150,
                  ),
                  Image(
                    image: AssetImage("Assets/images/aed2.png"),
                    width: MediaQuery.of(context).size.width / 1.2,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 150,
                  ),
                  Image(
                    image: AssetImage("Assets/images/aed3.png"),
                    width: MediaQuery.of(context).size.width / 1.2,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 150,
                  ),
                  Image(
                    image: AssetImage("Assets/images/aed4.png"),
                    width: MediaQuery.of(context).size.width / 1.2,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 150,
                  ),
                  Image(
                    image: AssetImage("Assets/images/aed5.png"),
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
