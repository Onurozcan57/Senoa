import 'package:flutter/material.dart';

class YemekTarifleri extends StatefulWidget {
  const YemekTarifleri({super.key});

  @override
  State<YemekTarifleri> createState() => _YemekTarifleriState();
}

class _YemekTarifleriState extends State<YemekTarifleri> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1,
          children: [
            RecipeCard(
              title: "Tok Tutan Sandviç",
              description: "Malzemeler:\n"
                  "1 adet dilimlenmiş yumurta\n"
                  "100 gram ızgara tavuk\n"
                  "1 dilim az yağlı dil peyniri\n"
                  "1 yemek kaşığı labne\n"
                  "1 adet dilimlenmiş kornişon turşu\n"
                  "2-3 yaprak doğranmış marul\n"
                  "1adet közlenmiş kırmızı biber\n"
                  "1 adet rendelenmiş havuç\n"
                  "1 adet tahıllı sandviç ekmeği\n\n\n"
                  " NASIL YAPILIYOR?\n"
                  "Tahıllı sandviç ekmeğinin içine labne peynirini sürün."
                  "Ekmeğin içene malzemeleri tavuk, yumurta, peynir , turşu ve biber, marul ve havuç olacak şekilde sırasıyla ekleyin."
                  "Servis yaparken yanına karışık salata ekleyin.\n"
                  "Afiyet olsun...",
              imagePath: "lib/assets/sandvic.jpg",
              kalori: "250 kcal",
              porsiyon: "1",
              diyetisyenAdi: "Dyt. İrem Enginyurt tarafından öneriliyor",
              diyetisyenResimPath: "lib/assets/diyetisyen.webp",
            ),
            RecipeCard(
              title: "Detoks Suyu",
              description: "Malzemeler:\n"
                  "1 havuç\n"
                  "1 tatlı kaşığı zeytinyağı\n"
                  "Bir tutam kereviz yaprağı\n"
                  "1/4 bağ semizotu\n\n"
                  "Nasıl Yapılıyor?\n"
                  "Kereviz yapraklarını ve semizotunu iyice yıkayın."
                  "Tüm sebzelerin içine biraz su ilave edin ve  bir blender yardımıcı ile sıvı hale getirin."
                  "İçine 1 tatlı kaşığı zeytinyağını vitamin emilimi artması için ekleyin."
                  "Sabahları kür şeklinde 1 su bardağı içebilirsiniz.\n"
                  "Afiyet olsun...",
              imagePath: "lib/assets/detoks.jpg",
              kalori: "80 kcal",
              porsiyon: "1",
              diyetisyenAdi: "Dyt. Helin Özalkan tarafından öneriliyor",
              diyetisyenResimPath: "lib/assets/Helin_Ozalkan.png",
            ),
            RecipeCard(
              title: "Patatesli Omlet",
              description: "Malzemeler:\n"
                  "1 patates\n"
                  "2 yumurta\n"
                  "3-4 maydanoz\n"
                  "karabiber\n"
                  "tuz\n"
                  "2 tatlı kaşığı yağ\n\n"
                  "Nasıl Yapılıyor?\n"
                  "Patatesi rendeleyip, maydanozları küçük küçük doğradıktan sonra bir kapta yumurtayı çırpın."
                  "Karabiber ve çok az tuzuda ekleyerek tüm malzemeleri karıştırın"
                  "2 tatlı kaşığı yağ eklediğiniz tavaya karışımı döküp pişirin."
                  "Afiyet olsun...",
              imagePath: "lib/assets/omlet.jpeg",
              kalori: "290 kcal",
              porsiyon: "2",
              diyetisyenAdi: "Dyt. Elif Kabaklı tarafından öneriliyor",
              diyetisyenResimPath: "lib/assets/diyetisyen2.jpg",
            ),
            RecipeCard(
              title: "Sebzeli Biftek",
              description: "Malzemeler\n"
                  "500 gr. biftek,\n"
                  "3-4 dal brokoli,\n"
                  "2 adet soğan,\n"
                  "4-5 diş sarımsak,\n"
                  "6-7 adet yeşil sivri biber,\n"
                  "3 adet domates,\n"
                  "Yarım demet maydanoz,\n"
                  "Yeteri kadar baharat\n\n"
                  "Nasıl Yapılıyor?\n"
                  "Biftekleri yanmaz tavada ızgara usulu pişirin."
                  "Soğan, sarımsak, biber domates, brokoli, maydanoz ve salçayı başka bir tavada (bifteğin çıkan suyundan da içine katarak) pişirin."
                  "Pişmiş olan biftekleri yaklaşık 40´ar gram kesip üzerine bir yemek kaşığı domatesli sostan koyarak servis edin."
                  "Afiyet olsun...",
              imagePath: "lib/assets/biftek.jpg",
              kalori: "200 kcal",
              porsiyon: "2",
              diyetisyenAdi: "Dyt. Beyzanur Bayır tarafından öneriliyor",
              diyetisyenResimPath: "lib/assets/diyetisyen2.jpg",
            ),
            RecipeCard(
              title: "Poşe Somon",
              description: "Malzemeler:\n"
                  "3 parça somon fileto\n"
                  "2 diş sarımsak\n"
                  "2 dal maydanoz sapı\n"
                  "2-3 dilim limon\n"
                  "1 çay kaşığı tuz (azaltıp arttırılabilir)\n\n"
                  "Nasıl Yapılıyor?\n"
                  "Sığ bir tencereye yarı hizası kadar su ilave edin. Maydanoz ve limonu içine ilave edin, kaynatın."
                  "Kaynadığında somonları ekleyin. Dağılmamasına özen gösterek pişirin. 10 dakika yeterli olacaktır."
                  "Pişen somonları ocaktan alıp servis edin. Poşe somonlarınız hazır. Afiyetler olsun.",
              imagePath: "lib/assets/somon.webp",
              kalori: "210 kcal",
              porsiyon: "1",
              diyetisyenAdi: "Dyt. Ayşe Sümeyra Kesim tarafından öneriliyor",
              diyetisyenResimPath: "lib/assets/diyetisyen3.webp",
            ),
            RecipeCard(
              title: "Kinoalı Girit Kebabı",
              description: " Malzemeler:\n"
                  "2 soğan\n"
                  "1 havuç\n"
                  "6 yemek kaşığı zeytinyağı\n"
                  "1/2 çay bardağı yer fıstığı\n"
                  "1/2 çay bardağı kabak çekirdeği içi\n"
                  "1 çay kaşığı tuz\n"
                  "1/2 çay kaşığı karabiber\n"
                  "6 Girit kabağı \n"
                  "1/2 çay bardağı kurutulmuş yaban mersini\n"
                  "1 su bardağı kinoa \n"
                  "2 su bardağı sıcak su \n\n"
                  "Sosu İçin:\n"
                  "1 tatlı kaşığı domates salçası \n"
                  "1.5 su bardağı sıcak su \n"
                  "1 yemek kaşığı zeytinyağı\n"
                  "1 çay kaşığı nane\n"
                  "1/2 çay kaşığı tuz\n\n"
                  "NASIL YAPPILIYOR?\n"
                  "Soğanları ve havucu küçük küp doğrayın. Zeytinyağını bir tavada ısıtın. Soğanları ilave edip pembeleşinceye kadar soteleyin. Küp doğradığınız havucu ekleyip, sotelemeye devam edin."
                  "Kurutulmuş yaban mersini, yer fıstığı, kabak çekirdeği içi, tuz ve karabiberi ilave edin. Kinoayı bir tencereye alın."
                  "Üzerine sıcak su ilave edip suyunu çekinceye kadar pişirin. Ocaktan alıp sotelediğiniz sebzelere ilave edin."
                  "Girit kabaklarını yıkayıp üst kısımını kesin. Kabakların iç kısımlarını oyarak sandal görünümü verin."
                  "Kabakların içlerini kinoalı iç harç ile tepeleme doldurun. Geniş tabanlı bir tencereye yan yana dizin."
                  "Dolmanın sosu için domates salçasını sıcak su ile açın. Zeytinyağı, nane ve tuzu ekledikten sonra karıştırın."
                  "Tencereye aldığınız dolmaların üzerine sosu gezdirin. Kısık ateşte yaklaşık 30 dakika kabaklar yumuşayana kadar pişirin",
              imagePath: "lib/assets/kinoa.jpg",
              kalori: "237 kcal",
              porsiyon: "1",
              diyetisyenAdi: "Dyt. İrem Enginyurt tarfından öneriliyor",
              diyetisyenResimPath: "lib/assets/diyetisyen.webp",
            ),
            RecipeCard(
              title: "Böğürtlenli Tart",
              description: "Malzemeler:\n"
                  "100 g tereyağı veya margarin\""
                  "2 yemek kaşığı yoğurt\n"
                  "2 yemek kaşığı tatlandırıcı \n"
                  "2 su bardağı tam buğday unu\n"
                  "1 yumurta ( beyazı hamuruna, sarısı üzerine)\n"
                  "1/2 kabartma tozu\n"
                  "içine;\n"
                  "500 g böğürtlen ( frambuaz da olabilir)\n"
                  "4 yemek kaşığı tatlandırıcı\n"
                  "1 paket vanilya\n\n"
                  "Nasıl Yapılıyor?\n"
                  "100 g margarini eritin, soğusun."
                  "2 yemek kaşığı tatlandırıcı , 1 yumurtanın beyazı, kabartma tozu ve 2 yemek kaşığı yoğurdu karıştırın. "
                  "Bu karışıma yaklaşık 2 su bardağı tam buğday unu ilave edin."
                  "Poğaça hamuru gbi yumuşak bir hamur olacak. "
                  "Donmuş böğürtlen ise önceden çözdürün , teflon tavaya koyun."
                  "Üzerine tatlandırıcı ilave edip 10 dakika kısık ateşte pişirin."
                  "Pişerken içine 1 paket toz vanilya ilave edin.  "
                  "Kenarları açılabilen yapışmaz tart kabınızı biraz yağlayın ve unlayın.Hazırladığınız hamuru ikiye bölün."
                  "Bir kısmını tart kabının en altına elinizle yayın. "
                  "Arasına pişen meyveli sosu koyun."
                  "Üzerine kalan hamuru bir tezgahta açarak yerleştirin ve elinizle düzeltin."
                  "Afiyet olsun...",
              imagePath: "lib/assets/tart.jpg",
              kalori: "150 kcal",
              porsiyon: "12",
              diyetisyenAdi: "Dyt. Helin  Özalkan tarafından öneriliyor",
              diyetisyenResimPath: "lib/assets/Helin_Ozalkan.png",
            ),
            RecipeCard(
              title: "Portakal Soslu Enginar",
              description: "Malzemeler:\n"
                  "4-5 adet enginar\n"
                  "1 adet büyük boy soğan \n"
                  "1 kase bezelye\n"
                  "1/2 adet limonun suyu\n"
                  "1 adet portakalın suyu\n"
                  "1/2 çay bardağı zeytinyağı\n"
                  "1 yemek kaşığı toz şeker\n"
                  "1 tatlı kaşığı tuz\n"
                  "NASIL YAPILIR?\n"
                  "Soğanı jülyen doğrayın. Zeytinyağında kavurun."
                  "Üzerine bezelyeleri elleyin. Şeker ve tuzu da ilave edip enginarları dizin."
                  "Portakal ve limon suyunu da ilave ettikten sonra portakal ve limon kabuklarından serpiştirin. Enginarların yarısına gelecek şekilde suyunu da ilave edin."
                  "Tencerenin kapağını kapatın ve enginarları ara ara ters yüz ederek pişmeye bırakın. Enginarlar pişmediyse su takviyesi yapabilirsiniz."
                  "Pişen enginarların ortasına bezelyeli harcı ekleyin. Bol dereotu ile servis edin. Afiyet olsun",
              imagePath: "lib/assets/enginar.jpg",
              kalori: "150 kcal",
              porsiyon: "1",
              diyetisyenAdi: "Dyt. İrem Enginyurt tarafından öneriliyor",
              diyetisyenResimPath: "lib/assets/diyetisyen.webp",
            ),
            RecipeCard(
              title: "Tavuk ve Avakadolu Tam Buğday Tostu",
              description: "Malzemeler:\n"
                  "2 dilim tam buğday ekmeği\n"
                  "100 gram haşlanmış tavuk göğsü (ince dilimlenmiş)\n"
                  "1/2 avokado (ezilmiş)\n"
                  "1 tatlı kaşığı limon suyu\n"
                  "Tuz ve karabiber\n"
                  "Hazırlanışı:\n"
                  "Ezilmiş avokadoyu limon suyu, tuz ve karabiber ile karıştırın."
                  "Karışımı ekmek dilimlerine sürün."
                  "Haşlanmış tavuk dilimlerini ekmeklerin arasına yerleştirin ve tost makinesinde kızartın.",
              imagePath: "lib/assets/avokado.webp",
              kalori: "386 kcal",
              porsiyon: "1",
              diyetisyenAdi: "Dyt. Helin Özalkan tarafından öneriliyor",
              diyetisyenResimPath: "lib/assets/Helin_Ozalkan.png",
            ),
            RecipeCard(
              title: "Acai Bowl",
              description: "1 su bardağı badem sütü\n"
                  "1/2 su bardağı süzme yoğurt\n"
                  "1/2 su bardağı dondurulmuş böğürtlen\n"
                  "1/2 su bardağı dondurulmuş frambuaz\n"
                  "1/2 su bardağı dondurulmuş yaban mersini\n"
                  "2 adet muz (dilimleyerek dondurulmuş)\n"
                  "4 yemek kaşığı acai tozu\n\n"
                  "Acai Bowl Üzerini Süslemek İçin:\n"
                  "3-4 adet yaban mersini\n"
                  "3-4 adet frambuaz\n"
                  "3-4 adet böğürtlen\n"
                  "3-4 adet dilimlenmiş muz\n"
                  "1-2 yemek kaşığı granola\n"
                  "1-2 yemek kaşığı chia tohumu\n"
                  "1-2 yemek kaşığı fıstık ezmesi\n\n"
                  "Acai Bowl Tarifi Nasıl Yapılır?"
                  "Tarife başlamadan önce yaban mersini ve iki muzu dilimleyerek buzluğa atın. Donduktan sonra buzluktan çıkarın ve kaseleri hazırlamaya başlayın."
                  "Dondurulmuş böğürtlen, dondurulmuş frambuaz, yaban mersini, muz, badem sütü, süzme yoğurt ve acai tozunu blenderda pürüzsüz bir kıvam alana dek çekin."
                  "Daha tatlı olmasını isterseniz 1-2 tatlı kaşığı kadar bal veya agave şurubu da ilave edebilirsiniz."
                  "Kaselere paylaştırın ve üzerini arzu ettiğiniz gibi süsleyin. Acai bowl hazır! Meyveler, granola, chia tohumu ve fıstık ezmesi oldukça yakışıyor. Afiyet olsun!",
              imagePath: "lib/assets/acaibowll.jpg",
              kalori: "350",
              porsiyon: "1",
              diyetisyenAdi: "Dyt. Ayşe Sümeyra Kesim tarafından öneriliyor",
              diyetisyenResimPath: "lib/assets/diyetisyen3.webp",
            ),
          ],
        ),
      ),
    );
  }
}

class RecipeCard extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;
  final String kalori;
  final String porsiyon;
  final String diyetisyenAdi;
  final String diyetisyenResimPath;

  const RecipeCard({
    required this.title,
    required this.description,
    required this.imagePath,
    required this.kalori,
    required this.porsiyon,
    required this.diyetisyenAdi,
    required this.diyetisyenResimPath,
    Key? key,
  });
  void _showPopup(BuildContext context, String baslik, String aciklama,
      String kalori, String porsiyon) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      backgroundColor: Colors.white,
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        maxChildSize: 0.85,
        minChildSize: 0.3,
        initialChildSize: 0.6,
        builder: (context, scrollController) => Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 60,
                    height: 5,
                    margin: EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    baslik,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal[700],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.local_fire_department,
                        color: Colors.orange, size: 22),
                    SizedBox(width: 6),
                    Text(
                      'Kalori: $kalori',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(width: 20),
                    Icon(Icons.restaurant_menu, color: Colors.green, size: 22),
                    SizedBox(width: 6),
                    Text(
                      'Porsiyon: $porsiyon',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  aciklama,
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.5,
                    color: Colors.grey[800],
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 30),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 244, 236, 236),
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      "Kapat",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          _showPopup(context, title, description, kalori, porsiyon);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.asset(
                imagePath,
                height: 95,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Kalori: $kalori / Porsiyon: $porsiyon',
                    style: TextStyle(
                      fontSize: 8,
                      color: Colors.grey[700],
                    ),
                    textAlign: TextAlign.center,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 10,
                        backgroundImage: AssetImage(diyetisyenResimPath),
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          diyetisyenAdi,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
