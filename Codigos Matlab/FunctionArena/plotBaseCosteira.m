% Draw the Costeira Base of Arena

function [] = plotBaseCosteira(h, X, Y, color, alpha)

    %%% ====  Colorir a plataforma de decolagem (posicionada a 0.5 m do chao) =====
    for x = X(1) : X(2)
        for y = Y(1): Y(2)            
            h(x,y).FaceColor = color;
            h(x,y).FaceAlpha = alpha;            
            %         h(x,y).EdgeColor = 'y';
            %         h(x,y).EdgeAlpha = 1;
            
        end
    end
end
