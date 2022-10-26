function [north, east, down] = geodetic2ned(lat, lon, alt, lat0, lon0, alt0, spheroid, angleUnit)
%% geodetic2ned    convert from geodetic to NED coordinates
%
%%% Inputs
% * lat,lon, alt:  ellipsoid geodetic coordinates of point under test (degrees, degrees, meters)
% * lat0, lon0, alt0: ellipsoid geodetic coordinates of observer/reference (degrees, degrees, meters)
% * spheroid: referenceEllipsoid
% * angleUnit: string for angular units. Default 'd': degrees
%
%%% outputs
% * e,n,u:  East, North, Up coordinates of test points (meters)
arguments
  lat {mustBeReal}
  lon {mustBeReal}
  alt {mustBeReal}
  lat0 {mustBeReal}
  lon0 {mustBeReal}
  alt0 {mustBeReal}
  spheroid (1,1) matmap3d.referenceEllipsoid = matmap3d.wgs84Ellipsoid()
  angleUnit (1,1) string = "d"
end

[x1,y1,z1] = matmap3d.geodetic2ecef(spheroid, lat,lon,alt,angleUnit);
[x2,y2,z2] = matmap3d.geodetic2ecef(spheroid, lat0,lon0,alt0,angleUnit);

dx = x1-x2;
dy = y1-y2;
dz = z1-z2;

[east, north, up] = matmap3d.ecef2enuv(dx, dy, dz, lat0, lon0, angleUnit);

down = -up;

end
