%% Matmap 3-D
%
% Matlab / GNU Octave code that has similar API to $1000 Matlab Mapping
% Toolbox.
%
% * <aer2ecef.html aer2ecef>
% * <aer2enu.html aer2enu>
% * <aer2geodetic.html aer2geodetic>
% * <ecef2aer.html ecef2aer>
% * <ecef2enu.html ecef2enu>
% * <ecef2enuv.html ecef2enuv>
% * <ecef2geodetic.html ecef2geodetic>
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
% * <lookAtSpheroid.html lookAtSpheroid>
% * <vdist.html vdist>
% * <vreckon.html vreckon>
% * <wgs84Ellipsoid.html wgs84Ellipsoid>


function publish_all(path)

flist = dir([path, filesep, '*.m']);

for i = 1:length(flist)
  fn = publish([path,filesep,flist(i).name], 'evalCode', false, 'outputDir', 'docs');
  [~,fname,ext] = fileparts(fn);
  fn = [fname, ext];
  
  disp(['% * <',fn,' ',fname,'>'])
end


end
