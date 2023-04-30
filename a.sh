ChangeLog=$(git log -n 1  --pretty=format: -p | grep  '^[diff+-]' | grep -Ev '/dev/null|^(--- a/|\+\+\+ b/)')
NameFiles=$(git log -n 1 --pretty="format:" --name-only)
LastID=$(git log -n 1 --pretty=format:%h -- )
echo "$ChangeLog" > ChangeLog.txt


ResultLog=ResultLog.txt
python CheckCahnge.py "$NameFiles" $ResultLog "ChangeLog.txt" "$LastID"



if test -f "$ResultLog"; then  
value="$(<$ResultLog)"
author=$(git log -n 1 --pretty=format:%an -- )
# echo $author
gh issue create --title "Consider incrementing minor version" --body "$value" -a "$author"
rm $ResultLog
fi 
rm ChangeLog.txt

#sleep 10