import 'package:flutter/material.dart';

class Detay extends StatefulWidget {

  // gelinen sayfadan veri almak için
  String ad;
  String detay;

  // constructorları
  Detay({required this.ad, required this.detay});

  @override
  State<Detay> createState() => _DetayState();
}

class _DetayState extends State<Detay> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          // alınan veriyi yazdırma
          widget.ad
        ),
        // appbar yazısını ortalama
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          widget.detay,
        ),
      ),
    );
  }
}
