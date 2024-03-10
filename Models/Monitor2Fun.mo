model Monitor2Fun

InputReal glucose ;
OutputReal x ;


Boolean condizione2(start = false) ;

Real contatore;

initial equation
x = 0;

equation



//glucosio deve rimanere sempre intorno ai 100  mg/dL
condizione2 = (glucose >= 90) and (glucose <= 110) ;



algorithm

when sample(0,1) then

contatore:=contatore+1;

end when;

when edge(condizione2) then

// il glucosio si stabilizza dopo circa mezz'ora perciò abbiamo inserito un contatore per far partire in ritardo il monitor
if contatore>3600 then

x := 1 ;

end if;



end when ;





end Monitor2Fun ;
