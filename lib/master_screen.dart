import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lottie/lottie.dart';

import 'models/meter_model.dart';

class MasterScreen extends StatelessWidget {
  final void Function(List<int>) onReadOutAll;
  final void Function(List<int>) onRefresh;
  final void Function(List<int>) onClear;
  final void Function() onExit;
  BuildContext context;
  int value;
  String deviceName = "";

  final void Function(String) onVanaAcPressed;
  final void Function(String) onMeterFiltered;
  List<Sayac> sayacList;
  int _selectedIndex;
  TextEditingController _selectedSayacNo;
  ScrollController _scrollController;
  bool isStart = false;
  bool _isShowAnimation = false;
  String _isShowAnimationFileName = "";

  MasterScreen(
      this.context,
      this._isShowAnimation,
      this._isShowAnimationFileName,
      this.deviceName,
      this.sayacList,
      this._selectedIndex,
      this._selectedSayacNo,
      this._scrollController,
      {this.onVanaAcPressed,
      this.onReadOutAll,
      this.onExit,
      this.onRefresh,
      this.onMeterFiltered,
      this.onClear});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(deviceName),
        actions: <Widget>[
          IconButton(
            tooltip: "Bağlantıyı Kes",
            icon: Icon(Icons.bluetooth_disabled),
            onPressed: () {
              onExit();
            },
          ),
          PopupMenuButton(
            tooltip: "Menu",
            itemBuilder: (context) {
              var list = List<PopupMenuEntry<Object>>();
              list.add(
                PopupMenuItem(
                  child: Text("Menu"),
                  value: 1,
                ),
              );
              list.add(
                PopupMenuDivider(
                  height: 10,
                ),
              );
              list.add(
                CheckedPopupMenuItem(
                  child: GestureDetector(
                    onTap: () {
                      //Navigator.push(context, MaterialPageRoute(builder: (context) => ModemScreen()),);

                      print("Container was tapped");
                    },
                    child: Text(
                      "Modem Bilgileri",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  value: 2,
                  checked: true,
                ),
              );
              list.add(
                PopupMenuDivider(
                  height: 10,
                ),
              );
              list.add(
                CheckedPopupMenuItem(
                  child: GestureDetector(
                    onTap: () {
                      print("Container was tapped");
                    },
                    child: Text(
                      "İş Emirleri",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  value: 2,
                  checked: true,
                ),
              );
              list.add(
                PopupMenuDivider(
                  height: 10,
                ),
              );
              list.add(
                CheckedPopupMenuItem(
                  child: GestureDetector(
                    onTap: () {
                      print("Container was tapped");
                    },
                    child: Text(
                      "Log Kayıtları",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  value: 2,
                  checked: true,
                ),
              );
              return list;
            },
            icon: Icon(
              Icons.menu,
              size: 30,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          _isShowAnimation == true
              ? Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height - 130,
                    child: Lottie.asset(_isShowAnimationFileName,
                        alignment: Alignment.center),
                  ),
                )
              : sayacSayisiGoster(),
          ExpandableTheme(
              data: const ExpandableThemeData(
                iconColor: Colors.blue,
                useInkWell: true,
              ),
              child: Expanded(child: buildMeterList())),
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        height: 48,
        backgroundColor: Colors.blueAccent,
        items: <Widget>[
          Icon(Icons.play_circle_outline, size: 30),
          Icon(Icons.search, size: 30),
          Icon(Icons.refresh, size: 30),
          Icon(Icons.restore_from_trash, size: 30),
        ],
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int value) {
    this._selectedIndex = value;
    if (value == 0) {
      /*    NotificationService.getFlushBar("Okuma işlemi  📖", "Emir gönderildi ✔️ ", this.context);
      onreadOutAll(KomutService.readOutAll());*/
    } else if (value == 1) {
      _selectedSayacNo.text = "";
      _showMyDialog();
    } else if (value == 2) {
      /*  NotificationService.getFlushBar("Liste yenileniyor 🔄", "Emir gönderildi ✔️ ", this.context);
      onreadOutAll(KomutService.readOutAll());*/
    } else if (value == 3) {
      // NotificationService.getFlushBar(  "Liste temizleniyor 🗑", "Emir gönderildi ✔️ ", this.context);
      //  onExit();
      // onClear(KomutService.clearList());
    }
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Sayaç numarası giriniz ⏬'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                buildSayacNoField(),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Ara 🔍'),
              onPressed: () {
                onMeterFiltered(_selectedSayacNo.text);
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Vazgeç ❌'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Widget buildSayacNoField() {
    return TextFormField(
      decoration:
          InputDecoration(labelText: "", hintText: "Sayaç no giriniz.."),
      controller: _selectedSayacNo,
      keyboardType: TextInputType.number,
    );
  }

  Padding sayacSayisiGoster() {
    if (sayacList.length <= 0 && _selectedSayacNo.text != "") {
      return Padding(
        padding: EdgeInsets.only(top: 17, left: 5),
        child: Card(
          color: Colors.redAccent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const ListTile(
                leading: Icon(Icons.error_outline),
                title: Text('LUNA'),
                subtitle: Text('Aranan sayaç numarası listede bulunamadı ❌'),
              ),
            ],
          ),
        ),
      );
    } else if (sayacList.length <= 0) {
      return Padding(
        padding: EdgeInsets.only(top: 17, left: 5),
        child: Card(
          color: Colors.blueAccent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const ListTile(
                leading: Icon(Icons.cast_connected),
                title: Text('LUNA'),
                subtitle: Text(
                    'Sayaçları listelemek için Yenile 🔄 butonuna basınız.'),
              ),
            ],
          ),
        ),
      );
    }
    return Padding(
        padding: EdgeInsets.only(top: 7, left: 15),
        child: Container(
            alignment: Alignment.topLeft,
            child: Text("Toplam Sayaç Sayısı: " + sayacList.length.toString(),
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 15, color: Colors.indigo))));
  }

  ListView buildMeterList() {
    return ListView.separated(
        separatorBuilder: (BuildContext context, position) => Divider(),
        controller: _scrollController,
        //  shrinkWrap:  true,//sayacList.length >= 0 ? true : false,
        //  reverse:  true,//sayacList.length >= 0 ? true : false,
        itemCount: sayacList.length,
        itemBuilder: (BuildContext context, int position) {
          return ExpandableNotifier(
              child: Padding(
            padding: const EdgeInsets.all(5),
            child: Card(
              elevation: 7,
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        color: buildStatusIconBorder(sayacList[position].ceza),
                        shape: BoxShape.rectangle,
                      ),
                    ),
                  ),
                  ScrollOnExpand(
                    scrollOnExpand: true,
                    scrollOnCollapse: false,
                    child: Container(
                      //color: Colors.white,
                      color: position % 2 == 0
                          ? Colors.grey.shade300
                          : Colors.white,
                      child: ExpandablePanel(
                        theme: const ExpandableThemeData(
                          headerAlignment:
                              ExpandablePanelHeaderAlignment.center,
                          tapBodyToCollapse: true,
                        ),
                        header: ListTile(
                            leading: CircleAvatar(
                              backgroundImage:
                                  AssetImage("assets/images/luna_sayac.png"),
                            ),
                            title: Padding(
                                padding: EdgeInsets.all(5),
                                child: Text(
                                  "Sayaç No : " + sayacList[position].sayacNo,
                                  style: Theme.of(context).textTheme.bodyText2,
                                )),
                            subtitle: Text("Tüketim: " +
                                sayacList[position].toplamTuketim +
                                " m3"),
                            trailing: Column(
                              children: <Widget>[
                                buildStatusIcon(sayacList[position].ceza),
                                // Icon(Icons.error_outline),
                                //  buildStatusUyari(sayacList[position].uyari), // Icon(Icons.error_outline),
                                buildVanaIcon(sayacList[position].vanaliMi),
                              ],
                            )),
                        collapsed: Text(
                          loremIpsum,
                          softWrap: true,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        expanded: Column(
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                    child: buttonGetir(sayacList[position])),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                    child: cezaGetir(sayacList[position]),
                                    flex: 2),
                                Padding(
                                    padding: const EdgeInsets.only(right: 7)),
                                Expanded(
                                    child: uyariGetir(sayacList[position]),
                                    flex: 2),
                              ],
                            ),
                          ],
                        ),
                        builder: (_, collapsed, expanded) {
                          return Padding(
                            padding: EdgeInsets.only(
                                left: 10, right: 10, bottom: 10),
                            child: Expandable(
                              collapsed: collapsed,
                              expanded: expanded,
                              theme:
                                  const ExpandableThemeData(crossFadePoint: 0),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ));
        });
  }

  Widget uyariGetir(Sayac sayac) {
    if (sayac.uyari) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 5, bottom: 5),
            child: Text('Uyarılar',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                    color: Colors.black)),
          ),
          sayac.uyariTersAkis == true
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Expanded(
                      child: Text("-Ters akış"),
                    ),
                    const Expanded(
                      child: Icon(
                        Icons.warning,
                        color: Colors.yellow,
                      ),
                    ),
                  ],
                )
              : Row(),
          sayac.uyariSizintiveyaPatlak == true
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Expanded(
                      child: Text("-Sızıntı veya patlak"),
                    ),
                    const Expanded(
                      child: Icon(
                        Icons.warning,
                        color: Colors.yellow,
                      ),
                    ),
                  ],
                )
              : Row(),
        ],
      );
    } else {
      return IconSlideAction(
        caption: 'Uyari yok',
        color: Colors.blueAccent,
        icon: Icons.check_box,
        onTap: () {},
      );
    }
  }

  Widget cezaGetir(Sayac sayac) {
    if (sayac.ceza) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 5, bottom: 5),
            child: Text('Cezalar',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                    color: Colors.black)),
          ),
          sayac.cezaOptik == true
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Expanded(
                      child: Text("-Optik"),
                    ),
                    const Expanded(
                      child: Icon(
                        Icons.error,
                        color: Colors.red,
                      ),
                    ),
                  ],
                )
              : Row(),
          sayac.cezaKapak == true
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Expanded(
                      child: Text("-Kapak"),
                    ),
                    const Expanded(
                      child: Icon(
                        Icons.error,
                        color: Colors.red,
                      ),
                    ),
                  ],
                )
              : Row(),
          sayac.cezaManyetikEtki == true
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Expanded(
                      child: Text("-Manyetik Etki"),
                    ),
                    const Expanded(
                      child: Icon(
                        Icons.error,
                        color: Colors.red,
                      ),
                    ),
                  ],
                )
              : Row(),
        ],
      );
    } else {
      return IconSlideAction(
        caption: 'Ceza yok',
        color: Colors.green,
        icon: Icons.check_box,
        onTap: () {},
      );
    }
  }

  Widget buttonGetir(Sayac sayac) {
    return DropdownButton(
        value: 1,
        items: [
          DropdownMenuItem(
            child: Text("İş Emri Seçiniz"),
            value: 1,
          ),
          DropdownMenuItem(
            child: Row(
              children: <Widget>[
                Icon(Icons.invert_colors, color: Colors.blue),
                Text("Vana Aç"),
              ],
            ),
            value: 2,
          ),
          DropdownMenuItem(
            child: Row(
              children: <Widget>[
                Icon(Icons.invert_colors, color: Colors.red),
                Text("Vana Kapat"),
              ],
            ),
            value: 3,
          ),
        ],
        onChanged: (_value) {
          if (_value == 2) {
            onVanaAcPressed(sayac.sayacNo);
          }
          print("SELECTED=>>>>>>>>" +
              _value.toString() +
              "   SAYAC NO==>" +
              sayac.sayacNo.toString());
        });
  }

  buildStatusIconBorder(bool ceza) {
    if (ceza) {
      return Colors.red;
    } else {
      return Colors.green;
    }
  }

  Icon buildStatusIcon(bool ceza) {
    if (ceza) {
      return Icon(
        Icons.assignment_late,
        color: Colors.red,
        size: 20.0,
      );
    } else {
      return Icon(
        Icons.check,
        color: Colors.green,
        size: 20.0,
      );
    }
  }

  Icon buildStatusUyari(bool uyari) {
    if (uyari) {
      return Icon(
        Icons.warning,
        color: Colors.yellow,
        size: 20.0,
      );
    } else {
      return Icon(
        Icons.check,
        color: Colors.yellow,
        size: 20.0,
      );
    }
  }

  Icon buildVanaIcon(bool vanaliMi) {
    if (vanaliMi) {
      return Icon(
        Icons.invert_colors,
        color: Colors.blue,
        size: 20.0,
      );
    } else {
      return Icon(
        Icons.invert_colors_off,
        color: Colors.blue,
        size: 20.0,
      );
    }
  }

  void onSelectedMenuItem(int value) {
    switch (value) {
      case 1:
        break;
      case 2:
        break;
    }
  }
}

const loremIpsum = "Detaylar için tıklayınız...";
