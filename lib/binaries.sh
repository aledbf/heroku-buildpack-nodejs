needs_resolution() {
  local semver=$1
  if ! [[ "$semver" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    return 0
  else
    return 1
  fi
}

install_nodejs() {
  local version="$1"
  local dir="$2"

  if needs_resolution "$version"; then
    echo "Resolving node version ${version:-(latest stable)} via semver.io..."
    local version=$(curl --silent --get --retry 5 --retry-max-time 15 --data-urlencode "range=${version}" https://semver.herokuapp.com/node/resolve)
  fi

  echo "Downloading and installing node $version..."
  #local download_url="https://s3pository.heroku.com/node/v$version/node-v$version-$os-$cpu.tar.gz"
  #curl "$download_url" --silent --fail  --retry 5 --retry-max-time 15 -o /tmp/node.tar.gz || (echo "Unable to download node $version; does it exist?" && false)
  if [ ! -f /tmp/node.js/node-v$version-$os-$cpu.tar.gz ]; then
    tar xzf /tmp/node.js/latest-node-$os-$cpu.tar.gz -C /tmp
  else
    tar xzf /tmp/node.js/node-v$version-$os-$cpu.tar.gz -C /tmp
  fi

  rm -rf $dir/*
  mv /tmp/node-v$version-$os-$cpu/* $dir
  chmod +x $dir/bin/*
}
