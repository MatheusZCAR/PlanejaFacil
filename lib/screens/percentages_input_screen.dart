import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/gasto_fixo.dart';
import '../utils/irpf_calculator.dart';
import 'result_screen.dart';

class PercentagesInputScreen extends StatefulWidget {
  final double salarioBruto;
  final List<GastoFixo> gastosFixos;

  const PercentagesInputScreen({
    super.key,
    required this.salarioBruto,
    required this.gastosFixos,
  });

  @override
  PercentagesInputScreenState createState() => PercentagesInputScreenState();
}

class PercentagesInputScreenState extends State<PercentagesInputScreen> {
  final TextEditingController _percentInvestimentoController =
      TextEditingController();
  final TextEditingController _percentLazerController = TextEditingController();

  void _calcularFinancas() {
    final percentInvestimento =
        double.tryParse(_percentInvestimentoController.text) ?? 0.0;
    final percentLazer = double.tryParse(_percentLazerController.text) ?? 0.0;

    if (percentInvestimento + percentLazer > 100) {
      // Mostrar um alerta ou mensagem de erro para o usuário
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'A soma dos percentuais de investimento e lazer não pode ultrapassar 100%.',
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final imposto = calcularIRPF(widget.salarioBruto);
    final somaGastosFixos = widget.gastosFixos.fold(
      0.0,
      (sum, gasto) => sum + gasto.valor,
    );
    final salarioLiquido = widget.salarioBruto - imposto - somaGastosFixos;
    final valorInvestir = salarioLiquido * (percentInvestimento / 100);
    final valorLazer = salarioLiquido * (percentLazer / 100);
    final saldoFinal = salarioLiquido - valorInvestir - valorLazer;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => ResultScreen(
              salarioBruto: widget.salarioBruto,
              impostoRenda: imposto,
              totalGastosFixos: somaGastosFixos,
              salarioLiquido: salarioLiquido,
              valorInvestir: valorInvestir,
              valorLazer: valorLazer,
              saldoFinal: saldoFinal,
            ),
      ),
    );
  }

  @override
  void dispose() {
    _percentInvestimentoController.dispose();
    _percentLazerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Percentuais', style: TextStyle(color: Colors.white)),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Digite o percentual para investimento e o percentual para lazer',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 40),
            TextField(
              controller: _percentInvestimentoController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: const TextStyle(color: Colors.white, fontSize: 20),
              decoration: InputDecoration(
                labelText: 'Percentual para Investimento (%)',
                labelStyle: TextStyle(color: Colors.white.withAlpha(178)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: Colors.tealAccent),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _percentLazerController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: const TextStyle(color: Colors.white, fontSize: 20),
              decoration: InputDecoration(
                labelText: 'Percentual para Lazer (%)',
                labelStyle: TextStyle(color: Colors.white.withAlpha(178)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: Colors.tealAccent),
                ),
              ),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: _calcularFinancas,
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
                'Calcular',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
