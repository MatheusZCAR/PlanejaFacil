double calcularIRPF(double salarioBruto) {
  double imposto = 0.0;
  const double descontoSimplificado = 607.20;

  if (salarioBruto <= 2259.20) {
    imposto = 0.0;
  } else if (salarioBruto <= 2826.65) {
    imposto = (salarioBruto * 0.075) - 169.44;
  } else if (salarioBruto <= 3751.05) {
    imposto = (salarioBruto * 0.15) - 381.44;
  } else if (salarioBruto <= 4664.68) {
    imposto = (salarioBruto * 0.225) - 662.77;
  } else {
    imposto = (salarioBruto * 0.275) - 896.00;
  }

  // Aplicar desconto simplificado e garantir que o imposto não seja negativo
  imposto = imposto - descontoSimplificado;
  if (imposto < 0) {
    imposto = 0.0;
  }

  return imposto;
}
