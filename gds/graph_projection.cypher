CALL gds.graph.project(
  'musicGraph',
  ['User', 'Music', 'Artist', 'Genre'],
  {
    LISTENED: {
      type: 'LISTENED',
      orientation: 'UNDIRECTED',
      properties: {
        count: {
          property: 'count',
          defaultValue: 1
        }
      }
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
