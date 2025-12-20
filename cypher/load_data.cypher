LOAD CSV WITH HEADERS FROM 'file:///dataset_grafo.csv' AS row

MERGE (u:User {id: row.user_id})
MERGE (m:Music {id: row.music_id})
MERGE (a:Artist {name: row.artist})
MERGE (g:Genre {name: row.genre})

MERGE (m)-[:PERFORMED_BY]->(a)
MERGE (a)-[:BELONGS_TO]->(g)

MERGE (u)-[l:LISTENED]->(m)
SET l.count = toInteger(row.listen_count)

FOREACH (_ IN CASE WHEN row.liked = 'true' THEN [1] ELSE [] END |
    MERGE (u)-[:LIKED]->(m)
)
