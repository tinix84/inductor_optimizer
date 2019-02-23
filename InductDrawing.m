function InductDrawing

global PM PC 

%% Definizione di nomi dei vari file e def del percorso  modifica del 12_01_2014 LS
nomefile        = PM.Files.nomefile;
nomefileFEMM    = strcat('./Casi/',nomefile, '.fem') ;
nomefileFEMM_AC = strcat('./Casi/',nomefile, '_AC', '.fem') ;
PM.Files.NomeFileFemm   = nomefileFEMM;
PM.Files.NomeFileFemmAC = nomefileFEMM_AC;

% DefaultFileFem   = [Dirs.Progetti  'Default' SLASH 'FEMM' SLASH 'empty_case.fem'];
NuovoFileFem_def = 'empty_case.fem';
pathname         = strcat(cd,'/Casi');
% keyboard
copyfile(['./Femm/',NuovoFileFem_def],pathname);

% Apre il programma per il disegno della macchina a vuoto
openfemm;
% if PC.Debug<1
    main_minimize;
    hideconsole;
% end


% carica il file vuoto (controllare che abbia tutti i materiali caricati)
opendocument(['./Casi/',NuovoFileFem_def]);

% definizione dei parametri per la simulazione
% mi probdef(freq,units,type,precision,depth,minangle,(acsolver))
mi_probdef(0,'millimeters','planar',1e-9,PM.Ind.D ,30);

% aggiunge due correnti (entrante e uscente)
mi_addcircprop('Ip',  PM.Femm.Spire.Ipk , 1);
mi_addcircprop('In', -PM.Femm.Spire.Ipk , 1);

% Condizioni al contorno
% mi addboundprop('propname', A0, A1, A2, Phi, Mu, Sig, c0, c1, BdryFormat)
%  BdryFormat=4 -> periodic
%  BdryFormat=5 -> antiperiodic
mi_addboundprop('A=0', 0, 0, 0, 0, 0, 0, 0, 0, 0);

%% disegno
% disegna Linee extra ed assegna il gruppo
Importa_Matrice(PM.Femm.LineeExtra       ,1,   PC.res * PC.rap_meshall_meshmin );
% disegna linee Nucleo ed assegna il gruppo
Importa_Matrice(PM.Femm.Nucleo.Lin       ,1,   PC.res );
% disegna i Spire ed assegna il gruppo
Importa_Matrice(PM.Femm.Spire.Lin        ,1,   PC.res * PC.rap_meshall_meshmin );

%% inestetismo
mi_zoomnatural

%% Assegna Materiali 
Assegna_Materiali();

%% Condizioni al Contorno
mi_clearselected;
[x,y]=pol2cart(pi/4,PM.Femm.BC.raggio);
mi_selectarcsegment(x,y);
mi_setarcsegmentprop(2, 'A=0', 0, 1);
mi_clearselected;
[x,y]=pol2cart(-pi/4,PM.Femm.BC.raggio);
mi_selectarcsegment(x,y);
mi_setarcsegmentprop(2, 'A=0', 0, 1);
mi_clearselected;

if PC.Debug
    % keyboard
%     pause
end

%% salva
mi_saveas(PM.Files.NomeFileFemm);


%% AC
mi_probdef(PM.dati.fele,'millimeters','planar',1e-9,PM.Ind.D ,30);
% aggiunge due correnti (entrante e uscente)
mi_setcurrent('Ip',  (PM.Femm.Spire.Ipk - PM.dati.Imedia));
mi_setcurrent('In', -(PM.Femm.Spire.Ipk - PM.dati.Imedia));

mi_saveas(PM.Files.NomeFileFemmAC);

%% cancella il file di lavoro
delete(['./Casi/',NuovoFileFem_def]);


%% chiude il programma
closefemm


