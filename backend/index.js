const express = require('express');
const cors = require('cors');
const percentageRoutes = require('./src/routes/percentageRoutes');

const app = express();

app.use(cors());
app.use(express.json());

app.use('/api/percentage', percentageRoutes);

const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
  console.log(`Servidor rodando na porta ${PORT}`);
});

module.exports = app; 