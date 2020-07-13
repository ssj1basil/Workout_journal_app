import 'package:workoutjournal/Data_models/Category_model.dart';

List<Category> get_categoryList(){

  List<Category> Categorylist = new List<Category>();
  Category category_model = new Category();
  //1

  category_model = new Category(name: "Any", id: 0, muscle_group: [2,1,13,14,4,10,6,3],is_front: true );
  Categorylist.add(category_model);

  category_model = new Category(name: "Abs", id: 10, muscle_group: [6,3],is_front: true );
  Categorylist.add(category_model);

  category_model = new Category(name: "Arms", id: 8, muscle_group: [1,13],is_front: true );
  Categorylist.add(category_model);


  category_model = new Category(name: "Back", id: 12, muscle_group: [12,9],is_front: false );
  Categorylist.add(category_model);

  category_model = new Category(name: "Chest", id: 11, muscle_group: [4],is_front: true );
  Categorylist.add(category_model);

  category_model = new Category(name: "Shoulders", id: 13, muscle_group: [2],is_front: true );
  Categorylist.add(category_model);


  category_model = new Category(name: "Legs", id: 9, muscle_group: [10],is_front: true );
  Categorylist.add(category_model);

  category_model = new Category(name: "Calves", id: 14, muscle_group: [7],is_front: false );
  Categorylist.add(category_model);

  return Categorylist;
  

}