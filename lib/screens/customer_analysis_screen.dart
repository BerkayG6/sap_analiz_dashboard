import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';

class CustomerAnalysisScreen extends StatefulWidget {
  const CustomerAnalysisScreen({super.key});

  @override
  State<CustomerAnalysisScreen> createState() => _CustomerAnalysisScreenState();
}

class _CustomerAnalysisScreenState extends State<CustomerAnalysisScreen> {
  List<List<dynamic>> _data = [];
  Map<String, int> _segmentCounts = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCsvData();
  }

  Future<void> _loadCsvData() async {
    final rawData = await rootBundle.loadString("assets/musteri_analizi.csv");
    List<List<dynamic>> csvTable = const CsvToListConverter().convert(rawData);

    // Başlık satırını çıkar
    csvTable.removeAt(0);

    // Segment sayımını yap
    final segmentCounts = <String, int>{};
    for (var row in csvTable) {
      final segment = row[4].toString();
      segmentCounts[segment] = (segmentCounts[segment] ?? 0) + 1;
    }

    setState(() {
      _data = csvTable;
      _segmentCounts = segmentCounts;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(30.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Müşteri Analizi ve Segmentasyon",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 30),

                    /// Pie Chart – Segment oranları
                    SizedBox(
                      height: 300,
                      child: PieChart(
                        PieChartData(
                          sections: _buildPieSections(),
                          centerSpaceRadius: 50,
                          sectionsSpace: 2,
                        ),
                      ),
                    ),

                    const SizedBox(height: 50),

                    /// Bar Chart – Segment müşteri sayıları
                    SizedBox(
                      height: 400,
                      child: BarChart(
                        BarChartData(
                          borderData: FlBorderData(show: false),
                          gridData: FlGridData(show: false),
                          titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  final keys = _segmentCounts.keys.toList();
                                  if (value.toInt() < keys.length) {
                                    return Text(
                                      keys[value.toInt()],
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 12,
                                      ),
                                    );
                                  }
                                  return const SizedBox.shrink();
                                },
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) => Text(
                                  value.toInt().toString(),
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          barGroups: _segmentCounts.entries
                              .toList()
                              .asMap()
                              .entries
                              .map((entry) {
                                int index = entry.key;
                                String segment = entry.value.key;
                                int count = entry.value.value;

                                return BarChartGroupData(
                                  x: index,
                                  barRods: [
                                    BarChartRodData(
                                      toY: count.toDouble(),
                                      color: _getSegmentColor(segment),
                                      width: 35,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ],
                                );
                              })
                              .toList(),
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    /// İlk 10 müşteri tablosu
                    const Text(
                      "En Önemli 10 Müşteri",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 15),
                    _buildCustomerTable(),

                    const SizedBox(height: 40),

                    /// Yorum / Analiz
                    const Text(
                      "Analiz Özeti",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _generateAnalysisSummary(),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  /// Pie Chart bölümleri
  List<PieChartSectionData> _buildPieSections() {
    final total = _segmentCounts.values.fold(0, (a, b) => a + b);
    return _segmentCounts.entries.map((e) {
      final double percentage = (e.value / total) * 100;
      return PieChartSectionData(
        color: _getSegmentColor(e.key),
        value: e.value.toDouble(),
        title: "${percentage.toStringAsFixed(1)}%",
        radius: 90,
        titleStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  /// Tablo – İlk 10 müşteri
  Widget _buildCustomerTable() {
    final top10 = _data.take(10).toList();

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.deepPurpleAccent.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DataTable(
        headingTextStyle: const TextStyle(
          color: Colors.deepPurpleAccent,
          fontWeight: FontWeight.bold,
        ),
        dataTextStyle: const TextStyle(color: Colors.white70),
        columns: const [
          DataColumn(label: Text("Müşteri Adı")),
          DataColumn(label: Text("Sipariş Sayısı")),
          DataColumn(label: Text("Ortalama Büyüklük")),
          DataColumn(label: Text("Segment")),
        ],
        rows: top10.map((row) {
          return DataRow(
            cells: [
              DataCell(Text(row[0].toString())),
              DataCell(Text(row[1].toString())),
              DataCell(Text(row[3].toStringAsFixed(2))),
              DataCell(Text(row[4].toString())),
            ],
          );
        }).toList(),
      ),
    );
  }

  ///  Analiz özeti oluştur
  String _generateAnalysisSummary() {
    final total = _segmentCounts.values.fold(0, (a, b) => a + b);
    final biggestSegment = _segmentCounts.entries.reduce(
      (a, b) => a.value > b.value ? a : b,
    ); // en yüksek segmenti bulur

    return "Toplam $total müşteri analize dahil edilmiştir. "
        "${biggestSegment.key} segmenti en yüksek paya sahiptir (${biggestSegment.value} müşteri). "
        "Küçük alıcılar yüksek sayıda müşteri içermelerine rağmen toplam sipariş katkıları daha düşüktür. "
        "Segment sınıflandırması, müşterilerin ortalama sipariş büyüklüğüne göre yapılmıştır: "
        "30.000 üzeri ortalamaya sahip müşteriler **Büyük Alıcı**, 10.000–30.000 arası ortalamaya sahip müşteriler **Orta Seviye Alıcı**, "
        "10.000 altındaki ortalamaya sahip müşteriler ise **Küçük Alıcı** olarak sınıflandırılmıştır. "
        "Segmentlere göre farklı stratejiler geliştirerek satış performansı artırılabilir.";
  }

  ///  Segment rengi
  Color _getSegmentColor(String segment) {
    switch (segment) {
      case "Büyük Alıcı":
        return Colors.deepPurpleAccent;
      case "Orta Seviye Alıcı":
        return Colors.teal;
      case "Küçük Alıcı":
        return Colors.pinkAccent;
      default:
        return Colors.grey;
    }
  }

  Color _getColorForSegment(String segment) {
    switch (segment.toLowerCase()) {
      case 'Büyük Alıcı':
        return Colors.deepPurpleAccent;
      case 'Orta Seviye Alıcı':
        return Colors.teal;
      case 'Küçük Alıcı':
        return Colors.pinkAccent;
      default:
        return Colors.purpleAccent;
    }
  }
}
