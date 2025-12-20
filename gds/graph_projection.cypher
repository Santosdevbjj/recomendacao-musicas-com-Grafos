CALL gds.graph.project(
  'musicGraph',
  ['User','Music','Artist'],
  {
    LISTENED: {type:'LISTENED', orientation:'UNDIRECTED'},
    PERFORMED_BY: {type:'PERFORMED_BY', orientation:'UNDIRECTED'}
  }
);
