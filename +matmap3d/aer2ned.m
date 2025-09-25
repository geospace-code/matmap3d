%% AER2NED convert azimuth, elevation, range to NED coordinates
%
%%% Inputs
% * az, el, slantrange: look angles and distance to point under test (degrees, degrees, meters)
% * az: azimuth clockwise from local north
% * el: elevation angle above local horizon
% * angleUnit: string for angular units. Default 'd': degrees
%
%%% Outputs
% * north, east, down:  coordinates of points (meters)
function [north, east, down] = aer2ned(az, el, slantRange, angleUnit)
if nargin < 4
  angleUnit = 'd';
end

[east, north, up] = matmap3d.aer2enu(az, el, slantRange, angleUnit);

down = -up;

end
