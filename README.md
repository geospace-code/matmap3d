# MatMap3d

[![DOI](https://zenodo.org/badge/144219717.svg)](https://zenodo.org/badge/latestdoi/144219717)
![ci](https://github.com/geospace-code/matmap3d/workflows/ci/badge.svg)
[![View matmap3d on File Exchange](https://www.mathworks.com/matlabcentral/images/matlab-file-exchange.svg)](https://www.mathworks.com/matlabcentral/fileexchange/68480-matmap3d)

Matlab / GNU Octave coordinate conversions for geospace ecef enu eci.
Similar to Python [PyMap3D](https://github.com/scivision/pymap3d).

## Usage

MatMap3D is setup as a
[Matlab package](https://www.mathworks.com/help/matlab/matlab_oop/scoping-classes-with-packages.html),
which means `import matmap3d` statements allow scoped use of this code.
GNU Octave is also capable of using packages by putting the package name before each function name.

```matlab
import matmap3d.*
% or add matmap3d. to start of function name

[x,y,z] = geodetic2ecef([],lat,lon,alt)

[az,el,range] = geodetic2aer(lat, lon, alt, observer_lat, observer_lon, observer_alt)
```

Optionally, verify functionality:

```sh
matmap3d.tests.test_unit
```

### GNU Octave

MatMap3D uses "datetime" for reliability--Octave can use datetime via tablicious:

```octave
pkg install https://github.com/scivision/octave-tablicious/archive/master.zip
```

### Functions

Popular mapping & aerospace toolbox functions ported to Matlab include the
following, where the source coordinate system (before the "2") is
converted to the desired coordinate system:

```
aer2ecef  aer2enu  aer2geodetic  aer2ned
ecef2aer  ecef2enu  ecef2enuv  ecef2geodetic  ecef2ned  ecef2nedv
enu2aer  enu2ecef   enu2geodetic
juliantime
geodetic2aer  geodetic2ecef  geodetic2enu  geodetic2ned
ned2aer  ned2ecef   ned2geodetic
lookAtSpheroid
```

Abbreviations:

* [AER: Azimuth, Elevation, Range](https://en.wikipedia.org/wiki/Spherical_coordinate_system)
* [ECEF: Earth-centered, Earth-fixed](https://en.wikipedia.org/wiki/ECEF)
* [ECI: Earth-centered Inertial](https://en.wikipedia.org/wiki/Earth-centered_inertial)
* [ENU: East North Up](https://en.wikipedia.org/wiki/Axes_conventions#Ground_reference_frames:_ENU_and_NED)
* [NED: North East Down](https://en.wikipedia.org/wiki/North_east_down)
* [radec: right ascension, declination](https://en.wikipedia.org/wiki/Right_ascension)

### Caveats

* Atmospheric effects neglected in all functions not invoking AstroPy.
  Would need to update code to add these input parameters (just start a GitHub Issue to request).
* Planetary perturbations and nutation etc. not fully considered.

Mathworks currently charges $1000 for the
[Matlab Mapping Toolbox](https://www.mathworks.com/products/mapping.html)
that provides these functions.

## Notes

The full set of Python conversions are accessed from Matlab &ge; R2014b by commands like:

```matlab
lla = py.pymap3d.geodetic2ecef(x,y,z)
```
