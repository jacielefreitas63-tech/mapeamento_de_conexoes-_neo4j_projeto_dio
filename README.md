# Mapeamento de Conexões Profundas com Neo4j - Projeto DIO

Este projeto faz parte de um desafio da *DIO (Digital Innovation One)*, focado em modelar, construir e consultar um banco de dados de grafos para analisar engajamento e conexões em uma plataforma de mídia social fictícia.

O objetivo é demonstrar como bancos de dados de grafos (NoSQL) são superiores a bancos relacionais (SQL) para cenários onde as conexões entre dados são tão importantes quanto os dados em si.

## 🧠 O Conceito de Mapeamento de Conexões
Diferente de bancos de dados baseados em tabelas, o Neo4j trata as *relações como cidadãos de primeira classe. Isso significa que o banco de dados armazena não apenas quem é usuário ou o que é um post, mas **como* eles estão conectados diretamente.

Isso permite analisar o "efeito rede": como uma curtida de um usuário em um post propaga a informação para toda a sua rede de seguidores.

## 🛠️ Tecnologias Utilizadas
* *Neo4j AuraDB*: Plataforma de banco de dados de grafos na nuvem.
* *Cypher Query Language*: Linguagem de consulta para grafos.

## 📊 Estrutura do Grafo
O modelo foi desenhado utilizando o conceito de Labeled Property Graph:

![Modelo do Grafo](dados/img/modelo_grafo.png) 
* *Nós*:
    * Usuario: Representa as pessoas na rede.
    * Postagem: Conteúdos criados pelos usuários.
    * Comentario: Conteúdos que vinculam usuários a postagens.

* *Relacionamentos*:
    * SEGUE: Direção da conexão entre usuários.
    * POSTOU: Autor de uma postagem.
    * CURTIU: Interação de interesse.
    * ESCREVEU: Conecta usuário ao comentário.
    * EM: Conecta comentário à postagem.

## 📝 Queries de Análise
Abaixo estão as consultas desenvolvidas para extrair insights da rede:

```cypher
// Q1 Quem a 'ana_dev' deveria seguir?
MATCH (eu:Usuario {nome_usuario: 'ana_dev'})-[:SEGUE]->(amigo)-[:SEGUE]->(sugestao)
WHERE NOT (eu)-[:SEGUE]->(sugestao) AND eu <> sugestao
RETURN sugestao.nome_usuario AS Sugestao, 
       count(*) AS AmigosEmComum, 
       sugestao.bio AS Biografia
ORDER BY AmigosEmComum DESC;


//Q2 Quais são os posts mais "quentes"?
MATCH (p:Postagem)
OPTIONAL MATCH (p)<-[:CURTIU]-(u)
OPTIONAL MATCH (p)<-[:EM]-(c:Comentario)
RETURN p.conteudo AS Post, 
       count(DISTINCT u) AS Total_Curtidas, 
       count(DISTINCT c) AS Total_Comentarios,
       (count(DISTINCT u) + count(DISTINCT c)) AS Score_Engajamento
ORDER BY Score_Engajamento DESC;


// Q3 Aqui definimos o caminho usando a função shortestPath diretamente
MATCH (origem:Usuario {nome_usuario: 'elisa_mkt'}), 
      (destino:Usuario {nome_usuario: 'diego_tech'})
MATCH p = shortestPath((origem)-[:SEGUE*..10]->(destino))
RETURN p;


// Q4 Quem são os maiores influenciadores?
MATCH (u:Usuario)
OPTIONAL MATCH (u)<-[:SEGUE]-(seguidor)
OPTIONAL MATCH (u)-[:POSTOU]->(p:Postagem)<-[:CURTIU]-(curtida)
RETURN u.nome_usuario AS Usuario, 
       count(DISTINCT seguidor) AS Seguidores, 
       count(DISTINCT curtida) AS Total_Curtidas_Recebidas
ORDER BY Seguidores DESC, Total_Curtidas_Recebidas DESC;
