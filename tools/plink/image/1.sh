if [ ! $# -eq 3 ]
then
    echo "  Usage:  sh 1.sh claim/cclaim/credit 2015 05 "
    echo "  one of claim/cclaim/credit "
    echo "  2015 "
    echo "  05 "
    exit
fi

va="\/Image\/$1post\/$2\/"

for i in cp mv ln rm 
do
    case "${i}" in
        cp)    
            cp -p $1-$2-$3.txt ${i}$1$2$3.sh
            sed -i 's/$/ '${va}'/g' ${i}$1$2$3.sh
            sed -i 's/^/cp -r -p /g' ${i}$1$2$3.sh
            ;;    
        mv)    
            cp -p $1-$2-$3.txt ${i}$1$2$3.sh
            sed -i 's/.*$/& &/g' ${i}$1$2$3.sh
            sed -i 's/$/.bak/g' ${i}$1$2$3.sh
            sed -i 's/^/mv /g' ${i}$1$2$3.sh
            ;;    
        ln)    
            cp -p $1-$2-$3.txt ${i}$1$2$3.sh
            sed -i 's/.*$/& &/g' ${i}$1$2$3.sh
            sed -i 's/^/ln -sf '${va}'/g' ${i}$1$2$3.sh 
            ;;    
        rm)    
            cp -p $1-$2-$3.txt ${i}$1$2$3.sh
            sed -i 's/$/.bak/g' ${i}$1$2$3.sh
            sed -i 's/^/rm -rf /g' ${i}$1$2$3.sh
            ;;    
    esac   
done
