%% AER2ECI convert AER (azimuth, elevation, slant range) to ECI
%
%%% Inputs
% * utc: datetime UTC
% * az,el,rng: (degrees, meters)
% * lat, lon, alt: latitude, longitude, altiude of observer (degrees, meters)
%
%%% Outputs
% * x, y, z:  ECI x, y, z
function [x, y, z] = aer2eci(utc, az, el, rng, lat, lon, alt, spheroid, angleUnit)
arguments
  utc datetime
  az {mustBeReal}
  el {mustBeReal}
  rng {mustBeReal, mustBeNonnegative}
  lat {mustBeReal}
  lon {mustBeReal}
  alt {mustBeReal}
  spheroid (1,1) matmap3d.referenceEllipsoid = matmap3d.wgs84Ellipsoid()
  angleUnit (1,1) string = "d"
end

[x1, y1, z1] = matmap3d.aer2ecef(az, el, rng, lat, lon, alt, spheroid, angleUnit);

x = nan(like=az);
y = nan(like=az);
z = nan(like=az);

for i = 1:numel(x)
  r_eci = matmap3d.ecef2eci(utc, [x1(i); y1(i); z1(i)]);

  x(i) = r_eci(1);
  y(i) = r_eci(2);
  z(i) = r_eci(3);
end

end
