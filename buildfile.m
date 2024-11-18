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
  % https://www.mathworks.com/help/matlab/ref/publish.html
  % https://www.mathworks.com/help/matlab/matlab_prog/marking-up-matlab-comments-for-publishing.html
  %
  % for package code -- assumes no classes and depth == 1
  pkg_name = "matmap3d";
  tagline = "Geographic Map coordinate transform functions for Matlab";

  pkg = what("+" + pkg_name);
  % "+" avoids picking up cwd of same name

  %% generate docs
  cwd = fileparts(mfilename('fullpath'));
  docs = fullfile(cwd, "docs");
  readme = fullfile(docs, "index.html");

  if ~isfolder(docs)
    mkdir(docs);
  end

  txt = ["<!DOCTYPE html> <head> <title>" + pkg_name + " API</title> <body>", ...
         "<h1>" + pkg_name + " API</h1>", ...
         tagline, ...
         "<h2>API Reference</h2>"];
  fid = fopen(readme, 'w');
  fprintf(fid, join(txt, "\n"));

  for sub = pkg.m.'
    s = sub{1};
    [~, name] = fileparts(s);
    doc_fn = publish(pkg_name + "." + name, evalCode=false, outputDir=docs);
    disp(doc_fn)
    % inject summary into Readme.md
    summary = split(string(help(pkg_name + "." + name)), newline);
    words = split(strip(summary(1)), " ");
    % purposefully this will error if no docstring
    fname = words(1);
    if(lower(fname) ~= lower(name))
      error("fname %s does not match name %s", fname, name)
    end
    line = "<a href=" + name + ".html>" + fname + "</a> ";
    if(length(words) > 1)
      line = line + join(words(2:end));
    end
    fprintf(fid, line + "<br>\n");
  end

  fprintf(fid, "</body> </html>");

  fclose(fid);

  end
