function [az, el, rng] = eci2aer(utc, x0, y0, z0, lat, lon, alt)
% convert ECI to AER (azimuth, elevation, slant range)
%
% parameters:
% utc: datetime UTC
% x0, y0, z0:  ECI x, y, z
% lat, lon, alt: latitude, longitude, altiude of observer (degrees, meters)
%
% outputs:
% az,el,rng: aer
arguments
  utc datetime
  x0 {mustBeNumeric,mustBeReal}
  y0 {mustBeNumeric,mustBeReal}
  z0 {mustBeNumeric,mustBeReal}
  lat {mustBeNumeric,mustBeReal}
  lon {mustBeNumeric,mustBeReal}
  alt {mustBeNumeric,mustBeReal}
end

[x, y, z] = matmap3d.eci2ecef(utc, x0, y0, z0);

[az, el, rng] = matmap3d.ecef2aer(x, y, z, lat, lon, alt);

end
