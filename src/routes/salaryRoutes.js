const express = require('express');
const router = express.Router();
const { calculateSalary } = require('../controllers/salaryController');

// Rota para calcular salário
router.post('/calculate', calculateSalary);

module.exports = router; 