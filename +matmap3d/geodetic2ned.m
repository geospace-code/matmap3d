%% GEODETIC2NED   convert from geodetic to NED coordinates
%
%%% Inputs
% * lat,lon, alt:  ellipsoid geodetic coordinates of point under test (degrees, degrees, meters)
% * lat0, lon0, alt0: ellipsoid geodetic coordinates of observer/reference (degrees, degrees, meters)
% * spheroid: referenceEllipsoid
% * angleUnit: string for angular units. Default 'd': degrees
%% outputs
% * n,e,d: North, East, Down coordinates of test points (meters)

function [north, east, down] = geodetic2ned(lat, lon, alt, lat0, lon0, alt0, spheroid, angleUnit)
if nargin < 7 || isempty(spheroid)
  spheroid = matmap3d.wgs84Ellipsoid();
end
if nargin < 8 || isempty(angleUnit)
  angleUnit = 'd';
end

[east, north, up] = matmap3d.geodetic2enu(lat, lon, alt, lat0, lon0, alt0, spheroid, angleUnit);

down = -up;

end
