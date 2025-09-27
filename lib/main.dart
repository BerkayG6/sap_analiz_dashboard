import 'package:flutter/material.dart';
import 'package:sap_analiz_dashboard/screens/churn_analysis_screen.dart';
import 'package:sap_analiz_dashboard/screens/city_orders_screen.dart';
import 'package:sap_analiz_dashboard/screens/customer_analysis_screen.dart';
import 'package:sap_analiz_dashboard/screens/sales_performance_screen.dart';
import 'screens/home_screen.dart';
import 'screens/rfm_chart_screen.dart';
import 'screens/rfm_table_screen.dart';
import 'widgets/side_menu.dart';

void main() {
  runApp(const SapAnalizDashboard());
}

class SapAnalizDashboard extends StatelessWidget {
  const SapAnalizDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SAP Analiz Dashboard',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF121212),
        primaryColor: Colors.deepPurple,
        colorScheme: const ColorScheme.dark(
          primary: Colors.deepPurple,
          secondary: Colors.deepPurpleAccent,
        ),
      ),
      home: const MainLayout(), // Artık burası ana giriş noktası!
    );
  }
}

/// Ana Layout – Sidebar + Sayfalar
class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  // Sayfa listesi
  final List<Widget> _pages = const [
    HomeScreen(),
    SalesPerformanceScreen(),
    CustomerAnalysisScreen(),
    ChurnAnalysisScreen(),
    CityOrdersScreen(),
    RfmChartScreen(),
    RfmTableScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sol sabit menü
          SideMenu(
            selectedIndex: _selectedIndex,
            onItemSelected: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),

          // Sağ taraf: seçili sayfa içeriği
          Expanded(child: _pages[_selectedIndex]),
        ],
      ),
    );
  }
}
