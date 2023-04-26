import os


files=[]
f = open("ChangeLog.txt", "r")
result =f.read()
result=result.replace('--- ',"").split('a/')
print(result)
for r in result:
    if 'version' in r.lower():
        fileName=""
        for char in r:
            if char == " ":
                break
            fileName+=char
        print(fileName)
        files.append(fileName)

print(files)
f.close()


# delete previous files first
#os.system('rm -rf ' + check_mps_file)
#os.system('rm -rf ' + self.solution_file)
#cmd = 'cplex -f "' + cplex_command_file + '"'
#os.system(cmd)

f = open("FileLog.txt", "w")
for file in files:
    f.write(f'{file}\n')

eb_build = os.environ.get("log")
print(eb_build)
f.write("eb_build")
