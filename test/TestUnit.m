classdef (SharedTestFixtures={ matlab.unittest.fixtures.PathFixture(fileparts(fileparts(mfilename('fullpath'))))}) ...
  TestUnit < matlab.unittest.TestCase

properties
atol = 1e-9
rtol = 1e-6
angleUnit='d'
lat = 42
lon = -82
alt = 200
x0 = 660.6752518e3
y0 = -4700.9486832e3
z0 = 4245.7376622e3
lat1 = 42.0026
lon1 = -81.9978
alt1 = 1.1397e3
atol_dist = 1e-3 % 1 mm

er = 186.277521
nr = 286.84222
ur = 939.69262
az = 33
el = 70
srange = 1e3

xl = 6.609301927610815e+5
yl = -4.701424222957011e6
zl = 4.246579604632881e+06 % aer2ecef

a90 = 90
end


methods(Test)

function test_ellipsoid(tc)
tc.verifyClass(matmap3d.wgs84Ellipsoid(), 'matmap3d.referenceEllipsoid')
end

function test_geodetic2ecef(tc)

E = matmap3d.wgs84Ellipsoid();

[x,y,z] = matmap3d.geodetic2ecef(E, tc.lat, tc.lon, tc.alt, tc.angleUnit);
tc.verifyEqual([x,y,z], [tc.x0, tc.y0, tc.z0], AbsTol=tc.atol, RelTol=tc.rtol)

[x,y,z] = matmap3d.geodetic2ecef([], 0,0,-1);
tc.verifyEqual([x,y,z], [E.SemimajorAxis-1,0,0], AbsTol=tc.atol, RelTol=tc.rtol)

[x,y,z] = matmap3d.geodetic2ecef(E, 0,90,-1);
tc.verifyEqual([x,y,z], [0, E.SemimajorAxis-1,0], AbsTol=tc.atol, RelTol=tc.rtol)

[x,y,z] = matmap3d.geodetic2ecef(E, 0,-90,-1);
tc.verifyEqual([x,y,z], [0, -E.SemimajorAxis+1,0], AbsTol=tc.atol, RelTol=tc.rtol)

[x,y,z] = matmap3d.geodetic2ecef(E, 90,0,-1);
tc.verifyEqual([x,y,z], [0, 0, E.SemiminorAxis-1], AbsTol=tc.atol, RelTol=tc.rtol)

[x,y,z] = matmap3d.geodetic2ecef(E, 90,15,-1);
tc.verifyEqual([x,y,z], [0,0, E.SemiminorAxis-1], AbsTol=tc.atol, RelTol=tc.rtol)

[x,y,z] = matmap3d.geodetic2ecef(E, -90,0,-1);
tc.verifyEqual([x,y,z], [0,0, -E.SemiminorAxis+1], AbsTol=tc.atol, RelTol=tc.rtol)

end

function test_ecef2geodetic(tc)

E = matmap3d.wgs84Ellipsoid();

ea = E.SemimajorAxis;
eb = E.SemiminorAxis;

[lt, ln, at] = matmap3d.ecef2geodetic(E, tc.x0, tc.y0, tc.z0, tc.angleUnit);
tc.verifyEqual([lt, ln, at], [tc.lat, tc.lon, tc.alt], AbsTol=tc.atol, RelTol=tc.rtol)

[lt, ln, at] = matmap3d.ecef2geodetic([], ea-1, 0, 0);
tc.verifyEqual([lt, ln, at], [0, 0, -1], AbsTol=tc.atol, RelTol=tc.rtol)

[lt, ln, at] = matmap3d.ecef2geodetic(E, 0, ea-1, 0);
tc.verifyEqual([lt, ln, at], [0, 90, -1], AbsTol=tc.atol, RelTol=tc.rtol)

[lt, ln, at] = matmap3d.ecef2geodetic(E, 0, 0, eb-1);
tc.verifyEqual([lt, ln, at], [90, 0, -1], AbsTol=tc.atol, RelTol=tc.rtol)

[lt, ln, at] = matmap3d.ecef2geodetic(E, 0, 0, -eb+1);
tc.verifyEqual([lt, ln, at], [-90, 0, -1], AbsTol=tc.atol, RelTol=tc.rtol)

[lt, ln, at] = matmap3d.ecef2geodetic(E, -ea+1, 0, 0);
tc.verifyEqual([lt, ln, at], [0, 180, -1], AbsTol=tc.atol, RelTol=tc.rtol)

[lt, ln, at] = matmap3d.ecef2geodetic(E, (ea-1000)/sqrt(2), (ea-1000)/sqrt(2), 0);
tc.verifyEqual([lt,ln,at], [0,45,-1000], AbsTol=tc.atol, RelTol=tc.rtol)

end

function test_enu2aer(tc)

[a, e, r] = matmap3d.enu2aer(tc.er, tc.nr, tc.ur, tc.angleUnit);
tc.verifyEqual([a,e,r], [tc.az, tc.el, tc.srange] , AbsTol=tc.atol, RelTol=tc.rtol)

[a, e, r] = matmap3d.enu2aer(1, 0, 0, tc.angleUnit);
tc.verifyEqual([a,e,r], [tc.a90, 0, 1], AbsTol=tc.atol, RelTol=tc.rtol)
end

function test_aer2enu(tc)

[e,n,u] = matmap3d.aer2enu(tc.az, tc.el, tc.srange, tc.angleUnit);
tc.verifyEqual([e,n,u], [tc.er, tc.nr, tc.ur], AbsTol=tc.atol, RelTol=tc.rtol)

[n1,e1,d] = matmap3d.aer2ned(tc.az, tc.el, tc.srange, tc.angleUnit);
tc.verifyEqual([e,n,u], [e1,n1,-d])

[a,e,r] = matmap3d.enu2aer(e,n,u, tc.angleUnit);
tc.verifyEqual([a,e,r], [tc.az, tc.el, tc.srange], AbsTol=tc.atol, RelTol=tc.rtol)
end

function test_ecef2aer(tc)

E = matmap3d.wgs84Ellipsoid();

[a, e, r] = matmap3d.ecef2aer(tc.xl, tc.yl, tc.zl, tc.lat, tc.lon, tc.alt, E, tc.angleUnit);
% round-trip
tc.verifyEqual([a,e,r], [tc.az, tc.el, tc.srange], AbsTol=tc.atol, RelTol=tc.rtol)

% singularity check
[a, e, r] = matmap3d.ecef2aer(E.SemimajorAxis-1, 0, 0, 0,0,0, E, tc.angleUnit);
tc.verifyEqual([a,e,r], [0, -tc.a90, 1], AbsTol=tc.atol, RelTol=tc.rtol)

[a, e, r] = matmap3d.ecef2aer(-E.SemimajorAxis+1, 0, 0, 0, 2*tc.a90,0, E, tc.angleUnit);
tc.verifyEqual([a,e,r], [0, -tc.a90, 1], AbsTol=tc.atol, RelTol=tc.rtol)

[a, e, r] = matmap3d.ecef2aer(0, E.SemimajorAxis-1, 0,0, tc.a90,0, E, tc.angleUnit);
tc.verifyEqual([a,e,r], [0, -tc.a90, 1], AbsTol=tc.atol, RelTol=tc.rtol)

[a, e, r] = matmap3d.ecef2aer(0, -E.SemimajorAxis+1, 0,0, -tc.a90,0, E, tc.angleUnit);
tc.verifyEqual([a,e,r], [0, -tc.a90, 1], AbsTol=tc.atol, RelTol=tc.rtol)

[a, e, r] = matmap3d.ecef2aer(0, 0, E.SemiminorAxis-1, tc.a90, 0, 0, E, tc.angleUnit);
tc.verifyEqual([a,e,r], [0, -tc.a90, 1], AbsTol=tc.atol, RelTol=tc.rtol)

[a, e, r] = matmap3d.ecef2aer(0,  0, -E.SemiminorAxis+1,-tc.a90,0,0, E, tc.angleUnit);
tc.verifyEqual([a,e,r], [0, -tc.a90, 1], AbsTol=tc.atol, RelTol=tc.rtol)

[a, e, r] = matmap3d.ecef2aer((E.SemimajorAxis-1000)/sqrt(2), (E.SemimajorAxis-1000)/sqrt(2), 0, 0, 45, 0);
tc.verifyEqual([a,e,r],[0,-90,1000], AbsTol=tc.atol, RelTol=tc.rtol)

[x,y,z] = matmap3d.aer2ecef(tc.az, tc.el, tc.srange, tc.lat, tc.lon, tc.alt, E, tc.angleUnit);
tc.verifyEqual([x,y,z], [tc.xl, tc.yl, tc.zl], AbsTol=tc.atol, RelTol=tc.rtol)

[a,e,r] = matmap3d.ecef2aer(x,y,z, tc.lat, tc.lon, tc.alt, E, tc.angleUnit);
tc.verifyEqual([a,e,r], [tc.az, tc.el, tc.srange], AbsTol=tc.atol, RelTol=tc.rtol)
end

function test_geodetic2aer(tc)

E = matmap3d.wgs84Ellipsoid();

[lt,ln,at] = matmap3d.aer2geodetic(tc.az, tc.el, tc.srange, tc.lat, tc.lon, tc.alt, E, tc.angleUnit);
tc.verifyEqual([lt,ln,at], [tc.lat1, tc.lon1, tc.alt1], AbsTol=2*tc.atol_dist)

[a, e, r] = matmap3d.geodetic2aer(lt,ln,at, tc.lat, tc.lon, tc.alt, E, tc.angleUnit); % round-trip
tc.verifyEqual([a,e,r], [tc.az, tc.el, tc.srange], AbsTol=tc.atol, RelTol=tc.rtol)
end

function test_geodetic2enu(tc)

E = matmap3d.wgs84Ellipsoid();

[e, n, u] = matmap3d.geodetic2enu(tc.lat, tc.lon, tc.alt-1, tc.lat, tc.lon, tc.alt, E, tc.angleUnit);
tc.verifyEqual([e,n,u], [0,0,-1], AbsTol=tc.atol, RelTol=tc.rtol)

[lt, ln, at] = matmap3d.enu2geodetic(e,n,u,tc.lat,tc.lon,tc.alt, E, tc.angleUnit); % round-trip
tc.verifyEqual([lt, ln, at],[tc.lat, tc.lon, tc.alt-1], AbsTol=tc.atol, RelTol=tc.rtol)
end

function test_enu2ecef(tc)

E = matmap3d.wgs84Ellipsoid();

[x, y, z] = matmap3d.enu2ecef(tc.er, tc.nr, tc.ur, tc.lat,tc.lon,tc.alt, E, tc.angleUnit);
tc.verifyEqual([x,y,z],[tc.xl, tc.yl, tc.zl], AbsTol=tc.atol, RelTol=tc.rtol)

[e,n,u] = matmap3d.ecef2enu(x,y,z,tc.lat,tc.lon,tc.alt, E, tc.angleUnit); % round-trip
tc.verifyEqual([e,n,u],[tc.er, tc.nr, tc.ur], AbsTol=tc.atol, RelTol=tc.rtol)

[n1, e1, d] = matmap3d.ecef2ned(x,y,z,tc.lat,tc.lon,tc.alt, E, tc.angleUnit);
tc.verifyEqual([e,n,u],[e1,n1,-d])
end

function test_lookAtSpheroid(tc)

az5 = [0., 10., 125.];
tilt = [30, 45, 90];

[lat5, lon5, rng5] = matmap3d.lookAtSpheroid(tc.lat, tc.lon, tc.alt, az5, 0.);
tc.verifyEqual(lat5, repmat(tc.lat, 1, 3), AbsTol=tc.atol, RelTol=tc.rtol)
tc.verifyEqual(lon5, repmat(tc.lon, 1, 3), AbsTol=tc.atol, RelTol=tc.rtol)
tc.verifyEqual(rng5, repmat(tc.alt, 1, 3), AbsTol=tc.atol, RelTol=tc.rtol)


[lat5, lon5, rng5] = matmap3d.lookAtSpheroid(tc.lat, tc.lon, tc.alt, az5, tilt);

truth = [42.00103959, tc.lon, 230.9413173;
         42.00177328, -81.9995808, 282.84715651;
         nan, nan, nan];

tc.verifyEqual([lat5, lon5, rng5], truth(:).', AbsTol=tc.atol, RelTol=tc.rtol)
end

function test_eci2ecef(tc)
utc = datetime(2019, 1, 4, 12,0,0);
eci = [-2981784; 5207055; 3161595];
r_ecef = matmap3d.eci2ecef(utc, eci);
tc.verifyEqual(r_ecef, [-5762654.65677142; -1682688.09235503; 3156027.98313692], RelTol=2e-5)
end


function test_ecef2eci(tc)
ecef = [-5762640; -1682738; 3156028];
utc = datetime(2019, 1, 4, 12,0,0);
r_eci = matmap3d.ecef2eci(utc, ecef);
tc.verifyEqual(r_eci, [-2981829.07728415; 5207029.04470791; 3161595.0981204], RelTol=1e-5)
end

function test_ecef2eci_null(tc)
E = matmap3d.wgs84Ellipsoid();

[x, y, z] = matmap3d.geodetic2ecef(E, 0, 0, 0);
t = datetime(2000, 1, 1, 12, 0, 0, TimeZone='UTCLeapSeconds');
r_eci = matmap3d.ecef2eci(t, [x;y;z]);
tc.verifyEqual(r_eci, [1158174.72525987; -6272101.9503871; -143.138407305876], RelTol=tc.rtol)
end


function test_eci2aer(tc)
eci = [-3.8454e8, -0.5099e8, -0.3255e8];
utc = datetime(1969, 7, 20, 21, 17, 40);
lla = [28.4, -80.5, 2.7];
% aer = eci2aer(eci, datevec(utc), lla);
[a, e, r] = matmap3d.eci2aer(utc, eci(1), eci(2), eci(3), lla(1), lla(2), lla(3));
tc.verifyEqual([a, e, r], [162.548042074738, 55.1223823017527, 384013992.914642], RelTol=tc.rtol)
end

function test_aer2eci(tc)
aer = [162.55, 55.12, 384013940.9];
lla = [28.4, -80.5, 2.7];
utc = datetime(1969, 7, 20, 21, 17, 40);

% [x,y,z] = aer2ecef(aer(1), aer(2), aer(3), lla(1), lla(2), lla(3), wgs84Ellipsoid());
% eci = ecef2eci(utc, [x;y;z]);

[x,y,z] = matmap3d.aer2eci(utc, aer(1), aer(2), aer(3), lla(1), lla(2), lla(3));
tc.verifyEqual([x, y, z], [-384538755.067354, -50986804.9565394, -32567306.0200869], RelTol=2e5)
end

end
end
