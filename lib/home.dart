import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:sapphire_yssantamaria_application/iuran_add.dart';
import 'helpers/LeftMenu.dart';
import 'helpers/util.dart';
import 'helpers/session.dart' as session;

class HomeScreen extends StatefulWidget {
  @override
  createState() {
    return HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen> {
  int backPressCounter = 0;
  int backPressTotal = 2;
  bool isLoadIuran = true;
  List dataIuran;
  int isTabFocus = 1;
  @override
  void initState() {
    super.initState();
    loadIuran();
  }

  Future loadIuran() async {
    try {
      setState(() {
        isLoadIuran = true;
      });
      getData('/iuran/get-last').then((res) {
        setState(() {
          if (res.data['message'] == 'success') {
            dataIuran = res.data['data'];
          } else {
            bottomInfo(context, res.data['message']);
          }
          isLoadIuran = false;
        });
      });
    } catch (e) {
      bottomInfo(context, e.toString());
    }
  }

  Widget paymentStatus(status) {
    if (status == 1) {
      return Align(
          alignment: Alignment.topCenter,
          child: Row(children: const [
            Icon(
              Icons.lock_clock,
              size: 14,
            ),
            Text("Admin ", textAlign: TextAlign.center, style: TextStyle(color: Colors.red, fontSize: 12))
          ]));
    }
    if (status == 2) {
      return Align(
          alignment: Alignment.topCenter,
          child: Row(children: const [
            Icon(Icons.check_box, size: 14, color: Colors.green),
            Text("Lunas ", textAlign: TextAlign.center, style: TextStyle(color: Colors.green, fontSize: 12))
          ]));
    }
  }

  Widget homeTab() {
    if (isTabFocus == 1) {
      return Flexible(
          child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: dataIuran == null ? 0 : dataIuran.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                    child: Card(
                        child: Container(
                            padding: const EdgeInsets.all(20),
                            child: Row(children: [
                              Flexible(
                                  flex: 8,
                                  child: Column(children: [
                                    Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          dataIuran[index]['periode'],
                                          style: TextStyle(fontSize: 15),
                                        )),
                                    Align(
                                        alignment: Alignment.topLeft,
                                        child: Text("Payment Date : " + dataIuran[index]['payment_date'],
                                            style: TextStyle(color: Colors.grey[700]))),
                                    Align(
                                        alignment: Alignment.topLeft,
                                        child: Text("Payment Type : " + dataIuran[index]['payment_type'],
                                            style: TextStyle(color: Colors.grey[700]))),
                                  ])),
                              Flexible(flex: 2, child: paymentStatus(dataIuran[index]['payment_status']))
                            ]))));
              }));
    } else {
      return Flexible(
          child: ListView(padding: const EdgeInsets.only(top: 10, left: 15, right: 15, bottom: 10), children: [
        Container(
            margin: EdgeInsets.only(bottom: 15),
            child: Align(
                alignment: Alignment.topLeft,
                child: Text("Data Pribadi",
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500, color: Colors.grey[700])))),
        label_('No Form', session.noForm),
        label_('No Anggota', session.noAnggota),
        label_('No KTP', session.noKtp),
        label_('Nama KTP', session.name_),
        label_('Nama KTA', session.namaKta),
        label_('Email', session.email),
        label_('No Telp', session.telepon),
        label_('Tanggal Lahir', session.tanggalLahir),
        label_('Jenis Kelamin', session.jenisKelamin),
        label_('Alamat', session.alamat),
      ]));
    }
  }

  Widget label_(label, value) {
    return Container(
        margin: EdgeInsets.only(top: 12, bottom: 12),
        child: Row(children: [
          Expanded(flex: 3, child: Text(label, style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(flex: 7, child: Text(" : " + value.toString()))
        ]));
  }

  Widget build(context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
          title: const Text('YS Santa Maria', style: TextStyle(color: Colors.white)),
          bottomOpacity: 0.0,
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          actions: <Widget>[
            Container(margin: const EdgeInsets.only(right: 15), child: const Icon(Icons.person, color: Colors.white)),
          ]),
      drawer: AppDrawer(),
      body: WillPopScope(
          child: Container(
              child: Column(
            children: [
              Container(
                  margin: const EdgeInsets.only(top: 30.0),
                  padding: const EdgeInsets.only(top: 80.0, left: 20, right: 20, bottom: 40.0),
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/background.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                              padding: const EdgeInsets.all(10),
                              child: const Icon(
                                Icons.person_pin,
                                color: Colors.white,
                                size: 120,
                              )),
                          Container(
                              child: Column(children: [
                            Text(session.name_,
                                style: const TextStyle(
                                  fontSize: 25.0,
                                  color: Colors.white,
                                )),
                            Text(session.kota,
                                style: const TextStyle(
                                  color: Colors.white,
                                ))
                          ])),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        child: Row(
                          children: [
                            Expanded(
                                flex: 5,
                                child: Row(
                                  children: [
                                    Container(
                                        child: const Text("No Anggota",
                                            style: TextStyle(fontSize: 12.0, color: Colors.white60))),
                                    Container(
                                        child: Text(" : " + session.noAnggota.toString(),
                                            style: TextStyle(fontSize: 12.0, color: Colors.white))),
                                  ],
                                )),
                            Expanded(
                                flex: 5,
                                child: Align(
                                    alignment: Alignment.topRight,
                                    child: Row(
                                      children: [
                                        Container(
                                            child: const Text("Aktif",
                                                style: TextStyle(fontSize: 12.0, color: Colors.white60))),
                                        Container(
                                            child: Text(" : " + session.tanggalAktif,
                                                style: TextStyle(fontSize: 12.0, color: Colors.white))),
                                      ],
                                    )))
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                              flex: 5,
                              child: Row(
                                children: [
                                  Container(
                                      child: const Text("Telepon",
                                          style: TextStyle(fontSize: 12.0, color: Colors.white60))),
                                  Container(
                                      child: Text(" : " + session.telepon,
                                          style: TextStyle(fontSize: 12.0, color: Colors.white))),
                                ],
                              )),
                          Expanded(
                              flex: 5,
                              child: Align(
                                  alignment: Alignment.topRight,
                                  child: Row(
                                    children: [
                                      Container(
                                          child: const Text("Umur",
                                              style: TextStyle(fontSize: 12.0, color: Colors.white60))),
                                      Container(
                                          child: Text(" : " + session.umur + " Tahun",
                                              style: TextStyle(fontSize: 12.0, color: Colors.white))),
                                    ],
                                  )))
                        ],
                      ),
                    ],
                  )),
              Container(
                decoration: const BoxDecoration(color: Colors.white),
                margin: EdgeInsets.only(top: 10),
                padding: EdgeInsets.only(left: 10, right: 10),
                width: double.infinity,
                child: Wrap(
                  direction: Axis.horizontal,
                  alignment: WrapAlignment.center,
                  children: <Widget>[
                    Container(
                        child: (isTabFocus == 1
                            ? Container(
                                width: MediaQuery.of(context).size.width * 0.45,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.blue[300],
                                  ),
                                  onPressed: () {
                                    setState(() {});
                                  },
                                  child: const Text("Riwayat Iuran"),
                                ),
                              )
                            : Container(
                                width: MediaQuery.of(context).size.width * 0.45,
                                child: FlatButton(
                                  onPressed: () {
                                    setState(() {
                                      isTabFocus = 1;
                                    });
                                  },
                                  child: const Text("Riwayat Iuran", style: TextStyle(color: Colors.black)),
                                )))),
                    (isTabFocus == 2
                        ? Container(
                            width: MediaQuery.of(context).size.width * 0.45,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.lightBlueAccent,
                              ),
                              onPressed: () {},
                              child: const Text("Data Pribadi"),
                            ))
                        : Container(
                            width: MediaQuery.of(context).size.width * 0.45,
                            child: FlatButton(
                              onPressed: () {
                                setState(() {
                                  isTabFocus = 2;
                                });
                              },
                              child: const Text("Data Pribadi", style: TextStyle(color: Colors.black)),
                            ))),
                    //
                  ],
                ),
              ),
              homeTab()
            ],
          )),
          onWillPop: onWillPop),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => IuranAddScreen()));
        },
        label: Text("IURAN"),
        icon: Icon(Icons.add),
        backgroundColor: Colors.amber[900],
      ),
    );
  }

  Future<bool> onWillPop() {
    if (backPressCounter < 1) {
      Toast.show("Press again time to exit app", context);
      backPressCounter++;
      Future.delayed(Duration(seconds: 1, milliseconds: 500), () {
        backPressCounter--;
      });
      return Future.value(false);
    } else {
      exit(0);
      // return Future.value(true);
    }
  }
}
