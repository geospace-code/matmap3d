function assert_allclose(actual, desired, equal_nan, err_msg,notclose,verbose, namedargs)
% ok = assert_allclose(actual, desired, rtol, atol)
%
% Inputs
% ------
% atol: absolute tolerance (scalar)
% rtol: relative tolerance (scalar)
%
% Output
% ------
% ok: logical TRUE if "actual" is close enough to "desired"
%
% based on numpy.testing.assert_allclose
% https://github.com/numpy/numpy/blob/v1.13.0/numpy/core/numeric.py#L2522
% for Matlab and GNU Octave
%
% if "actual" is within atol OR rtol of "desired", no error is emitted.
arguments
  actual {mustBeNumeric,mustBeReal}
  desired {mustBeNumeric,mustBeReal}
  equal_nan (1,1) logical = false
  err_msg (1,1) string = ""
  notclose (1,1) logical = false
  verbose (1,1) logical = false
  namedargs.rtol (1,1) {mustBeNumeric,mustBeReal,mustBeNonnegative} = 1e-6
  namedargs.atol (1,1) {mustBeNumeric,mustBeReal,mustBeNonnegative} = 1e-9
end

%% compute
  actual = actual(:);
  desired = desired(:);

  if equal_nan
    match = false(size(actual));
    match(isnan(actual)) = true;
  else
    match = false;
  end


  measdiff = abs(actual-desired);
  tol = namedargs.atol + namedargs.rtol * abs(desired);
  result = measdiff <= tol;
%% assert_allclose vs assert_not_allclose
  if notclose % more than N % of values should be changed more than tolerance (arbitrary)
    testok = match | sum(~result) > 0.0001*numel(desired);
  else
    testok = all(match | result);
  end

  if ~testok
    Nfail = sum(~result);
    j = find(~result);
    [bigbad,i] = max(measdiff(j));
    i = j(i);
    if verbose
      disp(['error mag.: ',num2str(measdiff(j)')])
      disp(['tolerance:  ',num2str(tol(j)')])
      disp(['Actual:     ',num2str(actual(i))])
      disp(['desired:    ',num2str(desired(i))])
    end

    error(['AssertionError: ',err_msg,' ',num2str(Nfail/numel(desired)*100,'%.2f'),'% failed accuracy. maximum error magnitude ',num2str(bigbad),' Actual: ',num2str(actual(i)),' Desired: ',num2str(desired(i)),' atol: ',num2str(namedargs.atol),' rtol: ',num2str(namedargs.rtol)])
  end

end

% Copyright (c) 2014-2018 Michael Hirsch, Ph.D.
%
% Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
% 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
% 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
