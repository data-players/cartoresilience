# cartoresilience

Serveur SemApps de Carto Résilience (ADEME).

## Statut — serveur décommissionné

L'instance OVH Public Cloud `resilience` (`54.38.255.109`, flavor `d2-8`, GRA5) a été
**supprimée définitivement le 08/11/2026**, ainsi que ses snapshots associés.

Les données sont archivées et servies par Vercel :

- JSON-LD : https://semapps-exports.vercel.app/ademe/ademe.jsonld
- Turtle : https://semapps-exports.vercel.app/ademe/ademe.ttl
- N-Triples : https://semapps-exports.vercel.app/ademe/ademe.nt
- RDF/XML : https://semapps-exports.vercel.app/ademe/ademe.rdf

Elles restent reproductibles via les workflows d'injection de données (à rejouer sur
une nouvelle instance SemApps). Voir aussi
[`prod-infos/acces/serveurs-decommissionnes.md`](https://github.com/data-players/prod-infos/blob/main/acces/serveurs-decommissionnes.md).

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
