import 'package:flutter/material.dart';
import 'package:planeja_facil/screens/fixed_expenses_screen.dart';

class GrossSalaryInputScreen extends StatefulWidget {
  const GrossSalaryInputScreen({super.key});

  @override
  GrossSalaryInputScreenState createState() => GrossSalaryInputScreenState();
}

class GrossSalaryInputScreenState extends State<GrossSalaryInputScreen> {
  final TextEditingController _salarioBrutoController = TextEditingController();

  void _goToNextScreen() {
    final salarioBruto = double.tryParse(_salarioBrutoController.text) ?? 0.0;
    if (salarioBruto > 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FixedExpensesScreen(salarioBruto: salarioBruto),
        ),
      );
    }
  }

  @override
  void dispose() {
    _salarioBrutoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Gestor de Renda',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Qual seu salário bruto mensal?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 40),
            TextField(
              controller: _salarioBrutoController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white, fontSize: 24),
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: 'Digite aqui...',
                hintStyle: TextStyle(color: Colors.white.withAlpha(128)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: Colors.tealAccent),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
              ),
            ),
            const SizedBox(height: 50),
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
