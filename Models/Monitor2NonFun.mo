model Monitor2NonFun

InputReal samplingTime;
OutputReal x;
parameter Real maxTime=600;

Boolean condizione2(start = false) ;

equation

//il sampling time deve essere massimizzato
condizione2 = samplingTime >= maxTime;

algorithm


when edge(condizione2) then

x := 1 ;

end when ;

end Monitor2NonFun;
