function package()
%PACKAGE  Build ScryLab.mltbx

    root = fileparts(mfilename('fullpath'));

    % Stable ID so rebuilds update the same File Exchange entry.
    identifier = "c9805f8b-6ff1-46ce-8c26-c301341e3131";

    opts = matlab.addons.toolbox.ToolboxOptions(root, identifier);

    opts.ToolboxName    = "ScryLab";
    opts.ToolboxVersion = "0.1.0";
    opts.AuthorName     = "ScryLab";
    opts.AuthorEmail    = "support@scrylab.de";
    opts.AuthorCompany  = "ScryLab";
    opts.Summary        = "Plot signals from MATLAB in a running ScryLab GUI via its REST API.";
    opts.Description     = "MATLAB wrapper for the ScryLab REST API. Plot signals " + ...
        "in a running ScryLab GUI from scripts or simulation pipelines.";

    opts.ToolboxFiles      = fullfile(root, ["+scry", "README.md", "LICENSE"]);
    opts.ToolboxMatlabPath = root;
    opts.MinimumMatlabRelease = "R2023a";
    opts.OutputFile = fullfile(root, "ScryLab.mltbx");

    matlab.addons.toolbox.packageToolbox(opts);
    fprintf("Built %s\n", opts.OutputFile);
end
