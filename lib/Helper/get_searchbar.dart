import 'package:flappy_search_bar/search_bar_style.dart';
import 'package:flutter/material.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flappy_search_bar/scaled_tile.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:workoutjournal/Data_models/Exercise_model.dart';
import 'package:workoutjournal/PageViews/ExercisePage_view.dart';
import 'package:workoutjournal/Helper/get_exercisetile.dart';
import 'package:workoutjournal/PageViews/FilterPage_view.dart';
import 'package:workoutjournal/Data_models/Category_model.dart';

class searchbar extends StatefulWidget {
  @override
  List<Exercise> ExerciseList;
  final void Function(int) change_exerciseid;

  searchbar({this.ExerciseList, this.change_exerciseid});

  _searchbarState createState() => _searchbarState();
}

class _searchbarState extends State<searchbar> {
  @override
  final SearchBarController<Exercise> _searchBarController = SearchBarController();


  // returns the search query
  Future<List<Exercise>> _getallexercise(String text) async {
    await Future.delayed(Duration(seconds: 1));

    List<Exercise> list = [];
    if (text == null) {
      text = '';
    }
    widget.ExerciseList.forEach((exercises) {
      if (exercises.name.toString().toLowerCase().contains(text.toLowerCase())) {
        list.add(exercises);
      }
    });
    return list;
  }

  //The filtered list will be passed through the placeholder, The filter button can be pressed to change the state again
  List<Exercise> Filtered_list;

  void initState() {
    super.initState();

    Filtered_list = widget.ExerciseList;
  }


  // refresh after applying filter to reset
  Future<void> refresh() {
    Filtered_list = widget.ExerciseList;
    setState(() {});
  }


  //apply filter with info received from Filter page
  List<Exercise> apply_filter(bool filter, [int chosen_equipment, Category chosen_category]) {
    if (filter) {
      Filtered_list = [];
      widget.ExerciseList.forEach((exercises) {
        if (exercises.equipment.contains(chosen_equipment) &&
            (exercises.category == chosen_category.id || chosen_category.id == 0)) {
          Filtered_list.add(exercises);
        }
      });
      setState(() {});
    } else {
      return widget.ExerciseList;
    }
  }


  //the default suggestion to show i.e., all the exerecise
  Widget placeholder(List<Exercise> _ExerciseList) {
    if (_ExerciseList.length > 0) {
      return (Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: ListView.builder(
          itemCount: _ExerciseList.length,
          itemBuilder: (BuildContext context, int index) {
            return (exercise_tile(
              panelController: pc,
              exercise: _ExerciseList[index],
              change_exerciseid: widget.change_exerciseid,
            ));
          },
        ),
      ));
    } else
      return (Center(child: Text('Empty')));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      RefreshIndicator(
        onRefresh: () async {
          refresh();
        },
        child: Container(
          padding: EdgeInsets.only(bottom: 80),
          child: SearchBar<Exercise>(
            searchBarStyle: SearchBarStyle(
                padding: EdgeInsets.symmetric(horizontal: 10), borderRadius: BorderRadius.circular(25.0)),
            minimumChars: 2,
            hintText: 'Search',
            //placeholder(apply_filter(to_filter)),
            placeHolder: placeholder(Filtered_list),
            textStyle: TextStyle(),
            searchBarPadding: EdgeInsets.only(left: 10, right: 60),
            headerPadding: EdgeInsets.symmetric(horizontal: 10),
            listPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
            onSearch: _getallexercise,
            searchBarController: _searchBarController,
            cancellationWidget: Text("Cancel"),
            indexedScaledTileBuilder: (int index) => ScaledTile.fit(2),
            emptyWidget: Center(child: Text('Empty')),
            mainAxisSpacing: 0,
            crossAxisSpacing: 0,
            crossAxisCount: 2,
            shrinkWrap: true,
            onItemFound: (Exercise exercise, int index) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child:
                    exercise_tile(panelController: pc, exercise: exercise, change_exerciseid: widget.change_exerciseid),
              );
            },
          ),
        ),
      ),
      // Filter ICON
      SizedBox.expand(
        child: Container(
          padding: EdgeInsets.only(top: 15, right: 10),
          child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: <Widget>[
            IconButton(
              icon: Icon(MaterialCommunityIcons.filter_variant),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => filterpage(apply_filter: apply_filter)));
              },
            )
          ]),
        ),
      )
    ]);
  }
}
