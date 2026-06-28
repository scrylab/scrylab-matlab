function signal_ids = upload_batch(base_url, ys, xs, zs, metas)
%UPLOAD_BATCH  Save signals as .mat files and POST to /api/signals/upload_batch.

    import matlab.net.*
    import matlab.net.http.*
    import matlab.net.http.io.*

    n         = numel(ys);
    tmp_paths = cell(1, n);
    cleanup   = onCleanup(@() delete_temps(tmp_paths));

    for i = 1:n
        tmp_paths{i} = [tempname '.mat'];
        save_signal_mat(tmp_paths{i}, ys{i}, xs{i}, zs{i});
    end

    % A FileProvider array repeats the 'file' field once per element.
    fps      = FileProvider(string(tmp_paths));
    provider = MultipartFormProvider('file', fps, 'meta', jsonencode(metas));

    req  = RequestMessage('POST', [], provider);
    opts = HTTPOptions('ConnectTimeout', 30, 'ResponseTimeout', 60);

    try
        resp = req.send(URI([char(base_url) '/api/signals/upload_batch']), opts);
    catch e
        error('scrylab:connectionError', ...
              'ScryLab desktop app is not running or unreachable – download it at https://scrylab.de/download.\n(%s)', ...
              e.message);
    end

    if resp.StatusCode ~= StatusCode.OK
        err_msg = '';
        try, err_msg = resp.Body.Data.error; catch, end
        error('scrylab:apiError', 'ScryLab error (%d): %s', double(resp.StatusCode), err_msg);
    end

    result = resp.Body.Data;
    if ~isstruct(result) || ~isfield(result, 'result')
        error('scrylab:parseError', 'Unexpected response from /api/signals/upload_batch.');
    end

    errors = result.result.errors;
    if isstruct(errors) && ~isempty(errors)
        details = arrayfun(@(e) sprintf('#%d: %s', e.index, e.error), errors, 'UniformOutput', false);
        error('scrylab:apiError', '%d signal(s) failed:\n%s', numel(errors), strjoin(details, '\n'));
    end

    signals    = result.result.signals;
    signal_ids = cell(1, n);
    if isstruct(signals)
        for i = 1:numel(signals)
            signal_ids{i} = signals(i).signal_id;
        end
    end
end


function save_signal_mat(path, y_in, x_in, z_in)
    % Variable names must be y/x/z – the backend reads them by name.
    y    = double(y_in);  %#ok<NASGU>
    vars = {'y'};
    if ~isempty(x_in), x = double(x_in); vars{end+1} = 'x'; end  %#ok<NASGU>
    if ~isempty(z_in), z = double(z_in); vars{end+1} = 'z'; end  %#ok<NASGU>
    save(path, vars{:}, '-v7');
end

function delete_temps(paths)
    for i = 1:numel(paths)
        if ~isempty(paths{i}) && exist(paths{i}, 'file')
            try, delete(paths{i}); catch, end
        end
    end
end
