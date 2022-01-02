class Question {
  String? title;
  List<Answer> answers;
  Question({this.title, this.answers = const []});
}

class Answer {
  int? type;
  String? value;
  Answer({this.type, this.value});
}
