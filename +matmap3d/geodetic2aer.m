
%% GEODETIC2AER converts geodetic coordinates to azimuth, elevation, slant range
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
function [az, el, slantRange] = geodetic2aer(lat, lon, alt, lat0, lon0, alt0, spheroid, angleUnit)
if nargin < 7 || isempty(spheroid)
  spheroid = matmap3d.wgs84Ellipsoid();
end
if nargin < 8
  angleUnit = 'd';
end

[e, n, u] = matmap3d.geodetic2enu(lat, lon, alt, lat0, lon0, alt0, spheroid, angleUnit);
[az, el, slantRange] = matmap3d.enu2aer(e, n, u, angleUnit);

end
