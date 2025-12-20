// -----------------------------------------------------------
// 03. ALGORITMOS DE RECOMENDAÇÃO (QUERIES)
// -----------------------------------------------------------

// RECOMENDAÇÃO 1: Por Gênero (Ex: Rock)
// "Quais artistas de Rock recomendar para a Ana que ela ainda não ouviu?"
MATCH (u:User {name: "Ana"})
MATCH (target_g:Genre {name: "Rock"})
MATCH (novo_artista:Artist)-[:BELONGS_TO]->(target_g)
WHERE NOT (u)-[:LISTENED_TO]->(:Music)-[:PERFORMED_BY]->(novo_artista)
RETURN novo_artista.name AS Recomendacao, target_g.name AS Genero;

// RECOMENDAÇÃO 2: Similaridade (Filtro Colaborativo)
// "Músicas que pessoas com gosto similar à Ana ouviram, mas ela não."
MATCH (u1:User {name: "Ana"})-[r1:LISTENED_TO]->(m:Music)<-[r2:LISTENED_TO]-(u2:User)
WHERE u1 <> u2
WITH u1, u2, COUNT(m) AS afinidade
ORDER BY afinidade DESC LIMIT 1
MATCH (u2)-[:LISTENED_TO]->(m_sugerida:Music)
WHERE NOT (u1)-[:LISTENED_TO]->(m_sugerida)
RETURN m_sugerida.name AS Sugestao, u2.name AS Porque_voce_ouviu_como;

// RECOMENDAÇÃO 3: Centralidade (PageRank Simples via Query)
// "Quais os artistas mais influentes (hubs) no meu grafo?"
MATCH (a:Artist)<-[:PERFORMED_BY]-(:Music)<-[r:LISTENED_TO]-(:User)
RETURN a.name AS Artista, SUM(r.count) AS Popularidade_Total
ORDER BY Popularidade_Total DESC;
