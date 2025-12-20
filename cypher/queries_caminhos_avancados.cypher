MATCH (u:User {id:'1'})-[:LISTENED]->(:Music)<-[:LISTENED]-(other:User)
      -[:LISTENED]->(:Music)-[:PERFORMED_BY]->(a:Artist)
WHERE NOT (u)-[:LISTENED]->(:Music)-[:PERFORMED_BY]->(a)
RETURN a.name AS RecommendedArtist, count(*) AS relevance
ORDER BY relevance DESC
LIMIT 5;
