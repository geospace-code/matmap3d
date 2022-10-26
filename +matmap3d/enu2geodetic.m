function [lat, lon, alt] = enu2geodetic(east, north, up, lat0, lon0, alt0, spheroid, angleUnit)
%% enu2geodetic   convert from ENU to geodetic coordinates
%
%%% Inputs
% * east,north,up:  ENU coordinates of point(s) (meters)
% * lat0, lon0, alt0: ellipsoid geodetic coordinates of observer/reference (degrees, degrees, meters)
% * spheroid: referenceEllipsoid
% * angleUnit: string for angular units. Default 'd': degrees, otherwise Radians
%
%%% outputs
% * lat,lon,alt: geodetic coordinates of test points (degrees,degrees,meters)
arguments
  east {mustBeReal}
  north {mustBeReal}
  up {mustBeReal}
  lat0 {mustBeReal}
  lon0 {mustBeReal}
  alt0 {mustBeReal}
  spheroid (1,1) matmap3d.referenceEllipsoid = matmap3d.wgs84Ellipsoid()
  angleUnit (1,1) string = "d"
end

[x, y, z] = matmap3d.enu2ecef(east, north, up, lat0, lon0, alt0, spheroid, angleUnit);
[lat, lon, alt] = matmap3d.ecef2geodetic(spheroid, x, y, z,  angleUnit);

end
