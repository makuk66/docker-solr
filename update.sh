#!/bin/bash
set -e

cd "$(dirname "$(readlink -f "$BASH_SOURCE")")"

template=Dockerfile.template
versions=( "$@" )
if [ ${#versions[@]} -eq 0 ]; then
	versions=( */ )
fi
versions=( "${versions[@]%/}" )

packagesUrl='http://archive.apache.org/dist/lucene/solr/'
upstream_versions='upstream-versions'
curl -sSL $packagesUrl | sed -r -e 's,.*<a href="(([0-9])+\.([0-9])+\.([0-9])+)/">.*,\1,' | grep -E '^[0-9]+\.[0-9]+\.[0-9]+$' | sort --version-sort > "$upstream_versions"

for version in "${versions[@]}"; do
	fullVersion="$(grep "^$version" "$upstream_versions" | tail -n 1)"
	(
		set -x
		cp $template "$version/Dockerfile"
		sed -r -i -e 's/^(ENV SOLR_VERSION) .*/\1 '"$fullVersion"'/' "$version/Dockerfile"
	)
done

rm "$upstream_versions"
