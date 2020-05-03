function [az, el, rng] = eci2aer(utc, x_eci, y_eci, z_eci, lat, lon, alt)
% convert ECI to AER (azimuth, elevation, slant range)
%
% parameters:
% utc: datetime UTC
% x_eci, y_eci, z_eci:  ECI x, y, z
% lat, lon, alt: latitude, longitude, altiude of observer (degrees, meters)
%
% outputs:
% az,el,rng: aer

narginchk(7,7)

[x, y, z] = eci2ecef(utc, x_eci, y_eci, z_eci);

[az, el, rng] = ecef2aer(x, y, z, lat, lon, alt);

end
