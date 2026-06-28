function name = default_name(name, index)
%DEFAULT_NAME  Return name, or "Unnamed Signal <index>" if blank.

    if isempty(name)
        name = sprintf('Unnamed Signal %d', index);
    end
end
