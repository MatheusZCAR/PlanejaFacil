import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/percentage_service.dart';

class PercentageScreen extends StatefulWidget {
  final double netSalary;

  const PercentageScreen({
    Key? key,
    required this.netSalary,
  }) : super(key: key);

  @override
  _PercentageScreenState createState() => _PercentageScreenState();
}

class _PercentageScreenState extends State<PercentageScreen> {
  final _formKey = GlobalKey<FormState>();
  final _percentageService = PercentageService();
  final _categoryController = TextEditingController();
  final _percentageController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  Map<String, dynamic>? _result;
  final List<Map<String, dynamic>> _percentages = [];

  Future<void> _calculatePercentages() async {
    if (_percentages.isEmpty) {
      setState(() {
        _errorMessage = 'Adicione pelo menos uma categoria';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _result = null;
    });

    try {
      final result = await _percentageService.calculatePercentages(
        widget.netSalary,
        _percentages,
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
        _errorMessage = 'Erro ao calcular percentuais: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _addPercentage() {
    if (!_formKey.currentState!.validate()) return;

    final percentage = double.parse(_percentageController.text.replaceAll(',', '.'));
    final category = _categoryController.text.trim();

    // Verificar se a soma dos percentuais não excede 100%
    final currentTotal = _percentages.fold<double>(
      0,
      (sum, p) => sum + (p['percentage'] as double),
    );

    if (currentTotal + percentage > 100) {
      setState(() {
        _errorMessage = 'A soma dos percentuais não pode exceder 100%';
      });
      return;
    }

    setState(() {
      _percentages.add({
        'category': category,
        'percentage': percentage,
      });
      _categoryController.clear();
      _percentageController.clear();
      _errorMessage = null;
    });
  }

  void _removePercentage(int index) {
    setState(() {
      _percentages.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Distribuição de Percentuais'),
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
                      'Adicionar Categoria',
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
                          TextFormField(
                            controller: _percentageController,
                            decoration: const InputDecoration(
                              labelText: 'Percentual',
                              suffixText: '%',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'[0-9,.]')),
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, insira o percentual';
                              }
                              final percentage = double.tryParse(value.replaceAll(',', '.'));
                              if (percentage == null || percentage <= 0 || percentage > 100) {
                                return 'Percentual inválido';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _addPercentage,
                            child: const Text('Adicionar Categoria'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (_percentages.isNotEmpty) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Categorias Adicionadas',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _percentages.length,
                        itemBuilder: (context, index) {
                          final percentage = _percentages[index];
                          return ListTile(
                            title: Text(percentage['category']),
                            subtitle: Text('${percentage['percentage']}%'),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => _removePercentage(index),
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
              onPressed: _isLoading ? null : _calculatePercentages,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Calcular Distribuição'),
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
                        'Resumo da Distribuição',
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
                        'Total Alocado',
                        _result!['summary']['totalAllocated'],
                        Colors.green,
                      ),
                      _buildSummaryRow(
                        'Valor Restante',
                        _result!['summary']['remainingValue'],
                        Colors.orange,
                      ),
                      const Divider(),
                      const Text(
                        'Categorias',
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
                              : Colors.blue.shade100,
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
    _categoryController.dispose();
    _percentageController.dispose();
    super.dispose();
  }
} 