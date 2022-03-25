import 'package:flutter/material.dart';

/// list of all devices
enum DeviceType {
  desktop,
  handset,
}

/// breakpoints for desktop, tablet and handset
const desktop = 520;
const handset = 280;

DeviceType _displayTypeOf(BuildContext context) {
  /// Use shortestSide to detect device type regardless of orientation
  double deviceWidth = MediaQuery.of(context).size.shortestSide;

  if (deviceWidth > desktop) {
    return DeviceType.desktop;
  } else {
    return DeviceType.handset;
  }
}

bool isDeviceDesktop(BuildContext context) {
  return _displayTypeOf(context) == DeviceType.desktop;
}

bool isDeviceMobile(BuildContext context) {
  return _displayTypeOf(context) == DeviceType.handset;
}
