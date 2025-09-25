%% ENU2GEODETIC convert from ENU to geodetic coordinates
%
%%% Inputs
% * east,north,up:  ENU coordinates of point(s) (meters)
% * lat0, lon0, alt0: ellipsoid geodetic coordinates of observer/reference (degrees, degrees, meters)
% * spheroid: referenceEllipsoid
% * angleUnit: string for angular units. Default 'd': degrees, otherwise Radians
%
%%% outputs
% * lat,lon,alt: geodetic coordinates of test points (degrees,degrees,meters)

function [lat, lon, alt] = enu2geodetic(east, north, up, lat0, lon0, alt0, spheroid, angleUnit)
if nargin < 7 || isempty(spheroid)
  spheroid = matmap3d.referenceEllipsoid();
end
if nargin < 8
  angleUnit = 'd';
end

[x, y, z] = matmap3d.enu2ecef(east, north, up, lat0, lon0, alt0, spheroid, angleUnit);
[lat, lon, alt] = matmap3d.ecef2geodetic(spheroid, x, y, z,  angleUnit);

end
