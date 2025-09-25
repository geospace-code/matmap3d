function plan = buildfile

plan = buildplan(localfunctions);

if ~isMATLABReleaseOlderThan("R2024a")
  plan("coverage") = matlab.buildtool.tasks.TestTask(Description="code coverage", SourceFiles="test", Strict=false, CodeCoverageResults="code-coverage.xml");
end

end


function testTask(context)
r = runtests(fullfile(context.Plan.RootFolder, "test"), Strict=false);
% Parallel Computing Toolbox takes more time to startup than is worth it for this task

assert(~isempty(r), "No tests were run")
assertSuccess(r)
end



function checkTask(context)
root = context.Plan.RootFolder;

c = codeIssues(root, IncludeSubfolders=true);

if isempty(c.Issues)
  fprintf('%d files checked OK with %s under %s\n', numel(c.Files), c.Release, root)
else
  disp(c.Issues)
  error("Errors found in " + join(c.Issues.Location, newline))
end

end


function publishTask(context)
outdir = fullfile(context.Plan.RootFolder, "docs");

publish_gen_index_html("matmap3d", ...
    "Geographic coordinate tranformation functions for Matlab.", ...
    "https://github.com/geospace-code/matmap3d", ...
    outdir)
end
