%% GMST Greenwich Mean Sidereal Time
%
% Input:
%  Mjd_UT1    Modified Julian Date UT1
%
% Output:
%  gmstime	   GMST in [rad]
%
% Last modified:   2018/01/27   Meysam Mahooti
%
% Meysam Mahooti (2025).
% ECI2ECEF & ECEF2ECI Transformations
% https://www.mathworks.com/matlabcentral/fileexchange/61957-eci2ecef-ecef2eci-transformations)
% MATLAB Central File Exchange.

function gmstime = gmst(Mjd_UT1)

Mjd_0 = floor(Mjd_UT1);
UT1   = 86400*(Mjd_UT1-Mjd_0);       % [s]
T_0   = (Mjd_0  - 51544.5)/36525;
T     = (Mjd_UT1- 51544.5)/36525;

gmst  = 24110.54841 + 8640184.812866*T_0 + 1.002737909350795*UT1...
        + (0.093104-6.2e-6*T)*T*T;  % [s]

gmstime = 2*pi*Frac(gmst/86400);     % [rad], 0..2pi

end
