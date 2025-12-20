// Recomendar artistas de Rock
MATCH (u:User)-[:LISTENED]->(:Music)-[:PERFORMED_BY]->(a:Artist)-[:BELONGS_TO]->(g:Genre {name:'Rock'})
RETURN a.name, count(*) AS popularity
ORDER BY popularity DESC
LIMIT 5;

// Recomendar artistas de Sertanejo
MATCH (u:User)-[:LISTENED]->(:Music)-[:PERFORMED_BY]->(a:Artist)-[:BELONGS_TO]->(g:Genre {name:'Sertanejo'})
RETURN a.name, count(*) AS popularity
ORDER BY popularity DESC;
