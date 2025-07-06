%% GHAMATRIX Transformation from true equator and equinox to Earth equator and Greenwich meridian system
%
% Inputs:
%   Mjd_UT1   Modified Julian Date UT1
%   Mjd_TT    Modified Julian Date TT
%
% Output:
%   GHAmat    Greenwich Hour Angle matrix
%
% Last modified:   2022/06/16   Meysam Mahooti
%
% Meysam Mahooti (2025).
% ECI2ECEF & ECEF2ECI Transformations
% https://www.mathworks.com/matlabcentral/fileexchange/61957-eci2ecef-ecef2eci-transformations)
% MATLAB Central File Exchange.

function GHAmat = GHAMatrix(Mjd_UT1,Mjd_TT)

GHAmat = R_z(gast(Mjd_UT1,Mjd_TT));

end
