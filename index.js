const express = require('express');
const cors = require('cors');
const dotenv = require('dotenv');
const authRoutes = require('./src/routes/authRoutes');
const salaryRoutes = require('./src/routes/salaryRoutes');
const financeRoutes = require('./src/routes/financeRoutes');
const percentageRoutes = require('./src/routes/percentageRoutes');

// Configuração do ambiente
dotenv.config();

const app = express();

// Middleware
app.use(cors());
app.use(express.json());

// Rotas
app.use('/api/auth', authRoutes);
app.use('/api/salary', salaryRoutes);
app.use('/api/finance', financeRoutes);
app.use('/api/percentage', percentageRoutes);

// Rota de teste
app.get('/', (req, res) => {
  res.json({ message: 'API do PlanejaFácil está funcionando!' });
});

// Porta do servidor
const PORT = process.env.PORT || 3000;
const HOST = '0.0.0.0'; // Permite conexões de qualquer IP

// Iniciar o servidor
app.listen(PORT, HOST, () => {
  console.log(`Servidor rodando em http://${HOST}:${PORT}`);
}); 