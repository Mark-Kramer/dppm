function out = method2str(method)
% example: method = struct('name', 'mmm', 'gamma', 1, 'omega', 1)
% method2str(method) returns: 'mmm_1-1'

out = [method.name '_']; %#ok<*AGROW>
method = rmfield(method, 'name');
fld = fieldnames(method);
for i = 1:length(fld)
    val = method.(fld{i});
    if isnumeric(val) || islogical(val)
        val = num2str(val);
    end
    if i > 1
        out = [out '-']; 
    end
    out = [out val];
end

end
