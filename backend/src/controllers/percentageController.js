const calculatePercentages = (netSalary, categories) => {
  if (netSalary <= 0) {
    return {
      success: false,
      message: 'O salário deve ser um valor positivo'
    };
  }

  if (!Array.isArray(categories) || categories.length === 0) {
    return {
      success: false,
      message: 'Lista de categorias inválida'
    };
  }

  const totalPercentage = categories.reduce((sum, category) => sum + category.percentage, 0);

  if (totalPercentage > 100) {
    return {
      success: false,
      message: 'A soma dos percentuais não pode exceder 100%'
    };
  }

  if (categories.some(category => category.percentage < 0)) {
    return {
      success: false,
      message: 'Os percentuais devem ser valores positivos'
    };
  }

  const result = {
    success: true,
    summary: {
      netSalary,
      totalAllocated: (netSalary * totalPercentage) / 100,
      remainingValue: netSalary - (netSalary * totalPercentage) / 100,
      totalPercentage,
      remainingPercentage: 100 - totalPercentage
    },
    categories: categories.map(category => ({
      ...category,
      value: (netSalary * category.percentage) / 100
    })),
    recommendations: []
  };

  if (result.summary.remainingPercentage > 0) {
    result.recommendations.push({
      type: 'info',
      message: `Você tem ${result.summary.remainingPercentage}% do seu salário não alocado. Considere distribuir esse valor.`
    });
  }

  return result;
};

module.exports = {
  calculatePercentages
}; 