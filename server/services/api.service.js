const ApiGatewayService = require('moleculer-web');
const { Routes: SparqlEndpointRoutes } = require('@semapps/sparql-endpoint');

module.exports = {
  mixins: [ApiGatewayService],
  dependencies: ['fuseki-admin'],
  settings: {
    routes: [],
    cors: {
      origin: '*',
      methods: ['GET', 'PUT', 'PATCH', 'POST', 'DELETE', 'HEAD', 'OPTIONS'],
      exposedHeaders: '*'
    }
  },
  methods: {
    authenticate(ctx, route, req, res) {
      return Promise.resolve(ctx);
    },
    authorize(ctx, route, req, res) {
      return Promise.resolve(ctx);
    }
  }
};
