%% ECEF2NED Convert ECEF coordinates to NED
%
%%% Inputs
% * x,y,z: Earth Centered Earth Fixed (ECEF) coordinates of test point (meters)
% * lat0, lon0, alt0: ellipsoid geodetic coordinates of observer/reference (degrees, degrees, meters)
% * spheroid: referenceEllipsoid
% * angleUnit: string for angular units. Default 'd': degrees
%
%%% outputs
% * North,East,Down: coordinates of points (meters)
function [north, east, down] = ecef2ned(x, y, z, lat0, lon0, alt0, spheroid, angleUnit)
arguments
  x {mustBeReal}
  y {mustBeReal}
  z {mustBeReal}
  lat0 {mustBeReal}
  lon0 {mustBeReal}
  alt0 {mustBeReal}
  spheroid (1,1) matmap3d.referenceEllipsoid = matmap3d.wgs84Ellipsoid()
  angleUnit (1,1) string = "d"
end

[east, north, up] = matmap3d.ecef2enu(x,y,z,lat0,lon0,alt0,spheroid,angleUnit);

down = -up;

end
