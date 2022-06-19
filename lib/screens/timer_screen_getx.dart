import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pomodoro/controller/timer_controller.dart';
import 'package:sprintf/sprintf.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

void showToast(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 5,
    backgroundColor: Colors.grey,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

class TimerScreenGetX extends StatelessWidget {
  TimerScreenGetX({Key? key}) : super(key: key);
  TimerController _controller = Get.put(TimerController());

  String secondsToString(String str) {
    int seconds = int.parse(str);
    return sprintf("%02d:%02d", [seconds ~/ 60, seconds % 60]);
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _runningButtons = [
      ElevatedButton(
        onPressed: () {
          _controller.timerStatus == TimerStatus.paused
              ? _controller.resume()
              : _controller.pause();
        },
        child: Text(
          _controller.timerStatus == TimerStatus.paused
              ? '계속하기'
              : '일시정지', // 일시정지 중 ? 계속하기: 잃시정지
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        style: ElevatedButton.styleFrom(primary: Colors.blue),
      ),
      Padding(padding: EdgeInsets.all(20)),
      ElevatedButton(
        onPressed: () {
          _controller.stop();
        },
        child: Text(
          '포기하기',
          style: TextStyle(fontSize: 16),
        ),
        style: ElevatedButton.styleFrom(primary: Colors.grey),
      ),
    ];
    final List<Widget> _stoppedButtons = [
      ElevatedButton(
        onPressed: () {
          _controller.run();
        },
        child: Text(
          '시작하기',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        style: ElevatedButton.styleFrom(
          primary: _controller.timerStatus == TimerStatus.resting
              ? Colors.green
              : Colors.blue, // 휴식 중 ? 녹색 : 파란색
        ),
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text('뽀모도로 타이머'),
        backgroundColor: _controller.timerStatus == TimerStatus.resting
            ? Colors.green
            : Colors.blue,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width * 0.6,
            child: Center(
              child: GetBuilder<TimerController>(
                builder: (controller) {
                  return Text(
                    secondsToString("${controller.timer}"),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
            ),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _controller.timerStatus == TimerStatus.resting
                  ? Colors.green
                  : Colors.blue,
            ),
          ),
          GetBuilder<TimerController>(
            builder: (controller) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: controller.timerStatus == TimerStatus.resting
                    ? const []
                    : controller.timerStatus == TimerStatus.stopped
                        ? _stoppedButtons
                        : _runningButtons,
              );
            },
          ),
        ],
      ),
    );
  }
}
