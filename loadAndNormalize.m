function [MM, normalized, minVal] = loadAndNormalize(filename)
    temp = load(filename);
    fn = fieldnames(temp);
    MM = temp.(fn{1});
    MM = rot90(MM, 3);
    minVal = min(MM(:));
    normalized = MM - minVal;
end