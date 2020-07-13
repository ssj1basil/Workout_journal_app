import 'package:workoutjournal/Data_models/Exercise_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:workoutjournal/Data_models/Blacklist_exercise.dart';
import 'package:string_validator/string_validator.dart';
import 'package:html/parser.dart';

class Exerciselist {
  List<Exercise> list = [];

  //Contains all the blacklisted words (misspelled, german ..)
  List<String> black_list = get_blacklist();

  Future<List<Exercise>> get_exercise() async {
    String url;

    url = "https://wger.de/api/v2/exercise/?format=json&language=2&limit=447";
    var response = await http.get(url);
    var jsonData = jsonDecode(response.body);
    jsonData.forEach((element) {
      if (!element['name'].contains(new RegExp(r'[^A-Za-z -()]')) &&
          element['name'] != '' &&
          element['description'] != '' &&
          element['description'] != null &&
          element['description'].contains(new RegExp(r'[A-Za-z ().,]')) &&
          element['category'] != '' &&
          element['category'] != null &&
          !black_list.contains(element['name']) &&
          element['id'] != null) {

        //Removing html tags from
        var document = parse(element['description']);
        String description = parse(document.body.text).documentElement.text;
        description = description[0].toUpperCase() + description.substring(1);
        description = description.replaceAll(new RegExp(r'[^\w\s]+'),'');

        Exercise exercise = Exercise(
          id: element['id'],
          name: element['name'],
          category: element['category'],
          description: description,
          muscles: element['muscles'],
          muscles_secondary: element["muscles_secondary"],
          equipment: element["equipment"],
        );

        //removing spaces & converting to lower case to check for duplicates
        if (!list.any((e) => blacklist(e.name, ' ').toLowerCase() == blacklist(exercise.name, ' ').toLowerCase())) {
          list.add(exercise);
        }
      }
    });

    return list;
  }
}
