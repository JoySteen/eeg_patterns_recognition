function runexp(fileName,port,subject,movieName)

if nargin && ( exist(fileName,'file') || exist([fileName,'.mat'],'file') )
    error('���� ��� ����������')
end

s = load(movieName);
s.subject = subject;
s.today = date();
save(fileName,'-struct','s')
fprintf('�������� %s\n',fileName)

nimovie(port,movieName)

return
