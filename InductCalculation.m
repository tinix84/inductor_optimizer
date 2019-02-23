function [Peso,Perdite]=InductCalculation(OptPar)

global PM PC

% help letture
% pm.SfinSfe          = SfinSfe;
% pm.Rfe              = A/D;
% pm.Rfin             = C/B;
% pm.RSS              = A*D/(C*B);
% A*D = Sfe
% C*B = Sfin

switch (PC.NumberOfVariables )
    case 1        
        Rfe  = PM.pm.Rfe;
        Rfin = PM.pm.Rfin;
        RSS  = PM.pm.RSS;
        g = OptPar(1)*2 / PM.Nuc.Fscala;
    otherwise
        Rfe  = OptPar(1);
        Rfin = OptPar(2);
        RSS  = OptPar(3);
end


% noto il prodotto ed il rapporto calcolo le aree
Sfin = sqrt(PM.pm.SfeSfin/RSS); % [m^2]
Sfe  = PM.pm.SfeSfin / Sfin;    % [m^2]

% noti i fattori di forma calcolo le dimensioni
D = sqrt(Sfe/Rfe);                   % [m]
A = Sfe/D / PM.Mat.Fe.etaF;          % [m]
B = sqrt(Sfin/Rfin);                 % [m]
C = Sfin/B;                          % [m]
F = C+2*A;                           % [m]
E = B+2*A;                           % [m]

% keyboard

% traferro 
if (PC.NumberOfVariables>1),
    g = PM.dati.L * PM.dati.k * PC.muo / Sfe * (PM.dati.Ipk / PM.dati.Bm)^2;
end
% numero di spire (pari...)
N = 2*round(1/2*PM.dati.L * PM.dati.Ipk /(Sfe * PM.dati.Bm));

%% parametri di disegno in millimetri
FScala = PM.Nuc.Fscala;

Ind.A = A*FScala;
Ind.B = B*FScala;
Ind.C = C*FScala;
Ind.D = D*FScala;
Ind.E = E*FScala;
Ind.F = F*FScala;
Ind.N = N;
Ind.G = g/2*FScala;

PM.Ind = Ind;

%% calcoli
% Volume ferro
Vfe = D*(F*E - C*B) * PM.Mat.Fe.etaF ;
% peso ferro
Wfe = PM.Mat.densitaFe * Vfe;
% perdite ferro
Loss_fe = PM.dati.pfw * Wfe;

% Volume del rame
Vcu = PM.dati.eta * C * (2*B*D + 4*(B+A)*B/2);
WAvv = PM.Mat.densitaAvv * Vcu;

% Resistenza avvolgimento DC
Rdc = N * PM.Mat.Cu.Ro * 2*(D + B + A)/(PM.dati.Scu);
Loss_Avv = Rdc * PM.dati.Irms^2; 

% Globale
Peso = Wfe + WAvv;
Perdite = Loss_fe + Loss_Avv;

%% punti per il disegno
% disegno di mezzo nucleo
Pnt(1,:) = [0              Ind.F/2+Ind.G/2];
Pnt(2,:) = [Ind.E/2        Ind.F/2+Ind.G/2];
Pnt(3,:) = [Ind.E/2        Ind.G/2];
Pnt(4,:) = [Ind.E/2-Ind.A  Ind.G/2];
Pnt(5,:) = [Ind.E/2-Ind.A  Ind.G/2+Ind.C/2];
Pnt(6,:) = [0              Ind.G/2+Ind.C/2];
Cnt(1,:) = 0.5*(Pnt(2,:)+Pnt(5,:));
Pnt(7:12,1) =  Pnt(1:6,1);
Pnt(7:12,2) = -Pnt(1:6,2);
Cnt(2,1) =  Cnt(1,1);
Cnt(2,2) = -Cnt(1,2);

% linee
LineeNuc( 1,:) = [Pnt( 1,:) Pnt( 2,:) [0 0 0] ];
LineeNuc( 2,:) = [Pnt( 2,:) Pnt( 3,:) [0 0 0] ];
LineeNuc( 3,:) = [Pnt( 3,:) Pnt( 4,:) [0 0 0] ];
LineeNuc( 4,:) = [Pnt( 4,:) Pnt( 5,:) [0 0 0] ];
LineeNuc( 5,:) = [Pnt( 5,:) Pnt( 6,:) [0 0 0] ];
LineeNuc( 6,:) = [Pnt( 6,:) Pnt( 1,:) [0 0 0] ];
LineeNuc( 7,:) = [Pnt( 7,:) Pnt( 8,:) [0 0 0] ];
LineeNuc( 8,:) = [Pnt( 8,:) Pnt( 9,:) [0 0 0] ];
LineeNuc( 9,:) = [Pnt( 9,:) Pnt(10,:) [0 0 0] ];
LineeNuc(10,:) = [Pnt(10,:) Pnt(11,:) [0 0 0] ];
LineeNuc(11,:) = [Pnt(11,:) Pnt(12,:) [0 0 0] ];
LineeNuc(12,:) = [Pnt(12,:) Pnt( 7,:) [0 0 0] ];


%% disegno di mezzo avvolgimento
% numero di spire da disegnare
N2 = N/2; 
Nv = N2;
No = 1;

HH = Ind.C + Ind.G - 2*PM.dati.IsoNuc - (N2-1) * PM.dati.Iso;
LL = Ind.B/2 - 2*PM.dati.IsoNuc;
ScuL = HH * LL / N2;

Ind.Ls = LL;
Ind.Hs = ScuL/Ind.Ls;

% keyboard

% partenza in alto a sinistra
Centro(1,1) = Pnt(5,1)- Ind.Ls/2 - PM.dati.IsoNuc;
Centro(1,2) = Pnt(5,2)- Ind.Hs/2 - PM.dati.IsoNuc;

ii = 1;

% sprire interne
for m = 1:No
    for n = 1:Nv
        IndFilo = n+(m-1)*Nv;
        Avv(ii,:) = Centro(IndFilo,:) + [ Ind.Ls/2  Ind.Hs/2]; 
        ii= ii+1;
        Avv(ii,:) = Centro(IndFilo,:) + [ Ind.Ls/2 -Ind.Hs/2];
        LineeAvv(ii-1,:) = [Avv(ii-1,:) Avv(ii,:) [0 0 0] ];
        ii= ii+1;
        Avv(ii,:) = Centro(IndFilo,:) + [-Ind.Ls/2 -Ind.Hs/2];
        LineeAvv(ii-1,:) = [Avv(ii-1,:) Avv(ii,:) [0 0 0] ];
        ii= ii+1;
        Avv(ii,:) = Centro(IndFilo,:) + [-Ind.Ls/2  Ind.Hs/2];
        LineeAvv(ii-1,:) = [Avv(ii-1,:) Avv(ii,:) [0 0 0] ];
        ii= ii+1;
        LineeAvv(ii-1,:) = [Avv(ii-1,:) Avv(ii-4,:) [0 0 0] ];
        
        if (IndFilo+1>N2), break, end
        Centro(IndFilo+1,:) = Centro(IndFilo,:) - [0 Ind.Hs+PM.dati.Iso];        
    end    
    if (IndFilo+1>N2), break, end
    Centro(IndFilo+1,:) = Centro(1,:) - m*[(Ind.Ls+PM.dati.Iso) 0];   
end

% sprire esterne
Centro(IndFilo+1,1) = Pnt(5,1) + PM.Ind.A + Ind.Ls/2 + PM.dati.IsoNuc;
Centro(IndFilo+1,2) = Pnt(5,2) - Ind.Hs/2 - PM.dati.IsoNuc;

for m = 1:No
    for n = 1:Nv
        IndFilo = N2 + n+(m-1)*Nv;
        Avv(ii,:) = Centro(IndFilo,:) + [ Ind.Ls/2  Ind.Hs/2]; 
        ii= ii+1;
        Avv(ii,:) = Centro(IndFilo,:) + [ Ind.Ls/2 -Ind.Hs/2];
        LineeAvv(ii-1,:) = [Avv(ii-1,:) Avv(ii,:) [0 0 0] ];
        ii= ii+1;
        Avv(ii,:) = Centro(IndFilo,:) + [-Ind.Ls/2 -Ind.Hs/2];
        LineeAvv(ii-1,:) = [Avv(ii-1,:) Avv(ii,:) [0 0 0] ];
        ii= ii+1;
        Avv(ii,:) = Centro(IndFilo,:) + [-Ind.Ls/2  Ind.Hs/2];
        LineeAvv(ii-1,:) = [Avv(ii-1,:) Avv(ii,:) [0 0 0] ];
        ii= ii+1;
        LineeAvv(ii-1,:) = [Avv(ii-1,:) Avv(ii-4,:) [0 0 0] ];
        
        if (IndFilo+1>N), break, end
        Centro(IndFilo+1,:) = Centro(IndFilo,:) - [0 Ind.Hs+PM.dati.Iso];        
    end    
    if (IndFilo+1>N), break, end
    Centro(IndFilo+1,:) = Centro(N2+1,:) + m*[(Ind.Ls+PM.dati.Iso) 0];   
end

%% condizioni al contorno
BC.raggio    = 1.2*abs(Pnt(2,1)+1i*Pnt(2,2));

% centro del traferro per assegnazione materiale
CntG(1,:) = [Pnt(3,1) + PM.dati.IsoNuc/2 0];
CntG(2,:) = 0.5*(Pnt(3,:)+Pnt(4,:)).*[1 0];
CntG(3,:) = [Pnt(4,1) - PM.dati.IsoNuc/2 0];

% linee di dettaglio
LineeExtra(1,:) = [[0 0] [0 -BC.raggio] [BC.raggio 0]  1 ];
LineeExtra(2,:) = [[0 0] [BC.raggio  0] [0 BC.raggio]  1 ];
LineeExtra(3,:) = [Pnt( 6,:) Pnt(12,:) [0 0 0] ];
LineeExtra(4,:) = [Pnt( 4,:) Pnt(10,:) [0 0 0] ];
LineeExtra(5,:) = [Pnt( 9,:) Pnt( 3,:) [0 0 0] ];
LineeExtra(6,:) = [Pnt( 1,:) [0  BC.raggio] [0 0 0] ];
LineeExtra(7,:) = [Pnt( 7,:) [0 -BC.raggio] [0 0 0] ];

BC.Norm.Cnt(1,:) = 0.5*(Pnt( 1,:) + Pnt( 6,:));
BC.Norm.Cnt(2,:) = 0.5*(Pnt( 6,:) + Pnt(12,:));
BC.Norm.Cnt(3,:) = 0.5*(Pnt(12,:) + Pnt( 7,:));
BC.Norm.Cnt(4,:) = 0.5*(Pnt( 1,:) + [0  BC.raggio]);
BC.Norm.Cnt(5,:) = 0.5*(Pnt( 7,:) + [0 -BC.raggio]);


%% figura in Matlab
if PC.H_fig1
    
    figure(PC.H_fig1) 
    
    plot(Avv(:,1),Avv(:,2),'rx')
    hold on   
    plot(Pnt(:,1),Pnt(:,2),'bx')
    
    fill(Pnt(1:6,1),Pnt(1:6,2),'b')
    fill(Pnt(7:12,1),Pnt(7:12,2),'b')

    for n=1:N
        indici = (4*(n-1)+1):(4*n);
        fill(Avv(indici,1),Avv(indici,2),'r')
    end
    
    plot(Pnt([3, 9],1),Pnt([3, 9],2),'k')
    plot(Pnt([4,10],1),Pnt([4,10],2),'k')
    plot(Pnt([6,12],1),Pnt([6,12],2),'k')
    plot([Pnt(1,1) 0],[Pnt(1,2)  BC.raggio],'k')
    plot([Pnt(7,1) 0],[Pnt(7,2) -BC.raggio],'k')
    
    plot(Centro(:,1),Centro(:,2),'kx')
    plot(Cnt(:,1),Cnt(:,2),'kx')
    plot(CntG(:,1),CntG(:,2),'kx')
        
    ango=linspace(-pi/2,pi/2,50);
    ragione=BC.raggio * ones(size(ango));
    [elliX,elliY]=pol2cart(ango,ragione);    
    plot(elliX,elliY,'k');
    
    hold off
    axis equal
    
end
% keyboard
pause (0.5)

%% dati per simulare
Femm.Nucleo.Cnt   = Cnt;
Femm.Nucleo.Ele   = 2;
Femm.Nucleo.Pnt   = Pnt;
Femm.Nucleo.Lin   = LineeNuc;
Femm.Nucleo.Mat   = PM.Mat.nuc;
Femm.Spire.Avv    = Avv;
Femm.Spire.Lin    = LineeAvv;
Femm.Spire.N      = N2;
Femm.Spire.Centro = Centro;
Femm.Spire.Mat    = PM.Mat.avv;
Femm.Spire.Ipk    = PM.dati.Ipk;
Femm.Traf.Cnt     = CntG;
Femm.Traf.Mat     = PM.Mat.tra;
Femm.LineeExtra   = LineeExtra;
Femm.BC           = BC;

PM.Femm=Femm;