function plan = buildfile
plan = buildplan(localfunctions);
plan.DefaultTasks = "test";
plan("test").Dependencies = "check";
end

function checkTask(~)
% Identify code issues (recursively all Matlab .m files)
issues = codeIssues;
assert(isempty(issues.Issues), formattedDisplayText(issues.Issues))
end

function testTask(~)
r = runtests(IncludeSubfolders=true, strict=true, UseParallel=true);
assert(~isempty(r), "No tests were run")
assertSuccess(r)
end

function coverageTask(~)
import matlab.unittest.TestRunner
import matlab.unittest.Verbosity
import matlab.unittest.plugins.CodeCoveragePlugin
import matlab.unittest.plugins.XMLPlugin
import matlab.unittest.plugins.codecoverage.CoberturaFormat


pkg = "matmap3d";

suite = testsuite("test/");

% not import to allow use of rest of buildfile with R2022b
format = matlab.unittest.plugins.codecoverage.CoverageResult;


runner = TestRunner.withTextOutput();
runner.addPlugin(CodeCoveragePlugin.forPackage(pkg, Producing=format))

% runner.addPlugin(XMLPlugin.producingJUnitFormat('test-results.xml'))
% runner.addPlugin(CodeCoveragePlugin.forPackage(pkg, 'Producing', ...
%     CoberturaFormat('test-coverage.xml')))

run_results = runner.run(suite);
assert(~isempty(run_results), "no tests found")

assertSuccess(run_results)

generateHTMLReport(format.Result)
end

function publishTask(~)
% publish (generate) docs from Matlab project

% for package code -- assumes no classes and depth == 0
pkg_name = 'matmap3d';

r = codeIssues;
files = r.Files;

% remove nuisance functions
i = contains(files, [mfilename, "buildfile.m", filesep + "private" + filesep]);
files(i) = [];

pkg = what(pkg_name);
subs = pkg.packages;

%% generate docs
cwd = fileparts(mfilename('fullpath'));
docs = fullfile(cwd, "docs");

for sub = subs.'
  s = sub{1};
  i = contains(files, filesep + "+" + s + filesep);
  fs = files(i);
  for f = fs.'
    [~, name, ext] = fileparts(f);
    if ext == ".m"
      doc_fn = publish(pkg_name + "." + name, evalCode=false, outputDir=docs, showCode=false);
      disp(doc_fn)
    end
  end
end

end
