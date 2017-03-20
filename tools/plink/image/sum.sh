if [ ! $# -eq 1 ]
then
    echo "    usage:     sh sum.sh yearmonth "
    echo "    yearmonth: 201301              "
    exit
fi

while read i
do
    cd $i
        for j in `ls`
        do 
            cd $j
            sh ../../../../../tools/sum1.sh
            cd ..
        done >> ../../../../tools/$1/sum$i.txt
    cd ..
done< ../../../tools/$1/$1
