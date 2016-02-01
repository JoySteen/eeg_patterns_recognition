% Находит веса Фишеровского классификатора
% fishertrain                                   инициализация обучения
% mdl = fishertrain(len)                        инициализация модели
% fishertrain(features,groups)                  сбор данных
% mdl = fishertrain                             вычисление весов
% mdl = fishertrain(nAverages,nGroups)          вычисление весов и порога
% mdl = fishertrain(nAverages,nGroups,mdl)      вычисление только порога
%
function mdl = fishertrain(features,groups,mdl)
persistent X XX count

if ~nargin && ~nargout % отчистка переменных для последующего обучения
    count = zeros(2,1,'single');
elseif nargin == 1 && nargout
    count = zeros(2,1,'single');
    mdl.weights = zeros(1,features,'single');
    mdl.threshold = single(0);
    mdl.mu = zeros(2,1,'single');
    mdl.sigma = zeros(2,1,'single');
elseif nargin && ~nargout % суммирование данных
    if isempty(count) || all(count==0)
        % инициализирует начало обучения
        len = size(features,1);
        X = zeros(len,2,'single');
        XX = zeros(len,len,2,'single');
        count = zeros(2,1,'single');
    end
    if nargin == 2
        if isempty(X)
            error('X is undefined');
        end
        len = size(X,1);
        for n = 1:length(groups)
            flag = 1+groups(n);
            count(flag) = count(flag) + 1;
            for k = 1:len
                X(k,flag) = X(k,flag) + features(k,n);
                for l = 1:len
                    XX(k,l,flag) = XX(k,l,flag) + features(k,n)*features(l,n);
                end
            end
        end
    end
elseif nargout
    % вычисление весов
    if nargin == 0 || nargin == 2
        if isempty(X)
            error('X is undefined');
        end
        % вычисление среднего вектора и матрицы ковариации
        len = size(X,1);
        mu = zeros(len,1,'single');
        Z = zeros(len,len,'single');
        for k = 1:len
            mu(k) = X(k,2)/count(2) - X(k,1)/count(1);
            for n = 1:2
                for l = 1:len
                    Z(k,l) = Z(k,l) + ( XX(k,l,n) - X(k,n)*X(l,n)/count(n) )/(count(n)-1);
                end
            end
        end
        % mdl.weights = mu'*pinv(Z);
        % небольшая регуляризация Z
        tr = single(0);
        for n = 1:len
            tr = tr + Z(n,n);
        end
        tr = 0.001*tr/len;
        for n = 1:len
            Z(n,n) = Z(n,n) + tr;
        end
        % алгоритм Фишера
        mdl.weights = mu'/Z;
        mdl.threshold = single(0);
        mdl.mu = zeros(2,1,'single');
        mdl.sigma = zeros(2,1,'single');
    end
    % вычисление оптимального порога
    if nargin == 2 || nargin == 3
        nAverages = features;
        nGroups = groups;
        mu = zeros(2,1,'single');
        sigma = zeros(2,1,'single');
        len = size(X,1);
        for n = 1:2
            for k = 1:len
                mu(n) = mu(n) + X(k,n)/count(n)*mdl.weights(k);
                for l = 1:len
                    z = ( XX(k,l,n) - X(k,n)*X(l,n)/count(n) )/(count(n)-1);
                    sigma(n) = sigma(n) + z*mdl.weights(k)*mdl.weights(l);
                end
            end
            if sigma(n) < 0
                sigma(n) = 1;
            end
        end
        sigma = sqrt(sigma)/sqrt(nAverages);
        for n = 1:2
            if sigma(n) == 0
                sigma(n) = single(1e-2);
            end
        end
        %     if mu(2)<mu(1)
        %         fprintf(2,'Среднее значение классификатора целевого стимула меньше среднего значения классификатора нецелевого\n');
        %     end
        start = mu(1)-3*sigma(1);
        stop = mu(2)+3*sigma(2);
        threshold = single(0);
        maxPf3 = single(0);
        for k = 0:1000
            value = single(start + single(k)/1000*(stop-start));
            % для одиночного стимула
            p0 = 1-normcdf(value,mu(1),sigma(1)); % вероятность срабатывания нецелевого стимула
            p1 = 1-normcdf(value,mu(2),sigma(2)); % вероятность срабатывания целевого стимула
            % окончательный результат
            pf3 = p1*(1-p0).^(nGroups-1); % вероятность правильного срабатывания
            % максимум вероятности правильного срабатывания
            if pf3 > maxPf3
                threshold = value;
                maxPf3 = pf3;
            elseif pf3 == maxPf3
                threshold = threshold + 0.5/1000*(stop-start);
            end
        end
        mdl.mu = mu;
        mdl.sigma = sigma;
        mdl.threshold = threshold;
    end
else
    error('Неверное количество праметров')
end

return
