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

function jd = juliandate(t)

[y, mon, d, h, m, s] = datevec(t);

i = mon < 3;
y(i) = y(i) - 1;
mon(i) = mon(i) + 12;

A = fix(y / 100.);
B = 2 - A + fix(A / 4.);
C = ((s / 60. + m) / 60. + h) / 24.;

jd = fix(365.25 * (y + 4716)) + fix(30.6001 * (mon + 1)) + d + B - 1524.5 + C;

end
