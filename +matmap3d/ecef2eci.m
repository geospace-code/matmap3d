%% ECEF2ECI Transforms Earth Centered Earth Fixed (ECEF) coordinates to
%           Earth Centered Inertial (ECI) coordinates
%
%%% Inputs
% * utc: datetime UTC
% * r_ecef: 3x1 vector of ECEF position [meters]
% * v_ecef: 3x1 vector if ECEF velocity [m/s] (optional)
%%% Outputs
% * r_eci: 3x1 vector of ECI position [meters]
% * v_eci; 3x1 vector of ECI velocity [m/s] (optional)
%
% Original by:  Meysam Mahooti

function [r_eci, v_eci] = ecef2eci(utc, r_ecef, v_ecef, eopdata)
arguments
  utc (1,1) datetime
  r_ecef (3,1) {mustBeReal}
  v_ecef {mustBeReal} = []
  eopdata (13, :) {mustBeReal} = h5read(fullfile(fileparts(mfilename('fullpath')), "private/EOP-All.h5"), '/eop')
end

mjd_utc = Mjday(utc);

[x_pole,y_pole,UT1_UTC,LOD,~,~,~,~,TAI_UTC] = IERS(eopdata, mjd_utc, 'l');
[~,~,~,TT_UTC] = timediff(UT1_UTC,TAI_UTC);

MJD_UT1 = mjd_utc + UT1_UTC/86400;
MJD_TT  = mjd_utc + TT_UTC/86400;

% ICRS to ITRS transformation matrix and its derivative
P      = PrecMatrix(51544.5, MJD_TT);     % IAU 1976 Precession
N      = NutMatrix(MJD_TT);                      % IAU 1980 Nutation
Theta  = GHAMatrix(MJD_UT1,MJD_TT);              % Earth rotation
Po     = PoleMatrix(x_pole,y_pole);              % Polar motion
U      = Po*Theta*N*P;                           % ICRS to ITRS transformation

% Transformation from WGS to ICRS
r_eci = U'*r_ecef;
if nargout > 1
  mustBeEqualSize(r_ecef, v_ecef)
  S = zeros(3);
  S(1,2) = 1;
  S(2,1) = -1;
  Omega  = 15.04106717866910/3600*pi/180 - 0.843994809*1e-9*LOD; % [rad/s] IERS
  dTheta = Omega*S*Theta;                          % Derivative of Earth rotation matrix [1/s]
  dU     = Po*dTheta*N*P;                          % Derivative [1/s]
  v_eci = U'*v_ecef + dU'*r_ecef;
end

end

%!test
%! pkg load tablicious
%! pkg load hdf5oct
%! eopdata = h5read("private/EOP-All.h5", '/eop');
%! utc = datetime(2019, 1, 4, 12,0,0);
%! ecef = [-5762640; -1682738; 3156028];
%! r_eci = ecef2eci(utc, ecef, [], eopdata);
%! assert(abs(r_eci - [-2981829.07728415; 5207029.04470791; 3161595.0981204]) < 1e-5 * max(abs(r_eci)))
