function mustBeEqualSize(a,b)

sa = size(a);
sb = size(b);
if ~isequal(sa, sb)
  throwAsCaller(MException('MATLAB:validators:mustBeEqualSize', 'Size of inputs [%s]  [%s] must equal each other', num2str(sa), num2str(sb)));
end

end
