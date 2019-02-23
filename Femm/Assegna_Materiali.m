function Assegna_Materiali

global PM
% pulisce da precedenti selezioni
mi_clearselected

% Aria
for n=1:size(PM.Femm.Traf.Cnt,1)
    x=PM.Femm.Traf.Cnt(n,1);
    y=PM.Femm.Traf.Cnt(n,2);
    mi_addblocklabel(x,y);
    mi_selectlabel(x,y);
    mi_setblockprop(PM.Femm.Traf.Mat, 1, 0, '', 0, 1, 0);
    mi_clearselected
end

% Nucleo
for n=1:size(PM.Femm.Nucleo.Cnt,1)
    x=PM.Femm.Nucleo.Cnt(n,1);
    y=PM.Femm.Nucleo.Cnt(n,2);
    mi_addblocklabel(x,y);
    mi_selectlabel(x,y);
    mi_setblockprop(PM.Femm.Nucleo.Mat, 1, 0, '', 0, 1, 0);
    mi_clearselected
end

%% Avvolgimento fatto con una spira per strato
Tot=size(PM.Femm.Spire.Centro,1)/2;
for m=0:1
    for n=1:Tot
        x=PM.Femm.Spire.Centro(n+m*Tot,1);
        y=PM.Femm.Spire.Centro(n+m*Tot,2);
        mi_addblocklabel(x,y);
        mi_selectlabel(x,y);
        if m==0
            fase='Ip';
        else
            fase='In';
        end
        mi_setblockprop(PM.Femm.Spire.Mat, 1, 0, fase, 0, 1, 1);
        mi_clearselected
    end
end

