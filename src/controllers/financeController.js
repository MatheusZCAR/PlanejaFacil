const calculateFinances = (req, res) => {
  try {
    const { netSalary, expenses } = req.body;

    if (!netSalary || isNaN(netSalary) || netSalary <= 0) {
      return res.status(400).json({
        success: false,
        message: 'Salário líquido inválido'
      });
    }

    if (!expenses || !Array.isArray(expenses)) {
      return res.status(400).json({
        success: false,
        message: 'Lista de despesas inválida'
      });
    }

    // Cálculos
    const totalExpenses = expenses.reduce((sum, expense) => sum + expense.value, 0);
    const savings = netSalary - totalExpenses;
    const savingsPercentage = (savings / netSalary) * 100;
    const expensesPercentage = (totalExpenses / netSalary) * 100;

    // Categorização das despesas
    const categorizedExpenses = expenses.reduce((acc, expense) => {
      const category = expense.category || 'Outros';
      if (!acc[category]) {
        acc[category] = 0;
      }
      acc[category] += expense.value;
      return acc;
    }, {});

    // Ordenar categorias por valor
    const sortedCategories = Object.entries(categorizedExpenses)
      .sort(([, a], [, b]) => b - a)
      .map(([category, value]) => ({
        category,
        value,
        percentage: (value / netSalary) * 100
      }));

    return res.status(200).json({
      success: true,
      summary: {
        netSalary,
        totalExpenses,
        savings,
        savingsPercentage,
        expensesPercentage
      },
      categories: sortedCategories,
      recommendations: generateRecommendations(savingsPercentage, expensesPercentage)
    });
  } catch (error) {
    console.error('Erro ao calcular finanças:', error);
    return res.status(500).json({
      success: false,
      message: 'Erro ao calcular finanças'
    });
  }
};

function generateRecommendations(savingsPercentage, expensesPercentage) {
  const recommendations = [];

  if (savingsPercentage < 20) {
    recommendations.push({
      type: 'warning',
      message: 'Sua taxa de poupança está abaixo do recomendado (20%). Considere reduzir despesas.'
    });
  }

  if (expensesPercentage > 80) {
    recommendations.push({
      type: 'warning',
      message: 'Suas despesas estão muito altas em relação à sua renda. Revise seus gastos.'
    });
  }

  if (savingsPercentage >= 20) {
    recommendations.push({
      type: 'success',
      message: 'Ótimo! Você está mantendo uma boa taxa de poupança.'
    });
  }

  if (expensesPercentage <= 50) {
    recommendations.push({
      type: 'success',
      message: 'Excelente! Você está mantendo suas despesas bem controladas.'
    });
  }

  return recommendations;
}

module.exports = {
  calculateFinances
}; 