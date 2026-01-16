# Gerenciador de Estoque App

Este é um aplicativo mobile desenvolvido com o framework Flutter para facilitar o gerenciamento de produtos e clientes. O sistema permite o controle de entrada de itens, registro de vendas e acompanhamento de estoque em tempo real.

## Funcionalidades

- Autenticação: Sistema de login para acesso restrito.
- Gestão de Produtos: Cadastro, edição e visualização de itens.
- Gestão de Clientes: Cadastro e listagem de base de clientes.
- Módulo de Vendas: Funcionalidade dedicada para processar saídas de estoque (SellPage).
- Interface: Navegação organizada por abas e menus funcionais.

## Tecnologias Utilizadas

- Linguagem: Dart
- Framework: Flutter
- Backend: Firebase (Firestore e Authentication)
- Gerenciamento de Estado: AppController

## Estrutura de Arquivos Principal

A organização do código na pasta lib segue esta estrutura:

- main.dart: Inicialização do aplicativo.
- AppWidget.dart: Configurações globais de rotas e temas.
- loginPage.dart: Interface de autenticação.
- inicio.dart / myhomepage.dart: Telas principais de navegação.
- produtos.dart / InsertPage.dart: Telas de listagem e cadastro de mercadorias.
- clientes.dart / addclient.dart: Gerenciamento de informações de clientes.
- SellPage.dart: Lógica para processamento de vendas.
