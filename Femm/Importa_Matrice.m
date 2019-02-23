function Importa_Matrice(Mat,gruppo,res)
 
[nrig,ncol] = size(Mat);
for ii=1:nrig;
    if Mat(ii,ncol)==0
        mi_drawline(Mat(ii,3),Mat(ii,4),Mat(ii,1),Mat(ii,2));
        mi_selectsegment(mean([Mat(ii,1) Mat(ii,3)]),mean([Mat(ii,2) Mat(ii,4)]));
        mi_setsegmentprop('None', res, 0, 0, gruppo);
        mi_clearselected
        mi_selectnode(Mat(ii,1),Mat(ii,2));
        mi_selectnode(Mat(ii,3),Mat(ii,4));
        mi_setnodeprop('None',gruppo);
        mi_clearselected
    else       
        [maxsegdeg,raggio,ang1,ang] = Disegna_Arco(Mat(ii,:),res);
        [x_temp,y_temp]=pol2cart((ang1+0.5*ang)*pi/180,raggio);
        x=x_temp+Mat(ii,1);
        y=y_temp+Mat(ii,2);
        mi_selectarcsegment(x,y);
        mi_setarcsegmentprop(maxsegdeg, 'None', 0, gruppo);
        mi_clearselected
        mi_selectnode(Mat(ii,5),Mat(ii,6));
        mi_selectnode(Mat(ii,3),Mat(ii,4));
        mi_setnodeprop('None',gruppo);
        mi_clearselected
    end       
end



