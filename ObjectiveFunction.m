function Result = ObjectiveFunction( OptPar )
% calculate the objective function optimum MINIMUM

global PC PM

%% incremento il numero delle iterazioni
PC.Iterazione = PC.Iterazione + 1 ;
PC.X(PC.Iterazione,:) = OptPar;


%% Draw and evaluation of the new motor
[ Losses, Weight, L_value] = DrawEvaluate(OptPar);

PC.Y(PC.Iterazione,:) = [Losses Weight L_value];

PM.Result.Losses = Losses;
PM.Result.Weight = Weight;
PM.Result.L_value = L_value;

%% Weighted objective function
Result = ...
    PC.Weight.Losses  * Losses + ...
    PC.Weight.Weight  * Weight + ...
    PC.Weight.L_value * abs((PM.dati.L - PM.Result.L_value)/PM.dati.L) + ...
    PC.Weight.G_A     * abs((PM.Ind.G/PM.Ind.A));



