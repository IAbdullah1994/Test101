
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


f = open("FileLog.txt", "a")
for file in files:
    f.write(file)