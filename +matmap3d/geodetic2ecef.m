function [x,y,z] = geodetic2ecef(spheroid, lat, lon, alt, angleUnit)
%% geodetic2ecef
% convert from geodetic to ECEF coordiantes
%
%%% Inputs
% * lat,lon, alt:  ellipsoid geodetic coordinates of point(s) (degrees, degrees, meters)
% * spheroid: referenceEllipsoid
% * angleUnit: string for angular units. Default 'd': degrees
%
%%% outputs
% * x,y,z:  ECEF coordinates of test point(s) (meters)
arguments
  spheroid
  lat {mustBeReal}
  lon {mustBeReal}
  alt {mustBeReal}
  angleUnit (1,1) string = "d"
end

%% defaults
if isempty(spheroid)
  spheroid = matmap3d.wgs84Ellipsoid();
end

if startsWith(angleUnit, 'd')
  lat = deg2rad(lat);
  lon = deg2rad(lon);
end

% Radius of curvature of the prime vertical section
N = matmap3d.get_radius_normal(lat, spheroid);
% Compute cartesian (geocentric) coordinates given  (curvilinear) geodetic coordinates.

x = (N + alt) .* cos(lat) .* cos(lon);
y = (N + alt) .* cos(lat) .* sin(lon);
z = (N .* (spheroid.SemiminorAxis / spheroid.SemimajorAxis)^2 + alt) .* sin(lat);

end
