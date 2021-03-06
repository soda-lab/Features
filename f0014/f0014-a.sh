#!/usr/bin/env bash

folder=$1
db_name=$2
output_file=$3

for file in $folder/*.gz; do
  filename=$(basename -- "$file")
  filename="${filename%.*}"
  filename="${filename#*mongodb_}"
  mongorestore --gzip --archive=$file \
  && count=`mongo $db_name --eval "printjson(db.getCollection('$filename').count());" --quiet` \
  && index=`mongo $db_name --eval "printjson(db.getCollection('$filename').getIndexes());" --quiet` \
  && echo "$file, $count,$index" >> $output_file \
  && mongo $db_name --eval "db.getCollection('$filename').drop()"
done
