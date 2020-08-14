function [lat,lon,alt] = ecef2geodetic(spheroid, x, y, z, angleUnit)
%% ecef2geodetic   convert ECEF to geodetic coordinates
%
%%% Inputs
% * x,y,z:  ECEF coordinates of test point(s) (meters)
% * spheroid: referenceEllipsoid parameter struct
% * angleUnit: string for angular units. Default 'd': degrees
%
%%% Outputs
% * lat,lon, alt:  ellipsoid geodetic coordinates of point(s) (degrees, degrees, meters)
%
% based on:
% You, Rey-Jer. (2000). Transformation of Cartesian to Geodetic Coordinates without Iterations.
% Journal of Surveying Engineering. doi: 10.1061/(ASCE)0733-9453

narginchk(3,5)

if isempty(spheroid)
  spheroid = matmap3d.wgs84Ellipsoid();
elseif isnumeric(spheroid) && nargin == 3
  z = y;
  y = x;
  x = spheroid;
  spheroid = matmap3d.wgs84Ellipsoid();
elseif isnumeric(spheroid) && ischar(z) && nargin == 4
  angleUnit = z;
  z = y;
  y = x;
  x = spheroid;
  spheroid = matmap3d.wgs84Ellipsoid();
end

% NOT nargin < 5 due to optional reordering
if ~exist('angleUnit', 'var') || isempty(angleUnit), angleUnit = 'd'; end

validateattributes(spheroid,{'struct'},{'scalar'},1)
validateattributes(x, {'numeric'}, {'real'},2)
validateattributes(y, {'numeric'}, {'real'},3)
validateattributes(z, {'numeric'}, {'real'},4)
validateattributes(angleUnit,{'string','char'},{'scalar'},5)

%% compute

a = spheroid.SemimajorAxis;
b = spheroid.SemiminorAxis;

r = sqrt(x.^2 + y.^2 + z.^2);

E = sqrt(a.^2 - b.^2);

% eqn. 4a
u = sqrt(0.5 * (r.^2 - E.^2) + 0.5 * sqrt((r.^2 - E.^2).^2 + 4 * E.^2 .* z.^2));

Q = hypot(x, y);

huE = hypot(u, E);

% eqn. 4b
Beta = atan(huE ./ u .* z ./ hypot(x, y));

% eqn. 13
eps = ((b * u - a * huE + E.^2) .* sin(Beta)) ./ (a * huE ./ cos(Beta) - E.^2 .* cos(Beta));

Beta = Beta + eps;
%% final output
lat = atan(a / b * tan(Beta));

lon = atan2(y, x);

% eqn. 7
alt = hypot(z - b * sin(Beta), Q - a * cos(Beta));

% inside ellipsoid?
inside = (x.^2 ./ a.^2) + (y.^2 ./ a.^2) + (z.^2 ./ b.^2) < 1;
alt(inside) = -alt(inside);


if strcmpi(angleUnit(1), 'd')
  lat = rad2deg(lat);
  lon = rad2deg(lon);
end

 end % function
%%
% Copyright (c) 2014-2018 Michael Hirsch, Ph.D.
%
% Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
% 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
% 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
