import 'package:flutter/material.dart';
import '../services/data_service.dart';

class RfmTableScreen extends StatefulWidget {
  const RfmTableScreen({super.key});

  @override
  State<RfmTableScreen> createState() => _RfmTableScreenState();
}

class _RfmTableScreenState extends State<RfmTableScreen> {
  bool _isLoading = true;
  List<RfmRecord> _records = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final records = await DataService.loadRfmData();

    if (!mounted) return; // ekranda değilse setState çağırma

    setState(() {
      _records = records;
      _isLoading = false;
    });
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _records.isEmpty
          ? const Center(
              child: Text(
                "Tabloda görüntülenecek veri bulunamadı.",
                style: TextStyle(color: Colors.white70, fontSize: 18),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // TABLO KISMI (Sol taraf)
                  Expanded(
                    flex: 3,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          headingRowColor: MaterialStateProperty.all(
                            Colors.deepPurple.withOpacity(0.3),
                          ),
                          dataRowColor: MaterialStateProperty.all(
                            Colors.white10,
                          ),
                          columnSpacing: 30,
                          columns: const [
                            DataColumn(
                              label: Text(
                                "Müşteri",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                "R",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                "F",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                "M",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                "Toplam",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                "Segment",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                          rows: _records.map((record) {
                            return DataRow(
                              cells: [
                                DataCell(
                                  Text(
                                    record.customer,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    record.r.toString(),
                                    style: const TextStyle(
                                      color: Colors.white70,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    record.f.toString(),
                                    style: const TextStyle(
                                      color: Colors.white70,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    record.m.toString(),
                                    style: const TextStyle(
                                      color: Colors.white70,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    record.total.toString(),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    record.segment,
                                    style: TextStyle(
                                      color: _getSegmentColor(record.segment),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),

                  //const SizedBox(width: 0), // tablo ile açıklama arası boşluk
                  //AÇIKLAMA KISMI (Sağ taraf)
                  Expanded(
                    flex: 7,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "RFM Skorlaması Açıklaması",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          "RFM analizi üç temel metrikten oluşur:",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "• **Recency (R):** Müşterinin en son alışveriş yapma tarihi. "
                          "Son alışverişi yakınsa yüksek puan alır (5), uzaksa düşük puan (1).\n\n"
                          "• **Frequency (F):** Belirli bir süre içinde yapılan alışveriş sayısı. "
                          "Daha sık alışveriş yapanlar daha yüksek puan alır.\n\n"
                          "• **Monetary (M):** Harcama miktarı. "
                          "Toplam harcama yüksekse daha yüksek puan verilir.",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                            height: 1.5,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          "Toplam RFM skoru (ör. 533) her metrik için 1–5 arasında verilen puanların birleşimidir. "
                          "Bu skorlar müşterilerin segmentlere ayrılmasında kullanılır:",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                            height: 1.5,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          "• Loyal (533, 523 vb.): Sadık ve yüksek değerli müşteriler.\n"
                          "• Need Attention (522, 521 vb.): Yakın zamanda alışveriş yapmış ama tekrar ilgilenilmeli.\n"
                          "• Hibernating (111, 122 vb.): Uzun süredir alışveriş yapmamış düşük değerli müşteriler.",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                            height: 1.6,
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

  // Segment türüne göre renk belirleme
  Color _getSegmentColor(String segment) {
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
