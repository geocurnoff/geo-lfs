
rm *.tar.* &> /dev/null

wget http://www.bzip.org/1.0.6/bzip2-1.0.6.tar.gz || die "Fetching sources for package $NAME failed."