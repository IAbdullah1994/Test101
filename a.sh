git remote prune origin
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
          commitsIDs=$(git log  --pretty=format:%H $val...$VALUE)
          python CheckCahnge.py "$NameFiles" $ResultLog "ChangeLog.txt" "$commitsIDs"

          if test -f "$ResultLog"; then  
          result="$(<$ResultLog)"
          author=$(git log -n 1 --pretty=format:%an  $VALUE)
          gh issue create --title "Consider incrementing minor version branch name $KEY" --body "$result" -a "$author"
          rm $ResultLog
          fi 
          rm val.temp
          rm ChangeLog.txt
          
      fi
    else 
    #This 
    i=1
    id=($(git log -n $i --pretty=format:%H $VALUE ))
    curnetid=${id[-1]}
    branchname=$(git log -n 1 --pretty="format:%D" $curnetid)
    branchname=(${branchname//// })
    branchname=${branchname[1]}
    echo $KEY
    echo $branchname
    while ( [ "$branchname" == "$KEY" ] || [ "" == "$branchname" ] ) 
    do
            echo $i
            i=$(( $i + 1 ))
            id=($(git log -n $i --pretty=format:%H $VALUE ))
            curnetid=${id[-1]}
            branchname=$(git log -n 1 --pretty="format:%D" $curnetid)
            branchname=(${branchname//// })
            branchname=${branchname[1]}
            echo $branchname
    done
    ChangeLog=$(git log --pretty=format:'diff --gitid:%H'  -p $curnetid...$VALUE  | grep  '^[diff+-]' | grep -Ev '/dev/null|^(--- a/|\+\+\+ b/)')
    echo $ChangeLog done...
    echo "$ChangeLog" > ChangeLog.txt
    NameFiles=$(git log  --pretty="format:" --name-only $curnetid...$VALUE)
    LastID=$(git log  --pretty=format:%H $curnetid...$VALUE)
    python CheckCahnge.py "$NameFiles" $ResultLog "ChangeLog.txt" "$LastID"

    if test -f "$ResultLog"; then  
    result="$(<$ResultLog)"
    author=$(git log -n 1 --pretty=format:%an  $VALUE)
    gh issue create --title "Consider incrementing minor version branch name $KEY" --body "$result" -a "$author"
    rm $ResultLog
    fi 
    rm ChangeLog.txt
    fi
    echo "$KEY":"$VALUE" >> LastCommitID.temp
done



mv LastCommitID.temp LastCommitID.log

#sleep 100


