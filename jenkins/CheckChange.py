import argparse
import os,sys
import subprocess

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


NameFiles = []
diff="diff --git "
version="version"
cereal="cereal"
path_sql="test/sql"
ex=".sql"

# Instantiate the parser
# Get the changed files
parser = argparse.ArgumentParser(description='Optional app description')
parser.add_argument('NameFiles', help='Change log')
parser.add_argument('ResultLog')
parser.add_argument('ChangeLog')
args = parser.parse_args()

# NameFiles = str(args.NameFiles).split('\n')
# NameFiles = set([x for x in NameFiles if x])
NameFiles = args.NameFiles
f = open(f"{NameFiles}", "r", errors="ignore")
NameFiles = f.readlines()
NameFiles = [x.replace("\n","") for x in NameFiles]
f.close()



ResultLog = args.ResultLog
ChangeLog = args.ChangeLog

    
# Read log Change for Last commit
f = open(f"{ChangeLog}", "r", errors="ignore")
ChangeLog =f.readlines()
file=""
is_version=False
resultdic={}
sqldic={}
id=""
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
        is_version=False       
        continue

    if is_version: continue
    if version in log.lower() and cereal in log.lower():
        is_version=True
        resultdic[file]+=f"{id} "
        continue
f.close()

# To remove empty files not have commitIds
resultdic={k: v for k, v in resultdic.items() if v and CheckPR(k,v)}
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
    
     



# For delete Emtpy item/s
#result=[x for x in result if x]
#result=[x.replace('/dev/null','') for x in result if x]
