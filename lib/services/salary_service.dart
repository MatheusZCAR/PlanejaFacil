import 'dart:convert';
import 'package:http/http.dart' as http;

class SalaryService {
  static const String baseUrl = 'http://192.168.0.95:3000/api';

  Future<Map<String, dynamic>> calculateSalary(double grossSalary) async {
    try {
      print('Calculando salário para: $grossSalary');
      
      final response = await http.post(
        Uri.parse('$baseUrl/salary/calculate'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'grossSalary': grossSalary,
        }),
      );

      print('Resposta do servidor: ${response.body}');
      print('Status code: ${response.statusCode}');

      final data = jsonDecode(response.body);
      
      if (response.statusCode == 200) {
        return {
          'success': true,
          'grossSalary': data['grossSalary'],
          'deductions': data['deductions'],
          'netSalary': data['netSalary'],
          'details': data['details'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Erro ao calcular salário',
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