
rm -rf $SRC &> /dev/null

mkdir -pv $SRC

cd $SRC

tar -xvf $CACHE/*.tar.gz

cd ./*/

# Ensure that gawk is found first during configuration
sed -i s/mawk// configure