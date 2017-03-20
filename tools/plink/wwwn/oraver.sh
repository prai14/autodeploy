dbver=`su - oracle -c "sqlplus -H|grep "Release""|awk '{print $3}'`
echo "Release "${dbver}
