function s=parse_named_args(v,s,invalid_err,standalone)

%  S=parse_named_args(V,S_IN[,INVALID_ERR,STANDALONE])
%
%  Parse named arguments V into the structure S for use in a
%  function with optional named arguments. When a arguments is not in
%  V, the default value from S_IN is used.
%
%  String arguments are parsed using str2num, unless the default value is
%  also a string. This is convenient for parsing arguments in standalone
%  applications.
%
%  If INVALID_ERR=true, an error is produced if an option name is not found
%  in S_IN. This is the default behavior if INVALID_ERR is omitted.
%
%  If STANDALONE=true, 
%
%  For the options in 
%
%  Example function:
%  function out=myfunction(a,b,varargin)
%  s.name='anonymous';
%  s.multiplier=1;
%  s=parse_named_args(varargin,s);
%  y=a*b;
%  y=s.multiplier*y;
%  out=[s.name ' : ' num2str(y)];
%
%  Example function calls:
%  myfunction(6,2)
%  myfunction(6,2,'multiplier',1.5)
%  myfunction(6,2,'name','Marion','multiplier',1.5)
%  Alternatively, the last call can also be done like this:
%  s.name='Marion';
%  s.multiplier=1.5;
%  myfunction(6,2,'name','Marion','multiplier',1.5)
%
%  See also: str2num.

if ~nargin
    help parse_named_args
    return
end

if isempty(v)
    % Just return s as is.
    return
end

if nargin<4
    standalone=false;
    if nargin<3
        invalid_err=true;
    end
end

% Convert arguments v to structure s_add
if isstruct(v)
    % If v is a structure itself, just copy it.
    s_add=v;
else
    if isstruct(v{1})
        % s_add struct is first entry in cell array v
        s_add=v{1};
        standalone=false;
    else
        % 'arg1',arg1,'arg2',arg2 format

        % If all arguments are strings, the arguments are potentially
        % from the command line of a standalone executable.
        standalone=standalone && all(cellfun(@ischar,v));

        for iv=1:length(v)
            if iscell(v{iv})
                % Put cell arguments into cell for correct
                % parsing by 'struct' function.
                v{iv}={v{iv}};
            end
        end
        s_add=struct(v{:});
    end
end

% Add s_add to s
for fn_cc=fieldnames(s_add)'
    fn_c=fn_cc{1};
    % Check if option name is valid
    if invalid_err && ~isfield(s,fn_c)
        error('BIOSIGNAL:wrongArguments',[fn_c ' is an invalid option name.'])
    end
    val_c=s_add.(fn_c);
    % Convert arguments in case of options from standalone executable
    if isfield(s,fn_c)
        if standalone && ~ischar(s.(fn_c))
            val_c=str2num(val_c); %#ok<ST2NM>
        end
    end
    
    s.(fn_c)=val_c;
end
