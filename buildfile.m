function plan = buildfile

plan = buildplan(localfunctions);

addpath(plan.RootFolder)

pkg_name = "+matmap3d";

if ~isMATLABReleaseOlderThan("R2023b")
  plan("check") = matlab.buildtool.tasks.CodeIssuesTask(pkg_name, IncludeSubfolders=true, WarningThreshold=0);
  plan("test") = matlab.buildtool.tasks.TestTask("test", Strict=false);
end

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
