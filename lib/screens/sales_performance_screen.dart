import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';
import 'package:fl_chart/fl_chart.dart';

class SalesPerformanceScreen extends StatefulWidget {
  const SalesPerformanceScreen({super.key});

  @override
  State<SalesPerformanceScreen> createState() => _SalesPerformanceScreenState();
}

class _SalesPerformanceScreenState extends State<SalesPerformanceScreen> {
  List<List<dynamic>> _salesData = [];

  @override
  void initState() {
    super.initState();
    _loadCsvData();
  }

  Future<void> _loadCsvData() async {
    final rawData = await rootBundle.loadString("assets/yillik_satis.csv");
    List<List<dynamic>> csvTable = const CsvToListConverter().convert(rawData);

    // Başlık satırını çıkarıyoruz
    csvTable.removeAt(0);

    setState(() {
      _salesData = csvTable;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: _salesData.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Yıllık Satış Performansı",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Grafik
                  SizedBox(
                    height: 600,
                    child: BarChart(
                      BarChartData(
                        gridData: FlGridData(
                          show: true,
                          drawHorizontalLine: true,
                          getDrawingHorizontalLine: (value) =>
                              FlLine(color: Colors.white12, strokeWidth: 1),
                        ),
                        borderData: FlBorderData(show: false),

                        // Eksen ayarları
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 45,
                              getTitlesWidget: (value, meta) => Text(
                                "${value ~/ 1000000}M",
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: false, // Sağ ekseni kapattık
                            ),
                          ),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                if (value.toInt() >= _salesData.length) {
                                  return const SizedBox.shrink();
                                }
                                return Text(
                                  _salesData[value.toInt()][0].toString(),
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),

                        // Bar verileri
                        barGroups: _salesData.asMap().entries.map((entry) {
                          int index = entry.key;
                          double value = entry.value[1].toDouble();
                          return BarChartGroupData(
                            x: index,
                            barRods: [
                              BarChartRodData(
                                toY: value,
                                color: Colors.deepPurpleAccent,
                                width: 30,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ],
                          );
                        }).toList(),

                        // Y ekseni min / max aralığı
                        minY: 0,
                        maxY: _getMaxYValue(),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Sonuç yorumu
                  const Text(
                    "Analiz Özeti",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "• 2019 ve 2020 yıllarında satışlarda olağanüstü artış gözlemlendi.\n"
                    "• 2021 sonrası satışlar tekrar ortalama seviyelere düştü.\n"
                    "• 2022 ve 2023 yıllarında satışlar nispeten istikrarlı ancak düşük kaldı.\n"
                    "• Bu grafik, stratejik planlama ve yeni müşteri kazanımı için kritik yılları açıkça gösterir.",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  /// Y ekseni için maksimum değeri hesapla (grafiğin üst sınırını biraz yukarı alır)
  double _getMaxYValue() {
    if (_salesData.isEmpty) return 0;
    final maxVal = _salesData
        .map((e) => e[1] as num)
        .reduce((a, b) => a > b ? a : b);
    return maxVal * 1.1; // %10 yukarı taşıyarak üstte boşluk bırakır
  }
}
