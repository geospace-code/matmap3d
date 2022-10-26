function E = wgs84Ellipsoid(lengthUnit)
%% wgs84Ellipsoid
% generate a WGS84 referenceEllipsoid
%
%%%  Inputs
%
% * lengthUnit: currently not implemented, for compatibility either nargin=0 or 'm' or 'meter' is accepted without conversion
%
%%% Outputs
%
% * E: referenceEllipsoid
arguments
  lengthUnit (1,1) string = "m"
end

E = matmap3d.referenceEllipsoid('wgs84', lengthUnit);

end
