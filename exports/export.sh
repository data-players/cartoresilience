#!/usr/bin/env bash
# Export complet des données ADEME (Carto Résilience) via l'API SPARQL
# (aucun accès direct aux fichiers Fuseki).
#
# Par défaut : repli sur l'endpoint SPARQL de Fuseki (l'API publique est hors ligne).
#   FUSEKI_USER=… FUSEKI_PASSWORD=… ./export.sh
# Si l'API publique est revenue, elle ne nécessite pas d'authentification :
#   SPARQL_ENDPOINT=https://data.resilience.data-players.com/sparql ./export.sh
set -euo pipefail

OUT="$(cd "$(dirname "$0")" && pwd)"
ENDPOINT="${SPARQL_ENDPOINT:-http://54.38.255.109:3030/localData/sparql}"
QUERY='CONSTRUCT { ?s ?p ?o } WHERE { { ?s ?p ?o } UNION { GRAPH ?g { ?s ?p ?o } } }'

AUTH=()
if [[ "$ENDPOINT" != *"data.resilience.data-players.com"* ]]; then
  : "${FUSEKI_USER:?définir FUSEKI_USER (identifiants Fuseki internes)}"
  : "${FUSEKI_PASSWORD:?définir FUSEKI_PASSWORD (identifiants Fuseki internes)}"
  AUTH=(-u "${FUSEKI_USER}:${FUSEKI_PASSWORD}")
fi

echo "→ ademe.jsonld  ($ENDPOINT)"
curl -sS --fail --retry 3 "${AUTH[@]}" -G \
  --data-urlencode "query=$QUERY" \
  -H 'Accept: application/ld+json' \
  "$ENDPOINT" -o "$OUT/ademe.jsonld"

echo "→ ademe.ttl  ($ENDPOINT)"
curl -sS --fail --retry 3 "${AUTH[@]}" -G \
  --data-urlencode "query=$QUERY" \
  -H 'Accept: text/turtle' \
  "$ENDPOINT" -o "$OUT/ademe.ttl"

if python3 -c 'import rdflib' >/dev/null 2>&1; then
  python3 - "$OUT" <<'PY'
import sys
from pathlib import Path
import rdflib
out = Path(sys.argv[1])
g = rdflib.Graph()
g.parse(out / "ademe.ttl", format="turtle")
g.serialize(destination=out / "ademe.nt", format="nt")
g.serialize(destination=out / "ademe.rdf", format="xml")
print(f"ademe: {len(g)} triplets → .nt + .rdf (RDF/XML)")
PY
else
  echo "rdflib absent : .nt/.rdf non générés (pip install rdflib)." >&2
fi
