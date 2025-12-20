// 🔹 Remove o grafo se já existir (boa prática)
CALL gds.graph.exists('musicGraph')
YIELD exists
WITH exists
CALL apoc.do.when(
  exists,
  'CALL gds.graph.drop("musicGraph") YIELD graphName RETURN graphName',
  'RETURN null',
  {}
)
YIELD value
RETURN value;


// 🔹 Criação da projeção do grafo para GDS
CALL gds.graph.project(
  'musicGraph',
  ['User','Music','Artist','Genre'],
  {
    LISTENED: {
      type: 'LISTENED',
      orientation: 'UNDIRECTED',
      properties: 'count'
    },
    PERFORMED_BY: {
      type: 'PERFORMED_BY',
      orientation: 'UNDIRECTED'
    },
    BELONGS_TO: {
      type: 'BELONGS_TO',
      orientation: 'UNDIRECTED'
    }
  }
);
