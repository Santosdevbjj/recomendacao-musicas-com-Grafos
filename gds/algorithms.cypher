CALL gds.graph.list();

CALL gds.pageRank.write(
  'musicGraph',
  { writeProperty: 'pagerank' }
);
