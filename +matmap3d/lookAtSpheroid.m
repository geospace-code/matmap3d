
function [lat, lon, d] = lookAtSpheroid(lat0, lon0, h0, az, tilt, spheroid, angleUnit)
%% LOOKATSPHEROID
% Calculates line-of-sight intersection with Earth (or other ellipsoid) surface from above surface ./ orbit
%
%%% Inputs
% * lat0, lon0: latitude and longitude of starting point
% * h0: altitude of starting point in meters
% * az: azimuth angle of line-of-sight, clockwise from North
% * tilt: tilt angle of line-of-sight with respect to local vertical (nadir = 0)
%
%%% Outputs
% * lat, lon: latitude and longitude where the line-of-sight intersects with the Earth ellipsoid
% * d: slant range in meters from the starting point to the intersect point
%
% Values will be NaN if the line of sight does not intersect.
%
% Algorithm based on:
% https://medium.com/@stephenhartzell/satellite-line-of-sight-intersection-with-earth-d786b4a6a9b6
% Stephen Hartzell
arguments
  lat0 {mustBeReal}
  lon0 {mustBeReal}
  h0 {mustBeReal,mustBeNonnegative}
  az {mustBeReal}
  tilt {mustBeReal}
  spheroid (1,1) matmap3d.referenceEllipsoid = matmap3d.wgs84Ellipsoid()
  angleUnit (1,1) string = "d"
end

if startsWith(angleUnit, 'd')
  el = tilt - 90;
else
  el = tilt - pi/2;
end

a = spheroid.SemimajorAxis;
b = a;
c = spheroid.SemiminorAxis;

[e, n, u] = matmap3d.aer2enu(az, el, 1., angleUnit);  % fixed 1 km slant range
[u, v, w] = matmap3d.enu2uvw(e, n, u, lat0, lon0, angleUnit);
[x, y, z] = matmap3d.geodetic2ecef([], lat0, lon0, h0, angleUnit);

value = -a.^2 .* b.^2 .* w .* z - a.^2 .* c.^2 .* v .* y - b.^2 .* c.^2 .* u .* x;
radical = a.^2 .* b.^2 .* w.^2 + a.^2 .* c.^2 .* v.^2 - a.^2 .* v.^2 .* z.^2 + 2 .* a.^2 .* v .* w .* y .* z - ...
           a.^2 .* w.^2 .* y.^2 + b.^2 .* c.^2 .* u.^2 - b.^2 .* u.^2 .* z.^2 + 2 .* b.^2 .* u .* w .* x .* z - ...
           b.^2 .* w.^2 .* x.^2 - c.^2 .* u.^2 .* y.^2 + 2 .* c.^2 .* u .* v .* x .* y - c.^2 .* v.^2 .* x.^2;

magnitude = a.^2 .* b.^2 .* w.^2 + a.^2 .* c.^2 .* v.^2 + b.^2 .* c.^2 .* u.^2;

% Return nan if radical < 0 or d < 0 because LOS vector does not point towards Earth
d = (value - a .* b .* c .* sqrt(radical)) ./ magnitude;
d(radical < 0 | d < 0) = nan; % separate line

% altitude should be zero
[lat, lon] = matmap3d.ecef2geodetic([], x + d .* u, y + d .* v, z + d .* w, angleUnit);

end
