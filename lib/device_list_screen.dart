import 'package:flutter/material.dart';

import 'bluetoothClassic/bluetooth_classic.dart';
import 'bluetoothLowEnergy/bluetooth_low_energy.dart';

class BluetoothDevicesListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //startTimeout();
    return Scaffold(
      appBar: AppBar(
        title: Text("LUNA Remote Reading"),
        actions: <Widget>[],
      ),
      body: buildConnectionList(),
    );
  }

  buildConnectionList() {
    return Container(
      child: Column(
        children: <Widget>[
          Expanded(child: SelectBluetoothClassicDevicePage()),
          Expanded(child: SelectBluetoothLowEnergyDevicePage()),
        ],
      ),
    );
  }
}
