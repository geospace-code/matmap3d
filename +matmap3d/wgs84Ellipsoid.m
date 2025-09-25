%% WGS84ELLIPSOID - generate a WGS84 referenceEllipsoid
%
%%%  Inputs
%
% * lengthUnit: currently not implemented, for compatibility either nargin=0 or 'm' or 'meter' is accepted without conversion
%
%%% Outputs
%
% * E: referenceEllipsoid
function E = wgs84Ellipsoid(lengthUnit)
if nargin < 1
  lengthUnit = 'm';
end

E = matmap3d.referenceEllipsoid('wgs84', lengthUnit);

end
