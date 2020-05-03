function [x,y,z] = eci2ecef(utc, x_eci, y_eci, z_eci)
% rotate ECI coordinates to ECEF
% because this doesn't account for nutation, etc. error is often > 1%
%
% x_eci, y_eci, z_eci:  eci position vectors
% utc: Matlab datetime UTC

% x,y,z:  ECEF position

narginchk(4,4)
validateattributes(utc, {'numeric', 'datetime'}, {'vector'})
validateattributes(x_eci, {'numeric'}, {'vector'})
validateattributes(y_eci, {'numeric'}, {'vector', 'numel', length(x_eci)})
validateattributes(z_eci, {'numeric'}, {'vector', 'numel', length(x_eci)})
%% Greenwich hour angles (radians)
gst = greenwichsrt(juliandate(datetime(utc)));
validateattributes(gst, {'numeric'}, {'vector', 'numel', length(x_eci)})
%% Convert into ECEF
x = nan(length(x_eci));
y = nan(length(x));
z = nan(length(x));

for j = 1:length(x)
  ecef = R3(gst(j)) * [x_eci(j), y_eci(j), z_eci(j)].';
  x(j) = ecef(1);
  y(j) = ecef(2);
  z(j) = ecef(3);
end
end
