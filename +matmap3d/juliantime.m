function jd = juliantime(t)
%% juliandate  datetime to Julian time
%
% from D.Vallado Fundamentals of Astrodynamics and Applications p.187
% and J. Meeus Astronomical Algorithms 1991 Eqn. 7.1 pg. 61
%
% parameters:
% t: datetime vector
%
% results:
% jd: julian date (days since Jan 1, 4173 BCE

narginchk(1,1)
validateattributes(t, {'numeric', 'datetime'}, {'nonempty'}, 1)

if matmap3d.isoctave()
  pkg('load', 'tablicious')  % provides datetime
end

t = datetime(t);

y = year(t);
m = month(t);
i = m < 3;
y(i) = y(i) - 1;
m(i) = m(i) + 12;

A = fix(y / 100.);
B = 2 - A + fix(A / 4.);
C = ((second(t) / 60. + minute(t)) / 60. + hour(t)) / 24.;

jd = fix(365.25 * (y + 4716)) + fix(30.6001 * (m + 1)) + day(t) + B - 1524.5 + C;

end
