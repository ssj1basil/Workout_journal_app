import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:workoutjournal/Data_models/Exercise_model.dart';
import 'package:workoutjournal/Helper/get_categorylist.dart';
import 'package:workoutjournal/Data_models/Category_model.dart';
import 'package:workoutjournal/Data_models/Equipment_model.dart';
import 'package:workoutjournal/Helper/get_equipmentlist.dart';
import 'package:flutter_svg/flutter_svg.dart';

class filterpage extends StatefulWidget {
  @override
  final List<Exercise> Function(bool, int, Category) apply_filter;

  filterpage({this.apply_filter});

  _filterpageState createState() => _filterpageState();
}

class _filterpageState extends State<filterpage> {
  @override
  List<Category> Categorylist;
  List<Equipment> Equipmentlist;

  //Default value
  Category chosen_category;
  int chosen_equipment;

  //The pictures to display
  List<Widget> _pictures = <Widget>[];

  void initState() {
    super.initState();
    Categorylist = get_categoryList();
    Equipmentlist = get_equipmentlist();

    //default value
    chosen_category = Categorylist[0];
    chosen_equipment = 7;

    pics_to_display();
  }

  pics_to_display() {
    _pictures = <Widget>[];

    _pictures.add(chosen_category.is_front
        ? SvgPicture.asset("assets/images/muscular_system_front.svg")
        : SvgPicture.asset("assets/images/muscular_system_back.svg"));

    for (int i in chosen_category.muscle_group) {
      _pictures.add(SvgPicture.asset("assets/images/muscle-${i}.svg"));
    }
  }

  Widget radio_tile_equipment(Equipment equipment) {
    return (RadioListTile<int>(
      title: Text(equipment.name,
          style: GoogleFonts.asap(textStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 18))),
      value: equipment.id,
      groupValue: chosen_equipment,
      onChanged: (int value) {
        setState(() {
          chosen_equipment = equipment.id;
        });
      },
    ));
  }

  Widget radio_tile_category(Category category) {
    return (RadioListTile<Category>(
      title:
          Text(category.name, style: GoogleFonts.asap(textStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 18))),
      value: category,
      groupValue: chosen_category,
      onChanged: (Category value) {
        setState(() {
          chosen_category = category;
          pics_to_display();
        });
      },
    ));
  }

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[

            //Header
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 5, left: 8),
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back_ios),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 18, left: 8, right: 80),
                  child: Text('Select Filters',
                      style: GoogleFonts.asap(textStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 22))),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: FlatButton(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                    color: Colors.blue,
                    textColor: Colors.white,
                    splashColor: Colors.blueAccent,
                    onPressed: () {
                      Navigator.pop(context);
                      widget.apply_filter(true,chosen_equipment,chosen_category);

                    },
                    child: Text(
                      "Submit",
                      style: TextStyle(fontSize: 15.0),
                    ),
                  ),
                )
              ],
            ),

            //OPTIONS FOR MUSCLE GROUP
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <Widget>[
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.50,
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: Categorylist.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(height: 43, child: radio_tile_category(Categorylist[index]));
                    }),
              ),
              SizedBox(width: MediaQuery.of(context).size.width * 0.48, child: Stack(children: _pictures.toList()))
            ]),

            //EQUIPMENT OPTIONS
            Row(
              children: <Widget>[
                Expanded(
                    child: Divider(color: Colors.grey,endIndent: 20.0, indent: 20,thickness: 0.5)
                )]),
                Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <Widget>[
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.50,
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: Equipmentlist.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(height: 43, child: radio_tile_equipment(Equipmentlist[index]));
                    }),
              ),
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.50,
                  child: Container(
                      child: Image.asset(
                    "assets/images/Equipment-$chosen_equipment.png",
                    height: 130,
                  )))
            ]),
          ],
        ),
      )),
    );
  }
}
