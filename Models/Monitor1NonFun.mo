model Monitor1NonFun

InputReal insulinaTotale ;
parameter Real minimumDose=50;
OutputReal x ;

Boolean condizione1(start = false) ;

initial equation
x = 0;

equation

//La quantità di insulina iniettata deve essere ridotta al minimo
condizione1= insulinaTotale <= minimumDose;

algorithm

when edge(condizione1) then

x := 1 ;

end when ;

end Monitor1NonFun;
