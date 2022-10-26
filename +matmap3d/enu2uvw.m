
function [u,v,w] = enu2uvw(east,north,up,lat0,lon0,angleUnit)
%% enu2uvw   convert from ENU to UVW coordinates
%
%%% Inputs
% * e,n,up:  East, North, Up coordinates of point(s) (meters)
% * lat0,lon0: geodetic coordinates of observer/reference point (degrees)
% * angleUnit: string for angular units. Default 'd': degrees
%
%%% outputs
% * u,v,w:   coordinates of test point(s) (meters)
arguments
  east {mustBeReal}
  north {mustBeReal}
  up {mustBeReal}
  lat0 {mustBeReal}
  lon0 {mustBeReal}
  angleUnit (1,1) string = "d"
end

if startsWith(angleUnit, 'd')
  lat0 = deg2rad(lat0);
  lon0 = deg2rad(lon0);
end

t = cos(lat0) * up - sin(lat0) * north;
w = sin(lat0) * up + cos(lat0) * north;

u = cos(lon0) * t - sin(lon0) * east;
v = sin(lon0) * t + cos(lon0) * east;

end
