function [Losses,Weight,L_value] = DrawEvaluate(Parameters)

global PC

%% calcolo delle dimensioni de rotore
[Weight,Losses] = InductCalculation(Parameters);


%% Motor build in FEMM (optionally in DXF)
if (PC.SimDC || PC.SimAC)
    InductDrawing;
end


%% Motor evaluation
L_value = InductEvaluation;

