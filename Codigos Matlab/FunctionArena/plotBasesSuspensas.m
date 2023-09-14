% Draw the Suspense Bases of Arena

function [] = plotBasesSuspensas(h, X1, Y1, X2, Y2, color, alpha)

    % ===== Colorir as plataformas fixas (Considerando a 1 m do chão) =====
    % Plataforma 1
    for x = X1(1) : X1(2)
        for y = Y1(1) : Y1(2)
            h(x,y,2).FaceColor = color;
            h(x,y,2).FaceAlpha = alpha;
            %             h(x,y,z).EdgeColor = 'y';
            %             h(x,y,z).EdgeAlpha = 1;
        end
    end

    % Plataforma 2
    for x = X2(1) : X2(2)
        for y = Y2(1) : Y2(2)
            h(x,y,2).FaceColor = color;
            h(x,y,2).FaceAlpha = alpha;
            %             h(x,y,z).EdgeColor = 'y';
            %             h(x,y,z).EdgeAlpha = 1;
        end
    end
end
