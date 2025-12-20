// 1️⃣ Recomendar artistas via usuários com gosto similar (2 saltos)
MATCH (u:User {id:'1'})-[:LISTENED]->(m1:Music)
      <-[:LISTENED]-(other:User)
      -[:LISTENED]->(m2:Music)
      -[:PERFORMED_BY]->(a:Artist)
WHERE NOT (u)-[:LISTENED]->(:Music)-[:PERFORMED_BY]->(a)
RETURN a.name AS RecommendedArtist, count(*) AS relevance
ORDER BY relevance DESC
LIMIT 5;


// 2️⃣ Descoberta de artistas por caminho de gênero
MATCH path = (u:User {id:'1'})-[:LISTENED]->(:Music)
             -[:PERFORMED_BY]->(:Artist)
             -[:BELONGS_TO]->(g:Genre)
             <-[:BELONGS_TO]-(:Artist)
             <-[:PERFORMED_BY]-(:Music)
WHERE length(path) = 6
RETURN DISTINCT 
       g.name AS Genre, 
       last(nodes(path)).name AS RecommendedArtist
LIMIT 10;


// 3️⃣ Caminho mais curto explicável entre usuário e artista
MATCH (u:User {id:'1'}), (a:Artist {name:'Queen'})
MATCH p = shortestPath(
  (u)-[:LISTENED|PERFORMED_BY|BELONGS_TO*..6]-(a)
)
RETURN p;


// 4️⃣ Ranking de artistas por força de escuta (peso na aresta)
MATCH (u:User {id:'1'})-[l:LISTENED]->(:Music)
      -[:PERFORMED_BY]->(a:Artist)
WITH a, sum(l.count) AS total_listens
RETURN a.name AS Artist, total_listens
ORDER BY total_listens DESC
LIMIT 5;


// 5️⃣ Conexões entre usuários por caminhos musicais (cross-genre)
MATCH path = (u1:User)-[:LISTENED]->(:Music)
             -[:PERFORMED_BY]->(:Artist)
             -[:BELONGS_TO]->(:Genre)
             <-[:BELONGS_TO]-(:Artist)
             <-[:PERFORMED_BY]-(:Music)
             <-[:LISTENED]-(u2:User)
WHERE u1 <> u2
RETURN DISTINCT u1.id AS User1, u2.id AS User2, path
LIMIT 5;


// 6️⃣ Artistas mais centrais nos caminhos do grafo
MATCH p = (u:User)-[:LISTENED]->(:Music)-[:PERFORMED_BY]->(a:Artist)
RETURN a.name AS Artist, count(p) AS pathFrequency
ORDER BY pathFrequency DESC
LIMIT 10;


// 7️⃣ Descoberta de artistas de nicho
MATCH (a:Artist)<-[:PERFORMED_BY]-(:Music)<-[:LISTENED]-(u:User)
WITH a, count(DISTINCT u) AS listeners
WHERE listeners <= 2
RETURN a.name AS NicheArtist, listeners
ORDER BY listeners ASC;
