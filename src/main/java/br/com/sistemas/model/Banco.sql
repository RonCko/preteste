-- Tabela de Fornecedores:
CREATE TABLE tb_fornecedores (
  for_codigo BIGINT PRIMARY KEY, 
  for_descricao VARCHAR(45) NOT NULL
);

-- Tabela de Funcionários:
CREATE TABLE tb_funcionarios (
  fun_codigo BIGINT PRIMARY KEY,
  fun_nome VARCHAR(45) NOT NULL,
  fun_cpf VARCHAR(45) NOT NULL UNIQUE,
  fun_senha VARCHAR(50) NOT NULL,
  fun_funcao VARCHAR(50) NOT NULL
);

-- Tabela de Vendas:
CREATE TABLE tb_vendas (
  ven_codigo BIGINT PRIMARY KEY,
  ven_horario TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
  ven_valor_total DECIMAL(7,2) NOT NULL,
  tb_funcionarios_fun_codigo BIGINT NOT NULL,
  FOREIGN KEY (tb_funcionarios_fun_codigo) REFERENCES tb_funcionarios(fun_codigo)
);

-- Tabela de Produtos:
CREATE TABLE tb_produtos (
  pro_codigo BIGINT PRIMARY KEY,
  pro_descricao VARCHAR(45) NOT NULL,
  pro_valor DECIMAL(10, 2) NOT NULL,
  pro_quantidade INT NOT NULL,
  tb_fornecedores_for_codigo BIGINT NOT NULL,
  FOREIGN KEY (tb_fornecedores_for_codigo) REFERENCES tb_fornecedores(for_codigo)
);

-- Tabela de Itens:
CREATE TABLE tb_itens (
  ite_codigo BIGINT PRIMARY KEY,
  ite_quantidade INT NOT NULL,
  ite_valor_parcial DECIMAL(10, 2) NOT NULL,
  tb_produtos_pro_codigo BIGINT NOT NULL,
  tb_vendas_ven_codigo BIGINT NOT NULL,
  FOREIGN KEY (tb_produtos_pro_codigo) REFERENCES tb_produtos(pro_codigo),
  FOREIGN KEY (tb_vendas_ven_codigo) REFERENCES tb_vendas(ven_codigo)
);

-- Indexação:

-- Criar um índice na tabela de produtos para a coluna pro_descricao
CREATE INDEX idx_produtos_descricao ON tb_produtos(pro_descricao);

-- Criar um índice na tabela de vendas para a coluna ven_horario
CREATE INDEX idx_vendas_horario ON tb_vendas(ven_horario);

-- Processamento de Transações e Controle de concorrência:

-- Função com Rollback

CREATE OR REPLACE FUNCTION realizar_venda(
    p_fun_codigo BIGINT,
    p_valor_total DECIMAL(7,2)
) RETURNS VOID AS $$
BEGIN
    INSERT INTO tb_vendas (ven_valor_total, tb_funcionarios_fun_codigo) 
    VALUES (p_valor_total, p_fun_codigo);
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Erro ao realizar a venda: %', SQLERRM;
        ROLLBACK;
END;
$$ LANGUAGE plpgsql;

-- Simulação de Transações

BEGIN;

-- Transação 1
INSERT INTO tb_vendas (ven_valor_total, tb_funcionarios_fun_codigo) VALUES (100.00, 1);

-- Transação 2
INSERT INTO tb_vendas (ven_valor_total, tb_funcionarios_fun_codigo) VALUES (150.00, 1);

COMMIT;

-- Recuperação:

-- Função com Verificação de Dados

CREATE OR REPLACE FUNCTION verificar_e_commit(
    p_fun_codigo BIGINT,
    p_valor_total DECIMAL(7,2)
) RETURNS VOID AS $$
BEGIN
    IF p_valor_total > 0 THEN
        INSERT INTO tb_vendas (ven_valor_total, tb_funcionarios_fun_codigo) 
        VALUES (p_valor_total, p_fun_codigo);
    ELSE
        RAISE EXCEPTION 'Valor total deve ser maior que zero';
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
END;
$$ LANGUAGE plpgsql;

-- Rotina de Backup (Usar o terminal)
-- pg_dump -U seu_usuario -F c -b -v -f "backup.bak" seu_banco_de_dados

-- Criar Usuários
CREATE USER usuario1 WITH PASSWORD 'senha1';
CREATE USER usuario2 WITH PASSWORD 'senha2';

-- Criar Grupos
CREATE ROLE grupo_vendas;
CREATE ROLE grupo_admin;

-- Conceder Privilégios
GRANT SELECT, INSERT, UPDATE ON tb_vendas TO grupo_vendas;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO grupo_admin;

-- Adicionar Usuários aos Grupos
GRANT grupo_vendas TO usuario1;
GRANT grupo_admin TO usuario2;

-- Conceder Novo Privilégio
GRANT DELETE ON tb_vendas TO usuario1;
