
%% ECEF2ENU convert ECEF to ENU
%
%%% Inputs
% * x,y,z: Earth Centered Earth Fixed (ECEF) coordinates of test point (meters)
% * lat0, lon0, alt0: ellipsoid geodetic coordinates of observer/reference (degrees, degrees, meters)
% * spheroid: referenceEllipsoid
% * angleUnit: string for angular units. Default 'd': degrees
%
%%% outputs
% * East, North, Up coordinates of test points (meters)

function [east, north, up] = ecef2enu(x, y, z, lat0, lon0, alt0, spheroid, angleUnit)
if nargin < 7 || isempty(spheroid)
  spheroid = matmap3d.wgs84Ellipsoid();
end
if nargin < 8
  angleUnit = 'd';
end

[x0, y0, z0] = matmap3d.geodetic2ecef(spheroid, lat0, lon0, alt0, angleUnit);
[east, north, up] = matmap3d.ecef2enuv(x - x0, y - y0, z - z0, lat0, lon0, angleUnit);

end
