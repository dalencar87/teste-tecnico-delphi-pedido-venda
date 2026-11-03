# Teste Técnico Delphi - [pedido-venda]
Delphi 10.4 Sydney, VCL win32
FireDAC
Firebird 2.5 (dialect 3 UTF8)

# Estrutura

- bin: executável, fbclient.dll e config.ini
- database: script do banco (db.sql)
- src: código fonte (model, repository, service, tools, view)
- tests: testes unitários (DUnitX)

# Banco de dados

1. Criar um banco vazio com dialect 3 e charset UTF8 (ex.: bin\PEDIDO.FDB);
2. Executar o script database\db.sql (IBExpert: Tools > Script Executive).

# Configuração

1. Copiar o config.ini.example para bin\config.ini (pasta do executável);
2. Preencher os dados de conexão:

```ini
[Database]
Database=PEDIDO.FDB
Username=SYSDBA
Password=sua_senha
Server=127.0.0.1
Port=3050
ClientLibrary=fbclient.dll
```

- Database e ClientLibrary são relativos à pasta do executável;
- Usar 127.0.0.1 em vez de localhost (o Firebird 2.5 não escuta em IPv6).

# Execução

1. Abrir src\Pedidos.dproj e compilar em Win32;
2. Conferir se o fbclient.dll (32 bits) e o config.ini estão na pasta bin;
3. Executar bin\Pedidos.exe.

# Atalhos da tela

- ENTER no grid: editar o item selecionado;
- DEL no grid: excluir o item selecionado;
- Carregar: abre o pedido informado em modo consulta;
- Cancelar: exclui o pedido e os itens;
- Novo Pedido: limpa a tela.

# Testes manuais

1. Informar o cliente 999: deve exibir mensagem e limpar os campos;
2. Informar o cliente 1: deve preencher nome, cidade e UF;
3. Informar o produto 999: deve exibir mensagem e limpar os campos;
4. Inserir os itens:
   - produto 1, quantidade 2, valor 27,90 = 55,80;
   - produto 4, quantidade 3, valor 18,75 = 56,25;
   - produto 6, quantidade 12, valor 5,39 = 64,68;
   - total do pedido: 176,73;
5. Inserir um item com quantidade 0: deve ser recusado;
6. ENTER no produto 4, alterar a quantidade para 1 e atualizar: total 139,23;
7. DEL no produto 6: total 74,55;
8. Informar a observação e gravar: deve exibir o número do pedido e limpar a tela;
9. Conferir no banco a tabela PEDIDO (VALOR_TOTAL 74,55 e OBSERVACAO) e PEDIDO_ITEM (2 itens);
10. Tentar gravar sem cliente e sem itens: não deve gravar;
11. Carregar o pedido gravado: deve exibir cabeçalho, observação, itens e total;
12. Novo Pedido: deve limpar a tela e liberar a edição;
13. Carregar o pedido e cancelar: ao carregar de novo, deve exibir "Pedido não encontrado".

# Testes unitários

1. Abrir tests\PedidosTests.dproj;
2. Compilar e executar (F9); o resultado é exibido no console.

Cobre a totalização do pedido: inserir, atualizar, excluir itens, arredondamento e validações.

# Manutenção

- Adicionado campo observação ao pedido de venda;
- Correção total do item ao excluir, a tela foi feita para sempre recalcular o valor a partir dos itens.

# Bônus

- Carregar pedido por número;
- Cancelar pedido (pedido + itens com transação);
- Testes unitários (DUnitX) da totalização.
