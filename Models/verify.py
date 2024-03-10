import os
import sys
import math
import numpy 
import time
import os.path
import random

from OMPython import OMCSessionZMQ

print "removing old System (if any) ..."
os.system("rm -f ./System")    # remove previous executable, if any.
print "done!"

omc = OMCSessionZMQ()
omc.sendExpression("getVersion()")
omc.sendExpression("cd(Models)")

omc.sendExpression("loadModel(Modelica)")
omc.sendExpression("getErrorString()")

omc.sendExpression("loadFile(\"Connectors.mo\")")
omc.sendExpression("getErrorString()")

omc.sendExpression("loadFile(\"Monitor1Fun.mo\")")
omc.sendExpression("getErrorString()")

omc.sendExpression("loadFile(\"Monitor2Fun.mo\")")
omc.sendExpression("getErrorString()")

omc.sendExpression("loadFile(\"Monitor1NonFun.mo\")")
omc.sendExpression("getErrorString()")

omc.sendExpression("loadFile(\"f.mo\")")
omc.sendExpression("getErrorString()")

omc.sendExpression("loadFile(\"k_empt.mo\")")
omc.sendExpression("getErrorString()")

omc.sendExpression("loadFile(\"KPar.mo\")")
omc.sendExpression("getErrorString()")

omc.sendExpression("loadFile(\"MealGenerator.mo\")")
omc.sendExpression("getErrorString()")

omc.sendExpression("loadFile(\"Patient.mo\")")
omc.sendExpression("getErrorString()")

omc.sendExpression("loadFile(\"Pump.mo\")")
omc.sendExpression("getErrorString()")

omc.sendExpression("loadFile(\"System.mo\")")
omc.sendExpression("getErrorString()")

omc.sendExpression("buildModel(System, stopTime=14450)")
omc.sendExpression("getErrorString()")

inizio = time.time()
y = 0
x = 0
num_pass = 0
num_fail = 0



nTest = 100

#crea file outputFun con il numero di test fatti sui requisti funzionali 

with open ("outputFun" + str(nTest)+".txt", 'wt') as f:
        f.write("Outcomes"+"\n\n")
        f.flush()
        os.fsync(f)

with open ("logFun" + str(nTest)+".txt", 'wt') as f:
    f.write("Begin log\n")
    print("\nBegin log\n")
    f.flush()
    os.fsync(f)

for i in range(nTest):

    
    with open ("modelica_rand.in", 'wt') as f:                
        rand1 = random.randint(50,62)
        rand2 = random.randint(83,104)
        rand3 = random.randint(163,175)
        rand4 = random.randint(0,1)
        f.write("pa.parametri.Age="+str(rand1)+"\n")
        f.write("pa.parametri.BW="+str(rand2)+"\n")
        f.write("pa.parametri.Height="+str(rand3)+"\n")
        f.write("pa.parametri.gender="+str(rand4)+"\n")
        f.flush()
        os.fsync(f)

    with open ("logFun" + str(nTest)+".txt", 'a') as f:
        f.write("\nTest "+str(i)+" :\n")
        f.write("età: "+ str(rand1)+"\n")
        f.write("peso: "+ str(rand2)+"\n")
        f.write("altezza: "+ str(rand3)+"\n")
        f.write("sesso: "+ str(rand4)+"\n")
        f.flush()
        os.fsync(f)  
                
    os.system("./System -overrideFile=modelica_rand.in >> logFun")
    time.sleep(1.0)        
    os.system("rm -f modelica_rand.in")    # .... to be on the safe side
    os.system("rm -f "+"logFun" + str(nTest)+".txt")    # .... to be on the safe side
    
    #os.system("rm -f log.txt")    # .... to be on the safe side


    y = omc.sendExpression("val(mo1.x, 4000.0, \"System_res.mat\")")
    x = omc.sendExpression("val(mo2.x, 4000.0, \"System_res.mat\")")
    os.system("rm -f System_res.mat")      # .... to be on the safe side
    
    print ("Monitor value at iteration "+ str(i) + ": "+  str(y)+" "+str(x) +" with age: "+str(rand1)+" weight: "+str(rand2)+" gender: "+str(rand4)+" height: "+str(rand3))

    with open ("outputFun" + str(nTest)+".txt", 'a') as g:
        if (y == 0 and x == 0):
            num_pass = num_pass + 1.0
            g.write("y["+str(i)+"] = "+str(y)+" "+str(x)+ " Pass with age: "+str(rand1)+" weight: "+str(rand2)+" gender: "+str(rand4)+" height: "+str(rand3)+"\n")
        else:
            num_fail = num_fail + 1.0
            g.write("y["+str(i)+"] = "+str(y) +" "+str(x)+ " Fail with age: "+str(rand1)+" weight: "+str(rand2)+" gender: "+str(rand4)+" height: "+str(rand3)+ "\n")
        g.flush()
        os.fsync(g)
        
fine = time.time()
with open ("outputFun" + str(nTest)+".txt", 'a') as g: 
    g.write("Tempo di esecuzione del programma "+str(fine-inizio)+"\n")
    g.flush()
    os.fsync(g)


print ("num pass = ", num_pass)
print ("num fail = ", num_fail)
print ("total tests = ",  num_pass + num_fail)
print ("pass prob = ", num_pass/(num_pass + num_fail))
print ("fail prob = ", num_fail/(num_pass + num_fail))
print("Tempo di esecuzione del programma "+str(fine-inizio))
