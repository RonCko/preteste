## 📚 **Trabalho 2 - Banco de Dados 2**  
**Curso:** Engenharia de Software  
**Universidade:** Universidade Tecnológica Federal do Paraná - Câmpus Dois Vizinhos  
**Data de Entrega:** dd/02/2024  

### **Descrição do Projeto**  
Este trabalho consiste no desenvolvimento de uma aplicação simples integrada a um banco de dados PostgreSQL, com foco na realização de operações de vendas. A aplicação não precisa ser totalmente implementada, mas deve ser capaz de realizar a venda de produtos de forma completa. Além disso, deve ser incluído um relatório explicando o funcionamento do sistema e as implementações dos itens a seguir.

### **Requisitos do Projeto**

1. **Desenvolver a aplicação de vendas**  
   - A aplicação deve permitir a operação de venda de produtos de maneira funcional.

2. **Indexação**  
   - Criar um ou mais índices para algumas tabelas do projeto.
   - Analisar e escrever conclusões sobre a criação dos índices.

3. **Processamento de Transações e Controle de Concorrência**  
   - Criar uma função em PL/pgSQL com teste de comando `Rollback` para garantir a integridade de dados.
   - Simular duas ou mais transações utilizando um mesmo recurso simultaneamente, para observar o controle de transações funcionando.

4. **Recuperação de Dados**  
   - Criar uma função que verifica a consistência dos dados antes de fazer o `Commit`, utilizando `Exception` para garantir que dados incorretos resultem em `Rollback`.
   - Desenvolver uma rotina de backup do banco de dados e integrá-la ao sistema.

5. **Segurança no Banco de Dados** 
   - Criar usuários e grupos no banco de dados, concedendo diferentes privilégios de acesso.
   - Testar login com diferentes usuários, garantindo que os privilégios sejam corretamente aplicados.
   - Adicionar um novo privilégio a um usuário que já pertence a um grupo e verificar se todos os usuários desse grupo receberam o novo privilégio.

### **Tecnologias Utilizadas**  
- **Banco de Dados:** PostgreSQL
- **Linguagem de Programação:** PL/pgSQL (para funções e transações)
- **Interface Gráfica:** Exemplo: Python ou Java (Tkinter ou PyQt)

### **Objetivo do Trabalho**  
Este trabalho visa desenvolver habilidades em integração de aplicações com banco de dados, manipulação de dados, controle de transações, segurança e gestão de privilégios, além de otimização de consultas por meio da criação de índices. O projeto também inclui a implementação de uma rotina de backup para garantir a recuperação dos dados.

### **Link para o Trello**
O projeto está sendo gerenciado através de um quadro no Trello. Para acompanhar o progresso e o status das tarefas, acesse o Trello do Projeto - Banco de Dados 2. 
Trabalho de Banco de dados 2 
Link para o Trello: https://trello.com/invite/b/677e65cb9121d5c4b0109559/ATTIfb903a1fca57626c42b84ebec001345919843A33/trabalho-de-banco-2


