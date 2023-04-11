setlocal EnableDelayedExpansion
del LastCommitID.temp
set file=test\sql\sql3.txt,test\sql\sql1.txt,test\sql\sql2.txt,test\sql\sql4.txt

FOR %%a in (%file%) do  (
set sql=%%a
set IsNew=0
FOR /F  "tokens=1,2 delims==" %%G IN (LastCommitID.log) DO (
    set FileName=%%G
    set old_id=%%S
    
    echo !FileName!
    if !sql! == !FileName! (
    set IsNew=1
    
    rem Get ID last commit when !sql! changed.
    set "cmd=git log -n 1 --pretty=format:%%H -- !sql!"
    for /f %%a in ('!cmd!') do set id=%%a
    echo Issa 
    git log -n 4 --pretty=format:%%H -- test\sql\sql3.txt
    if !id! NEQ !old_id! (
    echo Modified !sql!: !id!
    gh issue create --title "The file !sql! was modified in commit:!id!" --body "Modified !sql!: !id!" -a DevIssaAb
    )
    echo !sql!=!id!>>LastCommitID.temp
    )
)
if !IsNew! == 0 (
    set "cmd=git log -n 1 --pretty=format:%%H -- !sql!"
    for /f %%k in ('!cmd!') do set id=%%k
    echo Add !sql!: !id!
    echo !sql!=!id!>>LastCommitID.temp
)
)

