import 'package:flutter/material.dart';
import 'package:urun_listeleme/AnaSayfa.dart';

// Navigaor keyler uygulama sayfalarının ağacının bulunduğu yerin id si gibidir
//tüm sayfa geçişlerinde yada alert dialog popup gibi şeyler bu ana sayfanın
// üzerinde görüntülensin ki üst üste sayfa açılmış olmasın hem ram açısından hemde hata açısından temiz
final navKey = GlobalKey<NavigatorState>();

void main()
{
  runApp(
      MaterialApp(
        //debug moddan çıkarma etiketi kaldırma
        debugShowCheckedModeBanner: false,
        // navigator key i ana nesneye bağlıyoruz
        navigatorKey: navKey,
        //scaffoldlar ile değişim yapıcaz çünkü appbarımız değişken olabilir
        home: AnaSayfa(),
      ));
}