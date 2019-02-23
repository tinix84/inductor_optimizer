function [maxsegdeg,raggio,ang1,ang]=Disegna_Arco(dati,ris)
% Disegna_Arco(dati,ris)
% input:
% - dati: una riga della matrice statore o rotore (xy punto 1, xy punto 2, xy centro, verso
% rotazione)

% mi_drawarc(x1,y1,x2,y2,angle,maxseg). maxseg->numero massimo di segmenti
% in cui divido l'arco da disegnare.

% centro
x0 = dati(1); y0 = dati(2);
if dati(7) > 0
    % punto 1
    x1 = dati(3); y1 = dati(4);
    %  punto 2
    x2 = dati(5); y2 = dati(6);
else
    % punto 1
    x2 = dati(3); y2 = dati(4);
    %  punto 2
    x1 = dati(5); y1 = dati(6);
end

% apertura angolare
ang1 = 180/pi * atan2((y1-y0),(x1-x0));
ang2 = 180/pi * atan2((y2-y0),(x2-x0));

ang=ang2-ang1;
if ang<0
    ang=ang+360;
end

raggio = sqrt((x0-x1)^2+(y0-y1)^2);
maxseg = ang*pi./180*raggio./ris;
maxsegdeg = ang./maxseg;

mi_drawarc(x1,y1,x2,y2,ang,maxseg);
end




