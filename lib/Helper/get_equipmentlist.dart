import 'package:workoutjournal/Data_models/Equipment_model.dart';

List<Equipment> get_equipmentlist(){

  List<Equipment> Equipmentlist = [];

  Equipment temp;

  temp = Equipment(name: "None",id: 7);
  Equipmentlist.add(temp);

  temp = Equipment(name: "Barbell",id: 1);
  Equipmentlist.add(temp);


  temp = Equipment(name: "PullUp Bar",id: 6);
  Equipmentlist.add(temp);


  temp = Equipment(name: "Dumbbell",id: 3);
  Equipmentlist.add(temp);


  temp = Equipment(name: "Bench",id: 8);
  Equipmentlist.add(temp);


  temp = Equipment(name: "Kettlebell",id: 10);
  Equipmentlist.add(temp);


  temp = Equipment(name: "Gym Mat",id: 4);
  Equipmentlist.add(temp);

  return Equipmentlist;
}