%% GAST Greenwich Apparent Sidereal Time
%
% Inputs:
%   Mjd_UT1   Modified Julian Date UT1
%   Mjd_TT    Modified Julian Date TT
%
% Output:
%   gstime    GAST in [rad]
%
% Last modified:   2022/06/16   Meysam Mahooti
%
% Meysam Mahooti (2025).
% ECI2ECEF & ECEF2ECI Transformations
% https://www.mathworks.com/matlabcentral/fileexchange/61957-eci2ecef-ecef2eci-transformations)
% MATLAB Central File Exchange.

function gstime = gast(Mjd_UT1,Mjd_TT)

gstime = mod(gmst(Mjd_UT1) + EqnEquinox(Mjd_TT), 2*pi);

end
