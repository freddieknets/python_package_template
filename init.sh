#!/bin/bash

if [[ $# -ne 2 ]]
then
  echo "Usage: $0 <GitHub username> <package_name>"
  exit 1
fi

github_user=$1
name=${2/ /_}

description="Template for python packages"
visibility="public"  # or private

# Capitalise
Nname=${name//[-_]/ }
first=$(echo "${Nname:0:1}" | tr '[:lower:]' '[:upper:]')
Nname=$first${Nname:1}

mv package $name
sed -i '.BLABLA' "s/%package_name%/$name/g" install_protection_hook.sh make_release_branch.py release.py rename_release_branch.py  README.md pyproject.toml examples/stub.py tests/test_version.py
sed -i '.BLABLA' "s/%package_name_capt%/$Nname/g" install_protection_hook.sh make_release_branch.py release.py rename_release_branch.py  README.md $name/__init__.py $name/general.py examples/stub.py tests/test_version.py
sed -i '.BLABLA' "s/%github_user%/$github_user/g" README.md pyproject.toml
sed -i '.BLABLA' "s/%description%/$description/g" README.md pyproject.toml
rm **/*.BLABLA

# TODO:
#   auto-update copyright (year, CERN, correct spaces for package name) and NOTICE
#   set pyproject.toml info
#   Select which shields in README.md to update (e.g. CI, code coverage, pypi, etc.)


# Make on GitHub
gh repo create $name --public --description "$description"

# Make locally
rm -rf .git  # Remove the template's git history
git init
git add .
git rm --cached init.sh
git commit -m "Welcome $Nname!"

# Sync
git branch -M main
git remote add origin git@github.com:$github_user/$name.git
git push -u origin main

rm init.sh
