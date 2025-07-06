%% EQNEQUINOX Computation of the equation of the equinoxes
%
% Input:
%   Mjd_TT    Modified Julian Date (Terrestrial Time)
%
% Output:
%    EqE      Equation of the equinoxes
%
% Notes:
%   The equation of the equinoxes dpsi*cos(eps) is the right ascension of
%   the mean equinox referred to the true equator and equinox and is equal
%   to the difference between apparent and mean sidereal time.
%
% Last modified:   2018/01/27   Meysam Mahooti
%
% Meysam Mahooti (2025).
% ECI2ECEF & ECEF2ECI Transformations
% https://www.mathworks.com/matlabcentral/fileexchange/61957-eci2ecef-ecef2eci-transformations)
% MATLAB Central File Exchange.

function EqE = EqnEquinox (Mjd_TT)

% Nutation in longitude and obliquity
dpsi = NutAngles (Mjd_TT);

% Equation of the equinoxes
EqE = dpsi * cos(MeanObliquity(Mjd_TT));

end
