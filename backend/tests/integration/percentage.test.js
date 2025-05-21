const request = require('supertest');
const app = require('../../index');

describe('API de Percentuais', () => {
  test('deve calcular percentuais corretamente', async () => {
    const response = await request(app)
      .post('/api/percentage/calculate')
      .send({
        netSalary: 5000,
        categories: [
          { category: 'Moradia', percentage: 30 },
          { category: 'Alimentação', percentage: 20 },
          { category: 'Transporte', percentage: 15 }
        ]
      });

    expect(response.status).toBe(200);
    expect(response.body.success).toBe(true);
    expect(response.body.summary.netSalary).toBe(5000);
    expect(response.body.summary.totalAllocated).toBe(3250);
    expect(response.body.summary.remainingValue).toBe(1750);
    expect(response.body.categories).toHaveLength(3);
    expect(response.body.recommendations).toHaveLength(1);
  });

  test('deve retornar erro quando percentual total excede 100%', async () => {
    const response = await request(app)
      .post('/api/percentage/calculate')
      .send({
        netSalary: 5000,
        categories: [
          { category: 'Moradia', percentage: 60 },
          { category: 'Alimentação', percentage: 50 }
        ]
      });

    expect(response.status).toBe(400);
    expect(response.body.success).toBe(false);
    expect(response.body.message).toBe('A soma dos percentuais não pode exceder 100%');
  });

  test('deve retornar erro quando percentual é negativo', async () => {
    const response = await request(app)
      .post('/api/percentage/calculate')
      .send({
        netSalary: 5000,
        categories: [
          { category: 'Moradia', percentage: -10 }
        ]
      });

    expect(response.status).toBe(400);
    expect(response.body.success).toBe(false);
    expect(response.body.message).toBe('Os percentuais devem ser valores positivos');
  });

  test('deve retornar erro quando salário é negativo', async () => {
    const response = await request(app)
      .post('/api/percentage/calculate')
      .send({
        netSalary: -5000,
        categories: [
          { category: 'Moradia', percentage: 30 }
        ]
      });

    expect(response.status).toBe(400);
    expect(response.body.success).toBe(false);
    expect(response.body.message).toBe('O salário deve ser um valor positivo');
  });
}); 