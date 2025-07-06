function plan = buildfile

plan = buildplan(localfunctions);

plan.DefaultTasks = "test";

pkg_name = "+matmap3d";

plan("check") = matlab.buildtool.tasks.CodeIssuesTask(pkg_name, Results="CodeIssues.sarif", ...
  IncludeSubfolders=true, WarningThreshold=0);
plan("test") = matlab.buildtool.tasks.TestTask("test", TestResults="TestResults.xml", Strict=false);

if ~isMATLABReleaseOlderThan("R2024a")
  plan("coverage") = matlab.buildtool.tasks.TestTask(Description="code coverage", SourceFiles="test", Strict=false, CodeCoverageResults="code-coverage.xml");
end

end


function publishTask(context)
% publish HTML inline documentation strings to individual HTML files
outdir = fullfile(context.Plan.RootFolder, 'docs');

publish_gen_index_html("matmap3d", ...
    "Geographic coordinate tranformation functions for Matlab.", ...
    "https://github.com/geospace-code/matmap3d", ...
    outdir)
end
