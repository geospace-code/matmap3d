%% COVERAGE_RUN
% called from buildfile.m

function coverage_run(pkg, test_dir)

import matlab.unittest.TestRunner
import matlab.unittest.Verbosity
import matlab.unittest.plugins.CodeCoveragePlugin
import matlab.unittest.plugins.XMLPlugin
import matlab.unittest.plugins.codecoverage.CoberturaFormat

suite = testsuite(test_dir);

% not import to allow use of rest of buildfile with R2022b
format = matlab.unittest.plugins.codecoverage.CoverageResult;


runner = TestRunner.withTextOutput();
runner.addPlugin(CodeCoveragePlugin.forPackage(pkg, Producing=format))

% runner.addPlugin(XMLPlugin.producingJUnitFormat('test-results.xml'))
% runner.addPlugin(CodeCoveragePlugin.forPackage(pkg, 'Producing', ...
%     CoberturaFormat('test-coverage.xml')))

r = runner.run(suite);
assert(~isempty(r), "no tests found")

assertSuccess(r)

generateHTMLReport(format.Result)

end