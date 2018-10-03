function jd = juliantime(t)
%% juliandate  datetime to Julian time
%
% from D.Vallado Fundamentals of Astrodynamics and Applications p.187
% and J. Meeus Astronomical Algorithms 1991 Eqn. 7.1 pg. 61

validateattributes(t, {'numeric'},{'vector'})

jd = nan(length(t),1);

dv = datevec(t);

for i = 1:length(t)
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
