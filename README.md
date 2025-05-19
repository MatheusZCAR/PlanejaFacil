# Gestor de Renda

**Gestor de Renda** é um aplicativo Flutter de planejamento financeiro pessoal mensal. Ele permite ao usuário calcular automaticamente quanto sobra do seu salário após o desconto de impostos e gastos fixos, além de sugerir alocações para investimento e lazer com base em percentuais definidos.

## Funcionalidades

- Cálculo do **Imposto de Renda (IRPF)** com base na tabela oficial de 2025 da Receita Federal.
- Entrada dinâmica de **gastos fixos** (como aluguel, luz, água, escola etc.).
- Definição personalizada dos percentuais de **investimento** e **lazer**.
- Exibição do **salário líquido** após todos os descontos.
- Apresentação de um **resumo financeiro** completo com gráfico de pizza.
- Interface moderna e intuitiva, com design baseado em etapas interativas.

## Tecnologias Utilizadas

- **Flutter** e **Dart**
- **Gerenciamento de estado** com `setState`
- **Gráficos** com `fl_chart` (ou similar)
- **Design responsivo** com navegação entre múltiplas telas

## Estrutura das Telas

1. **Salário Bruto:** Entrada do valor mensal.
2. **Gastos Fixos:** Lista dinâmica para adicionar despesas recorrentes.
3. **Percentuais de Investimento e Lazer:** Definição dos percentuais.
4. **Resultado:** Exibição detalhada dos cálculos e gráfico de pizza.

## Tabela IRPF Utilizada

| Faixa salarial mensal (R$)   | Alíquota (%) | Parcela a deduzir (R$) |
|------------------------------|--------------|-------------------------|
| Até 2.259,20                 | Isento       | -                       |
| De 2.259,21 até 2.826,65     | 7,5%         | 169,44                  |
| De 2.826,66 até 3.751,05     | 15%          | 381,44                  |
| De 3.751,06 até 4.664,68     | 22,5%        | 662,77                  |
| Acima de 4.664,68            | 27,5%        | 896,00                  |

Com desconto simplificado de R$ 607,20 aplicado sobre o imposto devido.
