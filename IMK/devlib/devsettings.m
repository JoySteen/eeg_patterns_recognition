function [params,devgenerate,devrun,devpatterns,devshow] = devsettings(type,version)
switch type
    case 'cvep'
        devgenerate = @cvepgenerate;
        devrun = @cveprun;
        devpatterns = @cveppatterns;
        devshow = @cvepshow;
        params = cvepsettings(version);
    case 'p300'
        devgenerate = @p300generate;
        devrun = @p300run;
        devpatterns = @p300patterns;
        devshow = @p300show;
        params = p300settings(version);
end
return
