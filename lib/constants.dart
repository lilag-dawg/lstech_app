library constants;
import 'package:flutter/material.dart';

const int defaultPageIndex = 0;

// colors
var backGroundColor = Colors.white;
var greyColor = Colors.grey[300];
var greyColorSelected = Colors.grey[400];

// phone size
var appBarHeight = 55;
var trainingStartStopWidgetHeight = 200;

// emulator
final bool isWorkingOnEmulator = true;


enum pageIndexes {
  home,
  training,
  history,
}