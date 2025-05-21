import 'dart:convert';
import 'package:http/http.dart' as http;

class FinanceService {
  static const String baseUrl = 'http://192.168.0.95:3000/api';

  Future<Map<String, dynamic>> calculateFinances(double netSalary, List<Map<String, dynamic>> expenses) async {
    try {
      print('Calculando finanças para salário: $netSalary');
      print('Despesas: $expenses');
      
      final response = await http.post(
        Uri.parse('$baseUrl/finance/calculate'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'netSalary': netSalary,
          'expenses': expenses,
        }),
      );

      print('Resposta do servidor: ${response.body}');
      print('Status code: ${response.statusCode}');

      final data = jsonDecode(response.body);
      
      if (response.statusCode == 200) {
        return {
          'success': true,
          'summary': data['summary'],
          'categories': data['categories'],
          'recommendations': data['recommendations'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Erro ao calcular finanças',
        };
      }
    } catch (e) {
      print('Erro na requisição: $e');
      return {
        'success': false,
        'message': 'Erro ao conectar com o servidor: $e',
      };
    }
  }
} 