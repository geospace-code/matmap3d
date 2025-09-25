%% ECEF2AER convert ECEF of target to azimuth, elevation, slant range from observer
%
%%% Inputs
% * x,y,z: Earth Centered Earth Fixed (ECEF) coordinates of test point (meters)
% * lat0, lon0, alt0: ellipsoid geodetic coordinates of observer/reference (degrees, degrees, meters)
% * spheroid: referenceEllipsoid
% * angleUnit: string for angular units. Default 'd': degrees
%
%%% Outputs
% * az, el, slantrange: look angles and distance to point under test (degrees, degrees, meters)
% * az: azimuth clockwise from local north
% * el: elevation angle above local horizon
function [az, el, slantRange] = ecef2aer(x, y, z, lat0, lon0, alt0, spheroid, angleUnit)
if nargin < 7 || isempty(spheroid)
  spheroid = matmap3d.wgs84Ellipsoid();
end
if nargin < 8
  angleUnit = 'd';
end

[e, n, u] = matmap3d.ecef2enu(x, y, z, lat0, lon0, alt0, spheroid, angleUnit);
[az,el,slantRange] = matmap3d.enu2aer(e, n, u, angleUnit);

end
