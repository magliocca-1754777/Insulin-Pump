function k_empt

InputReal Q ;

InputKPar parametri ;

OutputReal y ;


protected Real alpha, beta ;

algorithm

alpha := 5 / (2 * parametri.Dose * (1 - parametri.b)) ;

beta := 5 / (2 * parametri.Dose * parametri.d) ;

y := parametri.kmin + ((parametri.kmax - parametri.kmin) / 2) * (tanh(alpha * (Q - beta * parametri.Dose)) - tanh(beta * (Q - parametri.d * parametri.Dose)) + 2) ;

end k_empt ;
