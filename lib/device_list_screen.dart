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
      body: buildbody(context), //buildConnectionList(),
    );
  }

  buildbody(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            FlatButton(
              onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        SelectBluetoothClassicDevicePage()));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.bluetooth),
                  //SizedBox(width: 10),
                  Text("Bluetooth Classic"),
                  IconButton(
                    icon: Icon(Icons.arrow_forward_ios),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              SelectBluetoothClassicDevicePage()));
                    },
                  ),
                ],
              ),
            ),
            FlatButton(
              onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        SelectBluetoothLowEnergyDevicePage()));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.bluetooth_audio_sharp),
                  //SizedBox(width: 10),
                  Text("Bluetooth Low Energy"),
                  IconButton(
                    icon: Icon(Icons.arrow_forward_ios),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              SelectBluetoothLowEnergyDevicePage()));
                    },
                  ),
                ],
              ),
            ),
            FlatButton(
              onPressed: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.wifi),
                  //SizedBox(width: 10),
                  Text("Wi-Fi"),
                  IconButton(
                      icon: Icon(Icons.arrow_forward_ios), onPressed: null)
                ],
              ),
            ),
          ],
        ),
      ),
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
