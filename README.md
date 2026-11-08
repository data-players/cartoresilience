# cartoresilience

Serveur SemApps de Carto Résilience (ADEME).

## Exports de données

Les exports JSON-LD / RDF du triplestore sont publiés dans le dépôt dédié
[`data-players/semapps-exports`](https://gitlab.com/data-players/semapps-exports) et servis par Vercel :

- JSON-LD : https://semapps-exports.vercel.app/ademe/ademe.jsonld
- Turtle : https://semapps-exports.vercel.app/ademe/ademe.ttl
- N-Triples : https://semapps-exports.vercel.app/ademe/ademe.nt
- RDF/XML : https://semapps-exports.vercel.app/ademe/ademe.rdf

Les copies locales restent dans [`exports/`](./exports/) pour l'archivage et la régénération
(`FUSEKI_USER=… FUSEKI_PASSWORD=… ./exports/export.sh`). Après régénération, copier les fichiers
dans le dépôt `semapps-exports` puis pousser : Vercel redéploie automatiquement.
