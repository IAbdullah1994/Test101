####
# This script it work in the job UpdateBranchDic in Jenkins
# Check if a new branch was added to Github, if yes then trigger another job that checks for potential version changes
# This runs every minute, and checks 5 times with a delay betwen
###

# To use shell git functions
sh=C:/Git/usr/bin/

# This command it work without local repo in local PC
# It fetches all existing branches in the remote repository along with the last commit ID for each branch
branches=($( git ls-remote --heads  https://github.com/IAbdullah1994/Test101.git))

# if LastBranches.log is not exit
# Add all branches and exit 0
if ! test -f "LastBranches.log"; then  
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

# If this file exists (Branches.log), it means that there are new branches created, 
# which leads to running the VersionChanges job in Jecnkins
file=Branches.log
if test -f "$file"; then  
    rm $file
fi

for j in {0..5}
do
    # LastBranches.log stores all branches with commit IDs in dictionary form.
    # This file helps to know if there are new branches that have been added.
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
          # replace refs/heads/<Branch Name> to <Branch Name>
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

# If the file exists 9Branches.log), the values are assigned to the "newbranches" parameter,
# which is present in the VersionChanges job in Jecnkins.
# This file is passed to this parameter in Post-build Actions,through
# Add Parameters > Parameters from properties file, And make a choice "Don't trigger if any files are missing"
if test -f "$file"; then  
  value="newbranches="$(<$file)
  echo $value > $file
fi