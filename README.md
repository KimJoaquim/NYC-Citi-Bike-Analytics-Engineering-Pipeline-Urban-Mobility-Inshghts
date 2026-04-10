# NYC-Citi-Bike-Analytics-Engineering-Pipeline-Urban-Mobility-Inshghts
Um projeto focado em transformar dados brutos de micromobilidade urbana em inshghts estratégicos, utilizando a Modern Data Stack (Google Cloud Platform &amp; BigQuery).

Este projeto demonstra a construção de um pipeline de dados ponta a ponta, focado em transformar milhões de registros de viagens de micromobilidade em Nova York em insights estratégicos. O foco principal foi a aplicação de conceitos de **Analytics Engineering** para otimizar custos e performance no Google Cloud Platform.

---

## 🏗️ Arquitetura da Solução

Diferente de uma análise tradicional, este projeto focou na criação de uma **Camada de Modelagem Física** para garantir eficiência:

1.  **Fonte de Dados:** Google Cloud Public Datasets (`bigquery-public-data.new_york_citibike`).
2.  **Processamento e Modelagem:** BigQuery (SQL Avançado).
3.  **Visualização:** Looker Studio (Conectado à tabela otimizada).

> **Eficiência Técnica:** Ao criar uma tabela agregada (`resumo_viagens`), reduzi o volume de dados processados pelo dashboard em mais de 90% em comparação à conexão direta com a tabela bruta.

---

## 🛠️ Desafios Técnicos & Soluções

### 1. Gerenciamento de Infraestrutura e Localidade (Região)
Durante a fase de extração, identifiquei um erro de processamento devido à incompatibilidade de regiões entre o dataset público localizado nos **US** e o meu conjunto de dados local. Para garantir a integridade e evitar custos desnecessários, configurei o ambiente do BigQuery para processar as consultas na localidade correta, garantindo um pipeline sem latência.

### 2. Garantia de Qualidade e Tratamento de Dados (Data Quality)
Ao realizar o perfilamento dos dados, identifiquei que aproximadamente 10% das entradas possuíam valores nulos nos campos de identificação das estações. Realizei um tratamento para isolar essas inconsistências, garantindo que o dashboard refletisse apenas métricas confiáveis e precisas.

---

📊 Insights Estratégicos
Picos de Demanda: Identificação dos horários críticos (08h e 17h), essenciais para logística de reposição de bicicletas.

Representatividade: Análise percentual onde descobri que as Top 10 estações são responsáveis por uma fração distribuída, indicando alta capilaridade da rede.

Qualidade de Dados: Detecção de 10% de registros nulos, gerando uma oportunidade de melhoria na governança da coleta.


## 💻 SQL Avançado em Ação

Para entender a dinâmica de tráfego, utilizei **Window Functions** para comparar o volume de viagens entre janelas de tempo consecutivas:

```sql
SELECT 
    start_station_name,
    hora_inicio,
    total_viagens,
    -- Puxa o valor da hora anterior para comparação direta na mesma linha
    LAG(total_viagens) OVER(PARTITION BY start_station_name ORDER BY hora_inicio) AS viagens_hora_anterior
FROM `seu_projeto.analise_citibike.resumo_viagens`
ORDER BY hora_inicio;
