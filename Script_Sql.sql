-- Database: BancoTrabalho2

-- DROP DATABASE IF EXISTS "BancoTrabalho2";

CREATE DATABASE "BancoTrabalho2"
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'Portuguese_Brazil.1252'
    LC_CTYPE = 'Portuguese_Brazil.1252'
    LOCALE_PROVIDER = 'libc'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;

-- Criação das Tabelas --

	-- Tabela de Fornecedores
CREATE TABLE tb_fornecedores (
    for_codigo BIGINT PRIMARY KEY,
    for_descricao VARCHAR(45) NOT NULL
);

	-- Tabela de Produtos
CREATE TABLE tb_produtos (
    pro_codigo BIGINT PRIMARY KEY,
    pro_descricao VARCHAR(45) NOT NULL,
    pro_valor DECIMAL(10, 2) NOT NULL,
    pro_quantidade INT NOT NULL,
    tb_fornecedores_for_codigo BIGINT NOT NULL,
    FOREIGN KEY (tb_fornecedores_for_codigo) REFERENCES tb_fornecedores (for_codigo)
);

	-- Tabela de Funcionários
CREATE TABLE tb_funcionarios (
    fun_codigo BIGINT PRIMARY KEY,
    fun_nome VARCHAR(45) NOT NULL,
    fun_cpf VARCHAR(45) NOT NULL UNIQUE,
    fun_senha VARCHAR(50) NOT NULL,
    fun_funcao VARCHAR(50) NOT NULL
);

	-- Tabela de Vendas
CREATE TABLE tb_vendas (
    ven_codigo BIGINT PRIMARY KEY,
    ven_horario TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    ven_valor_total DECIMAL(10, 2) NOT NULL,
    tb_funcionarios_fun_codigo BIGINT NOT NULL,
    FOREIGN KEY (tb_funcionarios_fun_codigo) REFERENCES tb_funcionarios (fun_codigo)
);

	-- Tabela de Itens
CREATE TABLE tb_itens (
    ite_codigo BIGINT PRIMARY KEY,
    ite_quantidade INT NOT NULL,
    ite_valor_parcial DECIMAL(10, 2) NOT NULL,
    tb_produtos_pro_codigo BIGINT NOT NULL,
    tb_vendas_ven_codigo BIGINT NOT NULL,
    FOREIGN KEY (tb_produtos_pro_codigo) REFERENCES tb_produtos (pro_codigo),
    FOREIGN KEY (tb_vendas_ven_codigo) REFERENCES tb_vendas (ven_codigo)
);

-- Criação de Indexação --

	-- Índice de Buscas por Descrição de Produtos: 
-- Justificativa: Facilita buscas frequentes por fornecedores pelo nome ou descrição.
CREATE INDEX idx_fornecedores_descricao ON tb_fornecedores (for_descricao);

	-- Índice de Buscas para filtrar Produtos com uma faixa de Valor:
-- Justificativa: Acelera consultas que filtram produtos por faixa de valor, como relatórios financeiros.
CREATE INDEX idx_produtos_valor ON tb_produtos (pro_valor);

-- Função para simular ROLLBACK
CREATE OR REPLACE FUNCTION teste_rollback()
RETURNS void AS $$
BEGIN
    -- Início da transação
    INSERT INTO tb_produtos (pro_codigo, pro_descricao, pro_valor, pro_quantidade, tb_fornecedores_for_codigo)
    VALUES (999, 'Produto Inválido', 100.00, 10, 1);

    -- Erro proposital para testar o Rollback
    PERFORM 1 / 0; -- Divisão por zero

    -- Este código nunca será alcançado devido ao erro acima
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Erro encontrado. Rollback realizado.';
        -- O Rollback já foi executado automaticamente pelo PostgreSQL
END;
$$ LANGUAGE plpgsql;

SELECT teste_rollback();

-- Criação de índices para otimização
-- Índice na tabela de produtos para consultas rápidas por descrição
CREATE INDEX idx_produtos_descricao ON tb_produtos (pro_descricao);
-- Índice na tabela de vendas para consultas por horário
CREATE INDEX idx_vendas_horario ON tb_vendas (ven_horario);

-- Transações e Controle de Concorrência
-- Função com Rollback
CREATE OR REPLACE FUNCTION testar_rollback() RETURNS VOID AS $$
BEGIN
    BEGIN
        INSERT INTO tb_produtos (pro_codigo, pro_descricao, pro_valor, pro_quantidade, tb_fornecedores_for_codigo)
        VALUES (1, 'Produto Teste', 10.00, 100, 1);
        RAISE EXCEPTION 'Forçando erro para teste de Rollback';
    EXCEPTION
        WHEN OTHERS THEN
            RAISE NOTICE 'Rollback realizado com sucesso';
            ROLLBACK;
    END;
END;
$$ LANGUAGE plpgsql;

-- Transações simultâneas para controle de concorrência
BEGIN;
    UPDATE tb_produtos SET pro_quantidade = pro_quantidade - 1 WHERE pro_codigo = 1;
END;
BEGIN;
    UPDATE tb_produtos SET pro_quantidade = pro_quantidade - 2 WHERE pro_codigo = 1;
END;

-- Recuperação de dados e backup
-- Função para verificar dados e realizar commit ou rollback
CREATE OR REPLACE FUNCTION verificar_dados() RETURNS VOID AS $$
BEGIN
    IF (SELECT COUNT(*) FROM tb_produtos WHERE pro_quantidade < 0) > 0 THEN
        RAISE EXCEPTION 'Dados inconsistentes detectados';
    ELSE
        COMMIT;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
END;
$$ LANGUAGE plpgsql;

-- Rotina de backup do banco de dados
-- Script para ser executado no terminal
pg_dump -U seu_usuario -h localhost -d nome_banco > caminho_para_backup.sql

-- Restauração do backup
pg_restore -U seu_usuario -h localhost -d novo_banco caminho_para_backup.sql

-- Configuração de segurança
-- Criação de usuários e grupos
CREATE ROLE grupo_vendas;
CREATE ROLE grupo_estoque;
CREATE USER usuario_vendas PASSWORD 'senha123';
CREATE USER usuario_estoque PASSWORD 'senha456';

-- Concessão de privilégios
GRANT SELECT, INSERT, UPDATE ON tb_vendas TO grupo_vendas;
GRANT SELECT, UPDATE ON tb_produtos TO grupo_estoque;
GRANT grupo_vendas TO usuario_vendas;
GRANT grupo_estoque TO usuario_estoque;

-- Teste de novos privilégios
GRANT DELETE ON tb_vendas TO usuario_vendas;
-- Verificar se outros usuários do grupo também receberam (deve ser "NÃO")