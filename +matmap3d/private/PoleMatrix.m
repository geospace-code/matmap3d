%% POLEMATRIX Transformation from pseudo Earth-fixed to Earth-fixed coordinates for a given date
%
% Input:
%   Pole coordinte(xp,yp)
%
% Output:
%   PoleMat   Pole matrix
%
% Last modified:   2018/01/27   Meysam Mahooti
%
% Meysam Mahooti (2025).
% ECI2ECEF & ECEF2ECI Transformations
% https://www.mathworks.com/matlabcentral/fileexchange/61957-eci2ecef-ecef2eci-transformations)
% MATLAB Central File Exchange.

function PoleMat =  PoleMatrix(xp,yp)

PoleMat = R_y(-xp) * R_x(-yp);

end
