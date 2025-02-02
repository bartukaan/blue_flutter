import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class BLEDeviceListEntry extends ListTile {
  String devicename;

  BLEDeviceListEntry(
      {@required BluetoothDevice device,
      int rssi,
      GestureTapCallback onTap,
      GestureLongPressCallback onLongPress,
      bool enabled = true})
      : super(
          onTap: onTap,
          onLongPress: onLongPress,
          enabled: enabled,
          leading: Icon(Icons.bluetooth_searching),
          // @TODO . !BluetoothClass! class aware icon
          title: Text(device.name ?? "Unknown device"),
          subtitle: Text(device.id.toString()),
          trailing: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
            rssi != null
                ? Container(
                    margin: new EdgeInsets.all(8.0),
                    child: DefaultTextStyle(
                        style: () {
                          /**/ if (rssi >= -35)
                            return TextStyle(color: Colors.greenAccent[700]);
                          else if (rssi >= -45)
                            return TextStyle(
                                color: Color.lerp(Colors.greenAccent[700],
                                    Colors.lightGreen, -(rssi + 35) / 10));
                          else if (rssi >= -55)
                            return TextStyle(
                                color: Color.lerp(Colors.lightGreen,
                                    Colors.lime[600], -(rssi + 45) / 10));
                          else if (rssi >= -65)
                            return TextStyle(
                                color: Color.lerp(Colors.lime[600],
                                    Colors.amber, -(rssi + 55) / 10));
                          else if (rssi >= -75)
                            return TextStyle(
                                color: Color.lerp(
                                    Colors.amber,
                                    Colors.deepOrangeAccent,
                                    -(rssi + 65) / 10));
                          else if (rssi >= -85)
                            return TextStyle(
                                color: Color.lerp(Colors.deepOrangeAccent,
                                    Colors.redAccent, -(rssi + 75) / 10));
                          else
                            /*code symetry*/ return TextStyle(
                                color: Colors.redAccent);
                        }(),
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(rssi.toString()),
                              Text('dBm'),
                            ])),
                  )
                : Container(width: 0, height: 0),
          ]),
        ) {
    devicename = device.name;
  }
}
