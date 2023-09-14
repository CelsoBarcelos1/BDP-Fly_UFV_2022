% =========================================
% PROJETO BDP FLY - 2022
% Codigo apenas para gerar um patch
%------------------------------------------

clc; close all; clear all;
n = 4; % numero de lados do quadrado
a = 4; % largura do cubo para o grid
h = 3; % altura do prisma

v1 = [0 0 0; a 0 0; a a 0; 0 a 0]; % face de baixo

% gera vertice superior
for ii=1:4
    v2(ii,:) = v1(ii,:) + [0 0 h];
end

v = [v1 ;v2]; % vertices inferior e superior

%face inferior e superior
f1 = [1:4; 5:8];

% faces laterais
for ii= 1:n
    faceLado(ii, :) = [ii ii+1 n+ii+1 n+ii];
    if ii==4
        faceLado(ii, :) = [ii ii-3 n+1 n+ii];
    end
end

f = [faceLado; f1];

h = patch('Faces',f,'Vertices',v,'FaceColor','red',...
            'FaceAlpha',.2,'EdgeColor','b');

title('Arena'); xlabel('x [m]'); ylabel('y [m]'); zlabel('z [m]');
grid on; axis([-0.5 8.5 -.5 8.5 -.5 4.5]); view(30,30);