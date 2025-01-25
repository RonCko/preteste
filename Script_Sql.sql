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
