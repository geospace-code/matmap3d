%% Matmap 3-D
%
% Matlab / GNU Octave code that has similar API to $1000 Matlab Mapping
% Toolbox.
%
% * <R3.html R3>
% * <aer2ecef.html aer2ecef>
% * <aer2eci.html aer2eci>
% * <aer2enu.html aer2enu>
% * <aer2geodetic.html aer2geodetic>
% * <ecef2aer.html ecef2aer>
% * <ecef2eci.html ecef2eci>
% * <ecef2enu.html ecef2enu>
% * <ecef2enuv.html ecef2enuv>
% * <ecef2geodetic.html ecef2geodetic>
% * <eci2aer.html eci2aer>
% * <eci2ecef.html eci2ecef>
% * <enu2aer.html enu2aer>
% * <enu2ecef.html enu2ecef>
% * <enu2ecefv.html enu2ecefv>
% * <enu2geodetic.html enu2geodetic>
% * <enu2uvw.html enu2uvw>
% * <geodetic2aer.html geodetic2aer>
% * <geodetic2ecef.html geodetic2ecef>
% * <geodetic2enu.html geodetic2enu>
% * <get_radius_normal.html get_radius_normal>
% * <getreferenceEllipsoid.html getreferenceEllipsoid>
% * <greenwichsrt.html greenwichsrt>
% * <juliantime.html juliantime>
% * <lookAtSpheroid.html lookAtSpheroid>
% * <vdist.html vdist>
% * <vreckon.html vreckon>
% * <wgs84Ellipsoid.html wgs84Ellipsoid>

function publish_all(path)
narginchk(1,1)

path = fileparts(mfilename('fullpath'));

flist = dir([path, '/*.m']);

docs = [path, '/docs'];
%%
for i = 1:length(flist)
  fn = publish([path,filesep,flist(i).name], 'evalCode', false, 'outputDir', docs);
  [~,fname,ext] = fileparts(fn);
  fn = [fname, ext];

  disp(['% * <',fn,' ',fname,'>'])
end

end
