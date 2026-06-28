function send_many(y, options)
%SEND_MANY  Send multiple signals to ScryLab at once.
%
%   scry.send_many(y)
%   scry.send_many(y, Name=Value, ...)
%
%   y must be a cell array of numeric arrays; each cell is one signal.
%
%   Parameters (Name=Value)
%   ---
%   names     Cell array of signal names, one per signal (default: auto)
%   source    Data source name (default: "Sent from API")
%   x         Single x-axis vector broadcast to all signals, or cell array
%   z         Single 2D spectrogram broadcast to all signals, or cell array
%   y_unit    Single unit string or cell array, one per signal
%   x_unit    Single unit string or cell array, one per signal
%   z_unit    Single unit string or cell array, one per signal
%   overwrite Replace existing signals with the same name (default: false)
%
%   Example
%   ---
%   t = linspace(0, 1, 1000);
%   scry.send_many({sin(2*pi*5*t), cos(2*pi*5*t)}, ...
%       names={"Sine", "Cosine"}, y_unit="V", x_unit="s", x=t)

    arguments
        y
        options.names                   = {}
        options.source    (1,1) string  = "Sent from API"
        options.x                       = {}
        options.z                       = {}
        options.y_unit                  = ""
        options.x_unit                  = ""
        options.z_unit                  = ""
        options.overwrite (1,1) logical = false
    end

    if ~iscell(y)
        error('scrylab:invalidInput', 'y must be a cell array of numeric arrays.');
    end
    n = numel(y);
    if n == 0
        return
    end

    base_url  = api_base_url();
    source_id = resolve_source(base_url, char(options.source));

    names   = broadcast_names(options.names, n);
    xs      = broadcast_val(options.x, n);
    zs      = broadcast_val(options.z, n);
    y_units = broadcast_str(options.y_unit, n);
    x_units = broadcast_str(options.x_unit, n);
    z_units = broadcast_str(options.z_unit, n);

    ys_dbl = cellfun(@double, y, 'UniformOutput', false);
    metas  = cellfun(@(name, yu, xu, zu) ...
        build_meta(name, source_id, yu, xu, zu, options.overwrite), ...
        names, y_units, x_units, z_units, 'UniformOutput', false);

    upload_batch(base_url, ys_dbl, xs, zs, metas);
end


function out = broadcast_val(val, n)
    if isempty(val) || (isnumeric(val) && ~iscell(val))
        out = repmat({val}, 1, n);
    elseif iscell(val) && numel(val) == n
        out = val;
    else
        error('scrylab:invalidInput', 'x/z must be a single value or a cell array of length n.');
    end
end

function out = broadcast_str(val, n)
    if isstring(val) || ischar(val)
        out = repmat({char(val)}, 1, n);
    elseif iscell(val) && numel(val) == n
        out = cellfun(@char, val, 'UniformOutput', false);
    else
        error('scrylab:invalidInput', 'units must be a single string or a cell array of length n.');
    end
end

function out = broadcast_names(val, n)
    if isempty(val)
        out = arrayfun(@(i) sprintf('Unnamed Signal %d', i), 1:n, 'UniformOutput', false);
    elseif iscell(val) && numel(val) == n
        out = cellfun(@char, val, 'UniformOutput', false);
    else
        error('scrylab:invalidInput', 'names must be a cell array of length n.');
    end
end
