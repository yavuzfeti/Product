import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:urun_listeleme/main.dart';

class Internet
{
  // internetin durumunu dinleyen bi dinleyici oluşturuyoruz
  static late StreamSubscription<ConnectivityResult> _dinleyici;

  // servisin açık yada kapalı olmasını kontrol ediyor kapatırken iki kere kapatmaya çalışmasın diye
  static bool servis = false;

  // internetin güncel durumunun değişkeni
  static bool internet = true;

  // interneti kontrol eden metod
  static void control() async
  {
    // sunucuya ping atıyor sorun yoksa true geliyor
    internet = await InternetConnectionChecker().hasConnection;
    // nomalde burda alert dilog vardı internet yok diye çıkan ama gerek olmadığı için sildim
    dialog(internet);
  }

  static void baslat()
  {
    control();
    // servis kapalı ise başlatıyor
    if(!servis)
    {
      // internet tuşlarını dinliyor
      _dinleyici = Connectivity().onConnectivityChanged.listen((sonuc)
      {
        //değişiklik olduğunda bağlantıyı kontrol ediyor
        internet = (sonuc == ConnectivityResult.mobile || sonuc == ConnectivityResult.wifi);
        dialog(internet);
      });
      servis = true;
    }
  }

  static void durdur()
  {
    _dinleyici?.cancel();
    servis = false;
  }

  static void dialog(bool internet)
  {
    if(internet)
    {
      //contexti ana sayfaya veriyoruz ki taa kökten bir mesaj gözüksün hata çıkarmasın üstüste çakışma olmasın
      ScaffoldMessenger.of(navKey.currentState!.context).showSnackBar(
        SnackBar(
          content: Text("Bağlantı Aktif"),
        ),
      );
    }
    else
    {
      ScaffoldMessenger.of(navKey.currentState!.context).showSnackBar(
        SnackBar(
          content: Text("İnternet Kapandı"),
        ),
      );
    }
  }
}