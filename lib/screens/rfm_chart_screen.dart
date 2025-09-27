import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/data_service.dart';

class RfmChartScreen extends StatefulWidget {
  const RfmChartScreen({super.key});

  @override
  State<RfmChartScreen> createState() => _RfmChartScreenState();
}

class _RfmChartScreenState extends State<RfmChartScreen> {
  bool _isLoading = true;
  bool _isDisposed = false; // widget dispose kontrolü
  Map<String, int> segmentCounts = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      final records = await DataService.loadRfmData();

      // Widget hala yaşıyor mu kontrolü
      if (!mounted || _isDisposed) return;

      final counts = <String, int>{};
      for (var record in records) {
        counts[record.segment] = (counts[record.segment] ?? 0) + 1;
      }

      if (!mounted || _isDisposed) return;

      setState(() {
        segmentCounts = counts;
        _isLoading = false;
      });
    } catch (e, st) {
      if (!mounted || _isDisposed) return;
      debugPrint("Veri yüklenirken hata oluştu: $e\n$st");
      setState(() {
        _isLoading = false;
        segmentCounts = {};
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : segmentCounts.isEmpty
          ? const Center(
              child: Text(
                "Veri yüklenemedi. CSV dosyasını veya sütun isimlerini kontrol edin.",
                style: TextStyle(color: Colors.white70, fontSize: 18),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "RFM Segment Dağılımı",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Sol taraf: Pie chart + segment listesi
                        Expanded(
                          flex: 2,
                          child: Row(
                            children: [
                              // Pie chart alanı
                              Expanded(
                                flex: 2,
                                child: PieChart(
                                  PieChartData(
                                    sectionsSpace: 2,
                                    centerSpaceRadius: 60,
                                    sections: _buildPieSections(),
                                  ),
                                ),
                              ),
                              // Segment istatistikleri
                              Expanded(
                                flex: 1,
                                child: ListView(
                                  children: segmentCounts.entries.map((e) {
                                    return ListTile(
                                      leading: Icon(
                                        Icons.circle,
                                        color: _getColorForSegment(e.key),
                                      ),
                                      title: Text(
                                        e.key,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                        ),
                                      ),
                                      trailing: Text(
                                        e.value.toString(),
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 16,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 30), // 📏 Aradaki boşluk
                        // Sağ taraf: RFM Analizi Raporu
                        Expanded(
                          flex: 3,
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  "RFM Analizi Raporu",
                                  style: TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 20),

                                // 1️.Genel Değerlendirme
                                Text(
                                  "1️. Genel Değerlendirme",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "RFM analizi sonucunda müşteri kitlesi, son sipariş tarihi (Recency), sipariş sıklığı (Frequency) ve toplam harcama (Monetary) değerlerine göre farklı segmentlere ayrılmıştır.",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16,
                                    height: 1.5,
                                  ),
                                ),
                                SizedBox(height: 20),

                                // 2️.Segment Bazlı Bulgular
                                Text(
                                  "2️. Segment Bazlı Bulgular",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "Champions: En değerli müşteriler. Çok sık alışveriş yapar, yakın zamanda işlem yapmıştır ve harcamaları yüksektir. Sadakati sürdürmek için kişisel teklifler önerilir.\n\n"
                                  "Loyal: Sadık ve düzenli müşteriler. Harcamaları ortalamanın üzerindedir. Özel indirim ve ödül programları ile bağlılık artırılabilir.\n\n"
                                  "At Risk: Önceden değerliydi ama uzun süredir işlem yapmadı. Yeniden kazanmak için e-posta ve kampanya hatırlatmaları önerilir.\n\n"
                                  "Need Attention: Potansiyeli olan ancak daha fazla etkileşim gerektiren müşteriler. Çapraz satış fırsatları sunulabilir.\n\n"
                                  "Hibernating: Uzun süredir alışveriş yapmayan, düşük harcama seviyesine sahip müşteriler. Geri kazanma kampanyaları önerilir.",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16,
                                    height: 1.5,
                                  ),
                                ),
                                SizedBox(height: 20),

                                // 3️.Veri Görselleştirme Bulguları
                                Text(
                                  "3️.Veri Görselleştirme Bulguları",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "Segment bazlı Monetary ortalamaları Champions segmentinde en yüksek seviyededir.\n"
                                  "Recency analizi, Hibernating ve At Risk segmentlerinin uzun süredir işlem yapmadığını gösterir.\n"
                                  "Frequency değerleri Loyal ve Champions müşterilerinde oldukça yüksektir.",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16,
                                    height: 1.5,
                                  ),
                                ),
                                SizedBox(height: 20),

                                // 4️.Önerilen Stratejiler
                                Text(
                                  "4️.Önerilen Strateji",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "Champions & Loyal: Sadakat programları ve kişisel teklifler.\n"
                                  "At Risk & Hibernating: Yeniden kazanma kampanyaları ve hedefli reklamlar.\n"
                                  "Need Attention: Sıklığı artırmaya yönelik promosyonlar.",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16,
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  // Pie chart dilimlerini oluşturur
  List<PieChartSectionData> _buildPieSections() {
    if (segmentCounts.isEmpty) return []; // boşsa çizim yapma

    final total = segmentCounts.values.fold(0, (a, b) => a + b);
    return segmentCounts.entries.map((e) {
      final double percentage = total == 0 ? 0 : (e.value / total) * 100;
      return PieChartSectionData(
        color: _getColorForSegment(e.key),
        value: e.value.toDouble(),
        title: "${percentage.toStringAsFixed(1)}%",
        radius: 100,
        titleStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  // Segment ismine göre renk belirler
  Color _getColorForSegment(String segment) {
    switch (segment.toLowerCase()) {
      case 'loyal':
        return Colors.pinkAccent;
      case 'at risk':
        return Colors.deepPurple;
      case 'new':
        return Colors.blueAccent;
      case "hibernating":
        return Colors.orangeAccent;
      case "champions":
        return Colors.teal;
      case "need attention":
        return Colors.blue;
      case 'lost':
        return Colors.redAccent;
      default:
        return Colors.purpleAccent;
    }
  }
}
