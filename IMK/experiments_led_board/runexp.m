function runexp(fileName,port,subject,movieName)

if nargin && ( exist(fileName,'file') || exist([fileName,'.mat'],'file') )
    error('Файл уже существует')
end

s = load(movieName);
s.subject = subject;
s.today = date();
save(fileName,'-struct','s')
fprintf('Сохранен %s\n',fileName)

nimovie(port,movieName)

return
