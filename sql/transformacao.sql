--Tabela Resumo de Viagens--
CREATE OR REPLACE TABLE analise_citibike.resumo_viagens AS
SELECT 
    start_station_name,
    EXTRACT(HOUR FROM starttime) AS hora_inicio,
    AVG(tripduration / 60) AS media_minutos,
    COUNT(*) AS total_viagens
FROM `bigquery-public-data.new_york_citibike.citibike_trips`
WHERE start_station_name IS NOT NULL
GROUP BY 1, 2
ORDER BY total_viagens DESC

--Tráfego por Estação(%)--
SELECT 
    start_station_name,
    total_viagens,
    -- Calcula o % do tráfego total usando uma Window Function
    ROUND(SAFE_DIVIDE(total_viagens, SUM(total_viagens) OVER()) * 100, 2) AS percentual_trafego
FROM `analise_citibike.resumo_viagens`
ORDER BY total_viagens DESC
LIMIT 10;

--Uso de LEAD e LAG(Crescimento)--
SELECT
  start_station_name,
  hora_inicio,
  total_viagens,
  --Pega o valor da hora anterior para comparar--
  LAG(total_viagens) OVER (PARTITION BY start_station_name ORDER BY hora_inicio) AS viagens_hora_anterior
FROM `analise_citibike.resumo_viagens`
Where start_station_name = 'Pershing Square North'
ORDER BY hora_inicio
