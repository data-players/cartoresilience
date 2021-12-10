const { SparqlEndpointService } = require('@semapps/sparql-endpoint');

module.exports = SparqlEndpointService;

module.exports = {
  mixins: [SparqlEndpointService],
  dependencies: ['fuseki-admin'],
  settings: {
    defaultAccept: 'application/ld+json'
  }
};
