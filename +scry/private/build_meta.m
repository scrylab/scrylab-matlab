function meta = build_meta(name, source_id, y_unit, x_unit, z_unit, overwrite, x_epoch)
%BUILD_META  Assemble the meta struct for an upload request.
%   x_epoch: date-axis anchor, Unix seconds UTC at x=0, or [].

    meta = struct('name', name, 'target_source_id', source_id);

    if ~isempty(y_unit), meta.y_unit = y_unit; end
    if ~isempty(x_unit), meta.x_unit = x_unit; end
    if ~isempty(z_unit), meta.z_unit = z_unit; end
    if ~isempty(x_epoch), meta.x_epoch = x_epoch; end
    if overwrite,        meta.overwrite = true; end
end
