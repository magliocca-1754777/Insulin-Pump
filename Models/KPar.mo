record KPar "system parameters"

//Glucosio Cinetica

//volume di distribuzione 
parameter Real Vg = 1.00 ;  //(dL / kg)

//Rate parametri
parameter Real k1 = 0.066 ; // min ^ -1

parameter Real k2 = 0.043 ; // min ^ -1

//Insulina Cinetica

//volume di distribuzione 
parameter Real Vi = 0.041 ;  //(L / kg)

//Rate parametri
parameter Real m1 = 0.314 ; // min ^ -1

parameter Real m2 = 0.268 ; // min ^ -1

parameter Real m4 = 0.443 ; // min ^ -1

parameter Real m5 = 0.260 ; // min ^ -1

parameter Real m6 = 0.017 ; // min ^ -1



//controllo del glucosio su HE 
parameter Real aG = 0.005 ; // (dL / mg)


parameter Real CPb = 0.0 ;

//Tasso di glucosio Aspetto

//costante di velocità dell'intestino assorbimento
parameter Real kabs = 0.0542 ; // min ^ -1

//velocità massima di svuotamento gastrico
parameter Real kmax = 0.0426 ; // min ^ -1

//velocità minima di svuotamento gastrico
parameter Real kmin = 0.0076 ; // min ^ -1

//punto di inflessione gastrica curva di svuotamento (adimensionale)
parameter Real b = 0.7328 ;

//punto di inflessione gastrica curva di svuotamento (adimensionale)
parameter Real d = 0.1014 ;

//frazione di assorbimento intestinale (adimensionale)
parameter Real f = 0.9 ;


//Endogeno Glucosio Produzione


//efficacia del glucosio epatico
parameter Real kp2 = 0.0008 ; // min ^ -1

//sensibilità all'insulina epatica
parameter Real kp3 = 0.0060 ; // (mg / kg / min per pmol / L)

//sensibilità all'insulina portale
parameter Real kp4 = 0.0484 ; // (mg/kg/min per pmol/kg)

//tasso di azione ritardata dell'insulina
parameter Real ki = 0.0075 ; // min ^ -1


//Glucosio Utilizzo

//Assorbimento del glucosio splancnico (insulino-indipendente)
parameter Real Fsnc = 1 ; // (mg/kg/min)

//sensibilità all'insulina sul glucosio utilizzo
parameter Real Vmx = 0.034 ; // (mg/kg/min per pmol/L)

//massa di glucosio che appare in Relazione Michaelis-Menten
parameter Real Km0 = 466.2 ; // (mg/kg)

//rate of insulin action on glucose utilization 
parameter Real p2U = 0.058 ; // min ^ -1

//parametri della funzione di rischio
parameter Real r1 = 0.7419 ; //(unidimensionale)

parameter Real r2 = 0.0807 ; //(unidimensionale)


//Escrezione renale

//velocità di filtrazione glomerulare
parameter Real ke1 =  0.0005 ; // min ^ -1

//soglia renale di glucosio 
parameter Real ke2 =  339 ; // (mg / kg)


//Peptide C. Cinetica

//volume di distribuzione 
 Real Vc ; // (L)

//Rate parametri
 Real k01  ; // min ^ -1

//Rate parametri
 Real k12 ; // min ^ -1

//Rate parametri
 Real k21  ; // min ^ -1



//Insulina e C-peptide Secrezione ...

//ritardo tra secrezioni di glucosio e insulina
parameter Real alpha =  0.034 ; // min ^ -1

//Risposta delle cellule beta al glucosio
parameter Real PHIs =  20.30 ; // (10^-9 min^-1)

//Risposta delle cellule beta al tasso di glucosio del cambiamento
parameter Real PHId =  286.0 ; // (10^-9)

//soglia del glucosio sulle cellule beta secrezione 
parameter Real h =  98.7 ; // (mg / dL)

//è la quantità di ingerita glucosio
parameter Real Dose = 105 ; // (mg)

// peso corporeo
parameter Real BW = 96 ; // (Kg)




// è la concentrazione di glucosio plasmatico 
parameter Real Gb = 127 ; // mg/dL  

//è la produzione endogena di glucosio
parameter Real EGPb = 1.59 ; // mg/kg/min

parameter Real Ib = 54 ; // pmol/l



 

//età
parameter Real Age = 54.9 ; // years 

//genere
parameter Integer gender = 0 ; // 0 = F / 1 = M

// sistema valutazione del peso
Real BMI; // kg/m^2 

// superficie corporea
Real BSA; // m^2

//altezza
parameter Real Height = 164 ; // cm

//
parameter Real Gth = 50 ; // mg / dL

parameter Real Heb = 0.51 ; //(senza dimensione)

//serve per calcolare determinati parametri che saranno utilizzati dal paziente
Real a1;
Real b1;
Real FRA;

algorithm

b1:=log(2)/(0.14*Age+29.16);

BMI:=BW/(h/100)^2;

if BMI<=27 then
    a1:=0.14;
    FRA:=0.76;
else
    a1:=0.152;
    FRA:=0.78;
    
end if;
 
k12:=FRA*b1+(1-FRA)*a1;
k01:=(a1*b1)/k12;
k21:=a1+b1-k12-k01;
 
BSA:=0.007194*(h^(0.725))*(BW^(0.425));
 
if gender==1 then
    Vc:=1.92*BSA+0.64;  // Volume MEN
else
    Vc:=1.11*BSA+2.04;  // Volume WOMEN
end if;


end KPar ;
