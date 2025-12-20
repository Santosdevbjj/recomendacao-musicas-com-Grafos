CALL gds.louvain.stream('musicGraph')
YIELD nodeId, communityId
RETURN gds.util.asNode(nodeId).name AS artist, communityId
ORDER BY communityId;
