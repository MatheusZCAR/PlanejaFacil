import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/finance_service.dart';

class FinanceScreen extends StatefulWidget {
  final double netSalary;

  const FinanceScreen({
    Key? key,
    required this.netSalary,
  }) : super(key: key);

  @override
  _FinanceScreenState createState() => _FinanceScreenState();
}

class _FinanceScreenState extends State<FinanceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _financeService = FinanceService();
  final _expenseController = TextEditingController();
  final _categoryController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  Map<String, dynamic>? _result;
  final List<Map<String, dynamic>> _expenses = [];

  Future<void> _calculateFinances() async {
    if (_expenses.isEmpty) {
      setState(() {
        _errorMessage = 'Adicione pelo menos uma despesa';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _result = null;
    });

    try {
      final result = await _financeService.calculateFinances(
        widget.netSalary,
        _expenses,
      );

      if (result['success']) {
        setState(() {
          _result = result;
        });
      } else {
        setState(() {
          _errorMessage = result['message'];
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Erro ao calcular finanças: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _addExpense() {
    if (!_formKey.currentState!.validate()) return;

    final value = double.parse(_expenseController.text.replaceAll(',', '.'));
    final category = _categoryController.text.trim();

    setState(() {
      _expenses.add({
        'value': value,
        'category': category,
      });
      _expenseController.clear();
      _categoryController.clear();
    });
  }

  void _removeExpense(int index) {
    setState(() {
      _expenses.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Finanças'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Adicionar Despesa',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _expenseController,
                            decoration: const InputDecoration(
                              labelText: 'Valor',
                              prefixText: 'R\$ ',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'[0-9,.]')),
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, insira o valor';
                              }
                              final expense = double.tryParse(value.replaceAll(',', '.'));
                              if (expense == null || expense <= 0) {
                                return 'Valor inválido';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _categoryController,
                            decoration: const InputDecoration(
                              labelText: 'Categoria',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, insira a categoria';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _addExpense,
                            child: const Text('Adicionar Despesa'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (_expenses.isNotEmpty) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Despesas Adicionadas',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _expenses.length,
                        itemBuilder: (context, index) {
                          final expense = _expenses[index];
                          return ListTile(
                            title: Text(expense['category']),
                            subtitle: Text('R\$ ${expense['value'].toStringAsFixed(2)}'),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => _removeExpense(index),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ElevatedButton(
              onPressed: _isLoading ? null : _calculateFinances,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Calcular Finanças'),
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
                        'Resumo Financeiro',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildSummaryRow(
                        'Salário Líquido',
                        _result!['summary']['netSalary'],
                        Colors.blue,
                      ),
                      _buildSummaryRow(
                        'Total de Despesas',
                        _result!['summary']['totalExpenses'],
                        Colors.red,
                      ),
                      _buildSummaryRow(
                        'Poupança',
                        _result!['summary']['savings'],
                        Colors.green,
                        isBold: true,
                      ),
                      const Divider(),
                      const Text(
                        'Categorias de Despesas',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ..._result!['categories'].map<Widget>((category) {
                        return _buildCategoryRow(
                          category['category'],
                          category['value'],
                          category['percentage'],
                        );
                      }).toList(),
                      const SizedBox(height: 16),
                      const Text(
                        'Recomendações',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ..._result!['recommendations'].map<Widget>((recommendation) {
                        return Card(
                          color: recommendation['type'] == 'warning'
                              ? Colors.orange.shade100
                              : Colors.green.shade100,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(recommendation['message']),
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, double value, Color color, {bool isBold = false}) {
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

  Widget _buildCategoryRow(String category, double value, double percentage) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(category),
          ),
          Text(
            'R\$ ${value.toStringAsFixed(2)} (${percentage.toStringAsFixed(1)}%)',
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _expenseController.dispose();
    _categoryController.dispose();
    super.dispose();
  }
} 