classdef ShadowVisualizer < handle
    properties (Constant)
        LIGHT = 1
        SHAPE = 2
        SURFACE = 3
    end
    properties
        lights cell;
        surfaces cell;
        shapes cell;
        shadows cell;
        cutouts cell;
        rays cell;
    end
    methods
        % Add a light to the list and return
        % its index
        function idx = add_light(obj, light)
            obj.lights{end + 1} = light;
            idx = length(obj.lights);
        end
        
        % Add a card/floor/wall to the list
        % and return its index
        function idx = add_surface(obj, surface, visible)
            idx = length(obj.surfaces) + 1;
            obj.surfaces{idx, 1} = surface;
            obj.surfaces{idx, 2} = visible;
        end
        
        % Add a shape to the list and return its index
        function idx = add_shape(obj, shape)
            obj.shapes{end + 1} = shape;
            idx = length(obj.shapes);
        end
        
        % Cast a shadow from light -> card -> surface
        % and store the resulting geometry
        function add_card_shadow(obj, light_idx, card_idx, surface_idx)
            light = obj.lights{light_idx};
            card = obj.surfaces{card_idx};
            surface = obj.surfaces{surface_idx};
            shadow = shadowcast(light, card.vertices, surface);
            obj.shadows{end + 1} = shadow;
        end
        
        function add_cutout(obj, light_idx, card_idx, shape)
            % Save the shape
            obj.add_shape(shape);
            
            % Shadowcast to calculate where the cutout is
            light = obj.lights{light_idx};
            card = obj.surfaces{card_idx};
            cutout = shadowcast(light, shape, card);
            obj.cutouts{end + 1} = cutout;
            
            % Also store the light rays
            obj.add_rays(light, shape);
        end
        
        function add_rays(obj, light, shape)
            N = size(shape, 1);
            % We're going to plot N line segments in 3D with 2 points each
            % but we need to rearrange the data for a call to plot3
            segments = zeros(2 * 3, N);
            % Put the shadow points in every other row. Note that
            % each point is now a spaced out column vector.
            segments(1:2:5, :) = shape';
            % interleave the light coordinates so every line is drawn
            % to the light source.
            segments(2:2:6, :) = repmat(light', 1, N);
            
            obj.rays{end + 1} = segments;
        end        
        
        function plot(obj)
            obj.setup_plot;
            obj.plot_shadows;
            obj.plot_surfaces;
            obj.plot_lights;
            obj.plot_rays;
            obj.plot_shapes;
            obj.plot_cutouts;
        end
        
        % Plot the shadows the card casts
        function plot_shadows(obj)
            for i = 1:length(obj.shadows)
                obj.fill_cols(obj.shadows{i}, 'b');
            end
        end
        
        % Plot the visible surfaces (cards where
        % the cutouts will appear)
        function plot_surfaces(obj)
            for i = 1:size(obj.surfaces, 1)
                [surface, visible] = obj.surfaces{i, :};
                if visible
                    obj.fill_cols(surface.vertices, 'w');
                end
            end
        end
        
        function plot_rays(obj)
            for i = 1:length(obj.rays)
                segments = obj.rays{i};
                % now plot the rays as line segments
                plot3(...
                    segments(1:2, :),...
                    segments(3:4, :),...
                    segments(5:6, :),...
                    'r');
            end
        end
        
        % Plot the shadows the card casts
        function plot_shapes(obj)
            for i = 1:length(obj.shapes)
                obj.fill_cols(obj.shapes{i}, 'w');
            end
        end
        
        function plot_cutouts(obj)
            for i = 1:length(obj.cutouts)
                obj.fill_cols(obj.cutouts{i}, [0.7, 0.7, 0.7]);
            end
        end
        
        % Plot points where the lights are
        function plot_lights(obj)
            for i = 1:length(obj.lights)
                obj.plot_cols(obj.lights{i}, 'or');
            end
        end
    end
    methods(Static)
        function setup_plot
            % Set up a 3D figure
            % with 1:1:1 aspect ratio
            % and enable rotation with the mouse
            figure;
            view(3);
            axis equal;
            rotate3d on;
            hold on;
            
            % Label the axes
            xlabel('X (in.)');
            ylabel('Y (in.)');
            zlabel('Z (in.)');
            
            % Make the background dark grey
            set(gca, 'color', [0.1, 0.1, 0.1]);
        end
        
        function plot_cols(X, varargin)
            plot3(X(:, 1), X(:, 2), X(:, 3), varargin{:});
        end
        
        function fill_cols(X, varargin)
            fill3(X(:, 1), X(:, 2), X(:, 3), varargin{:});
        end
    end
end