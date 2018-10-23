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











#  Discover the job ID to run, from either a grid environment variable and a
#  command line offset, or directly from the command line.
#
if [ x$CANU_LOCAL_JOB_ID = x -o x$CANU_LOCAL_JOB_ID = xundefined -o x$CANU_LOCAL_JOB_ID = x0 ]; then
  baseid=$1
  offset=0
else
  baseid=$CANU_LOCAL_JOB_ID
  offset=$1
fi
if [ x$offset = x ]; then
  offset=0
fi
if [ x$baseid = x ]; then
  echo Error: I need CANU_LOCAL_JOB_ID set, or a job index on the command line.
  exit
fi
jobid=`expr $baseid + $offset`
if [ x$CANU_LOCAL_JOB_ID = x ]; then
  echo Running job $jobid based on command line options.
else
  echo Running job $jobid based on CANU_LOCAL_JOB_ID=$CANU_LOCAL_JOB_ID and offset=$offset.
fi

if [ -e ../ecoli.ctgStore/seqDB.v001.tig -a -e ../ecoli.utgStore/seqDB.v001.tig ] ; then
  exit 0
fi

if [ ! -e ../ecoli.ctgStore -o \
     ! -e ../ecoli.utgStore ] ; then
  $bin/bogart \
    -S ../../ecoli.seqStore \
    -O    ../ecoli.ovlStore \
    -o     ./ecoli \
    -gs 4800000 \
    -eg 0.045 \
    -eM 0.045 \
    -mo 500 \
    -dg 6 \
    -db 6 \
    -dr 3 \
    -ca 2100 \
    -cp 200 \
    -threads 4 \
    -M 16 \
    -unassembled 2 0 1.0 0.5 3 \
    > ./unitigger.err 2>&1 \
  && \
  mv ./ecoli.ctgStore ../ecoli.ctgStore \
  && \
  mv ./ecoli.utgStore ../ecoli.utgStore
fi

if [ ! -e ../ecoli.ctgStore -o \
     ! -e ../ecoli.utgStore ] ; then
  echo bogart appears to have failed.  No ecoli.ctgStore or ecoli.utgStore found.
  exit 1
fi











if [ ! -e ../ecoli.ctgStore/seqDB.v001.sizes.txt ] ; then
  $bin/tgStoreDump \
    -S ../../ecoli.seqStore \
    -T ../ecoli.ctgStore 1 \
    -sizes -s 4800000 \
   > ../ecoli.ctgStore/seqDB.v001.sizes.txt
fi


exit 0
