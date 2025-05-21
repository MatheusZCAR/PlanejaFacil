# API Planeja Fácil

API para o projeto Planeja Fácil, desenvolvida em Node.js com Express.

## Instalação

1. Instale as dependências:
```bash
npm install
```

2. Configure as variáveis de ambiente:
- Crie um arquivo `.env` na raiz do projeto
- Adicione as seguintes variáveis:
  ```
  PORT=3000
  JWT_SECRET=sua-chave-secreta
  ```

## Executando o projeto

Para desenvolvimento:
```bash
npm run dev
```

Para produção:
```bash
npm start
```

## Endpoints

### Autenticação
- POST /api/login
  - Body: { "username": "admin", "password": "admin123" }
  - Retorna: { "token": "jwt-token" }

### Cálculos
- POST /api/calculate
  - Headers: { "Authorization": "Bearer jwt-token" }
  - Body: { "grossSalary": 5000 }
  - Retorna: { "grossSalary": 5000, "inss": 550, "irrf": 500, "netSalary": 3950, "discounts": { "inss": 550, "irrf": 500 } }

## Credenciais padrão
- Usuário: admin
- Senha: admin123 