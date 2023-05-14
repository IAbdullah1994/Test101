sh=C:/Git/usr/bin/

# if LastBranches.log is not exit
if ! test -f "LastBranches.log"; then  
    branches=($( git ls-remote --heads  https://github.com/DevIssaAb/Test101.git ))
    i=0
    VALUE=""
    for commitBr in "${branches[@]}"; do
        if [ $i == 1 ]; then
          #replace refs/heads/<Branch Name> to <Branch Name>
          KEY="$commitBr"
          KEY="${KEY////$' '}" 
          KEY="${KEY/refs heads /""}" 
          echo "$KEY":"$VALUE" >> LastBranches.log
          i=0
        else
          VALUE=$commitBr
          i=$(($i + 1))
        fi
    done
    exit 0
fi


file=Branches.log
if test -f "$file"; then  
    rm $file
fi

for j in {0..5}
do
    branches=($( git ls-remote --heads  https://github.com/DevIssaAb/Test101.git ))
    LastBranches=($(<LastBranches.log))


    declare -A newmap
    for lastBranch in "${LastBranches[@]}" ; do
        KEY=${lastBranch%%:*}
        VALUE=${lastBranch#*:}
        newmap["$KEY"]="$VALUE"
    done


    i=0
    VALUE=""
    for commitBr in "${branches[@]}"; do
        if [ $i == 1 ]; then
          #replace refs/heads/<Branch Name> to <Branch Name>
          KEY="$commitBr"
          KEY="${KEY////$' '}" 
          KEY="${KEY/refs heads /""}" 
          if ! test ${newmap["$KEY"]}; then
            echo "$KEY":"$VALUE">> $file
          fi
          echo "$KEY":"$VALUE" >> LastBranches.temp
          i=0
        else
          VALUE=$commitBr
          i=$(($i + 1))
        fi
    done
    echo $j
    mv LastBranches.temp LastBranches.log
    sleep 5
done

if test -f "$file"; then  
  value="newbranches="$(<$file)
  echo $value > $file
fi
# sleep 100