%% PRECMATRIX Precession transformation of equatorial coordinates
%
% Inputs:
%   Mjd_1     Epoch given (Modified Julian Date TT)
%   MjD_2     Epoch to precess to (Modified Julian Date TT)
%
% Output:
%   PrecMat   Precession transformation matrix
%
% Last modified:   2018/01/27   Meysam Mahooti
%
% Meysam Mahooti (2025).
% ECI2ECEF & ECEF2ECI Transformations
% https://www.mathworks.com/matlabcentral/fileexchange/61957-eci2ecef-ecef2eci-transformations)
% MATLAB Central File Exchange.

function PrecMat = PrecMatrix(Mjd_1, Mjd_2)

T  = (Mjd_1-51544.5)/36525;
dT = (Mjd_2-Mjd_1)/36525;

Arcs = 3600*180/pi;

% Precession angles
zeta  =  ( (2306.2181+(1.39656-0.000139*T)*T)+ ...
           ((0.30188-0.000344*T)+0.017998*dT)*dT )*dT/Arcs;
z     =  zeta + ( (0.79280+0.000411*T)+0.000205*dT)*dT*dT/Arcs;
theta =  ( (2004.3109-(0.85330+0.000217*T)*T)- ...
           ((0.42665+0.000217*T)+0.041833*dT)*dT )*dT/Arcs;

% Precession matrix
PrecMat = R_z(-z) * R_y(theta) * R_z(-zeta);

end
