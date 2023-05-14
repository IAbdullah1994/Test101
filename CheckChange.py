import argparse

NameFiles = []
diff="diff --git "
version="version"
path_sql="test\\sql"

# Instantiate the parser
# Get the changed files
parser = argparse.ArgumentParser(description='Optional app description')
parser.add_argument('NameFiles', help='Change log')
parser.add_argument('ResultLog')
parser.add_argument('ChangeLog')
args = parser.parse_args()

NameFiles = str(args.NameFiles).split('\n')
NameFiles = set([x for x in NameFiles if x])

ResultLog = args.ResultLog
ChangeLog = args.ChangeLog

    
# Read log Change for Last commit
f = open(f"{ChangeLog}", "r")
ChangeLog =f.readlines()
file=""
is_version=False
resultdic={}
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
                  break
        is_version=False       
        continue
    if log.startswith("path_sql"):
        f = open(f"sql.log", "w")
        f.write(f"{file}  \n")
    if is_version: continue
    if version in log.lower():
        is_version=True
        resultdic[file]+=f"{id} "
        continue
f.close()

# To remove empty files not have commitIds
resultdic={k: v for k, v in resultdic.items() if v}
print(resultdic)
if len(resultdic) != 0:
    f = open(f"{ResultLog}", "w")
    f.write("These files were changed:  \n")
    [f.write(f'{k} {v} \n') for k, v in resultdic.items() ]
    f.close()
    
     



# For delete Emtpy item/s
#result=[x for x in result if x]
#result=[x.replace('/dev/null','') for x in result if x]