// 🔹 Listar grafos carregados
CALL gds.graph.list();


// 🔹 PageRank ponderado por número de escutas
CALL gds.pageRank.write(
  'musicGraph',
  {
    relationshipWeightProperty: 'count',
    writeProperty: 'pagerank'
  }
)
YIELD nodePropertiesWritten, ranIterations, didConverge;


// 🔹 Visualizar ranking apenas de ARTISTAS
MATCH (a:Artist)
RETURN 
  a.name AS Artist,
  a.pagerank AS PageRankScore
ORDER BY PageRankScore DESC
LIMIT 10;
