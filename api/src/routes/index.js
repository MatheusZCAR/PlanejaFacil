const express = require('express');
const router = express.Router();
const authController = require('../controllers/authController');
const calculatorController = require('../controllers/calculatorController');
const authMiddleware = require('../middlewares/auth');

// Rotas públicas
router.post('/login', authController.login);

// Rotas protegidas
router.post('/calculate', authMiddleware, calculatorController.calculateSalary);

module.exports = router; 