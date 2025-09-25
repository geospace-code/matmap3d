%% aer2geodetic convert azimuth, elevation, range of target from observer to geodetic coordiantes
%
%%% Inputs
% * az, el, slantrange: look angles and distance to point under test (degrees, degrees, meters)
% * az: azimuth clockwise from local north
% * el: elevation angle above local horizon
% * lat0, lon0, alt0: ellipsoid geodetic coordinates of observer/reference (degrees, degrees, meters)
% * spheroid: referenceEllipsoid
% * angleUnit: string for angular units. Default 'd': degrees
%
%%% Outputs
% * lat1,lon1,alt1: geodetic coordinates of test points (degrees,degrees,meters)
function [lat1, lon1, alt1] = aer2geodetic(az, el, slantRange, lat0, lon0, alt0, spheroid, angleUnit)
if nargin < 7 || isempty(spheroid)
  spheroid = matmap3d.wgs84Ellipsoid();
end
if nargin < 8
  angleUnit = 'd';
end

[x, y, z] = matmap3d.aer2ecef(az, el, slantRange, lat0, lon0, alt0, spheroid, angleUnit);

[lat1, lon1, alt1] = matmap3d.ecef2geodetic(spheroid, x, y, z, angleUnit);

end
