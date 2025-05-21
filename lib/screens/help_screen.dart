import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajuda'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildHelpSection(
            'Como usar o aplicativo',
            'O Planeja Fácil é uma ferramenta para ajudar no planejamento financeiro. '
            'Siga os passos abaixo para começar:',
            [
              '1. Faça login com suas credenciais',
              '2. Insira seu salário bruto',
              '3. Visualize os cálculos de impostos e descontos',
              '4. Acompanhe seu salário líquido',
            ],
          ),
          const SizedBox(height: 24),
          _buildHelpSection(
            'Cálculos realizados',
            'O aplicativo realiza os seguintes cálculos:',
            [
              '• INSS (Instituto Nacional do Seguro Social)',
              '• IRRF (Imposto de Renda Retido na Fonte)',
              '• Salário Líquido',
            ],
          ),
          const SizedBox(height: 24),
          _buildHelpSection(
            'Dúvidas frequentes',
            'Respostas para as principais dúvidas:',
            [
              'Q: Como são calculados os impostos?',
              'R: Os cálculos seguem as tabelas oficiais do governo.',
              '',
              'Q: Os valores são atualizados automaticamente?',
              'R: Sim, sempre que houver alterações nas tabelas.',
            ],
          ),
          const SizedBox(height: 24),
          _buildHelpSection(
            'Contato',
            'Precisa de mais ajuda? Entre em contato:',
            [
              'Email: suporte@planejafacil.com',
              'Telefone: (11) 1234-5678',
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHelpSection(String title, String description, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          description,
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 16),
        ...items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                item,
                style: const TextStyle(fontSize: 16),
              ),
            )),
      ],
    );
  }
} 