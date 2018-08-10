classdef Quad
    properties (Constant)
        % vertex indices in Quad.vertices matrix.
        TOP_LEFT = 1;
        TOP_RIGHT = 2;
        BOTTOM_RIGHT = 3;
        BOTTOM_LEFT = 4;
    end
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
        
        % Find the bottom left corner of the card in world space
        function result = origin(obj)
            points = obj.vertices;
            result = points(obj.BOTTOM_LEFT, :);
        end
        
        % Compute unit vectors for the card's UV space from the bottom
        % left corner
        % This returns a 3x2 3D -> 2D projection matrix from
        % world space to UV space. 
        % NOTE: This is not a normalized UV space like in texture
        % mapping! It is just a set of coordinates measured across
        % the card.
        function vecs = uv_basis(obj)
            points = obj.vertices;
            corners = points([obj.BOTTOM_RIGHT, obj.TOP_LEFT], :);
            vecs = calc_directions(obj.origin, corners)';
        end
       
        % Project coordinates from world space -> UV space
        function uv = to_uv(obj, points)
            uv = (points - obj.origin) * obj.uv_basis;
        end
        
        % Get the coordinates of the 
        function uv = vertices_uv(obj)
            uv = obj.to_uv(obj.vertices);
        end
    end
end