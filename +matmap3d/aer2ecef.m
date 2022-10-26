function [x,y,z] = aer2ecef(az, el, slantRange, lat0, lon0, alt0, spheroid, angleUnit)
%% AER2CEF(az, el, slantRange, lat0, lon0, alt0, spheroid, angleUnit)
% convert azimuth, elevation, range to target from observer to ECEF coordinates
%
%%%  Inputs
%
% * az, el, slantrange: look angles and distance to point under test (degrees, degrees, meters)
% * az: azimuth clockwise from local north
% * el: elevation angle above local horizon
% * lat0, lon0, alt0: ellipsoid geodetic coordinates of observer/reference (degrees, degrees, meters)
% * spheroid: referenceEllipsoid
% * angleUnit: string for angular units. Default 'd': degrees
%
%%% outputs
%
% * x,y,z: Earth Centered Earth Fixed (ECEF) coordinates of test point (meters)
%% sanity checks
arguments
  az {mustBeReal}
  el {mustBeReal}
  slantRange {mustBeReal, mustBeNonnegative}
  lat0 {mustBeReal}
  lon0 {mustBeReal}
  alt0 {mustBeReal}
  spheroid (1,1) matmap3d.referenceEllipsoid = matmap3d.wgs84Ellipsoid()
  angleUnit (1,1) string = "d"
end

% Origin of the local system in geocentric coordinates.
[x0, y0, z0] = matmap3d.geodetic2ecef(spheroid, lat0, lon0, alt0, angleUnit);
% Convert Local Spherical AER to ENU
[e, n, u] = matmap3d.aer2enu(az, el, slantRange, angleUnit);
% Rotating ENU to ECEF
[dx, dy, dz] = matmap3d.enu2uvw(e, n, u, lat0, lon0, angleUnit);
% Origin + offset from origin equals position in ECEF
x = x0 + dx;
y = y0 + dy;
z = z0 + dz;

end
