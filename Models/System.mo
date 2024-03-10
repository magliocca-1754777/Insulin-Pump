class System

//Dichiarazione oggetti

MealGenerator gen ; // Generatore del pasto

Patient pa ;        // paziente che ha una pompa di insulina

Pump pu ;           // una pompa per insulina che inietta insulina al paziente  

Monitor1Fun mo1 ;   //un monitor che controlla che il glucosio non scenda mai sotto i 50 mg

Monitor2Fun mo2;    //un monitor che controlla che il glucosio rimanga sempre intorno ai 100 mg

Monitor1NonFun mo1N; //monitor che controlla che l'insulina iniettata sia minimizzata

Monitor2NonFun mo2N; //monitor che controlla che il sampling time sia massimizzato

equation

connect(gen.delta,pa.delta);
connect(pa.G,pu.glucose);
connect(pu.insulin,pa.pump);
connect(pa.G,mo1.glucose);
connect(pa.G,mo2.glucose);
connect(pu.insulinaTotale,mo1N.insulinaTotale);
connect(pu.samplingTime,mo2N.samplingTime);

end System ;
