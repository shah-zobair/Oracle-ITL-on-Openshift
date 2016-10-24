#!/bin/bash

mkdir -p /apps/opt/consumer/searchapp/tmp/
mkdir -p /apps/opt/consumer/search/searchresources

#host=`hostname`
#echo $host
#cd /apps/opt/consumer/searchapp/tmp/
#host=`hostname`

cp /u01/oracle/ATGDATA.tar /apps/opt/consumer/searchapp/
tar -xvf /apps/opt/consumer/searchapp/ATGDATA.tar
rm -f /apps/opt/consumer/searchapp/ATGDATA.tar

#cd /apps/opt/consumer/search/searchresources 
cp /u01/oracle/js_css.tar /apps/opt/consumer/search/searchresources/
tar -xvf /apps/opt/consumer/search/searchresources/js_css.tar
rm -f /apps/opt/consumer/search/searchresources/js_css.tar

#cd /apps/opt/consumer/searchapp/
#rm -rf tmp



