const express = require('express');
const router = express.Router();
const { calculatePercentages } = require('../controllers/percentageController');

router.post('/calculate', (req, res) => {
  const { netSalary, categories } = req.body;

  if (!netSalary || !categories) {
    return res.status(400).json({
      success: false,
      message: 'Salário líquido e categorias são obrigatórios'
    });
  }

  const result = calculatePercentages(netSalary, categories);

  if (!result.success) {
    return res.status(400).json(result);
  }

  return res.json(result);
});

module.exports = router; 