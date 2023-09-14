% =========================================
% PROJETO BDP FLY - 2022
% Controle de navegação e mapeamento
%------------------------------------------

clc, clearvars, close all

% - Constrói a arena:
arena = zeros(16,16,8);
posCenterBlock = zeros(16*16*8,3);

for high = 1:size(arena,3)
    for row = 1:size(arena,1)
        for col = 1:size(arena,2)
            idx = (size(arena,1)*(row - 1) + col) + (high-1)*size(arena,1)*size(arena,2);
            posCenterBlock(idx,1) = row/2 - .25; % x do centro bloco (row,col,high)
            posCenterBlock(idx,2) = col/2 - .25; % y
            posCenterBlock(idx,3) = high/2 - .25; % z
        end
    end
end

% plota o criculo no centro de cada bloco virtual
% plot3(posCenterBlock(:,1),posCenterBlock(:,2),posCenterBlock(:,3),'or')
figure
xlabel('x'), ylabel('y'), zlabel('z')
axis equal
% view(90,-90)
axis([-.5 8.5 -.5 8.5 -.5 4.5])
grid
hold on

% - Construir o bloco:
n = 4; % numero de lados
a = .25; % largura do cubo para o grid
l = .5; % altura do prisma

v1 = [-a -a -a; a -a -a; a a -a; -a a -a]; % face de baixo

% gera vertice superior
for ii=1:4
    v2(ii,:) = v1(ii,:) + [0 0 l];
end

v = [v1 ;v2]; % vertices inferior e superior

%face inferior e superior
f1 = [1:4
    5:8];

% faces laterais
for ii= 1:n
    faceLado(ii, :) = [ii ii+1 n+ii+1 n+ii];
    if ii==4
        faceLado(ii, :) = [ii ii-3 n+1 n+ii];
    end
end

% Matriz de faces superior/inferior e laterais
f = [faceLado; f1];

hold on
title('Arena'); xlabel('x [m]'); ylabel('y [m]'); zlabel('z [m]');
grid on; axis([-0.5 8.5 -.5 8.5 -.5 4.5]); view(30,30);

for idxBlock = 1:length(posCenterBlock)
    h(idxBlock) = patch('Faces',f,'Vertices',v,'FaceColor',[1 1 1],...
        'FaceAlpha',.2,'EdgeColor','k','EdgeAlpha',0.1);
end


% - Arena em blocos
for idxBlock = 1:length(posCenterBlock)
    pos = posCenterBlock(idxBlock,1:3);
    
    % Matriz de Transformação Homogenea
    T = [1 0 0 pos(1)
        0 1 0 pos(2)
        0 0 1 pos(3)
        0 0 0 1];
    
    % Translação a cada iteração
    % atualização dos vértices v = (T*v')'
    h1 = [h(idxBlock).Vertices ones(length(h(idxBlock).Vertices),1)];
    h1 = (T*(h1)')';   % h = [T * h1']'
    
    h(idxBlock).Vertices = h1(:,1:3);
    %     pause
end

drawnow
