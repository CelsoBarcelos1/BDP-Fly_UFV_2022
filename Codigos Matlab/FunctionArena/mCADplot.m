% Function to plto Arena of fly

function [h] = mCADplot(limitsArena,larg_block,alt_block)

    figure
    title('Arena');
    xlabel('x [m]', 'Interpreter', 'latex');
    ylabel('y [m]', 'Interpreter', 'latex');
    zlabel('z [m]', 'Interpreter', 'latex');
    axis(limitsArena); view(30,30); grid on; hold on;

    % ---- Construir o bloco ------
    n = 4; % numero de lados
    a = larg_block; % largura do cubo para o grid
    % alt_block; % altura do prisma

    v1 = [-a -a -a; a -a -a; a a -a; -a a -a]/2; % face de baixo

    % gera vertice superior
    for ii=1:4
        v2(ii,:) = v1(ii,:) + [0 0 alt_block];
    end

    v = [v1; v2]; % vertices inferior e superior

    %face inferior e superior
    f1 = [1:4; 5:8];

    % faces laterais
    for ii= 1:n
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
end