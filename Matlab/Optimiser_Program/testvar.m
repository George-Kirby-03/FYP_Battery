acceptVariableNumInputs(4,ones(3),'some text',pi)
handle = @(varargin) acceptVariableNumInputs(4, varargin{:});
handle(ones(3),'some text',pi)
function acceptVariableNumInputs(in, varargin)
    disp("Number of input arguments: " + nargin)
    celldisp(varargin)
    in
end