function plan = buildfile

plan = buildplan();

plan.DefaultTasks = "test";

pkg_name = "+matmap3d";

if isMATLABReleaseOlderThan("R2023b")
  plan("test") = matlab.buildtool.Task(Actions=@legacy_test);
else
  plan("check") = matlab.buildtool.tasks.CodeIssuesTask(pkg_name, IncludeSubfolders=true, ...
    WarningThreshold=0);
  plan("test") = matlab.buildtool.tasks.TestTask("test", Strict=false);
end

if ~isMATLABReleaseOlderThan("R2024a")
  plan("coverage") = matlab.buildtool.tasks.TestTask(Description="code coverage", SourceFiles="test", Strict=false, CodeCoverageResults="code-coverage.xml");
end

plan("publish") = matlab.buildtool.Task(Description="HTML inline doc generate", Actions=@publish_html);


end


function legacy_test(context)
r = runtests(fullfile(context.Plan.RootFolder, "test"), Strict=false);
% Parallel Computing Toolbox takes more time to startup than is worth it for this task

assert(~isempty(r), "No tests were run")
assertSuccess(r)
end


function publish_html(context)
  outdir = fullfile(context.Plan.RootFolder, "docs");

  publish_gen_index_html("matmap3d", ...
    "Geographic coordinate tranformation functions for Matlab.", ...
    "https://github.com/geospace-code/matmap3d", ...
    outdir)
end
