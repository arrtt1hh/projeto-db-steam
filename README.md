# Projeto de Banco de Dados: Engine de Loja (Baseada na Steam)
**Disciplina:** Banco de Dados I  
**Professor:** Carlos Edilson de Azevedo Barreto Junior  
**Desenvolvedor:** Arthur Silva de Paulo Duarte

## 📌 Visão Geral
Este projeto reproduz a lógica de backend da plataforma **Steam**. O foco foi mapear como os jogos são catalogados, como os desenvolvedores são vinculados a esses títulos e como o sistema processa a aquisição de um item pela biblioteca do usuário.

## 🛠️ Estrutura do Banco
O banco foi projetado com integridade referencial estrita:
- **Relacionamentos:** 1:N entre Desenvolvedoras e Jogos.
- **Relacionamento N:N:** Entre Usuários e Jogos (resolvido através da tabela `biblioteca`).
- **Constraints:** Uso de `CHECK` para impedir preços negativos e `UNIQUE` para credenciais de acesso.

## 🤖 Automação Implementada
Foi desenvolvida uma **Trigger** de transação financeira. Toda vez que um novo registro entra na tabela `biblioteca`, o sistema automaticamente:
1. Localiza o preço do jogo.
2. Verifica se o usuário tem saldo.
3. Deduz o valor da `carteira` do usuário.
4. Incrementa o contador de jogos do perfil.
