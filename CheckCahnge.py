import os,sys
import argparse

NameFiles = []
diff="diff --git "
version="version"

# Instantiate the parser
# Get the changed files
parser = argparse.ArgumentParser(description='Optional app description')
parser.add_argument('NameFiles', help='Change log')
parser.add_argument('ResultLog')
parser.add_argument('ChangeLog')
parser.add_argument('LastID')
args = parser.parse_args()
NameFiles = str(args.NameFiles).split('\n')
ResultLog = args.ResultLog
ChangeLog = args.ChangeLog
LastID = args.LastID


# Read log Change for Last commit
f = open(f"{ChangeLog}", "r")
ChangeLog =f.readlines()
result=[]
file=""
is_version=False

for log in ChangeLog:
    if diff in log : 
        for NameFile in NameFiles:
            if NameFile in log:
                  file=NameFile
                  NameFiles.remove(file)
                  break
        is_version=False       
        continue
    if is_version: continue
    if version in log.lower():
        is_version=True
        result.append(file)
        continue
f.close()

print(result)
if len(result) != 0:
    f = open(f"{ResultLog}", "w")
    f.write("These files were changed:  \n")
    [f.write(f'{i} {LastID}\n') for i in result ]
    f.close()
    
     



# For delete Emtpy item/s
#result=[x for x in result if x]
#result=[x.replace('/dev/null','') for x in result if x]