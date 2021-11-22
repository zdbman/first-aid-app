// import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

import 'package:first_aid_app/aed.dart';
import 'package:first_aid_app/answer.dart';
import 'package:first_aid_app/choke.dart';
import 'package:first_aid_app/command/call_dialog.dart';
import 'package:first_aid_app/cpr.dart';
import 'package:first_aid_app/webview_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:url_launcher/url_launcher.dart';
import '../number.dart';
import '../question.dart';

class VoiceCommand {
  /// call-name
  static void call(
      {required BuildContext context,
      required String text,
      bool isSimulator = false}) {
    String result = text.substring(4, text.length).trim();
    if (result.isEmpty) return;
    String matchText = text.toLowerCase();
    List numbers = test();
    Number? _item;
    int _count = 0;
    for (Number item in numbers) {
      String name = item.Name.toString().toLowerCase();
      List words = name.split(" ");
      if (name == matchText) {
        _item = item;
        _count = 999;
        break;
      }
      int count = _matchCount(matchText: matchText, words: words);
      if (count > 0 && count > _count) {
        _count = count;
        _item = item;
      }
    }
    if (_item != null) {
      String number = _item.Num.toString()
          .replaceAll(" ", "")
          .replaceAll("-", ""); //set the number here
      if (isSimulator) {
        CallDialog.show(
          context: context,
          title: "Simulator call dialog",
          content: number,
          cancelText: "OK",
        );
      } else {
        FlutterPhoneDirectCaller.callNumber(number).then((value) => null);
      }
    }
  }

  static _matchCount({required String matchText, required List words}) {
    int count = 0;
    for (var word in words) {
      if (matchText.contains(word)) {
        count++;
      }
    }
    return count;
  }

  static void jump({required BuildContext context, required String text}) {
    String matchText = text.toLowerCase();
    if (matchText.contains("cpr") || matchText.contains("cpr instruction")) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => cprPage()),
      );
      return;
    }
    if (matchText.contains("aed") || matchText.contains("aed instruction")) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => aedPage()),
      );
      return;
    }
    if (matchText.contains("choking") || matchText.contains("stop choking")) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => chokePage()),
      );
      return;
    }
    if (matchText.contains("911") || matchText.contains("ambulance")) {
      launch("tel:911");
      print("911");
      return;
    }
    if (matchText.contains("poison control") ||
        matchText.contains("bleach") ||
        matchText.contains("windex") ||
        matchText.contains("drank") ||
        matchText.contains("drink")) {
      launch("tel:18002221222");
      print("poison control");
      return;
    }
  }

  static void showChorking({required BuildContext context}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const WebViewPage(
          url: "https://www.google.com/search?q=chorking",
        ),
      ),
    );
  }

  static void showAnswer({required BuildContext context, required String kw}) {
    Question? question = _queryQuestionByKeywords(kw: kw);
    if (question != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AnswerPage(question: question),
        ),
      );
      return;
    }
  }

  static Question? _queryQuestionByKeywords({required String kw}) {
    kw = kw.toLowerCase();
    if (kw.contains("crisis")) {
      return Question(
        title: "How to do emergency treatment after a crisis?",
        answers: [
          Answer(type: 0, value: '''
When a wrist fractures, there are a few principles to keep in mind：
1.Raise and fix the affected limb. Only good fixation can reduce the occurrence of swelling. If it happens at home, you can use books or boards for temporary fixation; if you are in the wild, you can find some hard materials such as branches and bark to fix your wrists. 
        '''),
          Answer(type: 0, value: '''
2.Bandage the wound and stop bleeding. If it is an open wrist fracture and bone exposure occurs, the wound must be bandaged as soon as possible to stop bleeding. When a fracture damages the blood vessel and simple bandaging cannot effectively stop the bleeding, ligation can be done at the proximal end of the arm. However, the ligation time should not be too long to avoid ischemic necrosis of the distal limbs. In addition, for open fractures, do not arbitrarily apply back the exposed fracture ends, which will aggravate local infections. 
        '''),
          Answer(type: 1, value: "1_02.png"),
          Answer(
              type: 0,
              value:
                  "\"Crisis.\" Ppfocus.com, 5 Sept. 2020, ppfocus.com/0/he4c4878e.html. "),
          Answer(type: 0, value: '''
3.Seek medical treatment in time to reduce complications. Regardless of the fixation, the fracture victims must go to the hospital for medical treatment in time, so as to effectively reduce the chance of later complications.
        '''),
        ],
      );
    }
    if (kw.contains("fever")) {
      return Question(title: "What to do if you have a fever？", answers: [
        Answer(type: 0, value: '''
1. If you have a low-grade fever, you must first drink plenty of water. Drinking boiled water is the best. Use a large cup to pour water until you can't drink it. If you go to the toilet a few more times, the physical virus will have been excreted from your body. You can monitor your body temperature with the Ikai'er ear thermometer.

2. Then you can cook ginger in syrup at home, slice or chop the ginger and boil it with brown sugar, drink it while it is hot, and then sweat when you sleep. This method is not effective when the fever is not serious at first.

3. You can also use the physical cooling method, pour warm water, take a towel soaked in warm water, and wipe the body, especially the forehead, underarms, palms and soles.

4. If the fever is less than 38.5 degrees, but the fever has been for a while, you can go to the hospital to see what caused it, and then take the medicine prescribed by the hospital. Generally, colds are divided into wind-cold and wind-heat. You can take different cold medicines. If it is caused by inflammation, you can also take some antibiotics. This depends on the judgment of the doctor. After the cold and inflammation are cured, the fever will naturally go away.

5. If you develop a fever above 38.5 degrees, you must take anti-fever medicine or go to the hospital for an anti-fever injection.

6. If the fever is not very serious, you can try it at home. If it is serious, you must seek medical treatment in time. Cooling in the room has a good effect on cooling down the fever. For example, wipe the body with warm water to relieve the high temperature. , I hope you can recover soon.
      ''')
      ]);
    }
    if (kw.contains("bleeding") ||
        kw.contains("stop bleeding") ||
        kw.contains("blood")) {
      return Question(
        title: "How to quickly stop bleeding?",
        answers: [
          Answer(type: 0, value: '''
1. Use a tourniquet to stop bleeding. If there is no tourniquet around, you can use wires, cloth strips, ropes, rubber bands, etc. to bind the bleeding.

2. The bleeding can be stopped by pressing, wrapping and other methods.
          '''),
          Answer(type: 1, value: '3_01.png'),
          Answer(
              type: 0,
              value:
                  "“Bleeding.” Health.ifeng.com, 20 Nov. 2018, health.ifeng.com/c/7hz6NzRSl84."),
          Answer(type: 0, value: '''
    One pressure: When you see bleeding from the wound, immediately press the bleeding area with your hand. This is the compression hemostasis method. The compression hemostasis method is divided into two types. One is the direct compression of the wound. Whether it is directly pressed on the bleeding area with clean gauze or other cloth items, the bleeding can be effectively stopped. The other is the acupressure hemostasis method, which uses fingers to press on the adjacent bones at the proximal end of the bleeding artery to block the source of blood supply to achieve the purpose of hemostasis. When looking for the compression point, use the index finger or ring finger instead of the thumb, because there is a large artery in the center of the thumb, which can easily cause misjudgment. When the compression point of the artery is found, change the thumb to press or press several fingers at the same time.

    Second pack: No matter what kind of bleeding, it must be solved by bandaging. The material used for dressing is gauze, bandage, elastic bandage or clean cotton cloth or pad made of cotton fabric. The principle of dressing is to cover first and then wrap, with moderate intensity. Cover the wound first, then cover the wound with a dressing (cotton liner large enough and thick enough), and then wrap it with a bandage or triangle. Check the tightness after the dressing is completed. Only moderate dressing is effective for hemostasis.
'''),
        ],
      );
    }
    if (kw.contains("bitten by a snake") ||
        kw.contains("bitten") ||
        kw.contains("snake")) {
      return Question(
        title: "What should I do if I am bitten by a snake?",
        answers: [
          Answer(type: 1, value: "4_01.png"),
          Answer(
              type: 0,
              value:
                  "\"Snakebite.\" Bilibili, October 1, 2021, www.bilibili.com/read/cv13413078. "),
          Answer(type: 0, value: '''
The sooner the tying is done, the better. You can use rope or tear the clothes into strips. The wound (the circled point) and the tying part are shown in the figure. The ligation is to the degree that arterial blood can pass, but venous blood cannot return. In other words, when tying, the distal end can feel the pulsation of the artery. This tightness is similar to the tightness of the rubber tube when we usually take blood tests in the hospital. Loosen the tie for 3 minutes every half an hour to 1 hour. It can be released after effective treatment.
        '''),
          Answer(type: 1, value: "4_02.png"),
          Answer(
              type: 0,
              value:
                  "\"Snakebite.\" Bilibili, October 1, 2021, www.bilibili.com/read/cv13413078. "),
        ],
      );
    }
    if (kw.contains("nose bleed") ||
        kw.contains("nose") ||
        kw.contains("nose is bleeding")) {
      return Question(
        title: "What is the most reasonable way to stop a nosebleed?",
        answers: [
          Answer(type: 1, value: "5_01.png"),
          Answer(
              type: 0,
              value:
                  "“Noseblled.” 81.cn, 5 June 2017, www.81.cn/zghjy/2017-06/05/content_7628098.htm."),
          Answer(type: 0, value: '''
1.Lean forward and press the nose
When nosebleeds, remember to take a sitting or semi-recumbent position, tilt your head forward about 30°, and use your fingers to pinch the sides of your nose tightly, you can breathe with your mouth, if there is blood flowing into your mouth, spit it out in time .
Generally, about 5 minutes of compression, the bleeding can be stopped.
Notice! It is the cartilage part of the nose that is pinched, not the hard bone part.

2.Cold compress to stop bleeding
Cold compress can promote vasoconstriction, reduce local vascular congestion, so as to achieve hemostatic effect. You can apply cold compresses to the forehead, base of the nose, and neck. The material can be ice cubes, ice packs or popsicles, but pay attention to prevent frostbite. At the same time, you can rinse your mouth with cold water or ice water.

Notice! If this treatment cannot effectively stop the nosebleed and the bleeding still continues, then you should go to the hospital in time to clarify the cause of the bleeding.

If you have repeated nosebleeds, please consult a doctor as soon as possible!
'''),
        ],
      );
    }
    return null;
  }
}

void main(List<String> args) {
  // VoiceCommand.call(text: "call Peoria Emergency");
}
