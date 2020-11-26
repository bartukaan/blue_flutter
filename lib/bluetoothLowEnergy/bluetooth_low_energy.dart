import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

import 'bluetooth_low_energy_devices_list.dart';
import 'bluetooth_low_energy_main.dart';



class SelectBluetoothLowEnergyDevicePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BluetoothState>(
        stream: FlutterBlue.instance.state,
        initialData: BluetoothState.unknown,
        builder: (c, snapshot) {
          final state = snapshot.data;
          if (state == BluetoothState.on) {
            return FindDevicesScreen(); // find devices ekranına git
          }
          return BluetoothOffScreen(state: state);
        });
  }
}

class BluetoothOffScreen extends StatelessWidget {
  // bluetooth kapalı işlemi
  const BluetoothOffScreen({Key key, this.state}) : super(key: key);

  final BluetoothState state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.bluetooth_disabled,
              size: 200.0,
              color: Colors.white54,
            ),
            Text(
              'Bluetooth Adapter is ${state != null ? state.toString().substring(15) : 'not available'}.',
              style: Theme.of(context).primaryTextTheme.subtitle1.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class FindDevicesScreen extends StatelessWidget {
  // find devices ekranı
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bluetooth Low Energy Devices'),
        backgroundColor: Colors.blueAccent,
        actions: <Widget>[
          StreamBuilder<bool>(
            //search devices butonu
            stream: FlutterBlue.instance.isScanning,
            initialData: false,
            builder: (c, snapshot) {
              if (snapshot.data) {
                return FittedBox(
                  child: Container(
                      margin: new EdgeInsets.all(16.0), child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white))),
                );
              } else {
                return IconButton(icon: Icon(Icons.replay), onPressed: () => FlutterBlue.instance.startScan(timeout: Duration(seconds: 4)));
              }
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => FlutterBlue.instance.startScan(timeout: Duration(minutes: 400)),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              StreamBuilder<List<ScanResult>>(
                stream: FlutterBlue.instance.scanResults,
                initialData: [],
                builder: (c, snapshot) => Column(
                  children: snapshot.data
                      .map(
                        (r) => BLEDeviceListEntry(
                      // => bluetooth cihaz listesi getir
                      device: r.device,
                      rssi: r.rssi,
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                        //r.device.connect();

                        return MainScreen(r.device); // => bluetooth cihaz bağlan ve route işlemi
                      })),
                    ),
                  )
                      .where((element) => element.devicename != "")
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
