const calculateSalary = (req, res) => {
  try {
    const { grossSalary } = req.body;

    if (!grossSalary || isNaN(grossSalary) || grossSalary <= 0) {
      return res.status(400).json({
        success: false,
        message: 'Salário bruto inválido'
      });
    }

    // Cálculos
    const inss = calculateINSS(grossSalary);
    const irrf = calculateIRRF(grossSalary - inss);
    const netSalary = grossSalary - inss - irrf;

    return res.status(200).json({
      success: true,
      grossSalary,
      deductions: {
        inss,
        irrf
      },
      netSalary,
      details: {
        inssPercentage: (inss / grossSalary) * 100,
        irrfPercentage: (irrf / grossSalary) * 100,
        netPercentage: (netSalary / grossSalary) * 100
      }
    });
  } catch (error) {
    console.error('Erro ao calcular salário:', error);
    return res.status(500).json({
      success: false,
      message: 'Erro ao calcular salário'
    });
  }
};

// Função para calcular INSS
function calculateINSS(grossSalary) {
  const inssTable = [
    { limit: 1412.00, rate: 0.075 },
    { limit: 2666.68, rate: 0.09 },
    { limit: 4000.03, rate: 0.12 },
    { limit: 7786.02, rate: 0.14 }
  ];

  let inss = 0;
  let remainingSalary = grossSalary;

  for (const bracket of inssTable) {
    if (remainingSalary <= 0) break;

    const taxableAmount = Math.min(remainingSalary, bracket.limit);
    inss += taxableAmount * bracket.rate;
    remainingSalary -= bracket.limit;
  }

  // Teto do INSS
  return Math.min(inss, 876.97);
}

// Função para calcular IRRF
function calculateIRRF(taxableSalary) {
  const irrfTable = [
    { limit: 2112.00, rate: 0, deduction: 0 },
    { limit: 2826.65, rate: 0.075, deduction: 158.40 },
    { limit: 3751.05, rate: 0.15, deduction: 370.40 },
    { limit: 4664.68, rate: 0.225, deduction: 651.73 },
    { limit: Infinity, rate: 0.275, deduction: 884.96 }
  ];

  for (const bracket of irrfTable) {
    if (taxableSalary <= bracket.limit) {
      return Math.max(0, (taxableSalary * bracket.rate) - bracket.deduction);
    }
  }

  return 0;
}

module.exports = {
  calculateSalary
}; 