import 'package:get/get.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

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

enum TimerStatus { running, paused, stopped, resting }

class TimerController extends GetxController {
  static const WORK_SECONDS = 25;
  static const REST_SECONDS = 5;

  late TimerStatus timerStatus;
  late int timer;
  late int pomodoroCount;

  @override
  void onInit() {
    super.onInit();
    timerStatus = TimerStatus.stopped;
    print(timerStatus.toString());
    timer = WORK_SECONDS;
    pomodoroCount = 0;
    update();
  }

  void run() {
    timerStatus = TimerStatus.running;
    print("[=>]" + timerStatus.toString());
    runTimer();
    update();
  }

  void rest() {
    timer = REST_SECONDS;
    timerStatus = TimerStatus.resting;
    print("[=>]" + timerStatus.toString());
    update();
  }

  void pause() {
    timerStatus = TimerStatus.paused;
    print("[=>]" + timerStatus.toString());
    update();
  }

  void resume() {
    run();
  }

  void stop() {
    timer = WORK_SECONDS;
    timerStatus = TimerStatus.stopped;
    print("[=>]" + timerStatus.toString());
    update();
  }

  void runTimer() async {
    Timer.periodic(Duration(seconds: 1), (Timer t) {
      switch (timerStatus) {
        case TimerStatus.paused:
          t.cancel();
          break;
        case TimerStatus.stopped:
          t.cancel();
          break;
        case TimerStatus.running:
          if (timer <= 0) {
            showToast("작업완료");
            rest();
          } else {
            timer -= 1;
            update();
          }
          break;
        case TimerStatus.resting:
          if (timer <= 0) {
            pomodoroCount += 1;
            update();
            showToast("오늘 $pomodoroCount 개의 뽀모도로를 달성했습니다.");
            t.cancel();
            stop();
          } else {
            timer -= 1;
            update();
          }
          break;
        default:
          break;
      }
    });
  }
}
