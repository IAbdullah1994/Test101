setlocal EnableDelayedExpansion

echo hi >> "C:\Users\modar\Desktop\Test101\test\sql\sql1.txt"
echo hi >> "C:\Users\modar\Desktop\Test101\test\sql\sql2.txt"
echo hi >> "C:\Users\modar\Desktop\Test101\test\sql\sql3.txt"

git add test\sql\sql1.txt
git add test\sql\sql2.txt
git add test\sql\sql3.txt

git commit -am "AA"
git push

