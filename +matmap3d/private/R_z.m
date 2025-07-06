% R_Z rotation matrix around z-axis
%  Input:
%    angle       angle of rotation [rad]
%
%  Output:
%    rotmat      rotation matrix
%
% Last modified:   2018/01/27   Meysam Mahooti
%
% Meysam Mahooti (2025).
% ECI2ECEF & ECEF2ECI Transformations
% https://www.mathworks.com/matlabcentral/fileexchange/61957-eci2ecef-ecef2eci-transformations)
% MATLAB Central File Exchange.

function [rotmat] = R_z(angle)

C = cos(angle);
S = sin(angle);
rotmat = [ C,  S, 0.0;
      -S,  C, 0.0;
      0.0, 0.0, 1.0 ];

end
