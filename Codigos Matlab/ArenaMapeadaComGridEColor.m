% =========================================
% PROJETO BDP FLY - 2022
% Controle de navegação e mapeamento
%------------------------------------------

%   --------  Colors  ----------
% red = 100 (centena)
% green = 10 (dezena)
% blue = 1 (unidade) - trajetoria
% vazio = 111 (branco)

% dimensoes da Arena = (8, 8, 4) [m]
%==============================================

clc, clearvars, close all

figure
title('Arena');
xlabel('x [m]', 'Interpreter', 'latex');
ylabel('y [m]', 'Interpreter', 'latex');
zlabel('z [m]', 'Interpreter', 'latex');
axis([-0.5 8.5 -.5 8.5 0 4.5]); view(30,30); grid on; hold on;

% ---- Construir o bloco ------
n = 4; % numero de lados
a = .25; % largura do cubo para o grid
l = .5; % altura do prisma

v1 = [-a -a -a; a -a -a; a a -a; -a a -a]; % face de baixo

% gera vertice superior
for ii=1:4
    v2(ii,:) = v1(ii,:) + [0 0 l];
end

v = [v1; v2]; % vertices inferior e superior

%face inferior e superior
f1 = [1:4; 5:8];

% faces laterais
for ii = 1:n
    faceLado(ii, :) = [ii ii+1 n+ii+1 n+ii];
    if ii==4
        faceLado(ii, :) = [ii ii-3 n+1 n+ii];
    end
end

% Matriz de faces superior/inferior e laterais
f = [faceLado; f1];

% - Constrói a arena subdividida em grids:
arena = zeros(16,16,8);
posCenterBlock{1} = zeros(16,16,8,3);
posCenterBlock{2} = zeros(16*16*8,3);

for high = 1:size(arena,3)
    for row = 1:size(arena,1)
        for col = 1:size(arena,2)
            idx = (size(arena,1)*(row - 1) + col) + (high-1)*size(arena,1)*size(arena,2);
            
            posCenterBlock{1}(row,col,high,1) = row/2 - .25;  % x do centro bloco (row,col,high)
            posCenterBlock{1}(row,col,high,2) = col/2 - .25;  % y
            posCenterBlock{1}(row,col,high,3) = high/2 - .25; % z
            
            h(row,col,high) = patch('Faces',f,'Vertices',v,'FaceColor',[1 1 1],...
                'FaceAlpha',0,'EdgeColor','k','EdgeAlpha',0.1);
            
            posCenterBlock{2}(idx,1) = row/2 - .25;  % x do centro bloco (row,col,high)
            posCenterBlock{2}(idx,2) = col/2 - .25;  % y
            posCenterBlock{2}(idx,3) = high/2 - .25; % z
        end
    end
end

% plota o criculo no centro de cada bloco virtual
% centerPoint = plot3(posCenterBlock{2}(:,1),posCenterBlock{2}(:,2),posCenterBlock{2}(:,3),'or','MarkerSize',3);

% - Arena em blocos
for idzBlock = 1:size(arena,3)
    for idxBlock = 1:size(arena,1)
        for idyBlock = 1:size(arena,2)
            
            pos = posCenterBlock{1}(idxBlock,idyBlock,idzBlock,:); %posCenterBlock(idxBlock,1:3);
            
            % Matriz de Transformação Homogenea
            T = [1 0 0 pos(1)
                0 1 0 pos(2)
                0 0 1 pos(3)
                0 0 0 1];
            
            % Translação a cada iteração
            % atualização dos vértices v = (T*v')'
            h1 = [h(idxBlock,idyBlock, idzBlock).Vertices ones(length(h(idxBlock,idyBlock, idzBlock).Vertices),1)];
            h1 = (T*(h1)')';   % h = [T * h1']'
            
            h(idxBlock,idyBlock, idzBlock).Vertices = h1(:,1:3);
            %     pause
        end
    end
end

% - Posição do drone
X{1} = [5.2 3.41 1.53];
X{2} = [3.7 6.8 1.79];
X{3} = [1.43 6.27 0.87];
X{4} = [6.34 1.87 1.94];

% ======  Ponto desejado  =================
UAVpoints = plot3([X{1}(1) X{2}(1) X{3}(1) X{4}(1)], ... % x
    [X{1}(2) X{2}(2) X{3}(2) X{4}(2)], ... % y
    [X{1}(3) X{2}(3) X{3}(3) X{4}(3)], ... % z
    'xr','MarkerSize',10,'LineWidth',2);

% estima qual a posição h(x,y,z) ao informar uma posição espaciail em [m]
for idx = 1:length(X)
    p{idx} =  round(X{idx}/.5 + 0.25.*[1 1 1]); % 0.5 é a subdivisão usada nos cubos virtuais
    
    posBlock = posCenterBlock{1}(p{idx}(1),p{idx}(2),p{idx}(3),:);
    
    % ======  Ponto atual  ==========
    UAVpoints = plot3(posBlock(1),posBlock(2),posBlock(3),'xb', ...
        'MarkerSize',10,'LineWidth',2);
    
    %     h(p{idx}(1),p{idx}(2),p{idx}(3)).FaceColor = 'red';
    %     h(p{idx}(1),p{idx}(2),p{idx}(3)).FaceAlpha = 0.6;
end

%% ====  Colorir a plataforma de decolagem (posicionada a 0.5 m do chao) =====
for x = 1:4
    for y = 1:3
        h(x,y).FaceColor = [0,191,255]/255;
        h(x,y).FaceAlpha = 0.5;
        %         h(x,y).EdgeColor = 'y';
        %         h(x,y).EdgeAlpha = 1;
    end
end

% ===== Colorir as plataformas fixas (Considerando a 1 m do chão) =====
% Plataforma 1
for x = 2:3
    for y = 7:8
        h(x,y,2).FaceColor = [0,0,205]/255;
        h(x,y,2).FaceAlpha = 0.5;
        %             h(x,y,z).EdgeColor = 'y';
        %             h(x,y,z).EdgeAlpha = 1;
    end
end

% Plataforma 2
for x = 14:15
    for y = 2:3
        h(x,y,2).FaceColor = [0,0,205]/255;
        h(x,y,2).FaceAlpha = 0.5;
        %             h(x,y,z).EdgeColor = 'y';
        %             h(x,y,z).EdgeAlpha = 1;
    end
end

%% SEGUIMENTO DE TRAJETORIA - LENMISCATA
% clc; clearvars; close all;

% Tempos
tmax = 60*2;
tc = tic;
tp = tic;
t = tic;

dados = []; % Vetor de dados vazios
pos = [];

%% Inicio da simulacao
while (toc(t)<= tmax)
    
    if toc(tc) > 0.1
        
        tc = tic;
        
        % Trajetoria Lemniscata
        xd = 4 + 3.5*sin((2*pi*toc(t))/tmax);
        yd = 4 + 3*sin((2*pi*toc(t))/tmax*2);
        zd = 1.5 + 1*sin((2*pi*toc(t))/(2*tmax));
        
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
            
            % preenche os grids conforme a trajetoria se desloca
            pos = round([dados(end,1) dados(end,2) dados(end,3)]/.5 + 0.25.*[1 1 1]); % 0.5 é a subdivisão usada nos cubos virtuais
            
            % colore os grids por onde a trajetoria passa
            h(pos(1),pos(2),pos(3)).FaceColor = [0, 180, 20]/255; % cor
            h(pos(1),pos(2),pos(3)).FaceAlpha = 0.3; % transparencia
            
            drawnow
        end
    end
end

% =====================================================
% Comandos para visualizar vistas nos planos xy, zy e zx
% view(0,90) % x-y
% view(90,0) % z-y
% view(0,0) % z-x

%
% figure(2)
% subplot(3,1,1)
% plot3([X{1}(1) X{2}(1)],[X{1}(2) X{2}(2)],[X{1}(3) X{2}(3)],...
%        'xr','MarkerSize',10,'LineWidth',2);
% hold on; grid on
% UAVpoints = plot3(posBlock(1),posBlock(2),posBlock(3),'xb','MarkerSize',10,'LineWidth',2);
% view(0,90)
%
% subplot(3,1,2)
% plot3([X{1}(1) X{2}(1)],[X{1}(2) X{2}(2)],[X{1}(3) X{2}(3)],...
%        'xr','MarkerSize',10,'LineWidth',2);
% hold on; grid on
% UAVpoints = plot3(posBlock(1),posBlock(2),posBlock(3),'xb','MarkerSize',10,'LineWidth',2);
% view(90,0)
%
% subplot(3,1,3)
% plot3([X{1}(1) X{2}(1)],[X{1}(2) X{2}(2)],[X{1}(3) X{2}(3)],...
%        'xr','MarkerSize',10,'LineWidth',2);
% hold on; grid on
% UAVpoints = plot3(posBlock(1),posBlock(2),posBlock(3),'xb','MarkerSize',10,'LineWidth',2);
% view(0,0)
