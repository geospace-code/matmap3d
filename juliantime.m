function jd = juliantime(t)
%% juliandate  datetime to Julian time
%
% from D.Vallado Fundamentals of Astrodynamics and Applications p.187
% and J. Meeus Astronomical Algorithms 1991 Eqn. 7.1 pg. 61
%
% parameters:
% t: datetime or datenum or datevec (Nx1) or (Nx6)
%
% results:
% jd: julian date (days since Jan 1, 4173 BCE

jd = nan(size(t,1),1);

if size(t,2) == 6
  dv = t;
else
  dv = datevec(t);
end

for i = 1:size(t,1)
    if dv(i, 2) < 3
        year = dv(i,1) - 1;
        month = dv(i,2) + 12;
    else
        year = dv(i,1);
        month = dv(i,2);
    end

    A = fix(year / 100.);
    B = 2 - A + fix(A / 4.);
    C = ((dv(i,6) / 60. + dv(i,5)) / 60. + dv(i,4)) / 24.;

    jd(i) = fix(365.25 * (year + 4716)) + ...
            fix(30.6001 * (month + 1)) + dv(i,3) + B - 1524.5 + C;

end
             
end
