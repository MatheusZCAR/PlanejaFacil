# Projeto Flutter: Gestor de Finanças

**Gestor de Finanças** é um aplicativo Flutter de planejamento financeiro pessoal mensal, que consome uma API Node.js responsável por todos os cálculos financeiros. Ele calcula o salário líquido com base no salário bruto, descontos obrigatórios (INSS e IRPF), gastos fixos e percentuais definidos para investimento e lazer. O app possui uma interface moderna, com etapas simples e exibição de um gráfico de pizza no resultado final.

## Objetivo

- Realizar os cálculos financeiros no backend (Node.js):
    - INSS (baseado na tabela progressiva de 2025)
    - IRPF (tabela progressiva 2025 + desconto simplificado)
    - Gastos fixos
    - Salário líquido
    - Valores para investimento e lazer
    - Saldo final disponível

- Enviar e receber os dados via API REST entre o Flutter (frontend) e o Node.js (backend).

## Dados de entrada

- Salário bruto mensal.
- Lista de gastos fixos (nome + valor).
- Percentual para investimento (ex: 20).
- Percentual para lazer (ex: 15).

## Endpoint da API

### POST /gf/calcular-financas

Cada equipe deve usar um prefixo único no endpoint. Neste projeto, o prefixo definido é gf.

Requisição (JSON):

{
"salarioBruto": 10000,
"gastosFixos": [
{ "nome": "Aluguel", "valor": 1200 },
{ "nome": "Luz", "valor": 250 },
{ "nome": "Internet", "valor": 150 }
],
"percentualInvestimento": 15,
"percentualLazer": 20
}

Resposta esperada (JSON):

{
"inss": 828.38,
"irpf": 1246.80,
"gastosTotais": 1600,
"salarioLiquido": 6324.82,
"valorInvestimento": 948.72,
"valorLazer": 1264.96,
"saldoFinal": 4111.14
}

## Regras de cálculo

### INSS 2025 – Tabela Progressiva

| Faixa salarial mensal (R$)      | Alíquota (%) | Parcela a deduzir (R$) |
|---------------------------------|--------------|-------------------------|
| Até 1.518,00                    | 7,5%         | -                       |
| De 1.518,01 até 2.793,88        | 9%           | R$ 22,77                |
| De 2.793,89 até 4.190,83        | 12%          | R$ 106,59               |
| De 4.190,84 até 8.157,41        | 14%          | R$ 190,40               |

- O cálculo é progressivo por faixa.
- O desconto máximo permitido é limitado ao teto do INSS: R$ 8.157,41. Acima disso, o valor não aumenta.

### IRPF 2025 – Tabela Progressiva Mensal

| Faixa salarial mensal (R$)   | Alíquota (%) | Parcela a deduzir (R$) |
|------------------------------|--------------|-------------------------|
| Até 2.259,20                 | Isento       | -                       |
| De 2.259,21 até 2.826,65     | 7,5%         | R$ 169,44               |
| De 2.826,66 até 3.751,05     | 15%          | R$ 381,44               |
| De 3.751,06 até 4.664,68     | 22,5%        | R$ 662,77               |
| Acima de 4.664,68            | 27,5%        | R$ 896,00               |

- Após aplicar a alíquota e dedução da faixa, deve-se subtrair o desconto fixo de R$ 607,20.
- O imposto final não pode ser negativo.

## Telas esperadas no Flutter

1. Entrada do salário bruto mensal.
2. Lista de gastos fixos (nome + valor), com botão de adicionar.
3. Campos para digitar o percentual de investimento e lazer.
4. Botão "Calcular" que faz a requisição para a API.
5. Tela de resultados com:
    - Salário líquido
    - Impostos pagos
    - Valores destinados a lazer e investimento
    - Saldo final
    - Gráfico de pizza representando as proporções