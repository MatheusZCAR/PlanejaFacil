import 'package:flutter/material.dart';
import '../models/gasto_fixo.dart';
import 'percentages_input_screen.dart';

class FixedExpensesScreen extends StatefulWidget {
  final double salarioBruto;

  const FixedExpensesScreen({super.key, required this.salarioBruto});

  @override
  FixedExpensesScreenState createState() => FixedExpensesScreenState();
}

class FixedExpensesScreenState extends State<FixedExpensesScreen> {
  final TextEditingController _gastoNomeController = TextEditingController();
  final TextEditingController _gastoValorController = TextEditingController();

  final List<GastoFixo> _gastosFixos = [];

  void _adicionarGastoFixo() {
    final nome = _gastoNomeController.text;
    final valor = double.tryParse(_gastoValorController.text) ?? 0.0;
    if (nome.isNotEmpty && valor > 0) {
      setState(() {
        _gastosFixos.add(GastoFixo(nome: nome, valor: valor));
        _gastoNomeController.clear();
        _gastoValorController.clear();
      });
    }
  }

  void _goToNextScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => PercentagesInputScreen(
              salarioBruto: widget.salarioBruto,
              gastosFixos: _gastosFixos,
            ),
      ),
    );
  }

  @override
  void dispose() {
    _gastoNomeController.dispose();
    _gastoValorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Gastos Fixos',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Quais são seus gastos fixos?',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _gastoNomeController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Nome do Gasto',
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
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 1,
                  child: TextField(
                    controller: _gastoValorController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Valor (R\$)',
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
                ),
                const SizedBox(width: 10),
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _adicionarGastoFixo,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.tealAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    child: const Icon(Icons.add, color: Colors.black),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _gastosFixos.length,
                itemBuilder: (context, index) {
                  final gasto = _gastosFixos[index];
                  return ListTile(
                    title: Text(
                      gasto.nome,
                      style: const TextStyle(color: Colors.white),
                    ),
                    trailing: Text(
                      'R\$ ${gasto.valor.toStringAsFixed(2)}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _goToNextScreen,
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
                'Próximo',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
