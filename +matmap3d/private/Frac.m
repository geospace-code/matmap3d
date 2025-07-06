%% FRAC Fractional part of a number (y=x-[x])
%
% Last modified:   2018/01/27   Meysam Mahooti
%
% Meysam Mahooti (2025).
% ECI2ECEF & ECEF2ECI Transformations
% https://www.mathworks.com/matlabcentral/fileexchange/61957-eci2ecef-ecef2eci-transformations)
% MATLAB Central File Exchange.

function [res] = Frac(x)

res = x-floor(x);

end
