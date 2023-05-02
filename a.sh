branches=($(git for-each-ref refs/remotes/origin --sort="-committerdate" --format="%(refname:lstrip=3):%(objectname)" | grep -Ev "HEAD"))
LastCommitID=($(<LastCommitID.log))
ResultLog=ResultLog.txt


declare -A newmap
for commitBr in "${LastCommitID[@]}" ; do
    KEY=${commitBr%%:*}
    VALUE=${commitBr#*:}
    newmap["$KEY"]="$VALUE"
done



for commitBr in "${branches[@]}" ; do
    KEY=${commitBr%%:*}
    VALUE=${commitBr#*:}
    echo "$KEY" @ "$VALUE"
    if test ${newmap["$KEY"]}
    then
      val=${newmap[$KEY]}
      if [ $VALUE != $val ]; then
          echo $val > val.temp
          val=$(<val.temp)
          ChangeLog=$(git log --pretty=format:'diff --gitid:%H'  -p $val...$VALUE  | grep  '^[diff+-]' | grep -Ev '/dev/null|^(--- a/|\+\+\+ b/)')
          echo "$ChangeLog" > ChangeLog.txt
          NameFiles=$(git log  --pretty="format:" --name-only $val...$VALUE)
          LastID=$(git log  --pretty=format:%H $val...$VALUE)
          python CheckCahnge.py "$NameFiles" $ResultLog "ChangeLog.txt" "$LastID"

          if test -f "$ResultLog"; then  
          result="$(<$ResultLog)"
          author=$(git log -n 1 --pretty=format:%an  $VALUE)
          gh issue create --title "Consider incrementing minor version" --body "$result" -a "$author"
          rm $ResultLog
          fi 
          rm val.temp
          rm ChangeLog.txt
      fi
    else 
    i=1
    id=($(git log -n $i --pretty=format:%H $VALUE ))
    echo ${id[-1]}
    
    branchname=$(git log -n 1 --pretty="format:%D" $id)
    branchname=(${branchname//// })
    branchname=${branchname[1]}
    echo $branchname
    fi
    echo "$KEY":"$VALUE" >> LastCommitID.temp
done



rm LastCommitID.temp
sleep 10


