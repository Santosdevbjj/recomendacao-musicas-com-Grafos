CALL gds.pageRank.stream('musicGraph')
YIELD nodeId, score
RETURN gds.util.asNode(nodeId).name AS artist, score
ORDER BY score DESC
LIMIT 10;
