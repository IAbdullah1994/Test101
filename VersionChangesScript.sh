####
# This script it work in the job (VersionChanges) in Jenkins
# It checks if new changes have occurred in existing branches in GitHub 
# by comparing them to the last processing of these branches by this job (VersionChanges).
# Runs the Python file (jenkins\CheckChange.py) if any branch has new changes
# It creates an issue if there are files in which a line containing the phrase (version) has been changed, 
# or the SQL files in the path src\sql have been changed
###

# To use shell git functions
sh=C:/Git/usr/bin/

# This command deletes branch references to remote branches that do not exist. 
# A remote branch can be deleted as a result of a delete-branch-after merge-operation.
git remote prune origin

# This command will get the latest commit for each branch in the remote repository.
branches=($(git for-each-ref refs/remotes/origin --sort="-committerdate" --format="%(refname:lstrip=3):%(objectname)" | grep -Ev "HEAD"))

# If BranchCommitID.log is not exit
# Add all branches and exit 0
# This file (BranchCommitID.log) stores the branches and the last commit ID that the job processed.
if ! test -f "BranchCommitID.log"; then  
    for commitBr in "${branches[@]}" ; do
        echo "$commitBr" >> BranchCommitID.log
    done
    exit 0
fi

# It stores all the files for each branch that occurred in one of 
# its lines containing the word (version) on a change,
# In addition to any change, sql files happen within a path src\sql
# It is passed as a parameter within the python file (jenkins\CheckChange.py)
ResultLog=ResultLog.txt
FileNames=FileNames.txt
ChangeLogs=ChangeLog.txt
ResultData=ResultData.txt # For path data/system/reports


# Delete BranchCommitID.temp
filetemp=BranchCommitID.temp
if test -f "$filetemp"; then  
    rm $filetemp
fi

# The content of the file (BranchCommitID.log) is read and converted into a dictionary
LastCommitID=($(<BranchCommitID.log))
declare -A newmap
for commitBr in "${LastCommitID[@]}" ; do
    KEY=${commitBr%%:*}
    VALUE=${commitBr#*:}
    newmap["$KEY"]="$VALUE"
done


# $newbranches: a parameter defined in the VersionChanges job ,
# that stores any new branches  the UpdateBranchDic job captures along with their last commit IDs
# In order to know the commit ID of the parent branch of the new branch.
# These new branches are read, if they exist, and added to the previously defined dictionary (newmap).
if  [[ -n $newbranches ]]; then  
    newbranches=(${newbranches// / })
    for branch in ${newbranches[@]}; do
        KEY=${branch%%:*}
        VALUE=${branch#*:}
        newmap["$KEY"]="$VALUE"
        echo $KEY @ $VALUE
    done
fi

# Branches coming from GitHub are compared against a dictionary 
# to see if new commits have been added to those branches 
# so that they are processed within the Python file (jenkins\CheckChange.py)
# Note: New branches are not processed unless they are present in the parameter $newbranches
for commitBr in "${branches[@]}" ; do
    KEY=${commitBr%%:*}
    VALUE=${commitBr#*:}
    echo "$KEY" @ "$VALUE"
    if test ${newmap["$KEY"]}
    then
      # git checkout $VALUE
      val=${newmap[$KEY]}
      if [ $VALUE != $val ]; then

          # To solve "?" e.g Id=31d3ba5c6d47d9bcc6ed943e311189d506bfcada?
          echo $val > val.temp
          val=$(<val.temp)

          # This command fetches the changelog within a specified range between two commits.
          # /dev/null in the log indicating whether the file was deleted or added.
          # --pretty=format:'diff --gitid:%H' used to add a commit id in the log to see where the file has changed commitID 
          # The subcommand  ("$sh"grep -i 'diff --git\|cereal\|version') is used to display only the lines containing the words (diff --git OR cereal OR version) inside Log regardless if uppercase or lowercase letters
          # grep -i -e 'diff --git' -e 'cereal\|version'$ 
          ChangeLog=$(git log --pretty=format:'diff --gitid:%H'  -p $val...$VALUE | grep '^[diff+-]'  | grep -i 'diff --git\|cereal\|version'  | grep -Ev '/dev/null|^(--- a/|\+\+\+ b/)') # 
         
          # Store changes log in a text file (ChangeLog.txt) and pass them to the Python file (jenkins\CheckChange.py).
          echo "$ChangeLog" > $ChangeLogs
          
          # This command fetches the names of the files that have changed between two fields of the two commits.
          GetNameFiles=$(git log  --pretty="format:" --name-only $val...$VALUE) 
          
          # This processing was added to the filenames to remove duplicates, then it was printed into a text file (FileNames.txt) 
          # and the filename was passed to the Python script (jenkins\CheckChange.py).
          # Create an associative array
          declare -A unique_list
          # Loop through the input list and add elements to the associative array
          for k in $GetNameFiles ; do unique_list[$k]=1 ; done
          
          # Extract the unique elements from the associative array
          unique_array=("${!unique_list[@]}")

          # Print the unique elements
          for element in "${unique_array[@]}"; do
            echo "$element" >> $FileNames
          done
         

          # The Python file aims to create a text file ($ResultLog) of the results for which an issue is to be created 
          python jenkins\\CheckChange.py $FileNames $ResultLog $ChangeLogs $ResultData

          # In the case of the Python file (jenkins\CheckChange.py) creating the results file, create an issue.
          if test -f "$ResultLog"; then  
              result="$(<$ResultLog)"

              # It is not being used at the moment
              author=$(git log -n 1 --pretty=format:%an  $VALUE)

              gh issue create --title "Consider incrementing minor version branch: $KEY" --body "$result"  
              rm $ResultLog
          fi 

          # In the case of the Python file (jenkins\CheckChange.py) creating the results ResultData.txt file, create an issue.
          if test -f "$ResultData"; then  
              result="$(<$ResultData)"
              gh issue create --title "Consider incrementing minor version branch: $KEY" --body "$result"  
              rm $ResultData
          fi 
          rm val.temp
          rm $ChangeLogs
          rm $FileNames
      fi
      echo "$KEY":"$VALUE" >> BranchCommitID.temp
    else 
      # If the branch coming from the remote repository isn't in the (BranchCommitID.log)
      echo " The branch $KEY Not Found"
    fi
done

# Updating the BranchCommitID.log to store the last processed commit ID for the branches
mv BranchCommitID.temp BranchCommitID.log
echo "Done"
sleep 1000
