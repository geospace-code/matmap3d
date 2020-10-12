function [x,y,z] = aer2ecef(az, el, slantRange, lat0, lon0, alt0, spheroid, angleUnit)
%% AER2CEF  convert azimuth, elevation, range to target from observer to ECEF coordinates
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
  az {mustBeNumeric,mustBeReal}
  el {mustBeNumeric,mustBeReal}
  slantRange {mustBeNumeric,mustBeReal, mustBeNonnegative}
  lat0 {mustBeNumeric,mustBeReal}
  lon0 {mustBeNumeric,mustBeReal}
  alt0 {mustBeNumeric,mustBeReal}
  spheroid (1,1) matmap3d.referenceEllipsoid = matmap3d.wgs84Ellipsoid()
  angleUnit (1,1) string = "d"
end

%% Origin of the local system in geocentric coordinates.
[x0, y0, z0] = matmap3d.geodetic2ecef(spheroid, lat0, lon0, alt0, angleUnit);
%% Convert Local Spherical AER to ENU
[e, n, u] = matmap3d.aer2enu(az, el, slantRange, angleUnit);
%% Rotating ENU to ECEF
[dx, dy, dz] = matmap3d.enu2uvw(e, n, u, lat0, lon0, angleUnit);
%% Origin + offset from origin equals position in ECEF
x = x0 + dx;
y = y0 + dy;
z = z0 + dz;

end
%%
%  Copyright (c) 2020 Michael Hirsch
%  Copyright (c) 2013, Felipe Geremia Nievinski
%
%  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
%  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
%  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
%  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
