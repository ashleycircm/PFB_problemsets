#!/bin/sh


#  Path to Canu.

syst=`uname -s`
arch=`uname -m | sed s/x86_64/amd64/`

bin="/Users/admin/Desktop/Ash/canu/$syst-$arch/bin"

if [ ! -d "$bin" ] ; then
  bin="/Users/admin/Desktop/Ash/canu"
fi

#  Report paths.

echo ""
echo "Found perl:"
echo "  " `which perl`
echo "  " `perl --version | grep version`
echo ""
echo "Found java:"
echo "  " `which java`
echo "  " `java -showversion 2>&1 | head -n 1`
echo ""
echo "Found canu:"
echo "  " $bin/canu
echo "  " `$bin/canu -version`
echo ""


#  Environment for any object storage.

export CANU_OBJECT_STORE_CLIENT=
export CANU_OBJECT_STORE_NAMESPACE=ecoli
export CANU_OBJECT_STORE_PROJECT=








if [ ! -e ./ecoli.unitigs.aligned.gfa ] ; then

  $bin/alignGFA \
    -T ../ecoli.utgStore 2 \
    -i ./ecoli.unitigs.gfa \
    -o ./ecoli.unitigs.aligned.gfa \
    -t 4 \
  > ./ecoli.unitigs.aligned.gfa.err 2>&1
fi


if [ ! -e ./ecoli.contigs.aligned.gfa ] ; then

  $bin/alignGFA \
    -T ../ecoli.ctgStore 2 \
    -i ./ecoli.contigs.gfa \
    -o ./ecoli.contigs.aligned.gfa \
    -t 4 \
  > ./ecoli.contigs.aligned.gfa.err 2>&1
fi


if [ ! -e ./ecoli.unitigs.aligned.bed ] ; then

  $bin/alignGFA -bed \
    -T ../ecoli.utgStore 2 \
    -C ../ecoli.ctgStore 2 \
    -i ./ecoli.unitigs.bed \
    -o ./ecoli.unitigs.aligned.bed \
    -t 4 \
  > ./ecoli.unitigs.aligned.bed.err 2>&1
fi


if [ -e ./ecoli.unitigs.aligned.gfa -a \
     -e ./ecoli.contigs.aligned.gfa -a \
     -e ./ecoli.unitigs.aligned.bed ] ; then
  echo GFA alignments updated.
  exit 0
else
  echo GFA alignments failed.
  exit 1
fi
