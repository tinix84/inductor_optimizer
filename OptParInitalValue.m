function [OptPar0,LowerBound,UpperBound] = OptParInitalValue

global PM PC

% help
% pm.SfinSfe          = SfinSfe;  % [m^4]
% pm.Rfe              = A/D;      % [-]
% pm.Rfin             = C/B;      % [-]
% pm.RSS              = A*D/(C*B);% [-]
% pm.RHL              = Hs/Ls;    % [-]

switch (PC.NumberOfVariables )
    case 1
        OptPar0    = PM.Nuc.G;
        LowerBound = 0.9 * OptPar0;
        UpperBound = 1.1 * OptPar0;
        
    otherwise
        OptPar0    = [ PM.pm.Rfe PM.pm.Rfin PM.pm.RSS ];
        LowerBound = 0.5 * OptPar0;
%         LowerBound(2) = 0;
        UpperBound = 2 * OptPar0;
%         UpperBound(2) = 10;
end
