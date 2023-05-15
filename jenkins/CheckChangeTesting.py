import os,sys


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


resultdic={"test/sql/sql2.sql":"2cdb7651379ca1c741a2496bbf2b867f6f5e6351 3716fc0fe06b7ae1a50172fef66990154b112555",
           "sub.txt":"3716fc0fe06b7ae1a50172fef66990154b112555",
           "test.txt":"2cdb7651379ca1c741a2496bbf2b867f6f5e6351 3716fc0fe06b7ae1a50172fef66990154b112555"}
resultdic={k: v for k, v in resultdic.items() if v and CheckPR(k,v)}
print(resultdic)
if len(resultdic) != 0:
    f = open(f"r.txt", "w")
    f.write("Version strings in these files have changed:\n")
    [f.write(f'{k} {v} \n') for k, v in resultdic.items() if  CheckPR(k,v)]
    f.write("_____________________________________  \n")
    f.close()