classdef Quad
    properties
        center double;
        orientation double;
        dims double;
    end
    methods
        % Center [x, y, z]
        % orientation [azimuth, elevation]
        % dimensions [width, height]
        function obj = Quad(center, orientation, dims)
            obj.center = center;
            obj.orientation = orientation;
            obj.dims = dims;
        end
        
        % Calculate a vector normal to the surface
        function n = normal(obj)
            azimuth = obj.orientation(1);
            elevation = obj.orientation(2);
            n = make_normal(azimuth, elevation);
        end
        % Vertices of a card centered at the origin facing down
        % the x-axis
        function X = raw_vertices(obj)
            w = obj.dims(1);
            h = obj.dims(2);
            left = -w / 2;
            right = w / 2;
            top = h / 2;
            bottom = -h / 2;
            
            X = [
                0, left, top;
                0, right, top;
                0, right, bottom;
                0, left, bottom
            ];
        end
        % Rotation matrix for ROW vectors. This gets applied on the
        % RIGHT of the points, not the left
        function R = rot_matrix(obj)
            azimuth = obj.orientation(1);
            elevation = obj.orientation(2);
            R = rotate_z(azimuth) * rotate_y(-elevation);
            R = R';
        end
        % Calculate the corners of the card in world space
        function X = vertices(obj)
            X = obj.raw_vertices * obj.rot_matrix + obj.center;
        end
    end
end