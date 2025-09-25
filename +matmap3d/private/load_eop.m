%% LOAD_EOP: Reads Earth Orientation Parameters (EOP) from a file.

function eopdata = load_eop(filename)
arguments
  filename {mustBeFile} = fullfile(fileparts(mfilename('fullpath')), 'EOP-All.txt')
end

fid = fopen(filename, 'r');
%  ----------------------------------------------------------------------------------------------------
% |  Date    MJD      x         y       UT1-UTC      LOD       dPsi    dEpsilon     dX        dY    DAT
% |(0h UTC)           "         "          s          s          "        "          "         "     s
%  ----------------------------------------------------------------------------------------------------
while ~feof(fid)
    tline = fgetl(fid);
    k = strfind(tline,'NUM_OBSERVED_POINTS');
    if (k ~= 0)
        numrecsobs = str2num(tline(21:end)); %#ok<ST2NM>

        fgetl(fid);
        for i=1:numrecsobs
            eopdata(:,i) = fscanf(fid,'%i %d %d %i %f %f %f %f %f %f %f %f %i',[13 1]); %#ok<AGROW>
        end
        for i=1:4
            tline = fgetl(fid);
        end
        numrecspred = str2num(tline(22:end)); %#ok<ST2NM>

        fgetl(fid);

        for i=numrecsobs+1:numrecsobs+numrecspred
            eopdata(:,i) = fscanf(fid,'%i %d %d %i %f %f %f %f %f %f %f %f %i',[13 1]);
        end
        break
    end
end

fclose(fid);

end
