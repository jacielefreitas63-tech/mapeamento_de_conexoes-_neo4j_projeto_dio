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
