import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:flutter_picker/flutter_picker.dart';

class timer extends StatefulWidget {
  @override
  _timerState createState() => _timerState();
}

class _timerState extends State<timer> {
  @override
  final StopWatchTimer _stopWatchTimer = StopWatchTimer();

  String duration;
  bool use_stopwatch;

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  showPickerArray(BuildContext context) {
    Picker(
      adapter: NumberPickerAdapter(data: <NumberPickerColumn>[
        const NumberPickerColumn(
          begin: 0,
          end: 999,
        ),
        const NumberPickerColumn(
          begin: 0,
          end: 59,
        ),
        const NumberPickerColumn(
          begin: 0,
          end: 59,
        ),
      ]),
      hideHeader: false,
      containerColor: Colors.white,
      backgroundColor: Theme.of(context).brightness == Brightness.dark ? Colors.black54 : Colors.white,
      confirmText: 'Confirm',
      confirmTextStyle: TextStyle(inherit: false, color: Colors.green, fontSize: 15),
      title: const Text('Select duration'),
      builderHeader: (BuildContext context) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[Text('Hours'), Text('Minutes'), Text('Seconds')],
        );
      },
      selectedTextStyle: TextStyle(color: Colors.blue),
      onConfirm: (Picker picker, List<int> value) {
        setState(() {
          // You get your duration here
          _stopWatchTimer.onExecute.add(StopWatchExecute.reset);
          Duration _duration = Duration(
              hours: picker.getSelectedValues()[0],
              minutes: picker.getSelectedValues()[1],
              seconds: picker.getSelectedValues()[2]);
          use_stopwatch = false;
          duration = _printDuration(_duration);
        });
      },
    ).showDialog(context);
  }

  void initState() {
    super.initState();
    use_stopwatch = true;
  }

  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 40),
              child: StreamBuilder<int>(
                  stream: _stopWatchTimer.rawTime,
                  initialData: _stopWatchTimer.rawTime.value,
                  builder: (context, snap) {
                    final value = snap.data;
                    final displayTime = StopWatchTimer.getDisplayTime(value);
                    return Column(
                      children: <Widget>[
                        Container(
                            child: GestureDetector(
                          onTap: () {
                            showPickerArray(context);
                          },
                          child: AbsorbPointer(
                            child: TextFormField(
                              decoration: InputDecoration(
                                  hintText: use_stopwatch?displayTime:duration,
                                  hintStyle: TextStyle(
                                      color: Theme.of(context).brightness == Brightness.dark
                                          ? Colors.white
                                          : Colors.black),
                                  border: InputBorder.none),
                            ),
                          ),
                        )),
                      ],
                    );
                  }),
            ),

            //Button
            Container(
                child: Column(children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: IconButton(
                        onPressed: () async {
                          setState(() {

                          });
                          use_stopwatch = true;
                          _stopWatchTimer.onExecute.add(StopWatchExecute.start);
                        },
                        icon: Icon(Icons.play_arrow),
                      ),
                    ),
                    Container(
                      child: IconButton(
                        onPressed: () async {
                          _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
                        },
                        icon: Icon(Icons.stop),
                      ),
                    ),
                    Container(
                      child: IconButton(
                        onPressed: () async {
                          _stopWatchTimer.onExecute.add(StopWatchExecute.reset);
                        },
                        icon: Icon(Icons.loop),
                      ),
                    ),
                  ],
                ),
              ),
            ]))
          ]),
    );
  }
}
