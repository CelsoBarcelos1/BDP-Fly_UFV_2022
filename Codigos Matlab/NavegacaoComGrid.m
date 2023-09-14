% =========================================
% PROJETO BDP FLY - 2022
% Controle de navegação e mapeamento
%------------------------------------------

clc; close all; clear all;
n = 4; % numero de lados
a = .5; % largura do cubo para o grid
h = .5; % altura do prisma

v1 = [0 0 0; a 0 0; a a 0; 0 a 0]; % face de baixo

% gera vertice superior
for ii=1:4
    v2(ii,:) = v1(ii,:) + [0 0 h];
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

f = [faceLado; f1];

% h = patch('Faces',f,'Vertices',v,'FaceColor','red');
h = patch('Faces',f,'Vertices',v,'FaceColor','red',...
          'FaceAlpha',.001,'EdgeColor','k');

title('Ambiente'); xlabel('x [m]'); ylabel('y [m]'); zlabel('z [m]');
grid on; axis([-0.5 8.5 -.5 8.5 -.5 4.5]); view(30,30);

d = 0.5; % deslocamento

deltax = 0;
deltay = 0;
deltaz = 0;

% T = [1 0 0 5
%     0 1 0 0
%     0 0 1 0
%     0 0 0 1];
%     
% h2 = [h.Vertices ones(length(h.Vertices), 1)];
% h2 = (T*(h2)')';
% h.Vertices = h2(:,1:3);

T = [1 0 0 deltax
        0 1 0 deltay
        0 0 1 deltaz
        0 0 0 1];

%%
for ii = 0:8    
    deltax = deltax + d;
    deltay = deltay + d;
    deltaz = deltaz + d;
    
    % Matriz de Transformação Homogenea
%     for jj = 1:4      
    T = [1 0 0 deltax
        0 1 0 deltay
        0 0 1 deltaz
        0 0 0 1];
%     end
    
    % Translação a cada iteração
    % atualização dos vértices v = (T*v')'
    h1 = [h.Vertices ones(length(h.Vertices),1)];
    h1 = (T*(h1)')';   
    
   h.Vertices = h1(:,1:3);
   drawnow
end





