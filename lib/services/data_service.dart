import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class RfmRecord {
  final String customer;
  final int r;
  final int f;
  final int m;
  final int total;
  final String segment;

  RfmRecord({
    required this.customer,
    required this.r,
    required this.f,
    required this.m,
    required this.total,
    required this.segment,
  });

  // CSV'den gelen veriyi modele dönüştüren yardımcı fonksiyon
  factory RfmRecord.fromMap(Map<String, dynamic> map) {
    return RfmRecord(
      customer: map['Müşteri'], // ✅ değişti
      r: int.parse(map['R_Score']),
      f: int.parse(map['F_Score']),
      m: int.parse(map['M_Score']),
      total: int.parse(map['RFM_Skoru']),
      segment: map['Segment'], // ✅ değişti
    );
  }
}

class DataService {
  // CSV dosyasını okuyup List<RfmRecord> döner
  static Future<List<RfmRecord>> loadRfmData() async {
    final csvString = await rootBundle.loadString('assets/rfm_results.csv');

    // Satırları ayır
    final lines = const LineSplitter().convert(csvString);

    // Başlığı (ilk satır) ayır ve sütun adlarını al
    final headers = lines.first.split(',');

    // Geri kalan satırları kayıtlara dönüştür
    final records = <RfmRecord>[];
    for (var i = 1; i < lines.length; i++) {
      final values = lines[i].split(',');
      if (values.length == headers.length) {
        final map = <String, dynamic>{};
        for (var j = 0; j < headers.length; j++) {
          map[headers[j]] = values[j];
        }
        records.add(RfmRecord.fromMap(map));
      }
    }

    return records;
  }
}
