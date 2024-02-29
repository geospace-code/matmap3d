classdef TestUnit < matlab.unittest.TestCase

properties
TestData
end



methods(TestClassSetup)
function setup_path(tc)
import matlab.unittest.fixtures.PathFixture
cwd = fileparts(mfilename("fullpath"));
top = fullfile(cwd, "..");
tc.applyFixture(PathFixture(top))
end

function setup(tc)
tc.TestData.atol = 1e-9;
tc.TestData.rtol = 1e-6;

tc.TestData.E = matmap3d.wgs84Ellipsoid();

tc.TestData.lat = 42;
tc.TestData.lon = -82;
tc.TestData.alt = 200;
tc.TestData.angleUnit='d';
tc.TestData.x0 = 660.6752518e3;
tc.TestData.y0 = -4700.9486832e3;
tc.TestData.z0 = 4245.7376622e3;

tc.TestData.t0 = datetime(2014,4,6,8,0,0);

tc.TestData.lat1 = 42.0026;
tc.TestData.lon1 = -81.9978;
tc.TestData.alt1 = 1.1397e3;

tc.TestData.er = 186.277521;
tc.TestData.nr = 286.84222;
tc.TestData.ur = 939.69262;
tc.TestData.az = 33;
tc.TestData.el = 70;
tc.TestData.srange = 1e3;

tc.TestData.xl = 6.609301927610815e+5;
tc.TestData.yl = -4.701424222957011e6;
tc.TestData.zl = 4.246579604632881e+06; % aer2ecef

tc.TestData.atol_dist = 1e-3;  % 1 mm

tc.TestData.a90 = 90;
end
end

methods(Test)

function test_ellipsoid(tc)
E = matmap3d.wgs84Ellipsoid();
tc.verifyClass(E, 'matmap3d.referenceEllipsoid')
end

function test_geodetic2ecef(tc)

atol = tc.TestData.atol;
rtol = tc.TestData.rtol;
E = tc.TestData.E;

[x,y,z] = matmap3d.geodetic2ecef(E, tc.TestData.lat, tc.TestData.lon, tc.TestData.alt, tc.TestData.angleUnit);
tc.verifyEqual([x,y,z], [tc.TestData.x0, tc.TestData.y0, tc.TestData.z0], 'AbsTol', atol, 'RelTol', rtol)

[x,y,z] = matmap3d.geodetic2ecef([], 0,0,-1);
tc.verifyEqual([x,y,z], [E.SemimajorAxis-1,0,0], 'AbsTol', atol, 'RelTol', rtol)

[x,y,z] = matmap3d.geodetic2ecef(E, 0,90,-1);
tc.verifyEqual([x,y,z], [0, E.SemimajorAxis-1,0], 'AbsTol', atol, 'RelTol', rtol)

[x,y,z] = matmap3d.geodetic2ecef(E, 0,-90,-1);
tc.verifyEqual([x,y,z], [0, -E.SemimajorAxis+1,0], 'AbsTol', atol, 'RelTol', rtol)

[x,y,z] = matmap3d.geodetic2ecef(E, 90,0,-1);
tc.verifyEqual([x,y,z], [0,0,E.SemiminorAxis-1], 'AbsTol', atol, 'RelTol', rtol)

[x,y,z] = matmap3d.geodetic2ecef(E, 90,15,-1);
tc.verifyEqual([x,y,z], [0,0,E.SemiminorAxis-1], 'AbsTol', atol, 'RelTol', rtol)

[x,y,z] = matmap3d.geodetic2ecef(E, -90,0,-1);
tc.verifyEqual([x,y,z], [0,0,-E.SemiminorAxis+1], 'AbsTol', atol, 'RelTol', rtol)

end

function test_ecef2geodetic(tc)

atol = tc.TestData.atol;
rtol = tc.TestData.rtol;

E = tc.TestData.E;
ea = E.SemimajorAxis;
eb = E.SemiminorAxis;

[lt, ln, at] = matmap3d.ecef2geodetic(E, tc.TestData.x0, tc.TestData.y0, tc.TestData.z0, tc.TestData.angleUnit);
tc.verifyEqual([lt, ln, at], [tc.TestData.lat, tc.TestData.lon, tc.TestData.alt], 'AbsTol', atol, 'RelTol', rtol)

[lt, ln, at] = matmap3d.ecef2geodetic([], ea-1, 0, 0);
tc.verifyEqual([lt, ln, at], [0, 0, -1], 'AbsTol', atol, 'RelTol', rtol)

[lt, ln, at] = matmap3d.ecef2geodetic(E, 0, ea-1, 0);
tc.verifyEqual([lt, ln, at], [0, 90, -1], 'AbsTol', atol, 'RelTol', rtol)

[lt, ln, at] = matmap3d.ecef2geodetic(E, 0, 0, eb-1);
tc.verifyEqual([lt, ln, at], [90, 0, -1], 'AbsTol', atol, 'RelTol', rtol)

[lt, ln, at] = matmap3d.ecef2geodetic(E, 0, 0, -eb+1);
tc.verifyEqual([lt, ln, at], [-90, 0, -1], 'AbsTol', atol, 'RelTol', rtol)

[lt, ln, at] = matmap3d.ecef2geodetic(E, -ea+1, 0, 0);
tc.verifyEqual([lt, ln, at], [0, 180, -1], 'AbsTol', atol, 'RelTol', rtol)

[lt, ln, at] = matmap3d.ecef2geodetic(E, (ea-1000)/sqrt(2), (ea-1000)/sqrt(2), 0);
tc.verifyEqual([lt,ln,at], [0,45,-1000], 'AbsTol', atol, 'RelTol', rtol)

end

function test_enu2aer(tc)

atol = tc.TestData.atol;
rtol = tc.TestData.rtol;

[a, e, r] = matmap3d.enu2aer(tc.TestData.er, tc.TestData.nr, tc.TestData.ur, tc.TestData.angleUnit);
tc.verifyEqual([a,e,r], [tc.TestData.az, tc.TestData.el, tc.TestData.srange] , 'AbsTol', atol, 'RelTol', rtol)

[a, e, r] = matmap3d.enu2aer(1, 0, 0, tc.TestData.angleUnit);
tc.verifyEqual([a,e,r], [tc.TestData.a90, 0, 1], 'AbsTol', atol, 'RelTol', rtol)
end

function test_aer2enu(tc)
atol = tc.TestData.atol;
rtol = tc.TestData.rtol;

[e,n,u] = matmap3d.aer2enu(tc.TestData.az, tc.TestData.el, tc.TestData.srange, tc.TestData.angleUnit);
tc.verifyEqual([e,n,u], [tc.TestData.er, tc.TestData.nr, tc.TestData.ur], 'AbsTol', atol, 'RelTol', rtol)

[n1,e1,d] = matmap3d.aer2ned(tc.TestData.az, tc.TestData.el, tc.TestData.srange, tc.TestData.angleUnit);
tc.verifyEqual([e,n,u], [e1,n1,-d])

[a,e,r] = matmap3d.enu2aer(e,n,u, tc.TestData.angleUnit);
tc.verifyEqual([a,e,r], [tc.TestData.az, tc.TestData.el, tc.TestData.srange], 'AbsTol', atol, 'RelTol', rtol)
end

function test_ecef2aer(tc)

atol = tc.TestData.atol;
rtol = tc.TestData.rtol;

E = tc.TestData.E;
a90 = tc.TestData.a90;
angleUnit = tc.TestData.angleUnit;

[a, e, r] = matmap3d.ecef2aer(tc.TestData.xl, tc.TestData.yl, tc.TestData.zl, tc.TestData.lat, tc.TestData.lon, tc.TestData.alt, E, angleUnit);
% round-trip
tc.verifyEqual([a,e,r], [tc.TestData.az, tc.TestData.el, tc.TestData.srange], 'AbsTol', atol, 'RelTol', rtol)

% singularity check
[a, e, r] = matmap3d.ecef2aer(E.SemimajorAxis-1, 0, 0, 0,0,0, E, angleUnit);
tc.verifyEqual([a,e,r], [0, -a90, 1], 'AbsTol', atol, 'RelTol', rtol)

[a, e, r] = matmap3d.ecef2aer(-E.SemimajorAxis+1, 0, 0, 0, 2*a90,0, E, angleUnit);
tc.verifyEqual([a,e,r], [0, -a90, 1], 'AbsTol', atol, 'RelTol', rtol)

[a, e, r] = matmap3d.ecef2aer(0, E.SemimajorAxis-1, 0,0, a90,0, E, angleUnit);
tc.verifyEqual([a,e,r], [0, -a90, 1], 'AbsTol', atol, 'RelTol', rtol)

[a, e, r] = matmap3d.ecef2aer(0, -E.SemimajorAxis+1, 0,0, -a90,0, E, angleUnit);
tc.verifyEqual([a,e,r], [0, -a90, 1], 'AbsTol', atol, 'RelTol', rtol)

[a, e, r] = matmap3d.ecef2aer(0, 0, E.SemiminorAxis-1, a90, 0, 0, E, angleUnit);
tc.verifyEqual([a,e,r], [0, -a90, 1], 'AbsTol', atol, 'RelTol', rtol)

[a, e, r] = matmap3d.ecef2aer(0,  0, -E.SemiminorAxis+1,-a90,0,0, E, angleUnit);
tc.verifyEqual([a,e,r], [0, -a90, 1], 'AbsTol', atol, 'RelTol', rtol)

[a, e, r] = matmap3d.ecef2aer((E.SemimajorAxis-1000)/sqrt(2), (E.SemimajorAxis-1000)/sqrt(2), 0, 0, 45, 0);
tc.verifyEqual([a,e,r],[0,-90,1000], 'AbsTol', atol, 'RelTol', rtol)

[x,y,z] = matmap3d.aer2ecef(tc.TestData.az, tc.TestData.el, tc.TestData.srange, tc.TestData.lat, tc.TestData.lon, tc.TestData.alt,E, angleUnit);
tc.verifyEqual([x,y,z], [tc.TestData.xl, tc.TestData.yl, tc.TestData.zl], 'AbsTol', atol, 'RelTol', rtol)

[a,e,r] = matmap3d.ecef2aer(x,y,z, tc.TestData.lat, tc.TestData.lon, tc.TestData.alt, E, angleUnit);
tc.verifyEqual([a,e,r], [tc.TestData.az, tc.TestData.el, tc.TestData.srange], 'AbsTol', atol, 'RelTol', rtol)
end

function test_geodetic2aer(tc)

atol = tc.TestData.atol;
rtol = tc.TestData.rtol;

E = tc.TestData.E;
angleUnit = tc.TestData.angleUnit;
lat = tc.TestData.lat;
lon = tc.TestData.lon;
alt = tc.TestData.alt;

[lt,ln,at] = matmap3d.aer2geodetic(tc.TestData.az, tc.TestData.el, tc.TestData.srange, lat, lon, alt, E, angleUnit);
tc.verifyEqual([lt,ln,at], [tc.TestData.lat1, tc.TestData.lon1, tc.TestData.alt1], 'AbsTol', 2*tc.TestData.atol_dist)

[a, e, r] = matmap3d.geodetic2aer(lt,ln,at, lat, lon, alt, E, angleUnit); % round-trip
tc.verifyEqual([a,e,r], [tc.TestData.az, tc.TestData.el, tc.TestData.srange], 'AbsTol', atol, 'RelTol', rtol)
end

function test_geodetic2enu(tc)

atol = tc.TestData.atol;
rtol = tc.TestData.rtol;
E = tc.TestData.E;
angleUnit = tc.TestData.angleUnit;
lat = tc.TestData.lat;
lon = tc.TestData.lon;
alt = tc.TestData.alt;

[e, n, u] = matmap3d.geodetic2enu(lat, lon, alt-1, lat, lon, alt, E, angleUnit);
tc.verifyEqual([e,n,u], [0,0,-1], 'AbsTol', atol, 'RelTol', rtol)

[lt, ln, at] = matmap3d.enu2geodetic(e,n,u,lat,lon,alt, E, angleUnit); % round-trip
tc.verifyEqual([lt, ln, at],[lat, lon, alt-1], 'AbsTol', atol, 'RelTol', rtol)
end

function test_enu2ecef(tc)

atol = tc.TestData.atol;
rtol = tc.TestData.rtol;
E = tc.TestData.E;
angleUnit = tc.TestData.angleUnit;
lat = tc.TestData.lat;
lon = tc.TestData.lon;
alt = tc.TestData.alt;

[x, y, z] = matmap3d.enu2ecef(tc.TestData.er, tc.TestData.nr, tc.TestData.ur, lat,lon,alt, E, angleUnit);
tc.verifyEqual([x,y,z],[tc.TestData.xl, tc.TestData.yl, tc.TestData.zl], 'AbsTol', atol, 'RelTol', rtol)

[e,n,u] = matmap3d.ecef2enu(x,y,z,lat,lon,alt, E, angleUnit); % round-trip
tc.verifyEqual([e,n,u],[tc.TestData.er, tc.TestData.nr, tc.TestData.ur], 'AbsTol', atol, 'RelTol', rtol)
end

function test_lookAtSpheroid(tc)

atol = tc.TestData.atol;
rtol = tc.TestData.rtol;

lat = tc.TestData.lat;
lon = tc.TestData.lon;
alt = tc.TestData.alt;

az5 = [0., 10., 125.];
tilt = [30, 45, 90];

[lat5, lon5, rng5] = matmap3d.lookAtSpheroid(lat, lon, alt, az5, 0.);
tc.verifyEqual(lat5, repmat(lat, 1, 3), 'AbsTol', atol, 'RelTol', rtol)
tc.verifyEqual(lon5, repmat(lon, 1, 3), 'AbsTol', atol, 'RelTol', rtol)
tc.verifyEqual(rng5, repmat(alt, 1, 3), 'AbsTol', atol, 'RelTol', rtol)


[lat5, lon5, rng5] = matmap3d.lookAtSpheroid(lat, lon, alt, az5, tilt);

truth = [42.00103959, lon, 230.9413173;
         42.00177328, -81.9995808, 282.84715651;
         nan, nan, nan];

tc.verifyEqual([lat5, lon5, rng5], truth(:).', 'AbsTol', atol, 'RelTol', rtol)
end

function test_eci2ecef(tc)
utc = datetime(2019, 1, 4, 12,0,0);
eci = [-2981784, 5207055, 3161595];
[x, y, z] = matmap3d.eci2ecef(utc, eci(1), eci(2), eci(3));
tc.verifyEqual([x,y,z], [-5.7627e6, -1.6827e6, 3.1560e6], 'reltol', 0.02)
end

function test_eci2ecef_multiple(tc)
utc = datetime(2019, 1, 4, 12,0,0);
utc = [utc;utc];
eci = [-2981784, 5207055, 3161595]; eci = [eci; eci];
[x, y, z] = matmap3d.eci2ecef(utc, eci(:,1), eci(:,2), eci(:,3));
tc.verifyEqual([x(1,1), y(1,1), z(1,1)], [-5.7627e6, -1.6827e6, 3.1560e6], 'reltol', 0.02)
tc.verifyEqual([x(2,1), y(2,1), z(2,1)], [-5.7627e6, -1.6827e6, 3.1560e6], 'reltol', 0.02)
end

function test_ecef2eci(tc)
ecef = [-5762640, -1682738, 3156028];
utc = datetime(2019, 1, 4, 12,0,0);
[x,y,z] = matmap3d.ecef2eci(utc, ecef(1), ecef(2), ecef(3));
tc.verifyEqual([x,y,z], [-2.9818e6, 5.2070e6, 3.1616e6], 'RelTol', 0.01)
end

function test_ecef2eci_multiple(tc)
ecef = [-5762640, -1682738, 3156028]; ecef = [ecef; ecef];
utc = datetime(2019, 1, 4, 12, 0, 0);
utc = [utc; utc];
[x,y,z] = matmap3d.ecef2eci(utc, ecef(:,1), ecef(:,2), ecef(:,3));
tc.verifyEqual([x(1,1), y(1,1) , z(1,1)], [-2.9818e6, 5.2070e6, 3.1616e6], 'RelTol', 0.01)
tc.verifyEqual([x(2,1), y(2,1) , z(2,1)], [-2.9818e6, 5.2070e6, 3.1616e6], 'RelTol', 0.01)
end

function test_eci2aer(tc)
eci = [-3.8454e8, -0.5099e8, -0.3255e8];
utc = datetime(1969, 7, 20, 21, 17, 40);
lla = [28.4, -80.5, 2.7];
[a, e, r] = matmap3d.eci2aer(utc, eci(1), eci(2), eci(3), lla(1), lla(2), lla(3));
tc.verifyEqual([a, e, r], [162.55, 55.12, 384013940.9], 'RelTol', 0.01)
end

function test_aer2eci(tc)
aer = [162.55, 55.12, 384013940.9];
lla = [28.4, -80.5, 2.7];
utc = datetime(1969, 7, 20, 21, 17, 40);
[x,y,z] = matmap3d.aer2eci(utc, aer(1), aer(2), aer(3), lla(1), lla(2), lla(3));
tc.verifyEqual([x, y, z], [-3.8454e8, -0.5099e8, -0.3255e8], 'RelTol', 0.06)
end

end
end
