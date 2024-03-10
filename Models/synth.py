import os
import sys
import math
import numpy as np
import time
import os.path
import random
    
from OMPython import OMCSessionZMQ

print "removing old System (if any) ..."
os.system("rm -f ./System")    # remove previous executable, if any.
print "done!"

omc = OMCSessionZMQ()
omc.sendExpression("getVersion()")
omc.sendExpression("cd()")

omc.sendExpression("loadModel(Modelica)")
omc.sendExpression("getErrorString()")

omc.sendExpression("loadFile(\"ConnectorInputKPar.mo\")")
omc.sendExpression("getErrorString()")

omc.sendExpression("loadFile(\"ConnectorInputReal.mo\")")
omc.sendExpression("getErrorString()")

omc.sendExpression("loadFile(\"ConnectorOutput.mo\")")
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



#output monitor funzionali
y = 0
x = 0
#dizionario che conterrà i valori dell'insulina per ogni parametro della pompa simulato
d = {}
#lista che conterrà i vari sampling time
l = []
#output monitor non funzionali
k = 0
c = 0
inizio = time.time()
num_pass = 0
num_fail = 0


nTest = 100
#crea file outputFun con il numero di test fatti sui requisti non funzionali 

with open ("outputNotFun" + str(nTest)+".txt", 'wt') as f:
        f.write("Outcomes"+"\n\n")
        f.flush()
        os.fsync(f)

with open ("logNotFun" + str(nTest)+".txt", 'wt') as f:
    f.write("Begin log\n")
    print("\nBegin log\n")
    f.flush()
    os.fsync(f)
    
for i in range(nTest):
    a=2
    rand1 = random.randint(50,62)
    rand2 = random.randint(83,104)
    rand3 = random.randint(163,175)
    rand4 = random.randint(0,1)

     #simulo diversi sampling time sulla pompa    
    for j in range(0,601, 60):
        with open ("parameters2.txt", 'wt') as f:
            f.write("pa.parametri.Age="+str(rand1)+"\n")
            f.write("pa.parametri.BW="+str(rand2)+"\n")
            f.write("pa.parametri.Height="+str(rand3)+"\n")
            f.write("pa.parametri.gender="+str(rand4)+"\n")
            f.write("pu.T="+str(j)+"\n")
            f.flush()
            os.fsync(f)
 
        
        os.system("./System -overrideFile=parameters2.txt")
        time.sleep(1.0)        
        os.system("rm -f System_res.mat")      # .... to be on the safe side
        os.system("rm -f parameters.txt")    # .... to be on the safe side
        
        y = omc.sendExpression("val(mo1.x,4000.0, \"System_res.mat\")")
        x = omc.sendExpression("val(mo2.x, 4000.0, \"System_res.mat\")")      
        
        #solo se i requisiti funzionali sono rispettati aggiungo il sampling time alla lista 
        if (x == 0 and y == 0):
            l.append(j)
    j= max(l)
    print ("sampling time:"+str(j))
    while (a > 1):
        #simulo varie dosi di insulina per il paziente modificando i parametri dell pompa        
        with open ("parameters.txt", 'wt') as f:
            a=int((a-0.1)*10)/10;
            f.write("pa.parametri.Age="+str(rand1)+"\n")
            f.write("pa.parametri.BW="+str(rand2)+"\n")
            f.write("pa.parametri.Height="+str(rand3)+"\n")
            f.write("pa.parametri.gender="+str(rand4)+"\n")
            f.write("pu.correzione="+str(a)+"\n")
            f.write("pu.T="+str(j)+"\n")
            f.flush()
            os.fsync(f)
 
                
        os.system("./System -overrideFile=parameters.txt")
        time.sleep(1.0)        
        os.system("rm -f System_res.mat")      # .... to be on the safe side
        os.system("rm -f parameters.txt")    # .... to be on the safe side
        
        y = omc.sendExpression("val(mo1.x,4000.0, \"System_res.mat\")")
        x = omc.sendExpression("val(mo2.x, 4000.0, \"System_res.mat\")")      
        z = omc.sendExpression("val(pu.insulinaTotale, 4000.0 , \"System_res.mat\")")
        #solo se i requisiti funzionali sono rispettati aggiungo l'insulina totale al dizionario 
        if (x == 0 and y == 0):
            d[z]= a 
    #prendo il valore minimo di insulina totale per il paziente       
    tupla = min(d.items(), key=lambda x: x[1])
    d.clear()
    z=tupla[0]
    a=tupla[1]
    print ("a:"+str(a)+" insulin:"+str(z))    
    
    with open ("modelica_rand.in", 'wt') as f:                
        f.write("pa.parametri.Age="+str(rand1)+"\n")
        f.write("pa.parametri.BW="+str(rand2)+"\n")
        f.write("pa.parametri.Height="+str(rand3)+"\n")
        f.write("pa.parametri.gender="+str(rand4)+"\n")
        f.write("pu.correzione="+str(a)+"\n")
        f.write("mo1N.minimumDose="+str(z)+"\n")
        f.write("pu.T="+str(j)+"\n")
        f.flush()
        os.fsync(f)

    with open ("logNotFun" + str(nTest)+".txt", 'a') as f:
   
        f.write("\nTest "+str(i)+":\n")
        f.write("età: "+ str(rand1)+"\n")
        f.write("peso: "+ str(rand2)+"\n")
        f.write("altezza: "+ str(rand3)+"\n")
        f.write("sesso: "+ str(rand4)+"\n")
        f.flush()
        os.fsync(f) 
                
    os.system("./System -overrideFile=modelica_rand.in")
    time.sleep(1.0)        
    os.system("rm -f modelica_rand.in")    # .... to be on the safe side
    os.system("rm -f "+"logNotFun" + str(nTest)+".txt")    # .... to be on the safe side
    os.system("rm -f log.txt")    # .... to be on the safe side


    k = omc.sendExpression("val(mo1N.x, 4000.0, \"System_res.mat\")")
    c = omc.sendExpression("val(mo2N.x, 4000.0, \"System_res.mat\")")

    print ("Monitor value at iteration "+ str(i) + ": "+  str(k)+" "+str(c) +" with age: "+str(rand1)+" weight: "+str(rand2)+" gender: "+str(rand4)+" height: "+str(rand3))
    
    with open ("outputNotFun" + str(nTest)+".txt", 'a') as g:
        if (k == 0 and c == 0):
            num_pass = num_pass + 1.0
            g.write("y["+str(i)+"] = "+str(k)+" "+str(c)+": PASS with age: "+str(rand1)+" weight: "+str(rand2)+" gender: "+str(rand4)+" height: "+str(rand3)+"\n")
        else:
            num_fail = num_fail + 1.0
            g.write("y["+str(i)+"] = "+str(k)+" "+str(c)+": FAIL with age: "+str(rand1)+" weight: "+str(rand2)+" gender: "+str(rand4)+" height: "+str(rand3)+"\n")
            g.flush()
            os.fsync(g)
        
fine = time.time()
with open ("outputNotFun" + str(nTest)+".txt", 'a') as g:
    g.write("Tempo di esecuzione del programma "+str(fine-inizio)+"\n")
    g.flush()
    os.fsync(g)


print ("num pass = ", num_pass)
print ("num fail = ", num_fail)
print ("total tests = ",  num_pass + num_fail)
print ("pass prob = ", num_pass/(num_pass + num_fail))
print ("fail prob = ", num_fail/(num_pass + num_fail))
print("Tempo di esecuzione del programma "+str(fine-inizio))
