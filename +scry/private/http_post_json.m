function data = http_post_json(base_url, path, body)
%HTTP_POST_JSON  POST JSON body, returns decoded response struct.

    opts = weboptions('MediaType', 'application/json', 'ContentType', 'json', 'Timeout', 30);
    try
        data = webwrite([base_url path], body, opts);
    catch e
        error('scrylab:connectionError', ...
              'ScryLab desktop app is not running or unreachable – download it at https://scrylab.de/download.\n(%s)', ...
              e.message);
    end
end
