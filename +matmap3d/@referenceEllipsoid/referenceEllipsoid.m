%% referenceEllipsoid   Select available ellipsoid
%
%%% inputs
% * name: string of model name. Default: 'wgs84'
%%% outputs
% * E: referenceEllipsoid

classdef referenceEllipsoid
properties
  Code
  Name
  LengthUnit
  SemimajorAxis
  Flattening
  SemiminorAxis
  Eccentricity
  MeanRadius
  Volume
end

methods
function e = referenceEllipsoid(name, lengthUnit)
arguments
  name (1,1) string = "wgs84"
  lengthUnit (1,1) string = "m"
end

mustBeMember(lengthUnit, ["m", "meters"])

switch name
case 'wgs84'
% WGS-84 ellipsoid parameters.
% <http://earth-info.nga.mil/GandG/tr8350_2.html>
% <ftp://164.214.2.65/pub/gig/tr8350.2/wgs84fin.pdf>
  e.Code = 7030;
  e.Name = 'World Geodetic System 1984';
  e.LengthUnit = 'meter';
  e.SemimajorAxis = 6378137.0;
  e.Flattening = 1/298.2572235630;
  e.SemiminorAxis = e.SemimajorAxis * (1 - e.Flattening);
  e.Eccentricity = get_eccentricity(e);
  e.MeanRadius = meanradius(e);
  e.Volume = spheroidvolume(e);
case 'grs80'
% GRS-80 ellipsoid parameters
% <http://itrf.ensg.ign.fr/faq.php?type=answer> (accessed 2018-01-22)
  e.Code = 7019;
  e.Name = 'Geodetic Reference System 1980';
  e.LengthUnit = 'meter';
  e.SemimajorAxis = 6378137.0;
  e.Flattening = 1/298.257222100882711243;
  e.SemiminorAxis = e.SemimajorAxis * (1 - e.Flattening);
  e.Eccentricity  = get_eccentricity(e);
  e.MeanRadius = meanradius(e);
  e.Volume = spheroidvolume(e);
otherwise, error(name + " not yet implemented")
end
end

function v = spheroidvolume(E)
v = 4*pi/3 * E.SemimajorAxis^2 * E.SemiminorAxis;

assert(v>=0)
end

function r = meanradius(E)
r = (2*E.SemimajorAxis + E.SemiminorAxis) / 3;

assert(r>=0)
end

function ecc = get_eccentricity(E)
ecc = sqrt ( (E.SemimajorAxis^2 - E.SemiminorAxis^2) / (E.SemimajorAxis^2));
end

end
end
