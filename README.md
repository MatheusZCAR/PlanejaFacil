# Planeja Fácil

Aplicativo Flutter para planejamento financeiro, desenvolvido por alunos da ETEC.

## Funcionalidades

- Cálculo de impostos (INSS e IRRF)
- Visualização de salário líquido
- Interface intuitiva e responsiva
- Autenticação de usuários
- Suporte a temas claro/escuro

## Requisitos

- Flutter SDK ^3.7.0
- Dart SDK ^3.7.0
- Node.js (para a API)

## Instalação

1. Clone o repositório:
```bash
git clone https://github.com/seu-usuario/planeja-facil.git
```

2. Instale as dependências do Flutter:
```bash
flutter pub get
```

3. Instale as dependências da API:
```bash
cd api
npm install
```

4. Configure as variáveis de ambiente da API:
- Crie um arquivo `.env` na pasta `api`
- Adicione as seguintes variáveis:
  ```
  PORT=3000
  JWT_SECRET=sua-chave-secreta
  ```

## Executando o projeto

1. Inicie a API:
```bash
cd api
npm run dev
```

2. Execute o aplicativo Flutter:
```bash
flutter run
```

## Estrutura do projeto

```
planeja-facil/
├── api/                 # Backend em Node.js
├── lib/                 # Código fonte Flutter
│   ├── screens/        # Telas do aplicativo
│   ├── widgets/        # Widgets reutilizáveis
│   └── main.dart       # Ponto de entrada
├── assets/             # Recursos estáticos
│   ├── images/        # Imagens
│   └── fonts/         # Fontes
└── test/              # Testes
```

## Contribuição

1. Faça um fork do projeto
2. Crie uma branch para sua feature (`git checkout -b feature/nova-feature`)
3. Commit suas mudanças (`git commit -m 'Adiciona nova feature'`)
4. Push para a branch (`git push origin feature/nova-feature`)
5. Abra um Pull Request

## Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.
