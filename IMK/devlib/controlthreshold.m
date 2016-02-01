% диалог для измерения порога в процессе работы
% controlthreshold(value[,mu]) создает диалог
% [value,type] = controlthreshold опрашивает текущее значение value и type
function [value,type] = controlthreshold(value,mu)
global threshold thresholdType
persistent thresholdHandler
if isempty(thresholdHandler) || ~ishandle(thresholdHandler)
    figure;
    thresholdHandler = uicontrol('Style','edit','Callback',@thresholdcallback,'String',threshold);
    uicontrol('Style','checkbox','Position',[80,20,60,20],'Callback',@checkboxcallback);
    thresholdType = 0;
end
if nargin
    threshold = value;
    set(thresholdHandler,'String',threshold);
end
if nargin >= 2
    uicontrol('Style','text','String',mu(2),'Position',[20,40,60,20]);
    uicontrol('Style','text','String',mu(1),'Position',[20,60,60,20]);
end
if nargout
    value = threshold;
    type = thresholdType;
end
return

function thresholdcallback(h,varargin)
global threshold
threshold = str2double(get(h,'String'));
return

function checkboxcallback(h,varargin)
global thresholdType
thresholdType = get(h,'Value');
return
