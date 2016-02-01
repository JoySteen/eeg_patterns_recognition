% Классификатор Фишера
classdef Fisher<handle
    properties
        X
        XX
        count
        weights
        threshold
    end
    methods
        function self = Fisher(len)
            self.count = zeros(2,1,'single');
            if nargin
                self.weights = zeros(1,len,'single');
                self.threshold = single(0);
            end
        end
        % суммирование данных; может вызываться множество раз
        function collect(self,features,groups)
            len = size(features,1);
            if isempty(self.count) || all(self.count==0)
                self.X = zeros(len,2,'single');
                self.XX = zeros(len,len,2,'single');
                self.count = zeros(2,1,'single');
            end
            for n = 1:length(groups)
                flag = 1+groups(n);
                self.count(flag) = self.count(flag) + 1;
                for k = 1:len
                    self.X(k,flag) = self.X(k,flag) + features(k,n);
                    for l = 1:len
                        self.XX(k,l,flag) = self.XX(k,l,flag) + features(k,n)*features(l,n);
                    end
                end
            end
        end
        function compute(self,nAverages,nGroups)
            self.computeweights();
            self.computethreshold(nAverages,nGroups);
        end
        function computeweights(self)
            if isempty(self.X)
                error('X is undefined');
            end
            % вычисление среднего вектора и матрицы ковариации
            len = size(self.X,1);
            mu = zeros(len,1,'single');
            Z = zeros(len,len,'single');
            for k = 1:len
                mu(k) = self.X(k,2)/self.count(2) - self.X(k,1)/self.count(1);
                for n = 1:2
                    for l = 1:len
                        Z(k,l) = Z(k,l) + ( self.XX(k,l,n) - self.X(k,n)*self.X(l,n)/self.count(n) )/(self.count(n)-1);
                    end
                end
            end
            % self.weights = mu'*pinv(Z);
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
            self.weights = mu'/Z;
            self.threshold = single(0);
        end
        % Находит оптимальный порог для детектирования.
        function computethreshold(self,nAverages,nGroups)
            % вычисление средних mu и стандартных отклонений sigma
            mu = zeros(2,1,'single');
            sigma = zeros(2,1,'single');
            len = size(self.X,1);
            for n = 1:2
                for k = 1:len
                    mu(n) = mu(n) + self.X(k,n)/self.count(n)*self.weights(k);
                    for l = 1:len
                        z = ( self.XX(k,l,n) - self.X(k,n)*self.X(l,n)/self.count(n) )/(self.count(n)-1);
                        sigma(n) = sigma(n) + z*self.weights(k)*self.weights(l);
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
            % поиск максимума вероятности правильного срабатывания
            start = mu(1)-3*sigma(1);
            stop = mu(2)+3*sigma(2);
            self.threshold = single(0);
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
                    self.threshold = value;
                    maxPf3 = pf3;
                elseif pf3 == maxPf3
                    self.threshold = self.threshold + 0.5/1000*(stop-start);
                end
            end
            % values = start + (0:1000)/1000*(stop-start);
            % p0 = 1-normcdf(values,mu(1),sigma(1)); % вероятность срабатывания нецелевого стимула
            % p1 = 1-normcdf(values,mu(2),sigma(2)); % вероятность срабатывания целевого стимула
            % pt = p1.*(1-p0).^(nGroups-1); % вероятность правильного срабатывания
            % pf = (nGroups-1)*(1-p1).*p0.*(1-p0).^(nGroups-2); % вероятность ложного срабатывания
            % hold on
            % plot(values,p0,'b')
            % plot(values,p1,'g')
            % plot(values,pt,'r')
            % plot(values,pf,'m')
        end
        function results = classify(self,features)
            results = self.weights*features > self.threshold;
        end
    end
end
