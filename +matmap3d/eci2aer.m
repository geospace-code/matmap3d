%% ECI2AER convert ECI to AER (azimuth, elevation, slant range)
%
% parameters:
% utc: datetime UTC
% x0, y0, z0:  ECI x, y, z
% lat, lon, alt: latitude, longitude, altiude of observer (degrees, meters)
%
% outputs:
% az,el,rng: Azimuth (degrees), Elevation (degrees), Slant Range (meters)
function [az, el, rng] = eci2aer(utc, x0, y0, z0, lat, lon, alt)
arguments
  utc datetime
  x0 {mustBeReal}
  y0 {mustBeReal}
  z0 {mustBeReal}
  lat {mustBeReal}
  lon {mustBeReal}
  alt {mustBeReal}
end

az = nan(like=x0);
el = nan(like=x0);
rng = nan(like=x0);

for i = 1:numel(x0)
    r_ecef = matmap3d.eci2ecef(utc, [x0(i); y0(i); z0(i)]);

    [az(i), el(i), rng(i)] = matmap3d.ecef2aer(r_ecef(1), r_ecef(2), r_ecef(3), lat, lon, alt);
end

end
