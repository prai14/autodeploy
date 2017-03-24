#!/bin/sh

#sh get-odm-info.sh 2>/dev/null > odm-info-10.3.0.18

echo "-----------------------odmget -q & getlvodm -v---------------------"
for i in `lsvg -o`
do
    echo "---------------------------------"
    echo "$i====>"
    echo "---------------------------------"
    echo "odmget -q name=$i CuAt"
    echo "---------------------------------"
    odmget -q name=$i CuAt
    echo "---------------------------------"
    echo "odmget -q name=$i CuDep"
    echo "---------------------------------"
    odmget -q name=$i CuDep
    echo "---------------------------------"
    echo "odmget -q name=$i CuAv"
    echo "---------------------------------"
    odmget -q name=$i CuAv
    echo "---------------------------------"
    echo "odmget -q name=$i CuDvDr"
    echo "---------------------------------"
    odmget -q name=$i CuDvDr
    echo "---------------------------------"
    echo "getlvodm -v $i"
    echo "---------------------------------"
    getlvodm -v $i
done

echo "-----------------------getlvodm -p---------------------"
for i in `lspv|awk '{print $1}'`
do
    echo "---------------------------------"
    echo "$i====>"
    echo "---------------------------------"
    echo "getlvodm -p $i"
    echo "---------------------------------"
    getlvodm -p $i
done

echo "-----------------------getlvcb -AT---------------------"
for i in `lsvg -o|lsvg -il|grep -v \:|grep -v "LV NAME"|awk '{print $1}'`
do
    echo "---------------------------------"
    echo "$i====>"
    echo "---------------------------------"
    echo "getlvcb -AT $i"
    echo "---------------------------------"
    getlvcb -AT $i
done
