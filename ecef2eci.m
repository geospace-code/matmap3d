function [x,y,z] = ecef2eci(time, x_ecef, y_ecef, z_ecef)
% rotate ECEF coordinates to ECI
% because this doesn't account for nutation, etc. error is often > 1%
%
% x_ecef, y_ecef, z_ecef:  ECEF position (meters)
% time: Matlab datetime UTC

% x,y,z:  ECI position

narginchk(4,4)
validateattributes(time, {'datetime'}, {'vector'})
validateattributes(x_ecef, {'numeric'}, {'vector', 'numel', length(time)})
validateattributes(y_ecef, {'numeric'}, {'vector', 'numel', length(time)})
validateattributes(z_ecef, {'numeric'}, {'vector', 'numel', length(time)})
%% Greenwich hour angles (radians)
gst = greenwichsrt(juliandate(time));
%% Convert into ECEF
x = nan(length(time));
y = nan(length(time));
z = nan(length(time));

for j = 1:length(time)
  eci = R3(gst(j)).' * [x_ecef(j), y_ecef(j), z_ecef(j)].';
  x(j) = eci(1);
  y(j) = eci(2);
  z(j) = eci(3);
end
end
