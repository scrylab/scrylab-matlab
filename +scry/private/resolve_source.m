function source_id = resolve_source(base_url, source_name)
%RESOLVE_SOURCE  Return source_id for source_name, creating it if needed.

    ensure_version(base_url);

    data    = http_get(base_url, '/api/sources');
    sources = data.result;

    for i = 1:numel(sources)
        if strcmp(sources(i).name, source_name)
            source_id = sources(i).source_id;
            return
        end
    end

    resp      = http_post_json(base_url, '/api/sources', struct('name', source_name));
    source_id = resp.result.source_id;
end
