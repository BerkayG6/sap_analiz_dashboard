import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';
import 'package:fl_chart/fl_chart.dart';

class CityOrdersScreen extends StatefulWidget {
  const CityOrdersScreen({super.key});

  @override
  State<CityOrdersScreen> createState() => _CityOrdersScreenState();
}

class _CityOrdersScreenState extends State<CityOrdersScreen> {
  List<List<dynamic>> _data = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCsvData();
  }

  Future<void> _loadCsvData() async {
    final rawData = await rootBundle.loadString("assets/city_orders.csv");
    List<List<dynamic>> csvTable = const CsvToListConverter().convert(rawData);

    // Başlık satırını kaldır
    csvTable.removeAt(0);

    setState(() {
      _data = csvTable;
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
                      "Bölgesel Müşteri Dağılımı",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 30),

                    /// Bar Chart – Eyaletlere Göre Müşteri Sayısı
                    const Text(
                      "Eyaletlere Göre Müşteri Sayısı",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 400,
                      child: BarChart(
                        BarChartData(
                          gridData: FlGridData(show: false),
                          borderData: FlBorderData(show: false),
                          titlesData: FlTitlesData(
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  if (value.toInt() < _data.length) {
                                    return Transform.rotate(
                                      angle: -0.7, // dikey yazı için eğ
                                      child: Text(
                                        _data[value.toInt()][1].toString(),
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 10,
                                        ),
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
                          barGroups: _data.asMap().entries.map((entry) {
                            int x = entry.key;
                            double count = (entry.value[2] as num).toDouble();
                            return BarChartGroupData(
                              x: x,
                              barRods: [
                                BarChartRodData(
                                  toY: count,
                                  color: Colors.deepPurpleAccent,
                                  width: 20,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    /// Tablo – Detaylı Müşteri Dağılımı
                    const Text(
                      "Müşteri Dağılımı Tablosu",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildDataTable(),

                    const SizedBox(height: 40),

                    /// Analiz Özeti
                    const Text(
                      "Analiz Özeti",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Müşteri dağılımı incelendiğinde, en yüksek yoğunluk Georgia (8 müşteri) ve California (6 müşteri) eyaletlerinde görülmektedir. "
                      "Müşterilerin büyük bölümü ABD'nin doğu yakasında ve güney eyaletlerinde yoğunlaşmıştır. "
                      "Kanada (AB) ve Almanya (SN) gibi bölgelerde yalnızca 1'er müşteri bulunmaktadır; bu bölgeler gelecekte büyüme potansiyeli taşımaktadır. "
                      "Ayrıca müşteri sayısı 1 olan çok sayıda eyalet vardır; bu da müşteri kazanım stratejisinin bu bölgelerde güçlendirilmesi gerektiğini göstermektedir.",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  /// Tablo oluştur
  Widget _buildDataTable() {
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
          DataColumn(label: Text("Ülke/Bölge")),
          DataColumn(label: Text("İl")),
          DataColumn(label: Text("Müşteri Sayısı")),
        ],
        rows: _data.map((row) {
          return DataRow(
            cells: [
              DataCell(Text(row[0].toString())),
              DataCell(Text(row[1].toString())),
              DataCell(Text(row[2].toString())),
            ],
          );
        }).toList(),
      ),
    );
  }
}
