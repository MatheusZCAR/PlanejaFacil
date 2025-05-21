import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/salary_service.dart';
import 'finance_screen.dart';
import 'percentage_screen.dart';

class GrossSalaryInputScreen extends StatefulWidget {
  const GrossSalaryInputScreen({Key? key}) : super(key: key);

  @override
  _GrossSalaryInputScreenState createState() => _GrossSalaryInputScreenState();
}

class _GrossSalaryInputScreenState extends State<GrossSalaryInputScreen> {
  final _formKey = GlobalKey<FormState>();
  final _salaryController = TextEditingController();
  final _salaryService = SalaryService();
  bool _isLoading = false;
  String? _errorMessage;
  Map<String, dynamic>? _result;

  Future<void> _calculateSalary() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _result = null;
    });

    try {
      final grossSalary = double.parse(_salaryController.text.replaceAll(',', '.'));
      final result = await _salaryService.calculateSalary(grossSalary);

      if (result['success']) {
        setState(() {
          _result = result;
        });

        // Navegar para a tela de finanças após o cálculo
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FinanceScreen(
                netSalary: result['netSalary'],
              ),
            ),
          );
        }
      } else {
        setState(() {
          _errorMessage = result['message'];
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Erro ao calcular salário: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _navigateToPercentages() {
    if (_result != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PercentageScreen(
            netSalary: _result!['netSalary'],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cálculo de Salário'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _salaryController,
                decoration: const InputDecoration(
                  labelText: 'Salário Bruto',
                  prefixText: 'R\$ ',
                  border: OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9,.]')),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o salário bruto';
                  }
                  final salary = double.tryParse(value.replaceAll(',', '.'));
                  if (salary == null || salary <= 0) {
                    return 'Salário inválido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ElevatedButton(
                onPressed: _isLoading ? null : _calculateSalary,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Calcular'),
              ),
              if (_result != null) ...[
                const SizedBox(height: 32),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Resultado do Cálculo',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildResultRow(
                          'Salário Bruto',
                          _result!['grossSalary'],
                          Colors.blue,
                        ),
                        _buildResultRow(
                          'INSS',
                          _result!['deductions']['inss'],
                          Colors.red,
                        ),
                        _buildResultRow(
                          'IRRF',
                          _result!['deductions']['irrf'],
                          Colors.red,
                        ),
                        const Divider(),
                        _buildResultRow(
                          'Salário Líquido',
                          _result!['netSalary'],
                          Colors.green,
                          isBold: true,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Percentuais',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildPercentageRow(
                          'INSS',
                          _result!['details']['inssPercentage'],
                        ),
                        _buildPercentageRow(
                          'IRRF',
                          _result!['details']['irrfPercentage'],
                        ),
                        _buildPercentageRow(
                          'Líquido',
                          _result!['details']['netPercentage'],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _navigateToPercentages,
                                child: const Text('Distribuir Percentuais'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultRow(String label, double value, Color color, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            'R\$ ${value.toStringAsFixed(2)}',
            style: TextStyle(
              color: color,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPercentageRow(String label, double percentage) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text('${percentage.toStringAsFixed(2)}%'),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _salaryController.dispose();
    super.dispose();
  }
}
