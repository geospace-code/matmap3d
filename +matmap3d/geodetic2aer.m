function [az, el, slantRange] = geodetic2aer(lat, lon, alt, lat0, lon0, alt0, spheroid, angleUnit)
%% geodetic2aer
% from an observer's perspective, convert target coordinates to azimuth, elevation, slant range.
%
%%% Inputs
% * lat,lon, alt:  ellipsoid geodetic coordinates of point under test (degrees, degrees, meters)
% * lat0, lon0, alt0: ellipsoid geodetic coordinates of observer/reference (degrees, degrees, meters)
% * spheroid: referenceEllipsoid
% * angleUnit: string for angular units. Default 'd': degrees, otherwise Radians
%
%%% Outputs
% * az, el, slantrange: look angles and distance to point under test (degrees, degrees, meters)
% * az: azimuth clockwise from local north
% * el: elevation angle above local horizon
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

[e, n, u] = matmap3d.geodetic2enu(lat, lon, alt, lat0, lon0, alt0, spheroid, angleUnit);
[az, el, slantRange] = matmap3d.enu2aer(e, n, u, angleUnit);

end
