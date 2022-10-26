function [x,y,z] = eci2ecef(utc, x_eci, y_eci, z_eci)
%% eci2ecef(utc, x_eci, y_eci, z_eci)
% rotate ECI coordinates to ECEF
% because this doesn't account for nutation, etc. error is often > 1%
%
% x_eci, y_eci, z_eci:  eci position vectors
% utc: Matlab datetime UTC
%
% x,y,z:  ECEF position (meters)
arguments
  utc (:,1) datetime
  x_eci (:,1) {mustBeReal,mustBeEqualSize(utc,x_eci)}
  y_eci (:,1) {mustBeReal,mustBeEqualSize(utc,y_eci)}
  z_eci (:,1) {mustBeReal,mustBeEqualSize(utc,z_eci)}
end

% Greenwich hour angles (radians)
gst = matmap3d.greenwichsrt(juliandate(utc));

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
