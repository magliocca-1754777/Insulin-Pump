model Pump

InputReal glucose ;
OutputReal insulin ;
OutputReal insulinaTotale; // valore dell'insulina totale rilasciata fino al tempo T
OutputReal samplingTime;  // (5 minuti oppure anche con 10 minuti)

Real r0 ;
Real r1 ;
Real r2 ;

parameter Real correzione=1;
Real contatore;
parameter Real T = 600; 



algorithm

samplingTime := T;

when sample(0, T) then

//valore corrente
r2 := glucose ;

//valore precedente
r1 := pre(r2) ;

//valore precedente
r0 := pre(r1) ;

//la pompa viene attivata quando i valori del glucosio sono verosimili
if contatore >1 then
 // se il glucosio è inferiore ai 50 mg non viene rilasciata insulina
 if r2 < 50 then
    insulin := 0;
 // se il glucosio scende non viene rilasciata insulina
 elseif r2 <= r1 then
    insulin := 0 ;
  
 elseif r2 > r1 and (r2 - r1) < (r1 - r0) then
    insulin := 0 ;
    
 // se il glucosio sta salendo viene rilasciata l'insulina necessaria  
 elseif r2 > r1 and (r2 - r1) >= (r1 - r0) then
    insulin := ceil((r2 - r1) / 4)*correzione ;
   
        
 end if ;
 insulinaTotale := insulinaTotale + insulin;
 
end if;

contatore := contatore +1;

end when ;

end Pump ;
