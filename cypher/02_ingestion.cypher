// -----------------------------------------------------------
// 02. INGESTÃO DE DADOS (ETL)
// -----------------------------------------------------------

// Carrega o CSV (Certifique-se que o arquivo está na pasta 'import' do Neo4j ou use uma URL)
LOAD CSV WITH HEADERS FROM 'file:///dataset_spotify.csv' AS line

// Criar Nós de Usuário
MERGE (u:User {id: toInteger(line.user_id)})
SET u.name = line.user_name

// Criar Nós de Gênero
MERGE (g:Genre {name: line.genre})

// Criar Nós de Artista
MERGE (a:Artist {name: line.artist})

// Criar Nós de Música
MERGE (m:Music {id: toInteger(line.music_id)})
SET m.name = line.music_name

// Criar Relacionamento: Música pertence a um Artista
MERGE (m)-[:PERFORMED_BY]->(a)

// Criar Relacionamento: Artista pertence a um Gênero
MERGE (a)-[:BELONGS_TO]->(g)

// Criar Relacionamento: Usuário interagiu com a Música
MERGE (u)-[r:LISTENED_TO]->(m)
SET r.count = toInteger(line.listen_count),
    r.liked = toBoolean(line.liked);
