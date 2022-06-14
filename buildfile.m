function plan = buildfile
plan = buildplan(localfunctions);
end

function testTask(~)
assertSuccess(runtests('matmap3d'))
end

function coverageTask(~)
import matlab.unittest.TestRunner;
import matlab.unittest.Verbosity;
import matlab.unittest.plugins.CodeCoveragePlugin;
import matlab.unittest.plugins.XMLPlugin;
import matlab.unittest.plugins.codecoverage.CoberturaFormat;

name = "matmap3d";

suite = testsuite(name);

mkdir('code-coverage');
mkdir('test-results');

runner = TestRunner.withTextOutput();
runner.addPlugin(XMLPlugin.producingJUnitFormat('test-results/results.xml'));
runner.addPlugin(CodeCoveragePlugin.forPackage(name, 'Producing', CoberturaFormat('code-coverage/coverage.xml')));

results = runner.run(suite);
assert(~isempty(results), "no tests found")

assertSuccess(results)
end
