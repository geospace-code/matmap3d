% Note: these functions require Matlab datetime class
% test values from Matlab docs
%% eci2ecef
utc = [2019, 1, 4, 12,0,0];
eci = [-2981784, 5207055, 3161595];
[x, y, z] = eci2ecef(utc, eci(1), eci(2), eci(3));
assert_allclose([x,y,z], [-5.7627e6, -1.6827e6, 3.1560e6], 0.02)

%% ecef2eci
ecef = [-5762640, -1682738, 3156028];
utc = [2019, 1, 4, 12,0,0];
[x,y,z] = ecef2eci(utc, ecef(1), ecef(2), ecef(3));
assert_allclose([x,y,z], [-2.9818e6, 5.2070e6, 3.1616e6], 0.01)

%% eci2aer
eci = [-3.8454e8, -0.5099e8, -0.3255e8];
utc = [1969, 7, 20, 21, 17, 40];
lla = [28.4, -80.5, 2.7];
[a, e, r] = eci2aer(utc, eci(1), eci(2), eci(3), lla(1), lla(2), lla(3));
assert_allclose([a, e, r], [162.55, 55.12, 384013940.9], 0.01)

%% aer2eci
aer = [162.55, 55.12, 384013940.9];
lla = [28.4, -80.5, 2.7];
utc = [1969, 7, 20, 21, 17, 40];
[x,y,z] = aer2eci(utc, aer(1), aer(2), aer(3), lla(1), lla(2), lla(3));
assert_allclose([x, y, z], [-3.8454e8, -0.5099e8, -0.3255e8], 0.06)
