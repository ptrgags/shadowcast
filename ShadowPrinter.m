classdef ShadowPrinter < handle
    properties
        shadows cell
        surface Quad
    end
    methods
        function obj = ShadowPrinter(shadows, surface)
            obj.shadows = shadows;
            obj.surface = surface;
        end
        
        function print(obj, fname)
            writer = ShapeWriter(fname);
            shadows_2d = obj.flatten_shadows;
            for i = 1:length(shadows_2d)
                comment = sprintf('Card Shadow %d', i);
                writer.write_shape(shadows_2d{i}, comment);
            end
            writer.finish;
        end
        
        function shadows_2d = flatten_shadows(obj)
            shadows_3d = obj.shadows;
            N = length(shadows_3d);
            shadows_2d = cell(N, 1);
            for i = 1:N
                shadow = shadows_3d{i};
                shadows_2d{i} = obj.surface.to_uv(shadow);
            end
        end
    end
end