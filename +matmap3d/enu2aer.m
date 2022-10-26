function [az, elev, slantRange] = enu2aer(east, north, up, angleUnit)
%% enu2aer
% convert ENU to azimuth, elevation, slant range
%
%%% Inputs
% * e,n,u:  East, North, Up coordinates of test points (meters)
% * angleUnit: string for angular units. Default 'd': degrees
%
%%% outputs
% * az, el, slantrange: look angles and distance to point under test (degrees, degrees, meters)
% * az: azimuth clockwise from local north
% * el: elevation angle above local horizon
arguments
  east {mustBeReal}
  north {mustBeReal}
  up {mustBeReal}
  angleUnit (1,1) string = "d"
end

if abs(east) < 1e-3, east = 0.; end  % singularity, 1 mm precision
if abs(north) < 1e-3, north = 0.; end  % singularity, 1 mm precision
if abs(up) < 1e-3, up = 0.; end  % singularity, 1 mm precision

r = hypot(east, north);
slantRange = hypot(r,up);
% radians
elev = atan2(up,r);
az = mod(atan2(east, north), 2*pi);

if startsWith(angleUnit,'d')
  elev = rad2deg(elev);
  az = rad2deg(az);
end

end
