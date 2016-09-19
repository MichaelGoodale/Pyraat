#!/bin/sh
set -e

#check to see if miniconda folder is empty
if [ ! -d "$HOME/miniconda/miniconda/envs/test-environment$TRAVIS_PYTHON_VERSION" ]; then
  wget http://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh
  chmod +x miniconda.sh
  ./miniconda.sh -b -p $HOME/miniconda/miniconda
  export PATH="$HOME/miniconda/miniconda/bin:$PATH"
  conda config --set always_yes yes --set changeps1 no
  conda update -q conda
  conda info -a
  conda create -q -n "test-environment$TRAVIS_PYTHON_VERSION" python=$TRAVIS_PYTHON_VERSION pytest setuptools
  source activate "test-environment$TRAVIS_PYTHON_VERSION"
  which python
  pip install -q coveralls coverage
else
  echo "Miniconda already installed."
fi

if [ ! -f "$HOME/tools/praat" ]; then
  cd $HOME/downloads
  #FOR WHEN TRAVIS UPDATES TO A NEWER UBUNTU
  #latestVer=$(curl -s 'http://www.fon.hum.uva.nl/praat/download_linux.html' |
  # grep -Eo 'praat[0-9]+_linux64\.tar\.gz' | head -1)

  # Download.
  #curl "http://www.fon.hum.uva.nl/praat/${latestVer}" > praat-latest.tar.gz
  #tar -zxvf praat-latest.tar.gz
  wget http://www.fon.hum.uva.nl/praat/old/5412/praat5412_linux64.tar.gz
  tar -zxvf praat5412_linux64.tar.gz
  mv praat $HOME/tools/praat
else
  echo "Praat already installed."
fi
