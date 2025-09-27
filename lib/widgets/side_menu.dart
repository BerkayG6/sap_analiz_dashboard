import 'package:flutter/material.dart';

class SideMenu extends StatelessWidget {
  final int selectedIndex; // Hangi sayfanın aktif olduğunu takip eder
  final Function(int)
  onItemSelected; // Tıklanınca index'i güncellemek için callback

  const SideMenu({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220, // Sol menünün genişliği
      color: const Color(0xFF1E1E1E), // Koyu gri arka plan
      child: Column(
        children: [
          const SizedBox(height: 40),

          // 🏷Başlık
          const Text(
            "SAP ANALİZ",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 40),

          // Menü öğesi 1: RFM Segmentleri
          _buildMenuItem(icon: Icons.home, label: "Ana Sayfa", index: 0),
          _buildMenuItem(
            icon: Icons.bar_chart,
            label: "Satış Performansı",
            index: 1,
          ),
          _buildMenuItem(
            icon: Icons.people,
            label: "Müşteri Analizi",
            index: 2,
          ),
          _buildMenuItem(
            icon: Icons.pie_chart,
            label: "Churn Analizi ",
            index: 3,
          ),
          _buildMenuItem(
            icon: Icons.pie_chart,
            label: "Bölgesel Dağılım",
            index: 4,
          ),
          _buildMenuItem(
            icon: Icons.table_chart,
            label: "RFM Segmentleri",
            index: 5,
          ),

          _buildMenuItem(
            icon: Icons.table_chart,
            label: "RFM Skor Tablosu",
            index: 6,
          ),

          const Spacer(),

          // 👤 Footer / versiyon bilgisi
          const Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: Text(
              "v1.0.0",
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  // Menü öğesi oluşturan yardımcı fonksiyon
  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final bool isActive = selectedIndex == index;

    return InkWell(
      onTap: () => onItemSelected(index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        color: isActive
            ? Colors.deepPurple.withOpacity(0.2)
            : Colors.transparent,
        child: Row(
          children: [
            Icon(
              icon,
              color: isActive ? Colors.deepPurpleAccent : Colors.white70,
              size: 22,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.deepPurpleAccent : Colors.white70,
                fontSize: 16,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
