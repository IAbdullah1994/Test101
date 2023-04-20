# git diff 3ea6437..8395a7b -U0 | grep '^[+-]' | grep -Ev '^(--- a/|\+\+\+ b/)'

git log -n 1  --pretty=format: -p | grep '^[+-]' | grep -Ev '^(--- a/|\+\+\+ b/)'

author=$(git log -n 1  --pretty=format: -p | grep '^[+-]' | grep -Ev '^(\+\+\+ b/)')
echo $author

sleep 100