import 'package:flutter/material.dart';
import 'package:sap_analiz_dashboard/screens/churn_analysis_screen.dart';
import 'package:sap_analiz_dashboard/screens/city_orders_screen.dart';
import 'package:sap_analiz_dashboard/screens/customer_analysis_screen.dart';
import '../widgets/side_menu.dart';
import 'home_screen.dart';
import 'rfm_chart_screen.dart';
import 'rfm_table_screen.dart';
import "sales_performance_screen.dart";

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0; // 0 = Ana Sayfa, 1 = Chart, 2 = Table

  // Sayfa değişimini yöneten fonksiyon
  Widget _buildPage() {
    switch (_selectedIndex) {
      case 0:
        return const HomeScreen();
      case 1:
        return const SalesPerformanceScreen();
      case 2:
        return const CustomerAnalysisScreen();
      case 3:
        return const ChurnAnalysisScreen();
      case 4:
        return const CityOrdersScreen();
      case 5:
        return const RfmChartScreen();
      case 6:
        return const RfmTableScreen();
      default:
        return const HomeScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Row(
        children: [
          // 📁 Sol taraf: Side Menu
          SideMenu(
            selectedIndex: _selectedIndex,
            onItemSelected: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),

          // Sağ taraf: Sayfa içeriği
          Expanded(child: _buildPage()),
        ],
      ),
    );
  }
}
