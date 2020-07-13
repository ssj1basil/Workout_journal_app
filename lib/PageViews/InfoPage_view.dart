import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:workoutjournal/Data_models/Category_model.dart';
import 'package:workoutjournal/Data_models/Exercise_model.dart';
import 'package:workoutjournal/Helper/get_categorylist.dart';
import 'package:workoutjournal/Data_models/Musclegroup_model.dart';
import 'package:workoutjournal/Helper/get_equipmentlist.dart';
import 'package:workoutjournal/Data_models/Equipment_model.dart';

class infopage extends StatefulWidget {
  @override
  Exercise exercise;
  List<Category> categorylist;
  List<Muscle> musclelist;

  infopage({this.exercise, this.musclelist});

  _infopageState createState() => _infopageState();
}

class _infopageState extends State<infopage> {
  @override
  List<Widget> _front_pictures;
  List<Widget> _back_pictures;

  List<Equipment> equipmentlist;

  void initState() {
    super.initState();
    widget.categorylist = get_categoryList();
    _front_pictures = <Widget>[];
    _back_pictures = <Widget>[];
    equipmentlist = get_equipmentlist();
    pics_to_display();
  }

  String getequipments_fromlist(List<dynamic> _text) {

    List <String> equipments = [];
    equipmentlist = get_equipmentlist();


    String text;

    equipmentlist.removeWhere((item) => !_text.contains(item.id));
    for(int i=0; i<equipmentlist.length;i++){
   equipments.add (equipmentlist[i].name);}
   text = equipments.join(", ");
    return text;
  }

  pics_to_display() {
    _front_pictures.add(SvgPicture.asset("assets/images/muscular_system_front.svg"));
    _back_pictures.add(SvgPicture.asset("assets/images/muscular_system_back.svg"));

    for (int i in widget.exercise.muscles) {
      if (widget.musclelist[widget.musclelist.indexWhere((test) => test.id == i)].is_front)
        _front_pictures.add(SvgPicture.asset("assets/images/muscle-$i.svg"));
      else
        _back_pictures.add(SvgPicture.asset("assets/images/muscle-$i.svg"));
    }

    for (int i in widget.exercise.muscles_secondary) {
      if (widget.musclelist[widget.musclelist.indexWhere((test) => test.id == i)].is_front)
        _front_pictures.add(SvgPicture.asset("assets/images/muscle-$i.svg.1"));
      else
        _back_pictures.add(SvgPicture.asset("assets/images/muscle-$i.svg.1"));
    }
  }

  Widget display_muscles() {
    return Column(children: <Widget>[
      formatted_info("Muscles : ", "The diagram shows the most used muscles on this exercise"),

      SizedBox(height: 10,),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(height: 8,width: 8,color: Colors.orange,),
          Container(padding: EdgeInsets.only(left: 10),
            child: Text('Secondary Muscle',style: GoogleFonts.asap(textStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 12))),
          ),
          SizedBox(width: 10,),
          Container(height: 8,width: 8,color: Colors.red,),
          Container(padding: EdgeInsets.only(left: 10),
            child: Text('Primary Muscle',style: GoogleFonts.asap(textStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 12))),
          ),
        ],
      ),
      SizedBox(height: 18,),

      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          SizedBox(
              width: MediaQuery.of(context).size.width * 0.45,
              height: 300,
              child: Stack(children: _front_pictures.toList())),
          SizedBox(
              width: MediaQuery.of(context).size.width * 0.45,
              height: 300,
              child: Stack(children: _back_pictures.toList()))
        ],
      )

    ]);
  }

  Widget formatted_info(String subtext, String info) {
    return Container(
      padding: EdgeInsets.only(top: 20, left: 13),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
        Expanded(
            flex: 3,
            child: Text(subtext,
                style: GoogleFonts.asap(textStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 16)))),
        Expanded(
          flex: 7,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
            Container(padding: EdgeInsets.only(right: 2),child: Text(info, style: GoogleFonts.asap(textStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 16)))),
          ]),

        )
      ]),
    );
  }

  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.exercise.name),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              formatted_info(
                'Cateogory : ',
                widget.categorylist[widget.categorylist.indexWhere((test) => test.id == widget.exercise.category)].name,
              ),
              formatted_info('Description : ', widget.exercise.description),
              Container(
                child: widget.exercise.equipment.isEmpty?
                SizedBox(height: 0,): formatted_info('Equipment: ', getequipments_fromlist(widget.exercise.equipment)),
              ),
              Container(
                  child: (widget.exercise.muscles.isNotEmpty && widget.exercise.muscles != null)
                      ? display_muscles()
                      : SizedBox(
                          height: 0,
                        )),

            ],
          ),
        ),
      ),
    );
  }
}
