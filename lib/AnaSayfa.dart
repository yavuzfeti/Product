import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:urun_listeleme/Detay.dart';
import 'package:urun_listeleme/Internet.dart';
import 'package:urun_listeleme/Network.dart';
import 'package:urun_listeleme/main.dart';

class AnaSayfa extends StatefulWidget {
  const AnaSayfa({super.key});

  @override
  State<AnaSayfa> createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {

  // dynamic veriler türü yoktur
  // var ile oluşturulan değişkenler bile sonradan değişemez dynamic değişebilir
  dynamic veri = [
    {
      "no": "1",
      "isim": "Çilek",
      "detay": "Çilek Detay"
    },
    {
      "no": "2",
      "isim": "Vişne",
      "detay": "Vişne Detay"
    },
    {
      "no": "3",
      "isim": "Muz",
      "detay": "Muz Detay"
    }
  ];

  //başlangıçta çalışan metod
@override
  void initState() {
    super.initState();
    // servisimizi başlatıyoruz
    Internet.baslat();
    //fonksiyonu başta çalıştırıyoruz
    al();
  }

  //sınıfın stringini belirliyoruz
  Network Url = Network("https://metaakdeniz.com/Products/products.json");

//geri döndürmeyene asenkron metod
  Future<void> al() async
  {
    try
      {
        //yine dynamic hata kontrolü için
        // secure storage ile kaydedilmiş veri varsa okuyoruz
        dynamic kayit = await storage.read(key: "veri");
        if(kayit != "" && kayit !=null)
        {
          //setstateler stful ağacı içindeki stless widgeti tekrar oluşturur
          //yani görüntüyü günceller
          setState(() {
            // dönüşümü normalde otomatik yapar ama butür kütüphanelerde bazen yapamıyor
            // flutter secure storage string bazlı çalışıyor
            veri = jsonDecode(kayit);
          });
        }
        //ınterneti kontrol eden metodu çalıştırıyoz değişken güncellensin
        Internet.control();
        if(Internet.internet)
        {
          //servisi kullanarak veriyi çekiyoruz
          dynamic response = await Url.get();
          if(response != "" && response != null)
          {
            setState(() {
              veri = response;
            });
            //secure storage ile kaydediyoruz
            await storage.write(key: "veri", value: jsonEncode(veri));
          }
        }
      }
      catch(e)
      {
        // hata oluşursa kullanıcıyı bilgilendriyoruz
        ScaffoldMessenger.of(navKey.currentState!.context).showSnackBar(
          SnackBar(
            content: Text("Bir hata oluştu eski veriler görüntüleniyor."),
          ),
        );
      }
  }

  //initstate başta çalışan fonksiyon gibi buda activity yaşam döngüsünden geliyor
  // her activityde yapılan değişiklikte çalışır
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    al();
  }

  //yine activity ağacından activity kapanınca çalışıyor
  @override
  void dispose() {
    super.dispose();
    Internet.durdur();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ürün Listesi"),
        centerTitle: true,
      ),
      body: ListView.builder(
        //veri null ise 0 yapıyor liste uzunluğunu
        itemCount: veri.length ?? 0,
          itemBuilder: (context,index)
      {
        return Container(
          padding: EdgeInsets.all(10),
          child: ElevatedButton(
            onPressed: () {
              // sayfaya giderken veri gönderiyor
              // push ile gidildiği için bu sayfa kapanmıyor geri gelinebiliyor
              Navigator.push(context, MaterialPageRoute(builder: (context) => Detay(ad: veri[index]["isim"], detay: veri[index]["detay"],)));
            },
            // map verisi içinde index index sırayla isimleri yazdırıyor
            child: Text(veri[index]["isim"]),
          ),
        );
      }),
    );
  }
}
