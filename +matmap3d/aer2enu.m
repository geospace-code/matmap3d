%% AER2ENU convert azimuth, elevation, range to ENU coordinates
%
%%% Inputs
% * az, el, slantrange: look angles and distance to point under test (degrees, degrees, meters)
% * az: azimuth clockwise from local north
% * el: elevation angle above local horizon
% * angleUnit: string for angular units. Default 'd': degrees
%
%%% Outputs
% * e,n,u:  East, North, Up coordinates of test points (meters)
function [e, n, u] = aer2enu (az, el, slantRange, angleUnit)
if nargin < 4
  angleUnit = 'd';
end

if strncmp(angleUnit, 'd', 1)
  az = deg2rad(az);
  el = deg2rad(el);
end

u = slantRange .* sin(el);
r = slantRange .* cos(el);
e = r .* sin(az);
n = r .* cos(az);

end
