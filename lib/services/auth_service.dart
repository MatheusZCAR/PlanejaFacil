import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  // Usando o IP local da sua máquina
  static const String baseUrl = 'http://192.168.0.95:3000/api';

  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      print('Tentando login com: $username e $password');
      print('URL da requisição: $baseUrl/auth/login');
      
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      print('Resposta do servidor: ${response.body}');
      print('Status code: ${response.statusCode}');

      final data = jsonDecode(response.body);
      
      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': data['message'],
          'user': data['user'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Erro ao fazer login',
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