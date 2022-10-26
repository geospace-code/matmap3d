function [az, el, rng] = eci2aer(utc, x0, y0, z0, lat, lon, alt)
%% eci2aer(utc, x0, y0, z0, lat, lon, alt)
% convert ECI to AER (azimuth, elevation, slant range)
%
% parameters:
% utc: datetime UTC
% x0, y0, z0:  ECI x, y, z
% lat, lon, alt: latitude, longitude, altiude of observer (degrees, meters)
%
% outputs:
% az,el,rng: Azimuth (degrees), Elevation (degrees), Slant Range (meters)
arguments
  utc datetime
  x0 {mustBeReal}
  y0 {mustBeReal}
  z0 {mustBeReal}
  lat {mustBeReal}
  lon {mustBeReal}
  alt {mustBeReal}
end

[x, y, z] = matmap3d.eci2ecef(utc, x0, y0, z0);

[az, el, rng] = matmap3d.ecef2aer(x, y, z, lat, lon, alt);

end
