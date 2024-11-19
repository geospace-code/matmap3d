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
  cwd = fileparts(mfilename('fullpath'));

  coverage_run("matmap3d", fullfile(cwd, "test"))
end

function publishTask(~)
  cwd = fileparts(mfilename('fullpath'));
  outdir = fullfile(cwd, "docs");

  publish_gen_index_html("matmap3d", ...
    "Geographic Map coordinate transform functions for Matlab", ...
    outdir)
end
