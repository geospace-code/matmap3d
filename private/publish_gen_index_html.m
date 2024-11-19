%% PUBLISH_GEN_INDEX_HTML  generate index.html for package docs
% publish (generate) docs from Matlab project
% called from buildfile.m
%
% Ref:
% * https://www.mathworks.com/help/matlab/ref/publish.html
% * https://www.mathworks.com/help/matlab/matlab_prog/marking-up-matlab-comments-for-publishing.html
%
% for package code -- assumes no classes and depth == 1
function publish_gen_index_html(pkg_name, tagline, outdir)

pkg = what("+" + pkg_name);
% "+" avoids picking up cwd of same name
assert(~isempty(pkg), pkg_name + " is not detected as a Matlab directory or package")

%% generate docs
readme = fullfile(outdir, "index.html");

if ~isfolder(outdir)
  mkdir(outdir);
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
doc_fn = publish(pkg_name + "." + name, evalCode=false, outputDir=outdir);
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
