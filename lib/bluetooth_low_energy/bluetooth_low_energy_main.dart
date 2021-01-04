import 'dart:async';

import 'package:blue_flutter/master_screen.dart';
import 'package:blue_flutter/models/meter_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import "package:hex/hex.dart";

class MainScreen extends StatefulWidget {
  BluetoothDevice device;

  MainScreen(this.device);

  @override
  State<StatefulWidget> createState() {
    return MainScreenState(device);
  }
}

class MainScreenState extends State {
  Timer _timer;

  startTimeout([int milliseconds]) {
    return _timer = Timer.periodic(new Duration(seconds: 1), (timer) {
      handleTimeout();
    });
  }

  ScrollController _scrollController = new ScrollController();
  List<Sayac> sayacList = new List<Sayac>();
  int _selectedIndex = 0;
  final _selectedSayacNo = TextEditingController();
  int uzunluk = 0;
  List<int> tempData = new List<int>();
  BluetoothCharacteristic characteristic;
  BluetoothDevice device;
  bool _isShowAnimation = false;
  String _isShowAnimationFileName = "";

  MainScreenState(BluetoothDevice device) {
    this.device = device;
    startTimeout();
  }

  @override
  void initState() {
    if (this.mounted) {
      lottieHidingAnimationNoTimer("assets/animations/luna.json");
      setState(() {
        connectDevice().then((value) {
          connectedDeviceDiscoverServices().then((data) {
            //     NotificationService.getFlushBar("Modem ayarları yapılıyor ⚙️ ", "Modem ayarları gönderilidi ✔ ", context);
            this.characteristic = data;
            listenStart(this.characteristic);
          });
        });
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    try {
      device.disconnect();
    } on Exception catch (exception) {
      print("exception");
    } catch (error) {
      print("catch");
    }

    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Timer(
      Duration(seconds: 1),
      () =>
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent),
    );
    return MasterScreen(
      context,
      _isShowAnimation,
      _isShowAnimationFileName,
      device.name,
      sayacList,
      _selectedIndex,
      _selectedSayacNo,
      _scrollController,
      onVanaAcPressed: vanaAcIsmri,
      onReadOutAll: readOutAll,
      onExit: exitMethod,
      onRefresh: readOutAll,
      onMeterFiltered: meterFiltered,
      onClear: clearList,
    );
  }

  void handleTimeout() {
    if (tempData.length != 0) {
      if (uzunluk == tempData.length) {
        List<int> newTempData = [...tempData];
        tempData.clear();
        uzunluk = 0;
        parseMethod(newTempData);
      } else {
        uzunluk = tempData.length;
      }
    }
  }

  listenStart(BluetoothCharacteristic characteristic) async {
    await characteristic.setNotifyValue(true);
    readDataasync(characteristic);
  }

  readDataasync(BluetoothCharacteristic characteristic) async {
    characteristic.value.listen((value) {
      for (var i = 0; i < value.length; i++) {
        tempData.add(value[i]);
      }

      if (value.length == 0) {
        //     NotificationService.getFlushBar("Modem ayarları yapılıyor ⚙️ ", "Modem ayarları gönderilidi ✔ ", context);
        //       characteristic.write(KomutService.rfModeSet(), withoutResponse: true);
      }

      print("DATA=>" + value.toString());
    });

    //await characteristic.setNotifyValue(true);
  }

  void parseMethod(List<int> tempData) {
    var hexData = HEX.encode(tempData);
    /*   var result = ParserService.parserStart(hexData);
    if (result != null) {
      if (result == CalisacakFonksiyonGetir[CalisacakFonksiyon.rEADOUTS_OKU_ALL]) {
        setState(() {
          _isShowAnimation = false;
          sayacList.clear();
          sayacList = ParserService.readOutOkuParser(hexData);
          NotificationService.getFlushBar("️Sayaç listesi yenilendi ✔", sayacList.length.toString() + " sayaç bulundu ⏬", context);
        });
      } else if (result == CalisacakFonksiyonGetir[CalisacakFonksiyon.mK_RF_MODE]) {
        NotificationService.getFlushBar("Modem tarihi ve saati güncelleniyor ⏰ ",
            DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()).toString() + " olarak gönderildi ✔", context);
        characteristic.write(KomutService.clockSet(), withoutResponse: true);
      } else if (result == CalisacakFonksiyonGetir[CalisacakFonksiyon.mK_TIME_UPDATE]) {
        setState(() {
          characteristic.write(KomutService.readOutAll(), withoutResponse: true);
        });
      }
    }*/
  }

  readOutAll(List<int> data) async {
    setState(() {
      this._selectedIndex = 0;
      _selectedSayacNo.text = "";
      //   sayacList.clear();
    });
    lottieHidingAnimationNoTimer("assets/animations/luna.json");
    await characteristic.write(data, withoutResponse: true);
  }

  void meterFiltered(String sayacNo) {
    setState(() {
      this._selectedIndex = 1;
      //    sayacList = sayacList.where((element) => element.sayacNo == sayacNo).toList();
    });
  }

  void clearList(List<int> data) async {
    setState(() {
      this._selectedIndex = 2;
      _selectedSayacNo.text = "";
      //  sayacList.clear();
    });
    lottieHidingAnimation("assets/animations/clean.json");
    await characteristic.write(data, withoutResponse: true);
  }

  void exitMethod() async {
    await device.disconnect().then((value) => Navigator.pop(context));
  }

  void vanaAcIsmri(String sayacNo) async {
    //  NotificationService.getFlushBarWithButton("Sayaç Numarası :" + sayacNo, "Vana aç iş emri gönderildi ✔ 💧", context);
    // await characteristic.write(KomutService.meterOpen(sayacNo), withoutResponse: true);
    print(sayacNo);
  }

  Future<BluetoothCharacteristic> connectedDeviceDiscoverServices() async {
    List<BluetoothService> services = await device.discoverServices();
    var servicesData = services
        .where((item) => item.uuid.toString().contains("ffe0"))
        .toList();
    var characteristicsData = servicesData
        .where((item) => item.characteristics
            .any((element) => element.uuid.toString().contains("ffe1")))
        .first;
    return characteristicsData.characteristics[0];
  }

  Future<void> connectDevice() async {
    await device.connect();
  }

  lottieHidingAnimation(String fileName) {
    Timer(Duration(seconds: 3), () {
      setState(() {
        _isShowAnimation = false;
        _isShowAnimationFileName = "";
      });
    });
    setState(() {
      _isShowAnimation = true;
      _isShowAnimationFileName = fileName;
    });
  }

  lottieHidingAnimationNoTimer(String fileName) {
    setState(() {
      _isShowAnimation = true;
      _isShowAnimationFileName = fileName;
    });
  }
}
