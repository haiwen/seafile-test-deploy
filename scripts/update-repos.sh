#!/bin/bash
current_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
branch="$1"
repos="libsearpc ccnet seafile"
if test "$branch" == "" ; then
  echo "No branch specified"
  read -p "Press [Enter] key to track master branch..."
  branch="master"
fi
echo "trackint remote brach origin/${branch}"
cd "${current_dir}/.."
rm -f "*.timestamp" &>/dev/null
git submodule update --init &>/dev/null

for i in $repos ; do
  printf "updating ${i} ..."
  pushd "${i}"
  if test "$i" == "libsearpc"; then
    git fetch &>/dev/null && git reset --hard "origin/master" &>/dev/null && touch "../${i}.timestamp"
  else
    git fetch &>/dev/null && git reset --hard "origin/${branch}" &>/dev/null && touch "../${i}.timestamp"
  fi
  popd
  if [ -f "${i}.timestamp" ] ; then
    echo "done"
    rm -f "${i}.timestamp" &>/dev/null
  else
    echo "failed"
  fi
done
