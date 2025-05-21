const { calculatePercentages } = require('../../src/controllers/percentageController');

describe('PercentageController', () => {
  test('deve calcular percentuais corretamente', () => {
    const netSalary = 5000;
    const categories = [
      { category: 'Moradia', percentage: 30 },
      { category: 'Alimentação', percentage: 20 },
      { category: 'Transporte', percentage: 15 }
    ];

    const result = calculatePercentages(netSalary, categories);

    expect(result.success).toBe(true);
    expect(result.summary.netSalary).toBe(5000);
    expect(result.summary.totalAllocated).toBe(3250);
    expect(result.summary.remainingValue).toBe(1750);
    expect(result.categories).toHaveLength(3);
    expect(result.recommendations).toHaveLength(1);
  });

  test('deve retornar erro quando percentual total excede 100%', () => {
    const netSalary = 5000;
    const categories = [
      { category: 'Moradia', percentage: 60 },
      { category: 'Alimentação', percentage: 50 }
    ];

    const result = calculatePercentages(netSalary, categories);

    expect(result.success).toBe(false);
    expect(result.message).toBe('A soma dos percentuais não pode exceder 100%');
  });

  test('deve retornar erro quando percentual é negativo', () => {
    const netSalary = 5000;
    const categories = [
      { category: 'Moradia', percentage: -10 }
    ];

    const result = calculatePercentages(netSalary, categories);

    expect(result.success).toBe(false);
    expect(result.message).toBe('Os percentuais devem ser valores positivos');
  });

  test('deve retornar erro quando salário é negativo', () => {
    const netSalary = -5000;
    const categories = [
      { category: 'Moradia', percentage: 30 }
    ];

    const result = calculatePercentages(netSalary, categories);

    expect(result.success).toBe(false);
    expect(result.message).toBe('O salário deve ser um valor positivo');
  });
}); 