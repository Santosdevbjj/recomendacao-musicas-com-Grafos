MATCH (u:User {id:'1'})-[:LISTENED]->(:Music)<-[:LISTENED]-(other:User)
      -[:LISTENED]->(:Music)-[:PERFORMED_BY]->(a:Artist)
WHERE NOT (u)-[:LISTENED]->(:Music)-[:PERFORMED_BY]->(a)
RETURN a.name AS RecommendedArtist, count(*) AS relevance
ORDER BY relevance DESC
LIMIT 5;

MATCH path = (u:User {id:'1'})-[:LISTENED]->(:Music)
             -[:PERFORMED_BY]->(:Artist)
             -[:BELONGS_TO]->(g:Genre)
             <-[:BELONGS_TO]-(:Artist)<-[:PERFORMED_BY]-(:Music)
WHERE length(path) = 5
RETURN DISTINCT g.name AS Genre, 
                last(nodes(path)).name AS RecommendedArtist
LIMIT 10;



MATCH (u:User {id:'1'}), (a:Artist {name:'Queen'})
MATCH p = shortestPath((u)-[*..6]-(a))
RETURN p;


MATCH path = (u:User {id:'1'})-[l:LISTENED]->(:Music)
             -[:PERFORMED_BY]->(a:Artist)
WITH a, sum(l.count) AS total_listens
RETURN a.name AS Artist, total_listens
ORDER BY total_listens DESC
LIMIT 5;


MATCH path = (u1:User)-[:LISTENED]->(:Music)-[:PERFORMED_BY]->(:Artist)
             -[:BELONGS_TO]->(:Genre)
             <-[:BELONGS_TO]-(:Artist)<-[:PERFORMED_BY]-(:Music)
             <-[:LISTENED]-(u2:User)
WHERE u1 <> u2
RETURN DISTINCT u1.id AS User1, u2.id AS User2, path
LIMIT 5;


MATCH p = (u:User)-[:LISTENED]->(:Music)-[:PERFORMED_BY]->(a:Artist)
RETURN a.name AS Artist, count(p) AS pathFrequency
ORDER BY pathFrequency DESC
LIMIT 10;



MATCH (a:Artist)<-[:PERFORMED_BY]-(:Music)<-[:LISTENED]-(u:User)
WITH a, count(DISTINCT u) AS listeners
WHERE listeners <= 2
RETURN a.name AS NicheArtist, listeners
ORDER BY listeners ASC;



