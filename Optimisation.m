clear all
close all
clc

%% definition of the global variables
global PM PC 

% add path to varibles
addpath([pwd '/Femm'],'-BEGIN')

%% main parameters for machine construction and evaluation
Initialisation;

% iterazioni
PC.Iterazione = 1 ;

% initialisation
[OptPar0,LowerBound,UpperBound] = OptParInitalValue;
PC.X(1,:) = OptPar0;
PC.Y(1,:) = [0 0 0];

% esempi per lavorare a mano
% OptPar0 (2) = 2;
% OptPar0 = [0.4115    1.0000    0.9259    0.1628];


%% debug
if PC.Debug
    %% calculate default 
    ObjectiveFunction(OptPar0)
else
    %% fmincon parameters
    OptSetPoints = optimset('display','iter','algorithm','sqp','PlotFcns',@optimplotfval);
    % help:
    % 'display','iter'
    % 'algorithm','sqp'
    % 'TolX',0.01
    
    %% Optimization execution
    [xsol,fsol,flag] = fmincon('ObjectiveFunction',OptPar0,[],[],[],[],LowerBound,UpperBound,'Contraintes',OptSetPoints);
    % help for linear conditions:
    % [],[],[],[] ...
    % A,B,a,b ...
    % A OptPar = B
    % a OptPar < b
    % flag why optimization stops...
end

rmpath([pwd '/Femm']);
