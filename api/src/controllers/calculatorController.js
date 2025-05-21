const calculateSalary = (req, res) => {
  const { grossSalary } = req.body;

  if (!grossSalary || isNaN(grossSalary) || grossSalary <= 0) {
    return res.status(400).json({ message: 'Salário bruto inválido' });
  }

  // Cálculos de impostos e descontos
  const inss = calculateINSS(grossSalary);
  const irrf = calculateIRRF(grossSalary - inss);
  const netSalary = grossSalary - inss - irrf;

  return res.json({
    grossSalary,
    inss,
    irrf,
    netSalary,
    discounts: {
      inss,
      irrf
    }
  });
};

const calculateINSS = (salary) => {
  // Tabela INSS 2024
  if (salary <= 1412) {
    return salary * 0.075;
  } else if (salary <= 2666.68) {
    return salary * 0.09;
  } else if (salary <= 4000.03) {
    return salary * 0.12;
  } else {
    return salary * 0.14;
  }
};

const calculateIRRF = (baseSalary) => {
  // Tabela IRRF 2024
  if (baseSalary <= 2112) {
    return 0;
  } else if (baseSalary <= 2826.65) {
    return baseSalary * 0.075 - 158.40;
  } else if (baseSalary <= 3751.05) {
    return baseSalary * 0.15 - 370.40;
  } else if (baseSalary <= 4664.68) {
    return baseSalary * 0.225 - 651.73;
  } else {
    return baseSalary * 0.275 - 884.96;
  }
};

module.exports = {
  calculateSalary
}; 