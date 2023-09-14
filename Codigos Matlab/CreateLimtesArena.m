% ==================== * * * * * * * * ===============================
% Function to create a cubic patch to visualize the limites of Arena
% BDP - Uai Flydff
% ==================== * * * * * * * * ===============================

function h = CreateLimtesArena(limites)
    n = 4; % numero de lados
    a = limites(1); % largura em x do cubo para o grid
    b = limites(2); % largura em y do cubo para o grid
    l = limites(3); % altura do prisma

    v1 = [a -b 0; a b 0; -a b 0; -a -b 0]; % vertices de baixo

    % gera vertices superior
    for ii=1:4
        v2(ii,:) = v1(ii,:) + [0 0 l];
    end

    v = [v1; v2];

    %face inferior e superior
    f1 = [1:4; 5:8];

    % faces laterais
    for ii = 1:4
        faceLado(ii, :) = [ii ii+1 n+ii+1 n+ii];
        if ii == 4
            faceLado(ii, :) = [ii ii-3 n+1 n+ii];
        end
    end

    f = [faceLado; f1];

    h = patch('Faces',f,'Vertices', v, 'FaceColor', [255 255 255]/255);
    h.FaceAlpha = 0.2;
    h.EdgeAlpha = 0.2;
    view(30,30)
    

end