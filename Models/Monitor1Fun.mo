model Monitor1Fun

InputReal glucose ;
OutputReal x ;

Boolean condizione1(start = false) ;

Real contatore;
initial equation
x = 0;
equation


//glucosio non deve scendere mai sotto i 50  mg/dL
condizione1 = glucose >= 50 ;


algorithm


when sample(0,1) then

contatore:=contatore+1;

end when;

when edge(condizione1) then

// il glucosio sale sopra i 50 mg dopo circa 3 minuti perciò abbiamo inserito un contatore per far partire in ritardo il monitor
if contatore>700 then

x := 1 ;

end if;


end when ;




end Monitor1Fun ;
