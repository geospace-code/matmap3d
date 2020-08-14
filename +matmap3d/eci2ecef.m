function [x,y,z] = eci2ecef(utc, x_eci, y_eci, z_eci)
% rotate ECI coordinates to ECEF
% because this doesn't account for nutation, etc. error is often > 1%
%
% x_eci, y_eci, z_eci:  eci position vectors
% utc: Matlab datetime UTC

% x,y,z:  ECEF position

narginchk(4,4)
validateattributes(utc, {'numeric', 'datetime'}, {'2d'},1)
validateattributes(x_eci, {'numeric'}, {'vector'},2)
validateattributes(y_eci, {'numeric'}, {'vector', 'numel', length(x_eci)},3)
validateattributes(z_eci, {'numeric'}, {'vector', 'numel', length(x_eci)},4)
%% Greenwich hour angles (radians)
% gst = matmap3d.greenwichsrt(matmap3d.juliandate(datetime(utc)));
gst = matmap3d.greenwichsrt(matmap3d.juliantime(utc));
validateattributes(gst, {'numeric'}, {'vector', 'numel', length(x_eci)})
%% Convert into ECEF
x = nan(size(x_eci));
y = nan(size(x));
z = nan(size(x));

for j = 1:length(x)
  ecef = matmap3d.R3(gst(j)) * [x_eci(j), y_eci(j), z_eci(j)].';
  x(j) = ecef(1);
  y(j) = ecef(2);
  z(j) = ecef(3);
end
end
