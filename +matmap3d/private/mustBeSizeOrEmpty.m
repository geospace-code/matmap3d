function mustBeSizeOrEmpty(a, s)

if ~isempty(a)
  if isvector(a) && sum(s ~= 1) == 1
    ok = numel(a) == prod(s);
  else
    ok = isequal(size(a), s);
  end
  if ~ok
    throwAsCaller(MException('MATLAB:validators:mustBeEqualSize','Input must be size or empty'))
  end
end

end
