-- scripts/01_estrutura/1_base.sql

-- LIMPEZA (DDL)
DROP TABLE IF EXISTS propriedades CASCADE;
DROP TABLE IF EXISTS enderecos CASCADE;
DROP TABLE IF EXISTS hospedes CASCADE;

-- CRIAÇÃO (DDL)
CREATE TABLE enderecos (
    id SERIAL PRIMARY KEY,
    rua VARCHAR(150) NOT NULL,
    numero VARCHAR(10),
    bairro VARCHAR(100),
    cidade VARCHAR(100) NOT NULL,
    estado CHAR(2) NOT NULL
);

CREATE TABLE hospedes (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    telefone VARCHAR(20)
);

CREATE TABLE propriedades (
    id SERIAL PRIMARY KEY,
    nome_imovel VARCHAR(100) NOT NULL,
    capacidade_hospedes INTEGER CHECK (capacidade_hospedes > 0),
    id_endereco INT NOT NULL,
    CONSTRAINT fk_endereco_propriedade 
        FOREIGN KEY (id_endereco) 
        REFERENCES enderecos(id) 
        ON DELETE CASCADE
);