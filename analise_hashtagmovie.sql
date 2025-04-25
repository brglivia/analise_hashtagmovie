-- ==========================================================
-- Projeto: Análises de Dados com SQL - Plataforma HashtagMovie
-- Objetivo: Explorar o banco de dados fictício com foco em
--           análises de filmes, clientes e aluguéis.
-- ==========================================================

-- Visualização das tabelas disponíveis
-- (Executar apenas para ver os dados, pode ser comentado depois)
-- SELECT * FROM alugueis;
-- SELECT * FROM atores;
-- SELECT * FROM atuacoes;
-- SELECT * FROM clientes;
-- SELECT * FROM filmes;

-- ==========================================================
-- PARTE 1 - ANÁLISE DE PREÇOS DE ALUGUEL
-- ==========================================================

-- Análise 1: Preço médio geral dos filmes disponíveis
SELECT 
    ROUND(AVG(preco_aluguel), 2) AS preco_medio_geral
FROM filmes;

-- Análise 2: Preço médio por gênero de filme + total de títulos
SELECT 
    genero,
    ROUND(AVG(preco_aluguel), 2) AS preco_medio,
    COUNT(*) AS total_filmes
FROM filmes
GROUP BY genero;

-- Análise 3: Mesmo cálculo acima, mas apenas para filmes lançados em 2011
SELECT 
    genero,
    ROUND(AVG(preco_aluguel), 2) AS preco_medio_2011,
    COUNT(*) AS total_filmes_2011
FROM filmes
WHERE ano_lancamento = 2011
GROUP BY genero;

-- ==========================================================
-- PARTE 2 - AVALIAÇÃO DE DESEMPENHO DOS ALUGUEIS
-- ==========================================================

-- Análise 4: Identificando os aluguéis com nota acima da média
SELECT 
    *
FROM alugueis
WHERE nota > (
    SELECT AVG(nota) FROM alugueis
);

-- ==========================================================
-- PARTE 3 - CRIAÇÃO DE VIEWS
-- ==========================================================

-- Análise 5: Criando uma view com o preço médio e número de filmes por gênero
CREATE VIEW vw_resumo_genero_filmes AS
SELECT 
    genero,
    ROUND(AVG(preco_aluguel), 2) AS media_preco,
    COUNT(*) AS qtd_filmes
FROM filmes
GROUP BY genero;

-- Consulta à view criada
SELECT * FROM vw_resumo_genero_filmes;

-- Para excluir a view (se necessário)
-- DROP VIEW vw_resumo_genero_filmes;

-- ==========================================================
-- PARTE 4 - ANÁLISES DE CLIENTES E REGIÕES
-- ==========================================================

-- Análise 6: Quantidade de clientes ativos em cada região
SELECT 
    regiao,
    COUNT(*) AS total_clientes
FROM clientes
GROUP BY regiao
ORDER BY total_clientes DESC;

-- Análise 7: Distribuição de clientes por sexo dentro de cada região
SELECT 
    regiao,
    sexo,
    COUNT(*) AS total_clientes
FROM clientes
GROUP BY regiao, sexo
ORDER BY regiao, total_clientes DESC;

-- Análise 8: Clientes com contas mais antigas na base
SELECT 
    nome_cliente,
    data_criacao_conta,
    CURRENT_DATE - data_criacao_conta AS dias_ativos
FROM clientes
ORDER BY data_criacao_conta
LIMIT 10;

-- ==========================================================
-- PARTE 5 - COMPORTAMENTO DE CONSUMO DE FILMES
-- ==========================================================

-- Análise 9: Total de alugueis por gênero de filme
SELECT 
    f.genero,
    COUNT(*) AS total_alugueis
FROM alugueis a
JOIN filmes f ON a.id_filme = f.id_filme
GROUP BY f.genero
ORDER BY total_alugueis DESC;

-- Análise 10: Nota média dada pelos clientes aos filmes, por gênero
SELECT 
    f.genero,
    ROUND(AVG(a.nota), 2) AS media_nota,
    COUNT(*) AS total_avaliacoes
FROM alugueis a
JOIN filmes f ON a.id_filme = f.id_filme
GROUP BY f.genero
ORDER BY media_nota DESC;

-- ==========================================================
-- PARTE 6 - DESEMPENHO REGIONAL DE ALUGUEIS
-- ==========================================================

-- Análise 11: Total de alugueis realizados por região
SELECT 
    c.regiao,
    COUNT(*) AS total_alugueis
FROM alugueis a
JOIN clientes c ON a.id_cliente = c.id_cliente
GROUP BY c.regiao
ORDER BY total_alugueis DESC;

-- Análise 12: Receita gerada por alugueis em cada região
SELECT 
    c.regiao,
    ROUND(SUM(f.preco_aluguel), 2) AS receita_total
FROM alugueis a
JOIN clientes c ON a.id_cliente = c.id_cliente
JOIN filmes f ON a.id_filme = f.id_filme
GROUP BY c.regiao
ORDER BY receita_total DESC;

