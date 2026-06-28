function plot(y, options)
%PLOT  Send a signal to ScryLab and open it in a plot.
%
%   scry.plot(y)
%   scry.plot(y, Name=Value, ...)
%
%   Same parameters as scry.send except 'source' (always "Sent from API").
%   Creates a new plot if none exists.
%
%   Example
%   ---
%   t = linspace(0, 1, 1000);
%   scry.plot(sin(2*pi*5*t), name="Sine 5Hz", y_unit="V", x_unit="s", x=t)

    arguments
        y          {mustBeNumeric}
        options.name      (1,1) string  = ""
        options.x                       = []
        options.z                       = []
        options.y_unit    (1,1) string  = ""
        options.x_unit    (1,1) string  = ""
        options.z_unit    (1,1) string  = ""
        options.overwrite (1,1) logical = false
    end

    base_url  = api_base_url();
    name      = default_name(char(options.name), 1);
    source_id = resolve_source(base_url, 'Sent from API');
    meta      = build_meta(name, source_id, char(options.y_unit), char(options.x_unit), char(options.z_unit), options.overwrite);

    ids = upload_batch(base_url, {double(y)}, {options.x}, {options.z}, {meta});

    http_post_json(base_url, '/api/plot', struct('signal_id', ids{1}));
end
