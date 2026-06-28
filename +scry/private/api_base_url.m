function url = api_base_url()
%API_BASE_URL  Base URL of the local ScryLab REST API.
%   The desktop app always serves on 127.0.0.1:5678.

    url = 'http://127.0.0.1:5678';
end
