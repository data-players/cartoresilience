const { LdpService } = require('@semapps/ldp');
const ontologies = require('../ontologies');
const containers = require('../containers');
const urlJoin = require('url-join');

module.exports = {
  mixins: [LdpService],
  dependencies: ['fuseki-admin'],
  settings: {
    baseUrl: process.env.SEMAPPS_HOME_URL,
    ontologies,
    containers,
    defaultContainerOptions: {
      allowAnonymousEdit: true,
      allowAnonymousDelete: true,
      jsonContext: urlJoin(process.env.SEMAPPS_HOME_URL, 'context.json')
    }
  }
};
