# Procedure de Envio de E-mail - Cadastro de Profissionais

Este projeto contém uma procedure (função no banco de dados Oracle) que envia um e-mail com informações sobre referente a cadastro de profissionais.

## Objetivo

O objetivo principal desta procedure é **automatizar o envio de alerta** por e-mail com dados para que os setores responsáveis por cadastrar os profissionais se atentem a informação da especialidade no cadastro do profissional. A procedure contém:

- Nome do profissional;
- Código;
- Tipo de cadastro do profissional;
- Data do cadastro;
- Especialidade.

Essas informações são mostradas em um modelo de e-mail em HTML, pronto para ser enviado.

## Como funciona

A JOB chama diariamente a procedure que olha se há profissionais que foram incluidos na base de dados sem especialidade principal ou que não possuem especialidade.

1. Busca dados do profissional no banco de dados
2. Monta o conteúdo do e-mail com HTML
3. Chama a procedure para enviar esse e-mail para os responsáveis

Tudo isso é feito de forma automática, sem precisar escrever o e-mail manualmente.

## Tecnologias utilizadas

- Oracle PL/SQL
- Banco de dados relacional
- HTML para formatar o e-mail
- JOB

## Uso

Esta procedure pode ser útil para sistemas que:

- Registram cadastro de profissionais.
- Precisam enviar relatórios por e-mail
- Querem automatizar esse processo e ganhar tempo

---

> ⚠️ Atenção: este código é genérico e foi adaptado, para não trazer dados reais de profissionais, nem tabelas do banco de dados.
## Autor
Desenvolvido por Gabriel Lisboa 👨‍💻
