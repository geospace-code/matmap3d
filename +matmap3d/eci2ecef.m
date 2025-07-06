%% ECI2ECEF Transforms Earth Centered Inertial (ECI) coordinates to Earth
%           Centered Earth Fixed (ECEF) coordinates
%
% original by:   Meysam Mahooti
%

function [r_ecef, v_ecef] = eci2ecef(utc, r_eci, v_eci, eopdata)
arguments
  utc (1,1) datetime
  r_eci (3,1) {mustBeReal}
  v_eci {mustBeReal} = []
  eopdata (13, :) {mustBeReal} = h5read(fullfile(fileparts(mfilename('fullpath')), "private/EOP-All.h5"), '/eop')
end

mjd_utc = Mjday(utc);

[x_pole,y_pole,UT1_UTC,LOD,~,~,~,~,TAI_UTC] = IERS(eopdata, mjd_utc,'l');
[~,~,~,TT_UTC] = timediff(UT1_UTC,TAI_UTC);

MJD_UT1 = mjd_utc + UT1_UTC/86400;
MJD_TT  = mjd_utc + TT_UTC/86400; 

% ICRS to ITRS transformation matrix and its derivative
P      = PrecMatrix(51544.5, MJD_TT);     % IAU 1976 Precession
N      = NutMatrix(MJD_TT);                      % IAU 1980 Nutation
Theta  = GHAMatrix(MJD_UT1,MJD_TT);              % Earth rotation
Po     = PoleMatrix(x_pole,y_pole);              % Polar motion

S = zeros(3);
S(1,2) = 1;
S(2,1) = -1;
Omega  = 15.04106717866910/3600*pi/180 - 0.843994809*1e-9*LOD; % [rad/s] IERS
dTheta = Omega*S*Theta;                          % Derivative of Earth rotation matrix [1/s]
U      = Po*Theta*N*P;                           % ICRS to ITRS transformation
dU     = Po*dTheta*N*P;                          % Derivative [1/s]                   % Derivative [1/s]

% Transformation from ICRS to ITRS
r_ecef = U * r_eci;
if nargout > 1
  mustBeEqualSize(r_eci, v_eci)
  v_ecef = U * v_eci + dU * r_eci;
end

end
