%% MJDAY Modified Julian Date from calendar date and time
%
% Inputs:
%   Year      Calendar date components
%   Month
%   Day
%   Hour      Time components
%   Min
%   Sec
% Output:
%   Modified Julian Date
%
% Last modified:   2022/09/24   Meysam Mahooti
%
% Reference:
% Montenbruck O., Gill E.; Satellite Orbits: Models, Methods and
% Applications; Springer Verlag, Heidelberg; Corrected 3rd Printing (2005).
%
% Meysam Mahooti (2025).
% ECI2ECEF & ECEF2ECI Transformations
% https://www.mathworks.com/matlabcentral/fileexchange/61957-eci2ecef-ecef2eci-transformations)
% MATLAB Central File Exchange.

function Mjd = Mjday(utc)
arguments
  utc (1,1) datetime
end

Month = utc.Month;
Year = utc.Year;

if (Month<=2)
    Month = Month+12;
    Year  = Year-1;
end

if ( (10000*Year + 100*Month + utc.Day) <= 15821004 )
    b = (-2 + fix((Year+4716)/4) - 1179);        % Julian calendar
else
    b = fix(Year/400)-fix(Year/100)+fix(Year/4); % Gregorian calendar
end

MjdMidnight = 365*Year - 679004 + b + fix(30.6001*(Month+1)) + utc.Day;
FracOfDay   = (utc.Hour + utc.Minute/60+ utc.Second/3600)/24;

Mjd = MjdMidnight + FracOfDay;


end
