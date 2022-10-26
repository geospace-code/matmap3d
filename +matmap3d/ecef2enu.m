function [east, north, up] = ecef2enu(x, y, z, lat0, lon0, alt0, spheroid, angleUnit)
%% ecef2ned(x, y, z, lat0, lon0, alt0, spheroid, angleUnit)
% convert ECEF to NED
%
%%% Inputs
% * x,y,z: Earth Centered Earth Fixed (ECEF) coordinates of test point (meters)
% * lat0, lon0, alt0: ellipsoid geodetic coordinates of observer/reference (degrees, degrees, meters)
% * spheroid: referenceEllipsoid
% * angleUnit: string for angular units. Default 'd': degrees
%
%%% outputs
% * East, North, Up coordinates of test points (meters)
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

[x0, y0, z0] = matmap3d.geodetic2ecef(spheroid, lat0, lon0, alt0, angleUnit);
[east, north, up] = matmap3d.ecef2enuv(x - x0, y - y0, z - z0, lat0, lon0, angleUnit);

end
