import 'package:first_aid_app/question.dart';
import 'package:flutter/material.dart';

class AnswerPage extends StatelessWidget {
  final Question question;
  const AnswerPage({Key? key, required this.question}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          question.title ?? "",
          maxLines: 2,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: question.answers.length,
        itemBuilder: (context, index) {
          Answer item = question.answers[index];
          if (item.type == 0) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                item.value ?? "",
                style: TextStyle(
                  fontSize: 16,
                  height: 1.8,
                ),
              ),
            );
          }
          if (item.type == 1) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.centerLeft,
              child: Image.asset(
                "Assets/images/" + (item.value ?? ""),
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}
