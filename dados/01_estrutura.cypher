// --------------------------------------------------------------------------
// 1. CONFIGURAÇÃO DE REGRAS (Constraints)
// --------------------------------------------------------------------------
// Garante que não existam usuários com o mesmo nome de usuário
CREATE CONSTRAINT Usuario_Unico IF NOT EXISTS FOR (u:Usuario) REQUIRE u.nome_usuario IS UNIQUE;

// Garante que cada postagem tenha um ID exclusivo
CREATE CONSTRAINT Postagem_Unica IF NOT EXISTS FOR (p:Postagem) REQUIRE p.id IS UNIQUE;

// --------------------------------------------------------------------------
// 2. CRIAÇÃO DOS NÓS (Entidades da Rede Social)
// --------------------------------------------------------------------------

// Criando Perfis de Usuários
CREATE (u1:Usuario {nome_usuario: 'ana_dev', nome_real: 'Ana Souza', bio: 'Desenvolvedora Fullstack'})
CREATE (u2:Usuario {nome_usuario: 'bruno_dados', nome_real: 'Bruno Lima', bio: 'Cientista de Dados'})
CREATE (u3:Usuario {nome_usuario: 'carla_ux', nome_real: 'Carla Silva', bio: 'Designer de Produto'})
CREATE (u4:Usuario {nome_usuario: 'diego_tech', nome_real: 'Diego Santos', bio: 'CTO em Startup'})
CREATE (u5:Usuario {nome_usuario: 'elisa_mkt', nome_real: 'Elisa Dias', bio: 'Especialista em Marketing'})

// Criando Postagens de Conteúdo
CREATE (p1:Postagem {id: 'POST001', conteudo: 'Bancos de dados de grafos são incríveis para conexões!', data_criacao: datetime()})
CREATE (p2:Postagem {id: 'POST002', conteudo: 'Dicas de como otimizar suas consultas em Cypher.', data_criacao: datetime()})
CREATE (p3:Postagem {id: 'POST003', conteudo: 'Meu novo projeto de análise de redes sociais na DIO.', data_criacao: datetime()})

// Criando Comentários (Nós intermediários para medir engajamento)
CREATE (c1:Comentario {id: 'COM001', texto: 'Concordo plenamente com isso!', data: datetime()})
CREATE (c2:Comentario {id: 'COM002', texto: 'Conteúdo muito relevante, parabéns.', data: datetime()})

// --------------------------------------------------------------------------
// 3. CRIAÇÃO DOS RELACIONAMENTOS (As Conexões)
// --------------------------------------------------------------------------

// Relacionamentos de Seguidores (Rede de Contatos)
CREATE (u1)-[:SEGUE]->(u2)
CREATE (u1)-[:SEGUE]->(u3)
CREATE (u2)-[:SEGUE]->(u3)
CREATE (u2)-[:SEGUE]->(u4)
CREATE (u3)-[:SEGUE]->(u4)
CREATE (u5)-[:SEGUE]->(u1)

// Relacionamentos de Autoria e Interação
CREATE (u1)-[:POSTOU]->(p3)
CREATE (u2)-[:POSTOU]->(p2)
CREATE (u4)-[:POSTOU]->(p1)

// Curtidas (Engajamento Rápido)
CREATE (u1)-[:CURTIU]->(p1)
CREATE (u2)-[:CURTIU]->(p1)
CREATE (u3)-[:CURTIU]->(p1)
CREATE (u5)-[:CURTIU]->(p3)

// Fluxo de Comentários (Engajamento Profundo)
CREATE (u1)-[:ESCREVEU]->(c1)
CREATE (c1)-[:EM]->(p1)
