# MatMap3d Functions

The source coordinate system (before the "2") is converted to the desired coordinate system:

Abbreviations:

AER: Azimuth, Elevation, Range

[aer2ecef](./aer2ecef.html)
[aer2eci](./aer2eci.html)
[aer2enu](./aer2enu.html)
[aer2geodetic](./aer2geodetic.html)
[aer2ned](./aer2ned.html)
[ecef2aer](./ecef2aer.html)
[ecef2eci](./ecef2eci.html)
[ecef2enu](./ecef2enu.html)
[ecef2enuv](./ecef2enuv.html)
[ecef2geodetic](./ecef2geodetic.html)
[ecef2ned](./ecef2ned.html)
[eci2aer](./eci2aer.html)
[eci2ecef](./eci2ecef.html)
[enu2aer](./enu2aer.html)
[enu2ecef](./enu2ecef.html)
[enu2geodetic](./enu2geodetic.html)
[env2uvw](./env2uvw.html)
[geodetic2aer](./geodetic2aer.html)
[geodetic2ecef](./geodetic2ecef.html)
[geodetic2enu](./geodetic2enu.html)
[geodetic2ned](./geodetic2ned.html)
[get_radius_normal](./get_radius_normal.html)
[greenwichsrt](./greenwichsrt.html)
[lookAtSpheroid](./lookAtSpheroid.html)
[R3](./R3.html)
[referenceEllipsoid](./referenceEllipsoid.html)
[vdist](./vdist.html)
[vreckon](./vreckon.html)
[wgs84Ellipsoid](./wgs84Ellipsoid.html)

ECEF: Earth-centered, Earth-fixed
ECI: Earth-centered Inertial
ENU: East North Up
NED: North East Down
radec: right ascension, declination
Caveats
Atmospheric effects neglected in all functions not invoking AstroPy. Would need to update code to add these input parameters (just start a GitHub Issue to request).
Planetary perturbations and nutation etc. not fully considered.

These functions present a similar API of a subset of functions in the Mathworks Matlab:

* Mapping Toolbox
* Aerospace Blockset
