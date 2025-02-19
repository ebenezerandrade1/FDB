# 📊 Sistema de Informação de Mortalidade - Banco de Dados Relacional

##  Introdução

Este projeto tem como objetivo a criação de um **banco de dados relacional** para armazenar e analisar informações sobre óbitos, utilizando dados extraídos do Sistema de Informação de Mortalidade (SIM). A implementação inclui **ETL**, **views**, **procedures**, **triggers** e diversas consultas SQL para explorar os dados.

## Modelo de Dados Relacional

O banco de dados foi estruturado seguindo os princípios da **modelagem relacional**, garantindo **integridade referencial** e **normalização**. O esquema contém as seguintes tabelas:

- **`obitos`** - Registros dos óbitos com detalhes como local, hora, causa da morte, entre outros.
- **`localizacoes`** - Municípios e estados onde os óbitos ocorreram.
- **`causas`** - Código CID e descrição das causas de morte.