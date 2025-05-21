const calculatePercentages = (req, res) => {
  try {
    const { netSalary, percentages } = req.body;

    if (!netSalary || isNaN(netSalary) || netSalary <= 0) {
      return res.status(400).json({
        success: false,
        message: 'Salário líquido inválido'
      });
    }

    if (!percentages || !Array.isArray(percentages)) {
      return res.status(400).json({
        success: false,
        message: 'Lista de percentuais inválida'
      });
    }

    // Validar se a soma dos percentuais não excede 100%
    const totalPercentage = percentages.reduce((sum, p) => sum + p.percentage, 0);
    if (totalPercentage > 100) {
      return res.status(400).json({
        success: false,
        message: 'A soma dos percentuais não pode exceder 100%'
      });
    }

    // Calcular valores baseados nos percentuais
    const calculatedValues = percentages.map(p => ({
      category: p.category,
      percentage: p.percentage,
      value: (netSalary * p.percentage) / 100
    }));

    // Calcular valor restante
    const totalAllocated = calculatedValues.reduce((sum, p) => sum + p.value, 0);
    const remainingValue = netSalary - totalAllocated;
    const remainingPercentage = 100 - totalPercentage;

    return res.status(200).json({
      success: true,
      summary: {
        netSalary,
        totalAllocated,
        remainingValue,
        totalPercentage,
        remainingPercentage
      },
      categories: calculatedValues,
      recommendations: generatePercentageRecommendations(calculatedValues, remainingPercentage)
    });
  } catch (error) {
    console.error('Erro ao calcular percentuais:', error);
    return res.status(500).json({
      success: false,
      message: 'Erro ao calcular percentuais'
    });
  }
};

function generatePercentageRecommendations(categories, remainingPercentage) {
  const recommendations = [];

  // Verificar se há valor não alocado
  if (remainingPercentage > 0) {
    recommendations.push({
      type: 'info',
      message: `Você tem ${remainingPercentage.toFixed(1)}% do seu salário não alocado. Considere distribuir esse valor.`
    });
  }

  // Verificar categorias com percentuais muito altos
  categories.forEach(category => {
    if (category.percentage > 50) {
      recommendations.push({
        type: 'warning',
        message: `A categoria ${category.category} está com um percentual muito alto (${category.percentage.toFixed(1)}%). Considere redistribuir.`
      });
    }
  });

  // Verificar se há poucas categorias
  if (categories.length < 3) {
    recommendations.push({
      type: 'info',
      message: 'Considere diversificar suas categorias para melhor distribuição do orçamento.'
    });
  }

  return recommendations;
}

module.exports = {
  calculatePercentages
}; 