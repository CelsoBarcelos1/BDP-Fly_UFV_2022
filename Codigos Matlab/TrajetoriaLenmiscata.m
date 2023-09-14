%% TRAJETORIA LENMISCATA

clc; clearvars; close all;

% Tempos
tmax = 30;
tc = tic;
tp = tic;
t = tic;

dados = []; % Vetor de dados vazios

%% Inicio da simulacao
while (toc(t)<=tmax)
    
    if toc(tc) > 0.1
        % Inicio da realimenta��o
        tc = tic;
        
        % Trajetoria Lemniscata
        xd = 1.5*sin((pi*toc(t))/15);
        yd = 1*sin((2*pi*toc(t))/15);
        zd = 1 + 0.5*sin((2*pi*toc(t))/30);
        
        % xdp=(pi/10)*cos((pi*toc(t))/15);  % xd ponto
        % ydp=(2*pi/15)*cos((2*pi*toc(t))/15);% yd ponto
        
        dados = [dados;[xd yd zd toc(t)]]; % Matriz que acumula os
        % dados das variaveis da simulação
        
        if toc(tp) > 0.1
            tp = tic;
            try
                delete(sensacao); 
            catch
            end
            %   P.mCADplot2D('r')   % Simulação 2D
            
            sensacao = plot3(dados(:,1),dados(:,2), dados(:,3),...
                '->k','MarkerIndices',size(dados,1));
            hold on; grid on;
            title('Arena');
            xlabel('x [m]', 'Interpreter', 'latex');
            ylabel('y [m]', 'Interpreter', 'latex');
            zlabel('z [m]', 'Interpreter', 'latex');
            axis([-2 2 -2 2 0 3]);
            
            drawnow
        end
    end
end