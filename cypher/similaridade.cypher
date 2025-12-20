CALL gds.nodeSimilarity.stream('musicGraph')
YIELD node1, node2, similarity
RETURN 
  gds.util.asNode(node1).name AS Artist1,
  gds.util.asNode(node2).name AS Artist2,
  similarity
ORDER BY similarity DESC
LIMIT 10;
