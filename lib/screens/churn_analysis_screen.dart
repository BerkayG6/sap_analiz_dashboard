import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';
import 'package:fl_chart/fl_chart.dart';

class ChurnAnalysisScreen extends StatefulWidget {
  const ChurnAnalysisScreen({super.key});

  @override
  State<ChurnAnalysisScreen> createState() => _ChurnAnalysisScreenState();
}

class _ChurnAnalysisScreenState extends State<ChurnAnalysisScreen> {
  List<List<dynamic>> _data = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCsvData();
  }

  Future<void> _loadCsvData() async {
    final rawData = await rootBundle.loadString("assets/churn_df.csv");
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
                      "Müşteri Kayıp (Churn) Analizi",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 30),

                    /// Line Chart – Churn Rate (%)
                    const SizedBox(height: 40),

                    /// Bar Chart – Lost Count
                    const Text(
                      "Yıllara Göre Kayıp Müşteri Sayısı",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 300,
                      child: BarChart(
                        BarChartData(
                          borderData: FlBorderData(show: false),
                          gridData: FlGridData(show: false),
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
                                  // Aynı şekilde yalnızca 1 kez yıl yazdır
                                  if (value % 1 == 0 &&
                                      value.toInt() < _data.length) {
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        _data[value.toInt()][0].toString(),
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 12,
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
                            int lostCount = (entry.value[2] as num).toInt();
                            return BarChartGroupData(
                              x: x,
                              barRods: [
                                BarChartRodData(
                                  toY: lostCount.toDouble(),
                                  color: Colors.deepPurpleAccent,
                                  width: 35,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    /// Mini Tablo
                    const Text(
                      "Churn Verileri",
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
                    Text(
                      _generateAnalysisSummary(),
                      style: const TextStyle(
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

  /// Tablo Oluştur
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
          DataColumn(label: Text("Yıl")),
          DataColumn(label: Text("Churn Oranı (%)")),
          DataColumn(label: Text("Kayıp Sayısı")),
          DataColumn(label: Text("Önceki Aktif")),
        ],
        rows: _data.map((row) {
          return DataRow(
            cells: [
              DataCell(Text(row[0].toString())),
              DataCell(Text("${(row[1] as num).toStringAsFixed(2)}%")),
              DataCell(Text(row[2].toString())),
              DataCell(Text(row[3].toString())),
            ],
          );
        }).toList(),
      ),
    );
  }

  /// Analiz Özeti
  String _generateAnalysisSummary() {
    // En yüksek ve en düşük churn yılını bul
    _data.sort((a, b) => (a[1] as num).compareTo(b[1] as num));
    final lowest = _data.first;
    final highest = _data.last;

    return "Churn oranı, belirli bir yılda kaybedilen müşteri sayısının bir önceki yıl aktif müşteri sayısına oranıdır. "
        "Formül: Churn Rate = (lost_count / prev_active) × 100.\n\n"
        "${lowest[0]} yılında churn oranı en düşük seviyededir (${(lowest[1] as num).toStringAsFixed(2)}%), "
        "${highest[0]} yılında ise en yüksek seviyeye ulaşmıştır (${(highest[1] as num).toStringAsFixed(2)}%). "
        "Son yıllarda churn oranında dalgalanmalar görülmektedir; bu durum, müşteri bağlılığı stratejilerinin gözden geçirilmesi gerektiğini göstermektedir.";
  }
}
