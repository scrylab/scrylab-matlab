function send(y, options)
%SEND  Send a signal to ScryLab without plotting.
%
%   scry.send(y)
%   scry.send(y, Name=Value, ...)
%
%   Parameters (Name=Value)
%   ---
%   name      Signal name (default: auto-generated)
%   source    Data source name, created if absent (default: "Sent from API")
%   x         X-axis values; auto-generated if omitted
%   z         Spectrogram matrix (2D); optional (1D color axis coming soon)
%   y_unit    Y-axis unit, e.g. "V"
%   x_unit    X-axis unit, e.g. "s"
%   z_unit    Z-axis unit, e.g. "dB"
%   overwrite Replace existing signal with the same name (default: false)
%
%   Example
%   ---
%   t = linspace(0, 1, 1000);
%   scry.send(sin(2*pi*5*t), name="Sine 5Hz", y_unit="V", x_unit="s", x=t)

    arguments
        y          {mustBeNumeric}
        options.name      (1,1) string  = ""
        options.source    (1,1) string  = "Sent from API"
        options.x                       = []
        options.z                       = []
        options.y_unit    (1,1) string  = ""
        options.x_unit    (1,1) string  = ""
        options.z_unit    (1,1) string  = ""
        options.overwrite (1,1) logical = false
    end

    base_url  = api_base_url();
    name      = default_name(char(options.name), 1);
    source_id = resolve_source(base_url, char(options.source));
    meta      = build_meta(name, source_id, char(options.y_unit), char(options.x_unit), char(options.z_unit), options.overwrite);

    upload_batch(base_url, {double(y)}, {options.x}, {options.z}, {meta});
end
