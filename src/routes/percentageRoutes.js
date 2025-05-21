const express = require('express');
const router = express.Router();
const { calculatePercentages } = require('../controllers/percentageController');

// Rota para calcular percentuais
router.post('/calculate', calculatePercentages);

module.exports = router; 