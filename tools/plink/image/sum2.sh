if [ ! $# -eq 1 ]
then
    echo "    usage:     sh sum.sh yearmonth "
    echo "    yearmonth: 201301              "
    exit
fi

for i in `ls|grep txt`
do
echo -n $(cat $i|awk '{(sum+= $1)};END{print sum}' ) " " 
echo -n $(cat $i|awk '{(sum+= $2)};END{print sum}' ) " " 
echo -n $(cat $i|awk '{(sum+= $3)};END{print sum}' ) " " 
echo -n $(cat $i|awk '{(sum+= $4)};END{print sum}' ) " " 
echo -n $(cat $i|awk '{(sum+= $5)};END{print sum}' ) " " 
echo -n $(cat $i|awk '{(sum+= $6)};END{print sum}' ) " " 
echo -n $(cat $i|awk '{(sum+= $7)};END{print sum}' ) " " 
echo -n $(cat $i|awk '{(sum+= $8)};END{print sum}' ) " " 
echo -n $(cat $i|awk '{(sum+= $9)};END{print sum}' ) " " 
echo -n $(cat $i|awk '{(sum+=$10)};END{print sum}' ) " " 
echo -n $(cat $i|awk '{(sum+=$11)};END{print sum}' ) " " 
echo -n $(cat $i|awk '{(sum+=$12)};END{print sum}' ) " " 
echo -n $(cat $i|awk '{(sum+=$13)};END{print sum}' ) " " 
echo -n $(cat $i|awk '{(sum+=$14)};END{print sum}' ) " " 
echo -n $(cat $i|awk '{(sum+=$15)};END{print sum}' ) " " 
echo -n $(cat $i|awk '{(sum+=$16)};END{print sum}' ) " " 
echo -n $(cat $i|awk '{(sum+=$17)};END{print sum}' ) " " 
echo -n $(cat $i|awk '{(sum+=$18)};END{print sum}' ) " " 
echo -n $(cat $i|awk '{(sum+=$19)};END{print sum}' ) " " 
echo -n $(cat $i|awk '{(sum+=$20)};END{print sum}' ) " " 
echo -n $(cat $i|awk '{(sum+=$21)};END{print sum}' ) " " 
echo -n $(cat $i|awk '{(sum+=$22)};END{print sum}' ) " " 
echo -n $(cat $i|awk '{(sum+=$23)};END{print sum}' ) " " 
          cat $i|awk '{(sum+=$24)};END{print sum}' 
done >> sum$1
