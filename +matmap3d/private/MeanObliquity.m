%% MEANOBLIQUITY Computes the mean obliquity of the ecliptic
%
% Input:
%  Mjd_TT    Modified Julian Date (Terrestrial Time)
%
% Output:
%  MOblq     Mean obliquity of the ecliptic
%
% Last modified:   2018/01/27   Meysam Mahooti
%
% Meysam Mahooti (2025).
% ECI2ECEF & ECEF2ECI Transformations
% https://www.mathworks.com/matlabcentral/fileexchange/61957-eci2ecef-ecef2eci-transformations)
% MATLAB Central File Exchange.

function MOblq = MeanObliquity(Mjd_TT)

T = (Mjd_TT - 51544.5)/36525;

MOblq = (pi/180)*(23.43929111-(46.8150+(0.00059-0.001813*T)*T)*T/3600);

end
