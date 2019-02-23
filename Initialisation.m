function Initialisation

global PM PC 

%% Parametri PC
% weights fot the objective function
PC.Weight.Losses  =  0;
PC.Weight.Weight  = 1000;
PC.Weight.L_value =  0;
PC.Weight.G_A     = 1000;

% general parameters for design
PC.muo                     = 4*pi*1e-7;
PC.rap_meshall_meshmin     = 3;
PC.SimDC                   = 1;
PC.SimAC                   = 1;
PC.H_fig1                  = 1;   % se diverso da 0 stampa le figure in matlab
PC.Debug                   = 1;   % se diverso da 0 esegue il calcolo per la sola macchina di default
PC.NumberOfVariables       = 3;   % numero di variabili da utilizzare nell'ottimizzatore

%% Parametri Mat
% Materials Definition
Mat = MaterialDefinition;

%% dati per la definzione dell'induttanza
Imedia = 100;    % [A] corrente media in batteria
Vc     = 800;    % [V] tensione di bus

%% scelte
Ipk              = 125;    % [A] corrente massima
fele             = 30e3;   % [kHz] frequenza di lavoro dell'induttore
tempcu           = 130;    % [temperatura di esercizio del rame
delta            = 20*1e6; % [A/m^2] densità di corrente
Bm               = 1;      % [T] induzione di picco 
IsoNuc           = 0.5 ;   % [mm] margine della bobina dal nucleo
Iso              = 0.25;
eta              = 0.6 ;   % [-] Coefficiente di riempimento di cava
k                = 2 ;   % [-] Coefficiente di allargamento dell'area ferro

dI   = Ipk - Imedia;
L    = 1/8 * Vc/fele * 1/(dI);
Irms = sqrt(Imedia^2 + 1/3*(dI)^2);
dB   = dI/Imedia * Bm /(1 + dI/Imedia);  % oscillazione di flusso in proporzione all'oscillazione di corrente (linearità)

FScala           = 1e3;    % [-] fattore di scala per la rappresentazione numerica in millimetri

%% Parametri di Progetto
% perdite nel nucleo massiche
pfw              = Mat.Fe.Cfpm * (fele/Mat.Fe.Fo)^ Mat.Fe.alfa * (dB/Mat.Fe.Bo)^ Mat.Fe.beta;
% Temperatura e resistività
rocu             = Mat.Cu.Ro * (1+ Mat.Cu.Kt*(tempcu-Mat.Cu.To));
Mat.Cu.Ro        = rocu;


%% primo calcolo cubo
% Ferro Finestra
SfeSfin = (Irms * L * Ipk)/(Bm * eta * delta * Mat.Fe.etaF);
% dimensione cubo
A = (SfeSfin*27/2)^(1/4);
% area Ferro
Sfe = 1/6 * A^2;
% Traferro
g = L * k * PC.muo / Sfe * (Ipk / Bm)^2;
% Numero di spire
N = L * Ipk /(Sfe * Bm);
% Sezione in m^2
Scu = Irms/(delta);
% profondità di penetrazione
d = sqrt(2*Mat.Cu.Ro/(2*pi*fele*PC.muo));

% risoluzione minima
PC.res = d*FScala;

%% parametri di disegno in millimetri
D = A*FScala;
B = 2/3*A*FScala;
C = 2/3*A*FScala;
G = g/2*FScala;
A = 1/6 * A / Mat.Fe.etaF * FScala;
F = C + 2*A;
E = B + 2*A;

Hs = 2*d * FScala;
Ls = Scu/(2*d) * FScala;

% scaling factor
Nuc.Fscala = FScala;
% Nucleo parameters [mm]
Nuc.A = A; 
Nuc.B = B;
Nuc.C = C;
Nuc.D = D;
Nuc.E = E;
Nuc.F = F;
Nuc.G = G;
Nuc.Hs = Hs;
Nuc.Ls = Ls;
Nuc.N  = N;


%% Ragggruppamento delle variabili in una struttura.
pm.SfeSfin          = SfeSfin;  % [m^4]
pm.Rfe              = A/D;      % [-]
pm.Rfin             = C/B;      % [-]
pm.RSS              = A*D/(C*B);% [-]
pm.RHL              = Hs/(d*FScala);    % [-]

% parametri di progetto
dati.Scu            = Scu;     % [m^2]
dati.pfw            = pfw;     % [W/kg]
dati.fele           = fele;    % [Hz]
dati.tempcu         = tempcu;  % [°C]
dati.Imedia         = Imedia;    % [A]
dati.Irms           = Irms;    % [A]
dati.Ipk            = Ipk;     % [A]
dati.L              = L;       % [H]
dati.Bm             = Bm;      % [T]
dati.eta            = eta;     % [-]
dati.k              = k;       % [-]
dati.delta          = delta;   % [A/m^2]
dati.IsoNuc         = IsoNuc;   % [mm]
dati.Iso            = Iso;
dati.d              = d*FScala;

Files.nomefile       = 'Inductor';

%% Out
Out.Rs          = 0;

%% PMs
PM.Out          = Out;
PM.Mat          = Mat;
PM.pm           = pm;
PM.dati         = dati;
PM.Nuc          = Nuc;
PM.Files        = Files;

%% for FEMM
if not(exist('openfemm','file'))
    if exist('C:\\femm42\\mfiles','dir')
        addpath('C:\\femm42\\mfiles');
    else
        %warndlg('Manca FEMM4.2 o il Path al (mfile)');
        warndlg('Missing FEMM4.2 o Path to (\mfile) directory');
        return
    end
end


