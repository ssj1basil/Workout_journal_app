import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:flutter_picker/flutter_picker.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

// inside Widget build

class _MyAppState extends State<MyApp> {
  final StopWatchTimer _stopWatchTimer = StopWatchTimer(
    onChange: (value) => print('onChange $value'),
    onChangeSecond: (value) => print('onChangeSecond $value'),
    onChangeMinute: (value) => print('onChangeMinute $value'),
  );

  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _stopWatchTimer.rawTime.listen((value) => print('rawTime $value ${StopWatchTimer.getDisplayTime(value)}'));
    _stopWatchTimer.minuteTime.listen((value) => print('minuteTime $value'));
    _stopWatchTimer.secondTime.listen((value) => print('secondTime $value'));
    _stopWatchTimer.records.listen((value) => print('records $value'));
  }


  @override
  void dispose() async {
    super.dispose();
    await _stopWatchTimer.dispose();
  }

  Widget header(BuildContext context){
    return Row(
      children: <Widget>[
        Text('hours'),
        Text('minutes'),
        Text('seconds')
      ],
    );
  }

  showPickerArray(BuildContext context) {
    Picker(
      adapter: NumberPickerAdapter(data: <NumberPickerColumn>[
        const NumberPickerColumn(begin: 0, end: 999, ),
        const NumberPickerColumn(begin: 0, end: 59, ),
        const NumberPickerColumn(begin: 0, end: 59,),
      ]),
      hideHeader: false,
      confirmText: 'OK',
      confirmTextStyle: TextStyle(inherit: false, color: Colors.red, fontSize: 22),
      title: const Text('Select duration'),
      builderHeader: (BuildContext context){
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text('Hours'),
          Text('Minutes'),
          Text('Seconds')
        ],
      );
    } ,
      selectedTextStyle: TextStyle(color: Colors.blue),
      onConfirm: (Picker picker, List<int> value) {
        // You get your duration here
        Duration duration = Duration(hours: picker.getSelectedValues()[0], minutes: picker.getSelectedValues()[1], seconds: picker.getSelectedValues()[2]);
      },
    ).showDialog(context);
  }

  void onTap() {

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              /// Display stop watch time
              Padding(
                padding: const EdgeInsets.only(bottom: 0),
                child: StreamBuilder<int>(
                  stream: _stopWatchTimer.rawTime,
                  initialData: _stopWatchTimer.rawTime.value,
                  builder: (context, snap) {
                    final value = snap.data;
                    final displayTime = StopWatchTimer.getDisplayTime(value);
                    return Column(
                      children: <Widget>[
                        Padding(
                            padding: const EdgeInsets.all(8),
                            child: GestureDetector(
                              onTap:(){ showPickerArray(context);},
                              child: AbsorbPointer(
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    hintText: displayTime,
                                    border: InputBorder.none
                                  ),
                                ),
                              ),
                            )),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            value.toString(),
                            style: TextStyle(fontSize: 16, fontFamily: 'Helvetica', fontWeight: FontWeight.w400),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              /// Display every minute.
              Padding(
                padding: const EdgeInsets.only(bottom: 0),
                child: StreamBuilder<int>(
                  stream: _stopWatchTimer.minuteTime,
                  initialData: _stopWatchTimer.minuteTime.value,
                  builder: (context, snap) {
                    final value = snap.data;
                    print('Listen every minute. $value');
                    return Column(
                      children: <Widget>[
                        Padding(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 4),
                                  child: Text(
                                    'minute',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontFamily: 'Helvetica',
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 4),
                                  child: Text(
                                    value.toString(),
                                    style:
                                        TextStyle(fontSize: 30, fontFamily: 'Helvetica', fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            )),
                      ],
                    );
                  },
                ),
              ),

              /// Display every second.
              Padding(
                padding: const EdgeInsets.only(bottom: 0),
                child: StreamBuilder<int>(
                  stream: _stopWatchTimer.secondTime,
                  initialData: _stopWatchTimer.secondTime.value,
                  builder: (context, snap) {
                    final value = snap.data;
                    print('Listen every second. $value');
                    return Column(
                      children: <Widget>[
                        Padding(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 4),
                                  child: Text(
                                    'second',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontFamily: 'Helvetica',
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 4),
                                  child: Text(
                                    value.toString(),
                                    style:
                                        TextStyle(fontSize: 30, fontFamily: 'Helvetica', fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            )),
                      ],
                    );
                  },
                ),
              ),

              /// Lap time.
              Container(
                height: 120,
                margin: const EdgeInsets.all(8),
                child: StreamBuilder<List<StopWatchRecord>>(
                  stream: _stopWatchTimer.records,
                  initialData: _stopWatchTimer.records.value,
                  builder: (context, snap) {
                    final value = snap.data;
                    if (value.isEmpty) {
                      return Container();
                    }
                    Future.delayed(const Duration(milliseconds: 100), () {
                      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
                          duration: const Duration(milliseconds: 200), curve: Curves.easeOut);
                    });
                    print('Listen records. $value');
                    return ListView.builder(
                      controller: _scrollController,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (BuildContext context, int index) {
                        final data = value[index];
                        return Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                '${index + 1} ${data.displayTime}',
                                style: TextStyle(fontSize: 17, fontFamily: 'Helvetica', fontWeight: FontWeight.bold),
                              ),
                            ),
                            const Divider(
                              height: 1,
                            )
                          ],
                        );
                      },
                      itemCount: value.length,
                    );
                  },
                ),
              ),

              /// Button
              Padding(
                  padding: const EdgeInsets.all(2),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: RaisedButton(
                                padding: const EdgeInsets.all(4),
                                color: Colors.lightBlue,
                                shape: const StadiumBorder(),
                                onPressed: () async {
                                  _stopWatchTimer.onExecute.add(StopWatchExecute.start);
                                },
                                child: Text(
                                  'Start',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: RaisedButton(
                                padding: const EdgeInsets.all(4),
                                color: Colors.green,
                                shape: const StadiumBorder(),
                                onPressed: () async {
                                  _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
                                },
                                child: Text(
                                  'Stop',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: RaisedButton(
                                padding: const EdgeInsets.all(4),
                                color: Colors.red,
                                shape: const StadiumBorder(),
                                onPressed: () async {
                                  _stopWatchTimer.onExecute.add(StopWatchExecute.reset);
                                },
                                child: Text(
                                  'Reset',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(0),
                              child: RaisedButton(
                                padding: const EdgeInsets.all(4),
                                color: Colors.deepPurpleAccent,
                                shape: const StadiumBorder(),
                                onPressed: () async {
                                  _stopWatchTimer.onExecute.add(StopWatchExecute.lap);
                                },
                                child: Text(
                                  'Lap',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
