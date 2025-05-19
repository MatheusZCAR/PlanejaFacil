import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

class ResultScreen extends StatelessWidget {
  final double salarioBruto;
  final double impostoRenda;
  final double totalGastosFixos;
  final double salarioLiquido;
  final double valorInvestir;
  final double valorLazer;
  final double saldoFinal;

  const ResultScreen({
    super.key,
    required this.salarioBruto,
    required this.impostoRenda,
    required this.totalGastosFixos,
    required this.salarioLiquido,
    required this.valorInvestir,
    required this.valorLazer,
    required this.saldoFinal,
  });

  String _formatCurrency(double value) {
    final format = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    return format.format(value);
  }

  List<PieChartSectionData> showingSections(double total) {
    return [
      PieChartSectionData(
        color: Colors.redAccent,
        value: (impostoRenda / total) * 100,
        title: '${(impostoRenda / total * 100).toStringAsFixed(1)}%',
        radius: 50,
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      PieChartSectionData(
        color: Colors.orangeAccent,
        value: (totalGastosFixos / total) * 100,
        title: '${(totalGastosFixos / total * 100).toStringAsFixed(1)}%',
        radius: 50,
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      PieChartSectionData(
        color: Colors.blueAccent,
        value: (valorInvestir / salarioLiquido) * 100,
        title: '${(valorInvestir / salarioLiquido * 100).toStringAsFixed(1)}%',
        radius: 50,
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      PieChartSectionData(
        color: Colors.purpleAccent,
        value: (valorLazer / salarioLiquido) * 100,
        title: '${(valorLazer / salarioLiquido * 100).toStringAsFixed(1)}%',
        radius: 50,
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      PieChartSectionData(
        color: Colors.greenAccent,
        value: (saldoFinal / salarioLiquido) * 100,
        title: '${(saldoFinal / salarioLiquido * 100).toStringAsFixed(1)}%',
        radius: 50,
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    double totalParaGrafico =
        impostoRenda +
        totalGastosFixos +
        valorInvestir +
        valorLazer +
        saldoFinal;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Resumo Financeiro Mensal',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ListView(
          children: [
            Text(
              'Seu resumo financeiro:',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: showingSections(totalParaGrafico),
                  centerSpaceRadius: 40,
                  sectionsSpace: 2,
                  borderData: FlBorderData(show: false),
                ),
              ),
            ),
            const SizedBox(height: 40),
            _buildResultRow('Salário Bruto', salarioBruto),
            _buildResultRow('Imposto de Renda', impostoRenda),
            _buildResultRow('Total de Gastos Fixos', totalGastosFixos),
            const Divider(color: Colors.white38),
            _buildResultRow('Salário Líquido', salarioLiquido, isBold: true),
            const Divider(color: Colors.white38),
            _buildResultRow('Valor para Investir', valorInvestir),
            _buildResultRow('Valor para Lazer', valorLazer),
            const Divider(color: Colors.white38),
            _buildResultRow('Saldo Final', saldoFinal, isBold: true),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.tealAccent,
                padding: const EdgeInsets.symmetric(vertical: 15),
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Calcular Novamente',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultRow(String label, double value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: Colors.white,
            ),
          ),
          Text(
            _formatCurrency(value),
            style: TextStyle(
              fontSize: 16,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: value < 0 && isBold ? Colors.redAccent : Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
