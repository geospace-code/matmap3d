%% GET_RADIUS_NORMAL normal along the prime vertical section ellipsoidal radius of curvature
%
%%% Inputs
% * lat: geodetic latitude in Radians
% * ell: referenceEllipsoid
%
%%% Outputs
% * N: normal along the prime vertical section ellipsoidal radius of curvature, at a given geodetic latitude.
function N = get_radius_normal(lat, E)

if isempty(E)
  E = matmap3d.wgs84Ellipsoid();
end

N = E.SemimajorAxis^2 ./ sqrt( E.SemimajorAxis^2 .* cos(lat).^2 + E.SemiminorAxis^2 .* sin(lat).^2 );
end
