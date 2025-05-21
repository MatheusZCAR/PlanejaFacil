const express = require('express');
const cors = require('cors');
const config = require('./config/config');
const routes = require('./routes');

const app = express();

app.use(cors());
app.use(express.json());

// Rotas
app.use('/api', routes);

// Rota de teste
app.get('/', (req, res) => {
  res.json({ message: 'API Planeja Fácil funcionando!' });
});

app.listen(config.port, () => {
  console.log(`Servidor rodando na porta ${config.port}`);
}); 