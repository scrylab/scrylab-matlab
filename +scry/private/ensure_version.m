function ensure_version(base_url)
%ENSURE_VERSION  Verify the running ScryLab app is new enough.
%   Checks once per base_url; subsequent calls return immediately.

    min_version = '0.1.10';

    persistent checked_url
    if strcmp(checked_url, base_url), return; end

    data    = http_get(base_url, '/api/status');
    app_ver = data.version;

    if version_lt(app_ver, min_version)
        error('scrylab:versionError', ...
              'ScryLab v%s is too old – please update to v%s or later.', app_ver, min_version);
    end

    checked_url = base_url;
end

function tf = version_lt(a, b)
    pa = sscanf(a, '%d.', [1 Inf]);
    pb = sscanf(b, '%d.', [1 Inf]);
    n  = max(numel(pa), numel(pb));
    pa(end+1:n) = 0;
    pb(end+1:n) = 0;
    tf = false;
    for i = 1:n
        if pa(i) < pb(i), tf = true; return; end
        if pa(i) > pb(i), return; end
    end
end
