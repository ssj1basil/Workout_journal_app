import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:number_inc_dec/number_inc_dec.dart';
import 'package:workoutjournal/Data_models/Exercise_model.dart';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:workoutjournal/Helper/get_searchbar.dart';
import 'package:workoutjournal/PageViews/InfoPage_view.dart';
import 'package:workoutjournal/Data_models/Musclegroup_model.dart';
import 'package:workoutjournal/Helper/get_timer.dart';

PanelController pc = new PanelController();

class sliderpanel extends StatefulWidget {
  @override
  List<Exercise> exerciselist;
  List<Muscle> muslcelist;
  final void Function(bool) change_swipe;

  sliderpanel({this.exerciselist, this.change_swipe, this.muslcelist});

  sliderpanelstate createState() => sliderpanelstate();
}

class sliderpanelstate extends State<sliderpanel> {
  @override
  //to identify to show which exercises details
  int exercise_id, exercise_index;

  double _panelHeightOpen;
  double _panelHeightClosed = 0;
  TextEditingController distance_field = new TextEditingController();

  void initState() {
    super.initState();
    exercise_index = 0;
    exercise_id = 0;
  }

  //When a an exercise tile is pressed the panel value changes
  change_exerciseid(int _id) {
    setState(() {
      exercise_id = _id;
      exercise_index = widget.exerciselist.indexWhere((temp) => temp.id == exercise_id);
    });
  }

  Widget build(BuildContext context) {
    _panelHeightOpen = MediaQuery.of(context).size.height * .75;

    return SlidingUpPanel(
      maxHeight: _panelHeightOpen,
      minHeight: _panelHeightClosed,
      parallaxEnabled: true,
      onPanelOpened: () {
        if (FocusScope.of(context).hasPrimaryFocus) {
          FocusScope.of(context).unfocus();
        }
        if (pc.isPanelShown) {
          widget.change_swipe(false);
        }
      },
      onPanelClosed: () {
        widget.change_swipe(true);
      },
      onPanelSlide: (double _garbagevalue) => widget.change_swipe(false),
      backdropEnabled: true,
      color: Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.white,
      controller: pc,
      parallaxOffset: .5,
      body: body(),
      panelBuilder: (sc) => panel(sc),
      borderRadius: BorderRadius.only(topLeft: Radius.circular(18.0), topRight: Radius.circular(18.0)),
    );
  }

  Widget panel(ScrollController sc) {
    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView(
          controller: sc,
          children: <Widget>[
            Column(
              children: <Widget>[
                Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(top: 20, bottom: 10),
                    child: Material(
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => infopage(
                                    exercise: widget.exerciselist[exercise_index],
                                    musclelist: widget.muslcelist,
                                  )));
                        },
                        child: Text(widget.exerciselist[exercise_index].name,
                            style: GoogleFonts.asap(textStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 20))),
                      ),
                      color: Colors.transparent,
                    ),
                  ),
                ]),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Divider(
                        color: Colors.grey,
                        indent: 40,
                        endIndent: 40,
                        thickness: 0.6,
                      ),
                    )
                  ],
                ),
                Material(
                  child: Container(
                    child: Text('Tip : Click on header for more info',
                        style: GoogleFonts.asap(
                            textStyle: TextStyle(
                          fontWeight: FontWeight.w100,
                          fontSize: 13,
                          color: Theme.of(context).brightness == Brightness.light ? Colors.black54 : Colors.white70,
                        ))),
                  ),
                  color: Colors.transparent,
                ),
                Row(children: <Widget>[
                  Column(children: <Widget>[
                    textfield_reps_weight('Reps : '),
                    textfield_reps_weight('Weights :'),
                  ]),
                  SizedBox(
                    width: 30,
                  ),
                  Container(
                      height: 300,
                      child: VerticalDivider(color: Colors.grey, endIndent: 20.0, indent: 20, thickness: 0.5)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        child: Text('Duration : ',
                            style: GoogleFonts.asap(textStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 20))),
                      ),
                      Material(
                        color: Colors.transparent,
                        child: Container(
                            padding: EdgeInsets.only(top: 10, left: 10),
                            width: MediaQuery.of(context).size.width * 0.40,
                            height: 120,
                            child: timer()),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        child: Text('Distance : ',
                            style: GoogleFonts.asap(textStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 20))),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 50),
                        width: 120,
                        height: 70,
                        child: TextFormField(
                          controller: distance_field,
                          keyboardType: TextInputType.numberWithOptions(),
                        ),
                      )
                    ],
                  )
                ]),
              ],
            )
          ],
        ));
  }

  Widget textfield_reps_weight(String text) {
    return (Material(
      color: Colors.transparent,
      child: Row(children: <Widget>[
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 20, left: 30),
            child: Text(text, style: GoogleFonts.asap(textStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 20))),
          ),
          Container(
            padding: EdgeInsets.only(top: 10, left: 50),
            width: MediaQuery.of(context).size.width * 0.40,
            height: 100,
            child: NumberInputPrefabbed.roundedButtons(
              controller: TextEditingController(),
              max: 5000,
              min: 0,
              incIconColor: Colors.white,
              scaleHeight: 0.9,
              scaleWidth: 0.9,
              incIconSize: 27,
              decIconSize: 27,
              autovalidate: true,
              validator: (String value) {
                if (value.isNotEmpty) {
                  var condition = int.parse(value);
                  if (condition > 2000)
                    return 'Invalid';
                  else
                    return null;
                } else
                  return null;
              },
              numberFieldDecoration: InputDecoration(border: InputBorder.none),
              buttonArrangement: ButtonArrangement.incRightDecLeft,
              incDecBgColor: Colors.deepOrangeAccent,
            ),
          ),
        ]),
      ]),
    ));
  }

  //The search bar as its body
  Widget body() {
    return (searchbar(
      ExerciseList: widget.exerciselist,
      change_exerciseid: change_exerciseid,
    ));
  }
}
