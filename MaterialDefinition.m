function Mat = MaterialDefinition

% Densità 
Mat.densitaFe        = 7180;
Mat.densitaAvv       = 8500;

% caratteristiche di perdita ferro
Mat.Fe.Cfpm         = 6.5;
Mat.Fe.alfa         = 1.51;
Mat.Fe.Fo           = 1e3;
Mat.Fe.beta         = 1.74;
Mat.Fe.Bo           = 1.0;
Mat.Fe.etaF         = 0.81; 

% caratteristiche di perdita Rame
Mat.Cu.Ro           = 17 * 1e-9;
Mat.Cu.Kt           = 0.00393;
Mat.Cu.To           = 20;

%% Definizine dei materiali usati
Mat.avv='Copper';
Mat.nuc='M-27 Steel';
Mat.tra='Air';

