import 'package:finsavvy/core/theme/app_theme.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/consts/dark_color.dart';
import '../widgets/menu_app.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bienvenido!', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 57, 30, 105),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: AppTheme.backgroundColor,
      endDrawer: MenuApp(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildBalanceCard(),
            _buildQuickActions(),
            _buildSpendingChart(),
            _buildRecentTransactions(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBalanceCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: DarkColors.card,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Balance Total',
            style: TextStyle(color: DarkColors.textSecondary),
          ),
          const SizedBox(height: 8),
          Text(
            '\$12,450.00',
            style: TextStyle(
              color: DarkColors.textPrimary,
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildIncomeExpense(
                label: 'Ingresos',
                amount: 1850,
                isIncome: true,
              ),
              _buildIncomeExpense(
                label: 'Gastos',
                amount: 620,
                isIncome: false,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return SizedBox(
      height: 100,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildActionButton(
            icon: Icons.add,
            label: 'Agregar',
            color: DarkColors.primary,
          ),
          _buildActionButton(
            icon: Icons.money,
            label: 'Pagar',
            color: DarkColors.secondary,
          ),
          _buildActionButton(
            icon: Icons.save,
            label: 'Ahorro',
            color: Colors.blue[400]!,
          ),
          _buildActionButton(
            icon: Icons.analytics,
            label: 'Reporte',
            color: Colors.orange[300]!,
          ),
        ],
      ),
    );
  }

  Widget _buildSpendingChart() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: DarkColors.card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Distribución de Gastos',
            style: TextStyle(
              color: DarkColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sections: _buildChartSections(),
                centerSpaceRadius: 40,
                pieTouchData: PieTouchData(
                  touchCallback: (FlTouchEvent event, pieTouchResponse) {},
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentTransactions() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Últimas Transacciones',
            style: TextStyle(
              color: DarkColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: 5,
            separatorBuilder: (_, __) => Divider(
              color: DarkColors.textSecondary.withOpacity(0.1),
              height: 1,
            ),
            itemBuilder: (context, index) => _buildTransactionItem(index),
          ),
          TextButton(
            onPressed: () {},
            child: Text(
              'Ver todas',
              style: TextStyle(color: DarkColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      backgroundColor: DarkColors.card,
      selectedItemColor: DarkColors.primary,
      unselectedItemColor: DarkColors.textSecondary,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
        BottomNavigationBarItem(
          icon: Icon(Icons.analytics),
          label: 'Estadísticas',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
      ],
    );
  }

  // ---------------------------
  // Métodos auxiliares (Dark Mode)
  // ---------------------------

  List<PieChartSectionData> _buildChartSections() {
    return [
      PieChartSectionData(
        color: Colors.purple[300],
        value: 35,
        title: 'Comida',
        radius: 60,
        titleStyle: TextStyle(color: DarkColors.textPrimary, fontSize: 12),
      ),
      PieChartSectionData(
        color: Colors.tealAccent[400],
        value: 25,
        title: 'Transporte',
        radius: 60,
        titleStyle: TextStyle(color: DarkColors.textPrimary, fontSize: 12),
      ),
      PieChartSectionData(
        color: Colors.blue[300],
        value: 20,
        title: 'Entreten.',
        radius: 60,
        titleStyle: TextStyle(color: DarkColors.textPrimary, fontSize: 12),
      ),
      PieChartSectionData(
        color: Colors.orange[300],
        value: 15,
        title: 'Servicios',
        radius: 60,
        titleStyle: TextStyle(color: DarkColors.textPrimary, fontSize: 12),
      ),
    ];
  }

  Widget _buildIncomeExpense({
    required String label,
    required double amount,
    required bool isIncome,
  }) {
    return Column(
      children: [
        Text(label, style: TextStyle(color: DarkColors.textSecondary)),
        Text(
          '\$${amount.toStringAsFixed(2)}',
          style: TextStyle(
            color: isIncome ? Colors.green[300] : Colors.red[300],
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(12),
            child: Icon(icon, color: color),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(color: DarkColors.textSecondary, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(int index) {
    final categories = ['Comida', 'Transporte', 'Salario', 'Entretenimiento'];
    final icons = [
      Icons.restaurant,
      Icons.directions_car,
      Icons.work,
      Icons.movie,
    ];
    final colors = [
      Colors.purple[300]!,
      Colors.tealAccent[400]!,
      Colors.blue[300]!,
      Colors.orange[300]!,
    ];
    final amounts = [15.99, 42.50, 1200.00, 8.99];

    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: colors[index % colors.length].withOpacity(0.2),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icons[index % icons.length],
          color: colors[index % colors.length],
        ),
      ),
      title: Text(
        categories[index % categories.length],
        style: TextStyle(color: DarkColors.textPrimary),
      ),
      subtitle: Text(
        '${DateTime.now().day}/06/2024',
        style: TextStyle(color: DarkColors.textSecondary),
      ),
      trailing: Text(
        '\$${amounts[index % amounts.length].toStringAsFixed(2)}',
        style: TextStyle(
          color: index.isEven ? Colors.red[300] : Colors.green[300],
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
