const express = require('express');
const router = express.Router();
const { calculateFinances } = require('../controllers/financeController');

// Rota para calcular finanças
router.post('/calculate', calculateFinances);

module.exports = router; 