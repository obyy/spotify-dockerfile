#!/bin/bash


#update dockerfile avec la bonne version pour spotify.
# location of dockerfile need updated
DOCKERFILE="/home/docky/dockerfile/spotify/Dockerfile"
cd $(dirname "$DOCKERFILE")

#URL repository officiel de Spotify
url="http://repository-origin.spotify.com"

# full version name
SPOTIFY_DEB="$(curl -sS "$url/dists/stable/non-free/binary-amd64/Packages" | awk '$1 == "Package:"{pck=$2} $1 == "Version:"{v=$2} length(v)>0 { print v ; exit}')"

# need tu update git tag.
SPOTIFY_VERSION=$(echo $SPOTIFY_DEB | sed -rn 's=1:(.*)\..*=\1=p')

# check version of dockerfile
SPOTIFY_DEB_OLD=$(sed -rn -e 's/ARG SPOTIFY_DEB="(.*)"$/\1/p' $DOCKERFILE)

  echo "Current version = $SPOTIFY_DEB_OLD"
  echo ""


if [[ "$SPOTIFY_DEB" != "$SPOTIFY_DEB_OLD" ]]; then
  echo "new version available"
  echo "SPOTIFY_DEB=$SPOTIFY_DEB"
  echo ""
  echo "updating ..."
  sed -i -r -e "s/^(ARG SPOTIFY_DEB=).*/\1\"$SPOTIFY_DEB\"/" \
       -e "s/^(ARG SPOTIFY_VERSION=).*/\1\"$SPOTIFY_VERSION\"/" \
       $DOCKERFILE

  #mettre les pushs githubs
  git commit -am "Update to version $SPOTIFY_VERSION"
  git tag "$SPOTIFY_VERSION"
  git push --tags

  # send push
  /usr/bin/slack-push.sh "spotify updating from $SPOTIFY_DEB_OLD to $SPOTIFY_DEB "
else
  echo "Current version from repository (stable): $SPOTIFY_DEB"
  echo "pas de changement de version"
 exit 0
fi

exit 0
