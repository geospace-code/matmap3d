%% ECI2ECEF_NAIVE rotate ECI coordinates to ECEF
% because this doesn't account for nutation, etc. error is generally significant
%
% x_eci, y_eci, z_eci:  eci position vectors
% utc: Matlab datetime UTC
%
% x,y,z:  ECEF position (meters)

function [x,y,z] = eci2ecef_naive(utc, x_eci, y_eci, z_eci)
arguments
  utc (:,1) datetime
  x_eci (:,1) {mustBeReal,mustBeEqualSize(utc,x_eci)}
  y_eci (:,1) {mustBeReal,mustBeEqualSize(utc,y_eci)}
  z_eci (:,1) {mustBeReal,mustBeEqualSize(utc,z_eci)}
end

% Greenwich hour angles (radians)
gst = matmap3d.greenwichsrt(juliandate(utc));

x = nan(like=x_eci);
y = nan(like=y_eci);
z = nan(like=z_eci);

for j = 1:length(x)
  ecef = matmap3d.R3(gst(j)) * [x_eci(j), y_eci(j), z_eci(j)].';
  x(j) = ecef(1);
  y(j) = ecef(2);
  z(j) = ecef(3);
end
end
