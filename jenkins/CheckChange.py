import argparse
import os

# Not used at the moment
# Related in case of PR at merger
# need add "git checkout $VALUE" in shell script to work right
def CheckPR(filename,commitIDs):
    filename=str(filename).replace("/","\\")
    cmd="setlocal EnableDelayedExpansion\n"
    cmd += f"set " + f'"cmd=git log -n 1 --pretty=format:%%H -- {filename}"' +"\n"
    cmd += f"for /f %%a in ('!cmd!') do set id=%%a\n"
    cmd += f"echo %id% > ID.txt"
    f = open("cmd.bat", "w")
    f.write(cmd)
    f.close()
    os.system(f"cmd.bat")
    os.system(f"del cmd.bat")
    f = open("ID.txt", "r")
    fileId=str(f.readline()).replace("\n","")
    f.close()
    os.system(f"del ID.txt")
    if fileId in commitIDs:
        return True
    else:
        return False

############################################

# Variables included in the conditions during processing
diff="diff --git "
version="version"
cereal="cereal"
path_sql="test/sql"
path_data="/data/system/reports"
ex=".sql"

# Instantiate the parser
# Get the changed files
parser = argparse.ArgumentParser(description='Optional app description')
parser.add_argument('NameFiles', help='Change log')
parser.add_argument('ResultLog')
parser.add_argument('ChangeLog')
parser.add_argument('ResultData')
args = parser.parse_args()
NameFiles = args.NameFiles
ResultLog = args.ResultLog
ChangeLog = args.ChangeLog
ResultData = args.ResultData

# Adding the arrgument (errors="ignore") to slove encoding="utf-8"
# And also for reading huge files
# See : https://stackoverflow.com/questions/9233027/unicodedecodeerror-charmap-codec-cant-decode-byte-x-in-position-y-character
f = open(f"{NameFiles}", "r", errors="ignore")
NameFiles = f.readlines()
NameFiles = [x.replace("\n","") for x in NameFiles]
f.close()
    
# Read log Change for Last commit
f = open(f"{ChangeLog}", "r", errors="ignore")
ChangeLog =f.readlines()
f.close()

# A dictionary to store the name of the file as a key and the commitIDs in which the file was modified
# (If one of its lines containing the words (cereal and version) has changed)
resultdic={}

# A dictionary to store sql filenames as a key with 
# commit ids as a value if they exist in the changelog
sqldic={}


# A set of variables to helping in the processing
file=""
is_cerealversion=False
id=""
isDataChange=[]

for log in ChangeLog:
    if log.startswith("diff --gitid:"):
       id=log.split(':')[1].replace('\n','')
    if log.startswith(diff) : 
        for NameFile in NameFiles:
            if NameFile in log :
                  file=NameFile
                  if not file in resultdic.keys():
                      resultdic[file]=""
                  
                  # Check if test/sql/*.sql changing
                  if file.startswith(path_sql) and file.endswith(ex):
                      if file in sqldic.keys():
                          sqldic[file]+=f"{id} "
                      else:
                          sqldic[file]=f"{id} "
                  break
        if path_data in log:
            isDataChange.append(id)

        is_cerealversion=False       
        continue

    if is_cerealversion: continue
    if version in log.lower() and cereal in log.lower():
        is_cerealversion=True
        resultdic[file]+=f"{id} "
        continue

# Writing the final result into a ResultLog.txt file to create an issue for it
# To remove empty files not have commitIds
resultdic={k: v for k, v in resultdic.items() if v } # and CheckPR(k,v)
print(resultdic)
if len(resultdic) != 0:
    f = open(f"{ResultLog}", "w")
    f.write("Version strings in these files have changed:\n")
    [f.write(f'{k} {v} \n') for k, v in resultdic.items() ]
    f.write("_____________________________________  \n")
    f.close()

print(sqldic)
if len(sqldic) != 0:
    f = open(f"{ResultLog}", "a")
    f.write("These SQL files have changed:\n")
    [f.write(f'{k} {v} \n') for k, v in sqldic.items() ]
    f.close()

if isDataChange.count != 0:
    f = open(f"{ResultData}", "a")
    f.write(f"{path_data}:\n")
    for v in isDataChange:
        f.write(f"{v} ")
    f.close()
    
     