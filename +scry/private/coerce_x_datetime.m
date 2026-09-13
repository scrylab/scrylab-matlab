function [x_out, x_epoch] = coerce_x_datetime(x)
%COERCE_X_DATETIME  Convert a datetime x to elapsed seconds + Unix epoch.
%   Numeric x is returned unchanged with an empty x_epoch. Unzoned datetimes
%   are treated as UTC.

    x_out = x;
    x_epoch = [];
    if isdatetime(x) && ~isempty(x)
        x0 = x(1);
        x_out = seconds(x - x0);
        x_epoch = posixtime(x0);
    end
end
