-- ==========================================================
-- ESTRUTURA DAS TABELAS (DDL)
-- ==========================================================

DROP TABLE IF EXISTS biblioteca CASCADE;
DROP TABLE IF EXISTS jogos CASCADE;
DROP TABLE IF EXISTS desenvolvedores CASCADE;
DROP TABLE IF EXISTS usuarios CASCADE;

-- 1. Tabela de Desenvolvedoras
CREATE TABLE desenvolvedores (
    id_dev SERIAL PRIMARY KEY,
    nome_empresa VARCHAR(100) NOT NULL,
    pais VARCHAR(50)
);

-- 2. Tabela de Jogos
CREATE TABLE jogos (
    id_jogo SERIAL PRIMARY KEY,
    titulo VARCHAR(100) NOT NULL,
    genero VARCHAR(50),
    preco NUMERIC(10, 2) NOT NULL CHECK (preco >= 0),
    id_dev INT REFERENCES desenvolvedores(id_dev)
);

-- 3. Tabela de Usuários
CREATE TABLE usuarios (
    id_usuario SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    saldo_carteira NUMERIC(10, 2) DEFAULT 0.00,
    total_jogos INT DEFAULT 0
);

-- 4. Tabela de Ligação (Biblioteca do Usuário)
CREATE TABLE biblioteca (
    id_compra SERIAL PRIMARY KEY,
    id_usuario INT REFERENCES usuarios(id_usuario),
    id_jogo INT REFERENCES jogos(id_jogo),
    data_compra TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ==========================================================
-- INSERÇÃO DE DADOS REAIS/PARECIDOS (DML)
-- ==========================================================

INSERT INTO desenvolvedores (nome_empresa, pais) VALUES 
('FromSoftware', 'Japão'),
('Valve', 'EUA'),
('CD Projekt Red', 'Polônia');

INSERT INTO jogos (titulo, genero, preco, id_dev) VALUES 
('Elden Ring', 'RPG', 249.90, 1),
('Counter-Strike 2', 'FPS', 0.00, 2),
('The Witcher 3', 'RPG', 129.90, 3),
('Cyberpunk 2077', 'RPG', 199.90, 3);

INSERT INTO usuarios (username, email, saldo_carteira) VALUES 
('player_pro', 'pro@email.com', 500.00),
('casual_gamer', 'casual@email.com', 50.00);

-- ==========================================================
-- AUTOMAÇÃO COM TRIGGER (Function + Trigger)
-- Requisito: Atualizar o total de jogos do usuário e deduzir saldo após compra
-- ==========================================================

CREATE OR REPLACE FUNCTION fn_processar_compra()
RETURNS TRIGGER AS $$
DECLARE
    valor_jogo NUMERIC(10, 2);
BEGIN
    -- Busca o preço do jogo comprado
    SELECT preco INTO valor_jogo FROM jogos WHERE id_jogo = NEW.id_jogo;

    -- Atualiza os dados do usuário
    UPDATE usuarios 
    SET total_jogos = total_jogos + 1,
        saldo_carteira = saldo_carteira - valor_jogo
    WHERE id_usuario = NEW.id_usuario;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_pos_compra
AFTER INSERT ON biblioteca
FOR EACH ROW
EXECUTE FUNCTION fn_processar_compra();

-- ==========================================================
-- CONSULTAS QUE DEVOLVEM DADOS DO SITE (DQL)
-- ==========================================================

-- 1. "Página da Loja": Mostra jogos, seus preços e desenvolvedores (JOIN)
SELECT j.titulo, j.genero, j.preco, d.nome_empresa
FROM jogos j
JOIN desenvolvedores d ON j.id_dev = d.id_dev;

-- 2. "Página da Biblioteca": Mostra os jogos de um usuário específico
SELECT u.username, j.titulo, b.data_compra
FROM biblioteca b
JOIN usuarios u ON b.id_usuario = u.id_usuario
JOIN jogos j ON b.id_jogo = j.id_jogo
WHERE u.username = 'player_pro';

-- 3. Relatório de Marketing: Quantos jogos cada desenvolvedor tem na loja e o valor médio
SELECT d.nome_empresa, COUNT(j.id_jogo) AS total_titulos, AVG(j.preco) AS preco_medio
FROM desenvolvedores d
LEFT JOIN jogos j ON d.id_dev = j.id_dev
GROUP BY d.nome_empresa;

-- ==========================================================
-- TESTE DA AUTOMAÇÃO
-- ==========================================================

-- Usuário 'player_pro' compra 'Elden Ring'
INSERT INTO biblioteca (id_usuario, id_jogo) VALUES (1, 1);

-- Verifica se o saldo diminuiu e o total de jogos subiu
SELECT * FROM usuarios WHERE id_usuario = 1;