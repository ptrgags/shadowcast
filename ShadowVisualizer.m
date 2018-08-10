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
        links cell;
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
        
        % Link light -> shape -> surface triples
        % by passing in the indices
        function add_link(obj, light, shape, surface)
            row = length(obj.links) + 1;
            obj.links{row, 1} = light;
            obj.links{row, 2} = shape;
            obj.links{row, 3} = surface;
        end
        
        function plot(obj)
            obj.setup_plot;
            obj.plot_shadows;
            obj.plot_surfaces;
            obj.plot_lights;
            %obj.plot_rays;
            %obj.plot_cutouts;
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