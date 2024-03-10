model MealGenerator

import Modelica.Math.Random.Generators.Xorshift64star.random;
import Modelica.Math.Random.Utilities.initialStateWithXorshift64star;

parameter Integer localSeed=3062;

parameter Integer globalSeed=4056;

parameter Integer state[2];

OutputReal delta ;

parameter Real Meal_length = 3600 ;  // lunghezza pasto (minuti)

parameter Real Meal_period = 28800 ;  // pasti periodici: ogni 8 ore.

Boolean meal_on, meal_off ;

initial equation

meal_on = false ;

meal_off = false ;

equation

// pasto periodico di durata Meal_length ogni Meal_period minuti

//quando  ingerire pasto
when sample(0, Meal_period / 2) then

  meal_on = not(pre(meal_on)) ;

end when ;

when sample(Meal_length, Meal_period / 2) then

  meal_off = not(pre(meal_off)) ;

end when ;

//quanto pasto ingerire
when edge(meal_on) then
 
 delta = ceil((random(initialStateWithXorshift64star(localSeed, globalSeed, size(state,1)))*20)+10);
  
elsewhen edge(meal_off) then

  delta = 0 ;
  
end when ;

end MealGenerator ;
