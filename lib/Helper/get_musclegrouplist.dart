import 'package:workoutjournal/Data_models/Musclegroup_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:string_validator/string_validator.dart';
import 'package:html/parser.dart';

class Musclelist {
  List<Muscle> list = [];

  //Contains all the blacklisted words (misspelled, german ..)

  Future<List<Muscle>> get_musclegroup() async {
    String url;

    url = "https://wger.de/api/v2/muscle/?format=json";
    var response = await http.get(url);
    var jsonData = jsonDecode(response.body);
    jsonData.forEach((element) {
        Muscle _muscle = Muscle(
          id: element['id'],
          name: element['name'],
          is_front: element['is_front']
        );
          list.add(_muscle);
    });
    return list;
  }
}
