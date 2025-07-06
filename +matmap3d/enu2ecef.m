%% ENU2ECEF convert from ENU to ECEF coordiantes
%
%%% Inputs
% * east, north, up: coordinates of test points (meters)
% * lat0, lon0, alt0: ellipsoid geodetic coordinates of observer/reference (degrees, degrees, meters)
% * spheroid: referenceEllipsoid
% * angleUnit: string for angular units. Default 'd': degrees
%
%%% outputs
% * x,y,z: Earth Centered Earth Fixed (ECEF) coordinates of test point (meters)
function [x, y, z] = enu2ecef(east, north, up, lat0, lon0, alt0, spheroid, angleUnit)
arguments
  east {mustBeReal}
  north {mustBeReal}
  up {mustBeReal}
  lat0 {mustBeReal}
  lon0 {mustBeReal}
  alt0 {mustBeReal}
  spheroid (1,1) matmap3d.referenceEllipsoid = matmap3d.wgs84Ellipsoid()
  angleUnit {mustBeTextScalar} = 'd'
end

[x0, y0, z0] = matmap3d.geodetic2ecef(spheroid, lat0, lon0, alt0, angleUnit);
[dx, dy, dz] = matmap3d.enu2uvw(east, north, up, lat0, lon0, angleUnit);

x = x0 + dx;
y = y0 + dy;
z = z0 + dz;
end
