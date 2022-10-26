function [e, n, Up] = ecef2enuv(u, v, w, lat0, lon0, angleUnit)
%% ecef2enuv
% convert *vector projection* UVW to ENU
%
%%% Inputs
% * u,v,w: meters
% * lat0,lon0: geodetic latitude and longitude (degrees)
% * angleUnit: string for angular system. Default 'd' degrees
%
%%% Outputs
% * e,n,Up:  East, North, Up vector
arguments
  u {mustBeReal}
  v {mustBeReal}
  w {mustBeReal}
  lat0 {mustBeReal}
  lon0 {mustBeReal}
  angleUnit (1,1) string = "d"
end

if startsWith(angleUnit, 'd')
  lat0 = deg2rad(lat0);
  lon0 = deg2rad(lon0);
end

t  =  cos(lon0) .* u + sin(lon0) .* v;
e  = -sin(lon0) .* u + cos(lon0) .* v;
Up =  cos(lat0) .* t + sin(lat0) .* w;
n  = -sin(lat0) .* t + cos(lat0) .* w;

% 1mm precision
if abs(e) < 1e-3, e=0; end
if abs(n) < 1e-3, n=0; end
if abs(Up) < 1e-3, Up=0; end
end
