function [lat,lon,alt] = ecef2geodetic(spheroid, x, y, z, angleUnit)
%% ecef2geodetic
% convert ECEF to geodetic coordinates
%
%%% Inputs
% * x,y,z:  ECEF coordinates of test point(s) (meters)
% * spheroid: referenceEllipsoid
% * angleUnit: string for angular units. Default 'd': degrees
%
%%% Outputs
% * lat,lon, alt:  ellipsoid geodetic coordinates of point(s) (degrees, degrees, meters)
%
% based on:
% You, Rey-Jer. (2000). Transformation of Cartesian to Geodetic Coordinates without Iterations.
% Journal of Surveying Engineering. doi: 10.1061/(ASCE)0733-9453
arguments
  spheroid {mustBeScalarOrEmpty}
  x {mustBeReal}
  y {mustBeReal}
  z {mustBeReal}
  angleUnit (1,1) string = "d"
end

if isempty(spheroid)
  spheroid = matmap3d.wgs84Ellipsoid();
end

a = spheroid.SemimajorAxis;
b = spheroid.SemiminorAxis;

r = sqrt(x.^2 + y.^2 + z.^2);

E = sqrt(a.^2 - b.^2);

% eqn. 4a
u = sqrt(0.5 * (r.^2 - E.^2) + 0.5 * sqrt((r.^2 - E.^2).^2 + 4 * E.^2 .* z.^2));

Q = hypot(x, y);

huE = hypot(u, E);

% eqn. 4b
Beta = atan(huE ./ u .* z ./ hypot(x, y));

% eqn. 13
eps = ((b * u - a * huE + E.^2) .* sin(Beta)) ./ (a * huE ./ cos(Beta) - E.^2 .* cos(Beta));

Beta = Beta + eps;
% final output
lat = atan(a / b * tan(Beta));

lon = atan2(y, x);

% eqn. 7
alt = hypot(z - b * sin(Beta), Q - a * cos(Beta));

% inside ellipsoid?
inside = (x.^2 ./ a.^2) + (y.^2 ./ a.^2) + (z.^2 ./ b.^2) < 1;
alt(inside) = -alt(inside);


if startsWith(angleUnit, 'd')
  lat = rad2deg(lat);
  lon = rad2deg(lon);
end

end
