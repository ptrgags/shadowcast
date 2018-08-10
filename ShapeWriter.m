% Class to write shapes to a PostScript file.
classdef ShapeWriter
    properties
        ps_file;
    end
    
    methods
        function obj = ShapeWriter(fname)
            ps_file = fopen(fname, 'w');
            
            % Write the preamble 
            fprintf(ps_file, '%%!PS\n');
            fprintf(ps_file, '/inch {72 mul} def\n');
            fprintf(ps_file, '1 inch 1 inch translate\n');
            
            obj.ps_file = ps_file;
        end
        
        function finish(obj)
            % Write the final showpage command
            fprintf(obj.ps_file, '\nshowpage\n');
            
            % Close the file
            fclose(obj.ps_file);
        end
    end
end

