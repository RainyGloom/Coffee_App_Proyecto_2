import 'dart:convert';
import 'package:coffee_app/content/question.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_email_sender/flutter_email_sender.dart';
//import 'package:flutter'

class Questionary extends StatefulWidget
{
  const Questionary({super.key});

  @override
  QuestionaryState createState() => QuestionaryState();
}

class QuestionaryState extends State<Questionary>
{
  List<Widget> _body = [];
  List<Question> questions = [];

  Map<String, double> ratings = {};
  

  Future<void> _loadQuestions() async
  {
    final String response = await rootBundle.loadString('assets/saves/questions.json');
    final Map<String, dynamic> data = json.decode(response);

    _body = 
    [
      Column(children: _makeSection('Usabilidad',data['usabilidad'])),
      Column(children: _makeSection('Contenido',data['contenido'])),
      Column(children: _makeSection('Compartir',data['compartir'])),
      Center(child: ElevatedButton(
        onPressed: () async
        {
          String answer = "";

          for(int i = 0; i < questions.length; i++)
          {
            answer += questions[i].title + "\n" + questions[i].min + "\n" + questions[i].max + "\n" + "Valoracion: " + 
              (ratings[questions[i].title] != null ? ratings[questions[i].title].toString() : '2') + '\n\n';
          }

          final Email email = Email(
            body: answer,
            subject: 'Cuestionario App Coffee',
            recipients: ['lcarvajal21@alumnos.utalca.cl'],
            isHTML: false,
          );

          FlutterEmailSender.send(email);
          //Share.share(answer);
        }, 
        child: Text('Enviar')
        )
      ),
    ];
  }

  List<Card> _makeSection(String str, dynamic data)
  {
    List<Question> usability = (data as List).map((usability)
        {
          return Question.fromJson(usability);
        },
      ).toList();

      List<Card> cards =
      [
        Card(child: Center(child: Text(str),)),
      ];

      for(int i = 0; i < usability.length; i++)
      {
        cards.add(
          Card(
            child:
            Column(
              children:             
              [
                Text(usability[i].title),
                Text(usability[i].min),
                Text(usability[i].max),
                StarRating(
                  rating: ratings[usability[i].title] ?? 2,
                  starCount: 5,
                  onRatingChanged: (rating) => setState(() => ratings.addAll({usability[i].title: rating})),
                  allowHalfRating: false,

                )
              ],
            )
          )
        );
      }


    questions.addAll(usability);
    return cards;
  }
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      body: FutureBuilder(future: _loadQuestions(), builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return SingleChildScrollView(child: Column(children: _body));
          } else {
            // Otherwise, display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }
        },),
    );
  }
}