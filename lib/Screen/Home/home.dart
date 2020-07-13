import 'package:flutter/material.dart';
import 'package:workoutjournal/Helper/get_bottomnavigator.dart';
import 'package:workoutjournal/Helper/get_exerciselist.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:workoutjournal/Data_models/Exercise_model.dart';
import 'package:workoutjournal/PageViews/ExercisePage_view.dart';
import 'package:workoutjournal/Data_models/Musclegroup_model.dart';
import 'package:workoutjournal/Helper/get_musclegrouplist.dart';

class Homepage extends StatefulWidget {
  @override


  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  List<Exercise> ExerciseList = new List<Exercise>();
  List<Muscle> musclelist;

  final controller = PageController(initialPage: 2);

  GlobalKey bottomNavigationKey = GlobalKey();

  bool swipe_able = true;
  bool _exerciseloading = true;
  bool _muscleloading = true;


  void initState() {
    super.initState();
    get_exercise();
    get_musclelist();
  }

  change_swipe(bool state)
  {
    setState(() {
      swipe_able = state;
    });
  }

  get_exercise() async {
    Exerciselist _exerciselist = new Exerciselist();
    ExerciseList = await _exerciselist.get_exercise();
    print(ExerciseList.length);
    setState(() {
      _exerciseloading = false;
    });
  }

  get_musclelist() async{
    Musclelist _musclelist = new Musclelist();
    musclelist = await _musclelist.get_musclegroup();
    print(musclelist.length);

    setState(() {
      _muscleloading = false;
    });
  }

  Widget setupAlertDialoadContainer() {
    return Container(
      height: 300.0, // Change as per your requirement
      width: 300.0, // Change as per your requirement
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: ExerciseList.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(ExerciseList[index].name),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        bottomNavigationBar: bottomnavigator(context, bottomNavigationKey,controller),
        body: _exerciseloading || _muscleloading
            ? Center(child: CircularProgressIndicator())
            : Center(
                child: PageView(
                  physics: swipe_able? AlwaysScrollableScrollPhysics(): NeverScrollableScrollPhysics(),
                  controller: controller,
                children: <Widget>[
                  Container(
                    color: Colors.pink,
                  ),
                 sliderpanel(exerciselist: ExerciseList,change_swipe: change_swipe,muslcelist: musclelist,),
                  Container(
                    color: Colors.deepPurple,
                  ),
                  Container(
                    color: Colors.grey,
                  ),
                  Container(
                    color: Colors.green,
                  ),
                ],
                onPageChanged: (page) {
                  setState(() {
                    final CurvedNavigationBarState navBarState =
                        bottomNavigationKey.currentState;
                    navBarState.setPage(page);
                  });
                },
              )
                /*Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Summary'),
            ],
          ),*/

        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}
