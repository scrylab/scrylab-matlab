function meta = build_meta(name, source_id, y_unit, x_unit, z_unit, overwrite, options)
%BUILD_META  Assemble the meta struct for an upload request.
%   x_epoch/master_epoch: axis anchors, Unix seconds UTC.
%   x_domain/master_domain: declared quantities ('time'/'frequency'/...).
%   Empty values are omitted from the struct.

    arguments
        name
        source_id
        y_unit
        x_unit
        z_unit
        overwrite
        options.x_epoch       = []
        options.x_domain      = ''
        options.master_epoch  = []
        options.master_domain = ''
    end

    meta = struct('name', name, 'target_source_id', source_id);

    if ~isempty(y_unit), meta.y_unit = y_unit; end
    if ~isempty(x_unit), meta.x_unit = x_unit; end
    if ~isempty(z_unit), meta.z_unit = z_unit; end
    if ~isempty(options.x_epoch), meta.x_epoch = options.x_epoch; end
    if ~isempty(options.x_domain), meta.x_domain = options.x_domain; end
    if ~isempty(options.master_epoch), meta.master_epoch = options.master_epoch; end
    if ~isempty(options.master_domain), meta.master_domain = options.master_domain; end
    if overwrite, meta.overwrite = true; end
end
