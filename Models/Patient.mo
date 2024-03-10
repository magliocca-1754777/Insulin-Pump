model Patient

//oggetto di tipo KPar
InputKPar parametri ;

// pompa dose di insulina
InputReal pump ;

InputReal delta ;

// è la concentrazione di glucosio plasmatico 
OutputReal G ; // (mg / dL)


//Dichiarazione parametri 


//Dichiarazioni A1

// gli utilizzi insulino-indipendenti del glucosio 
Real Uii ; // (mg / kg / min)

// gli utilizzi insulino-dipendenti del glucosio 
Real Uid ; // (mg / kg / min)

// è l'escrezione renale 
Real E ; // (mg/kg/min)

// Estrazione epatica basale
Real HE ;

// masse di glucosio nel plasma in rapido equilibrio 
Real Gp;  // (mg/kg) 

// masse di glucosio nel plasma in tessuti che equilibrano lentamente
Real Gt ; // (mg/kg) 

Real Gtb ;

// glucosio endogeno stimato
Real EGP ; // (mg/kg/min)


Real Vm0 ; // mg/kg/min

parameter Real m30 ; //  min^-1

parameter Real Gpb ; // mg/kg

parameter Real SRb ;

//EGP estrapolato a glucosio zero e insulina 
parameter Real kp1 ; // (mg / kg / min)



//Dichiarazioni A2

Real m3 ;

parameter Real HEb ;

// sono masse di insulina nel plasma basale
parameter Real Ilb ; // (pmol / kg)

// masse di insulina nel fegato basale
parameter Real Ipb ; // (pmol / kg)

// masse di insulina nello spazio extravascolare basale
parameter Real Ievb ; // (pmol / kg)

// sono masse di insulina nel plasma
Real Il(start = Ilb) ;

// masse di insulina nel fegato
Real Ip(start = Ipb) ;

// masse di insulina nello spazio extravascolare
Real Iev(start = Ievb) ;

//è la concentrazione plasmatica di insulina 
Real I(start = parametri.Ib) ; // (pmol / L)

// è la velocità di secrezione di insulina beta-cellulare  
Real ISR ; //(pmol / min) 


//Dichiarazioni A5
Real Qsto(start = 0) ;

Real Qsto1(start = 0) ;

Real Qsto2(start = 0) ;

Real Qgut(start = 0) ;

Real Rameal(start = 0) ;



//è l'azione ritardata dell'insulina (attraverso il compartimento intermedio I' 
Real XL(start = parametri.Ib) ; // (pmol/L)


//Dichiarazioni A11
Real Iprimo(start = parametri.Ib) ;


//Dichiarazioni A13
Real risk ;

//Dichiarazioni A14

// è l'azione dell'insulina sull'utilizzo del glucosio 
Real X(start = 0 ) ; // (pmol / L)


//Dichiarazione A18

// concentrazioni di peptide C in accessibile periferico 
Real CP1(start = parametri.CPb) ; // (pmol / L)

// concentrazioni di peptide C in compartimento 
Real CP2 ; // (pmol / L)

//Dichiarazione A20

// totale statico delle componenti delle velocità di secrezione del peptide C (e dell'insulina) dalle cellule beta 
Real ISRs(start = 0) ; // (pmol / min)

//Dichiarazioni A21

// totale dinamico delle componenti delle velocità di secrezione del peptide C (e dell'insulina) dalle cellule beta
Real ISRd ; // (pmol / min)

//Dichiarazioni A22

// totale basale delle componenti delle velocità di secrezione del peptide C (e dell'insulina) dalle cellule beta
Real ISRb ; // (pmol / min)



initial equation

//Inizio A1

//Glucosio plasmatico basale
Gpb = parametri.Gb * parametri.Vg ; // mg/kg


kp1 = parametri.EGPb + parametri.kp2 * Gpb + parametri.kp3 * parametri.Ib + parametri.kp4 * Ilb ; // mg/kg/min

//Fine A1 


//Inizio A2

//Insulina plasmatica basale
Ipb = parametri.Ib * parametri.Vi ; // pmol/kg

//Estrazione epatica basale
HEb = (SRb - parametri.m4 * Ipb) / (SRb + parametri.m2 * Ipb) ;
HEb = max(HEb,0) ;

m30 = HEb * parametri.m1 / (1 - HEb) ;     // min^-1

//Insulina epatica basale
Ilb = (Ipb * parametri.m2 + SRb) / (parametri.m1 + m30) ;  // pmol/kg  
 
//Insulina extra-vascolare basale
Ievb = Ipb * parametri.m5 / parametri.m6 ;  // pmol/kg  


//Fine A2

//Inizio A18


CP2=parametri.CPb*(parametri.k21/parametri.k12);
SRb=parametri.CPb/parametri.BW*parametri.Vc*parametri.k01;





//Fine A18



algorithm

if Gpb <= parametri.ke2 then

    //nessuna escrezione
    Gtb := (parametri.Fsnc - parametri.EGPb + parametri.k1 * Gpb) / parametri.k2 ; // mg/kg
    Vm0 := (parametri.EGPb - parametri.Fsnc) * (parametri.Km0 + Gtb) / Gtb ; // mg/kg/min

else
  
    //presente escrezione
    Gtb := ((parametri.Fsnc - parametri.EGPb + parametri.ke1 * (Gpb - parametri.ke2)) / parametri.Vg + parametri.k1 * Gpb) / parametri.k2 ;// mg/kg
    Vm0 := (parametri.EGPb - parametri.Fsnc - parametri.ke1 * (Gpb - parametri.ke2)) * (parametri.Km0 + Gtb) / Gtb ; // mg/kg/min
  

end if ;



equation

//Inizio A1

//masse di glucosio nel plasma e in tessuti in rapido equilibrio
der(Gp) = EGP + Rameal - Uii - E - parametri.k1 * Gp + parametri.k2 * Gt ; // (mg/kg)

//masse di glucosio nel plasma e in tessuti che equilibrano lentamente
der(Gt) = -Uid + parametri.k1 * Gp - parametri.k2 * Gt ;  // (mg/kg)

//è la concentrazione di glucosio plasmatico
G = Gp / parametri.Vg ; // (mg/dL)



//Fine A1


//Inizio A2

der(Il) = -(parametri.m1 + m3) * Il + parametri.m2 * Ip + ISR / parametri.BW ;

der(Ip) = -(parametri.m2 + parametri.m4 + parametri.m5) * Ip + pump + parametri.m1 * Il + parametri.m6 * Iev ;

der(Iev) = -parametri.m6 *Iev + parametri.m5 * Ip ;

I = (Ip + pump) / parametri.Vi ;



//Fine A2


//Inizio A3

m3 = (HE * parametri.m1) / (1 - HE) ;

//Fine A3


//Inizio A4

HE = -parametri.aG * G ;

//Fine A4

//Inizio A5 
Qsto = Qsto1 + Qsto2 ;

der(Qsto1) = (-parametri.kmax) * Qsto1 + delta ;

der(Qsto2) = -k_empt(Qsto,parametri) * Qsto2 + parametri.kmax * Qsto1 ;

der(Qgut) = (-parametri.kabs) * Qgut + k_empt(Qsto,parametri) * Qsto2 ;

Rameal = (parametri.f * parametri.kabs * Qgut) / parametri.BW ;

//Fine A5


//Inizio A9 

EGP = kp1 - parametri.kp2 * Gp - parametri.kp3 * XL - parametri.kp4 * Il ;

//Fine A9


//Inizio A10 

der(XL) = -parametri.ki * (XL - Iprimo) ;



//Fine A10 



//Inizio A11

der(Iprimo) = -parametri.ki * (Iprimo - I) ;

//Fine A11


//Inizio A12

Uii = parametri.Fsnc ;

//Fine A12


//Inizio A13 

Uid = ((Vm0 + parametri.Vmx * X * (1 + parametri.r1 * risk)) * Gt ) / (parametri.Km0 + Gt) ;


//Fine A13


//Inizio A14

der(X) = -parametri.p2U * X + parametri.p2U * (I - parametri.Ib) ;

//Fine A14


//Inizio A15 

if G >= parametri.Gb then
  
  risk = 0 ;
  
elseif parametri.Gth <= G and G <= parametri.Gb then
  
  risk = 10 * (f(G,parametri)) ^ 2 ;
  
else

  risk = 10 * (f(parametri.Gth,parametri)) ^ 2 ;
  
end if ;
  

//Fine A15


//A16 sta in funzione f


//Inizio A17

if Gp > parametri.ke2 then
  E = parametri.ke1 * (Gp - parametri.ke2) ;
  
else
  E = 0 ;
end if ;

//Fine A17


//Inizio A18

der(CP1) = -(parametri.k01 + parametri.k12) * CP1 + parametri.k12 * CP2 + ISR / parametri.Vc ;

der(CP2) = -parametri.k12 * CP2 + parametri.k21 * CP1 ;

//Fine A18


//Inizio A19

ISR = ISRs + ISRd + ISRb ; 

//Fine A19


//Inizio A20

der(ISRs) = -parametri.alpha * (ISRs - parametri.Vc * parametri.PHIs * (G - parametri.h)) ;

//Fine A20


//Inizio A21

if der(G) >= 0 then 
  
  ISRd = parametri.Vc * parametri.PHId * der(G) ;
  
else 
  ISRd = 0 ;
  
end if ;


//Fine A21


//Inizio A22

ISRb = parametri.CPb * parametri.k01 * parametri.Vc ;

//Fine A22



end Patient ;
