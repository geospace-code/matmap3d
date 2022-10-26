function A = R3(x)
%% R3(x)
% rotation matrix for ECI
A = [cos(x),  sin(x), 0;
     -sin(x), cos(x), 0;
     0, 0, 1];
end
