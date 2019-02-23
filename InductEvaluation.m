function L_value = InductEvaluation

global PM PC

% compatibilità
L_value = 0;

if PC.SimDC
    %% Simula
    % open the program
    openfemm;
    main_minimize;
    hideconsole;
    
    % carica il file vuoto (controllare che abbia tutti i materiali caricati)
    opendocument(PM.Files.NomeFileFemm);
    
    %% execute the analyis
    mi_analyze(1);
    
    %% Valuta la soluzione
    mi_loadsolution ();
    
    %% Flussi
    temp_out = mo_getcircuitproperties('Ip');
    temp_out = temp_out - mo_getcircuitproperties('In');
    Flusso   = temp_out(3) * 2 ;
    
    L_value  = Flusso / PM.dati.Ipk;
    
    Bnuc = mo_getpointvalues(PM.Femm.Nucleo.Cnt(1,1),PM.Femm.Nucleo.Cnt(1,2));
    
    Out.Pk.L_value = L_value;
    Out.Pk.Flusso = Flusso;
    Out.Pk.I = PM.dati.Ipk;
    Out.Pk.Bnuc = Bnuc;
    
    % keyboard
    % pause
    
    % close the program
    closefemm
    PM.OutFemm = Out;
end

if PC.SimAC
    
    %% open the program
    openfemm;
    main_minimize;
    hideconsole;
    
    % carica il file vuoto (controllare che abbia tutti i materiali caricati)
    opendocument(PM.Files.NomeFileFemmAC);
    
    %% execute the analyis
    mi_analyze(1);
    
    %% Valuta la soluzione
    mi_loadsolution ();
    
    %% Flussi
    temp_out = mo_getcircuitproperties('Ip');
    temp_out = temp_out - mo_getcircuitproperties('In');
    Flusso   = temp_out(3) * 2 ;
    
    L_value  = Flusso / PM.dati.Ipk;
    
    Bnuc = mo_getpointvalues(PM.Femm.Nucleo.Cnt(1,1),PM.Femm.Nucleo.Cnt(1,2));
    
    Out.AC.L_value = L_value;
    Out.AC.Flusso = Flusso;
    Out.AC.I = PM.dati.Ipk;
    Out.AC.Bnuc = Bnuc;
    
    % keyboard
    % pause
    
    % close the program
    closefemm
    PM.OutFemm = Out;
end
