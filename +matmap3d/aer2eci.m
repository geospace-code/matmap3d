function [x, y, z] = aer2eci(utc, az, el, rng, lat, lon, alt)
% convert AER (azimuth, elevation, slant range) to ECI
% NOTE: because underlying ecef2eci() is rotation only, error can be order
% 1..10%
%
% parameters:
% utc: datetime UTC
% az,el,rng: (degrees, meters)
% lat, lon, alt: latitude, longitude, altiude of observer (degrees, meters)
%
% outputs:
% x, y, z:  ECI x, y, z

narginchk(7,7)

[x1, y1, z1] = matmap3d.aer2ecef(az, el, rng, lat, lon, alt);

[x, y, z] = matmap3d.ecef2eci(utc, x1, y1, z1);

end
