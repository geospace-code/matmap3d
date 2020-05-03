function [x,y,z] = eci2ecef(time, x_eci, y_eci, z_eci)
% rotate ECI coordinates to ECEF
% because this doesn't account for nutation, etc. error is often > 1%
%
% x_eci, y_eci, z_eci:  eci position vectors
% time: Matlab datetime

% x,y,z:  ECEF position

narginchk(4,4)
validateattributes(time, {'datetime'}, {'vector'})
validateattributes(x_eci, {'numeric'}, {'vector', 'numel', length(time)})
validateattributes(y_eci, {'numeric'}, {'vector', 'numel', length(time)})
validateattributes(z_eci, {'numeric'}, {'vector', 'numel', length(time)})
%% Greenwich hour angles (radians)
gst = greenwichsrt(juliandate(time));
%% Convert into ECEF
x = nan(length(time));
y = nan(length(time));
z = nan(length(time));

for j = 1:length(time)
  ecef = R3(gst(j)) * [x_eci(j), y_eci(j), z_eci(j)].';
  x(j) = ecef(1);
  y(j) = ecef(2);
  z(j) = ecef(3);
end
end
