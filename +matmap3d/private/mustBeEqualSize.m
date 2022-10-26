function mustBeEqualSize(a,b)

if ~isequal(size(a),size(b))
  throwAsCaller(MException('MATLAB:validators:mustBeEqualSize','Size of inputs must equal each other'))
end

end
