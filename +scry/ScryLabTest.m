classdef ScryLabTest < matlab.unittest.TestCase
%SCRYLABTEST  Unit tests for the ScryLab MATLAB client.
%
%   Exercises the package's private helpers directly (no server needed).
%   End-to-end sending is verified manually against a running ScryLab GUI.
%
%   Run:
%       results = runtests('scry.ScryLabTest');
%       disp(results)

    methods (Test)

        function test_default_name_blank(tc)
            name = default_name('', 3);
            tc.verifyEqual(name, 'Unnamed Signal 3');
        end

        function test_default_name_kept(tc)
            name = default_name('My Signal', 1);
            tc.verifyEqual(name, 'My Signal');
        end

        function test_build_meta_minimal(tc)
            meta = build_meta('Speed', 'src-123', '', '', '', false);
            tc.verifyEqual(meta.name, 'Speed');
            tc.verifyEqual(meta.target_source_id, 'src-123');
            tc.verifyFalse(isfield(meta, 'y_unit'));
            tc.verifyFalse(isfield(meta, 'overwrite'));
        end

        function test_build_meta_with_units(tc)
            meta = build_meta('Voltage', 'src-456', 'V', 's', '', false);
            tc.verifyEqual(meta.y_unit, 'V');
            tc.verifyEqual(meta.x_unit, 's');
            tc.verifyFalse(isfield(meta, 'z_unit'));
        end

        function test_build_meta_overwrite(tc)
            meta = build_meta('Sig', 'src-1', '', '', '', true);
            tc.verifyTrue(meta.overwrite);
        end

    end

end
