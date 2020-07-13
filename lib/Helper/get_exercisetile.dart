import 'package:flutter/material.dart';
import 'package:workoutjournal/Data_models/Exercise_model.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:google_fonts/google_fonts.dart';

class exercise_tile extends StatefulWidget {
  @override
  PanelController panelController;
  Exercise exercise;
  int index;
  void Function (int) change_exerciseid;

  exercise_tile({this.exercise, this.panelController, this.index,this.change_exerciseid});

  _exercise_tileState createState() => _exercise_tileState();
}

class _exercise_tileState extends State<exercise_tile> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        //closing keyboard when pressing a tile
        setState(() {});
        if (FocusScope.of(context).hasPrimaryFocus) FocusScope.of(context).unfocus();
        widget.change_exerciseid(widget.exercise.id);
        widget.panelController.open();
      },
      child: Container(
        padding: EdgeInsets.only(top: 10),
        height: 45,
        child: Text(widget.exercise.name,
            style: GoogleFonts.asap(textStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 18))),
      ),
    );
  }
}
