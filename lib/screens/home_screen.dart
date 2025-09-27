import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "SAP Veri Analizi - Genel Bakış",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),

            // 1️ Veri Hazırlama ve Temizleme
            Text(
              "1. Veri Hazırlama ve Temizleme",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Veri setleri birleştirildi, eksik veriler dolduruldu ve gereksiz sütunlar temizlendi. "
              "Tarih ve sayısal alanlar uygun formatlara dönüştürülerek analiz için hazır hâle getirildi.",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
                height: 1.5,
              ),
            ),

            SizedBox(height: 30),

            // 2️Satış Performansı
            Text(
              "2. Satış Performansı Analizi",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "2019 ve 2020 yılları olağanüstü yüksek satış hacmi (~850M USD) ile öne çıkmıştır. "
              "Diğer yıllarda satışlar ortalama 5–10M USD bandında seyretmiştir. "
              "Satışların büyük bölümü az sayıda müşteriden gelmektedir (Pareto ilkesi).",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
                height: 1.5,
              ),
            ),

            SizedBox(height: 30),

            // 3️Müşteri Analizi
            Text(
              "3. Müşteri Analizi ve Segmentasyonu",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Ortalama sipariş büyüklüğüne göre müşteriler:\n"
              "• Büyük Alıcılar: %50’ye yakın katkı sağlar.\n"
              "• Orta Seviye Alıcılar: %4 oranındadır.\n"
              "• Küçük Alıcılar: Çok sipariş verir ama katkısı düşüktür.\n\n"
              "Segmentlere göre farklı satış stratejileri geliştirilebilir.",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
                height: 1.5,
              ),
            ),

            SizedBox(height: 30),

            // 4️ Zaman Bazlı Analiz
            Text(
              "4. Zaman Bazlı Analiz",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "2019–2020 döneminde satış artışı belirli müşterilerden kaynaklanmıştır. "
              "2021 sonrası bazı büyük müşterilerde ciddi düşüş gözlemlenmiştir. "
              "Sadık müşterilerin oranı %96,7 ile yüksek olsa da yeni müşteri kazanımı zayıftır.",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
                height: 1.5,
              ),
            ),

            SizedBox(height: 30),

            // 5️ RFM Segmentleri
            Text(
              "5. RFM Analizi ve Müşteri Segmentleri",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "RFM sonuçlarına göre müşteri dağılımı:\n"
              "- Champions: %20.4\n"
              "- Loyal: %6.1\n"
              "- At Risk: %16.3\n"
              "- Hibernating: %24.5\n"
              "- Need Attention: %32.6",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
                height: 1.5,
              ),
            ),

            SizedBox(height: 30),

            // 6️ Müşteri Kayıp (Churn)
            Text(
              "6. Müşteri Kayıp (Churn) Analizi",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "2019’da churn oranı %2.8 iken 2023’te %7’ye yükselmiştir. "
              "Sık sipariş verenlerin churn olasılığı düşüktür. "
              "Hibernating segmentinde churn oranı %67 seviyesindedir.",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
                height: 1.5,
              ),
            ),

            SizedBox(height: 30),

            // 7️ Bölgesel Satış
            Text(
              "7. Bölgesel Satış Dağılımı",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "ABD en büyük pazar (~46 müşteri), Kanada ve Almanya’da büyüme potansiyeli vardır. "
              "Eyalet bazında Georgia ve California öne çıkmaktadır. "
              "Düşük yoğunluklu eyaletlerde yeni müşteri fırsatları vardır.",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
                height: 1.5,
              ),
            ),

            SizedBox(height: 30),

            // 8️ Stratejik Öneriler
            Text(
              "8. Stratejik Öneriler",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "• Champions & Loyal: Sadakat programları ve kişisel teklifler.\n"
              "• At Risk & Hibernating: Yeniden kazanma kampanyaları.\n"
              "• Need Attention: Promosyonlarla etkileşimi artır.",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
