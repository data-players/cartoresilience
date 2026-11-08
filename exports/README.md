# Export des données — ADEME (Carto Résilience)

Extraction complète du triplestore **via l'API SPARQL** de l'instance SemApps
(aucun accès direct aux fichiers Fuseki).

- API SemApps publique prévue : `https://data.resilience.data-players.com/sparql`
  → **indisponible** au 08/11/2026 (DNS OK, ports 80/443 fermés)
- Repli utilisé : `http://54.38.255.109:3030/localData/sparql` (endpoint SPARQL de Fuseki)
  → identifiants Fuseki : coffre d'accès interne Data Players (non versionné ici)
- Requête :

```sparql
CONSTRUCT { ?s ?p ?o }
WHERE { { ?s ?p ?o } UNION { GRAPH ?g { ?s ?p ?o } } }
```

Volumétrie : **25 106 triplets** (08/11/2026). Toutes les données sont dans le graphe par défaut.

| Fichier | Format | Taille |
|---|---|---|
| `ademe.jsonld` | JSON-LD | 2,3 Mo |
| `ademe.ttl` | Turtle (RDF) | 2,7 Mo |
| `ademe.nt` | N-Triples | 4,8 Mo |
| `ademe.rdf` | RDF/XML | 3,0 Mo |

`.jsonld` et `.ttl` sont produits directement par l'API ; `.nt` et `.rdf` sont dérivés du `.ttl`.
Validation par reparse `rdflib` : 25 106 triplets dans chaque fichier.

## Régénérer

```bash
FUSEKI_USER=… FUSEKI_PASSWORD=… ./export.sh
# ou, si l'API publique est revenue :
SPARQL_ENDPOINT=https://data.resilience.data-players.com/sparql ./export.sh
```

Dépendances : `curl` ; `rdflib` optionnel (formats `.nt`/`.rdf`).
