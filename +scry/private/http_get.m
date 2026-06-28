function data = http_get(base_url, path)
%HTTP_GET  GET request, returns decoded JSON as struct.

    opts = weboptions('ContentType', 'json', 'Timeout', 30);
    try
        data = webread([base_url path], opts);
    catch e
        error('scrylab:connectionError', ...
              'ScryLab desktop app is not running or unreachable – download it at https://scrylab.de/download.\n(%s)', ...
              e.message);
    end
end
