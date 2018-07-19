function T=interpMatrix(kernel, origin, numCtrlPoints, CtrlPointSep, extraprule)
% INTERPMATRIX - This function creates a sparse Toeplitz-like matrix representing 
% a regularly-spaced interpolation operation between a set of control points. The 
% user can specify the interpolation kernel, the number of control points, the
% spacing between the control points, and certain boundary conditions governing  
% the behavior at the first and last control point. 
%
% The tool has obvious applications to interpolation, curve fitting, and signal 
% reconstruction. More generally, the ability to represent interpolation as a 
% matrix is useful for minimizing cost functions involving interpolation operations.
% For such functions, the interpolation matrix and its transpose inevitably arise
% in the gradient.
% 
% Although the matrix generated by interpMatrix() is for 1D interpolation, it can be
% generalized to n-dimensional tensorial interpolation using kron(). However, a more
% efficient alternative to kron() is this tool,
% 
% http://www.mathworks.com/matlabcentral/fileexchange/25969-efficient-object-oriented-kronecker-product-manipulation
% 
%USAGE:
%
%
%  T=interpMatrix(kernel, origin, numCtrlPoints, CtrlPointSep, extraprule)
%
%out:
%
%     T: sparse output matrix. The columns of T are copies of a common interpolation
%        kernel (with adjustments for boundary conditions), but  shifted in
%        increments of the CtrlPointSep parameter (see below) to different control
%        point locations. The result is that if x is a vector of coefficients,         
%        then T*x is the interpolation of these coefficients on the interval 
%        enclosed by the control points.
% 
%
%in:
%
%  kernel: vector containing samples of an interpolation function, shifted copies 
%          of which will be used to create the columns of T. This vector never
%          needs to be zero-padded. Zero-padding is derived automatically from  
%          the other input arguments below.
%
%  origin: Index i such that kernel(i) is located at the first control point.
%          It is also possible to specify the origin using the following
%          string options:
%
%            'max': origin i will be selected where kernel(i) is maximized.
%            'ctr': origin i will be selected as ceil((length(kernel)+1)/2)
%
%  numCtrlPoints: number of control points in the system.
%
%  CtrlPointSep: a stricly positive integer indicating the number of samples between
%                control points. Default=1.
%
%  extraprule: String argument. Initially, the shifted copies of "kernel" form 
%            the columns of T. The columns are then modified to satisfy edge conditions
%            indicated by the "extraprules" parameter (options for this parameter
%            are discussed below).
%
%
%Choices of extraprule
%-------------------------
%
%The following 4 choices of extraprule result in a matrix T of size MxN where
%N=numCtrlPoints and M=(numCtrlPoints-1)*CtrlPointSep+1.
% 
%'zero' (default) - Extrapolation with zeroes. The columns of T are initially
%                   linear shifted copies of the kernel samples. Rows
%                   from the top and bottom of T are then discarded
%                   so that T(1,:)*x is the interpolated value at the 1st
%                   control point, for some coefficient vector x, while T(end,,:)*x 
%                   is the interpolated value at the last control point. 
%                   When CtrlPointSep=1, the resulting matrix T is a Toeplitz matrix.
%                  
%                   Equivalently, this means that T*x gives the same result as if there
%                   were infinite control points and if the coefficient vector x
%                   were extrapolated with zeros, i.e.,  x(i)=0 for i<=1 and for i>=N.
%
%
%'circ'           - Similar to 'zero' except the columns are related by a
%                   circulant shift of the kernel samples. When CtrlPointSep=1, 
%                   T is a circulant matrix.
%
%
%'rep'            - Extrapolation by replication. This option is the same as 'zero' 
%                   except that the first and final columns of T are modified.
%                   The modification is such that T*x gives the same result
%                   as if there were infinite control points and under the assumption                   
%                   that the coefficient vector x is extrapolated so 
%                   that x(i)=x(1) for i<=1 and x(i)=x(N) for i>=N.
%
%
%'mirror'         - Extrapolation by mirroring. Similar to 'rep' except the 
%                   extrapolation of x(i) uses mirroring at the array
%                   boundaries instead of replication. 
%
%
%The final option for the extraprule parameter is 'allcontrib', which is different from the
%other options in that the output matrix T has more columns:
%
%
%'allcontrib'       - This option adds control points to the system,
%                     with corresponding additional columns in T, 
%                     such that all control points that can affect the interval,                     
%                     Q, enclosed by the initial set of control points are now
%                     included. 
%
%                     As before, however, T(1,:)*x is the interpolated value at the 1st
%                     sample point in Q, while T(end,,:)*x is the interpolated value
%                     at the last sample point in Q. 
%
%
% 
%Copyright 2005, Matt Jacobson, The University of Michigan 


if nargin<5
 extraprule='zero';
else
 extraprule=strrep(lower(extraprule),' ',''); %shouldn't contain spaces
end

if ~any(ismember(extraprule,{'zero','rep','mirror','circ','allcontrib'}))
   error 'Unrecognized extraprule selection.' 
end

if nargin<4,
 CtrlPointSep=1;
end

if ischar(origin)
    
    switch origin
       
        case 'max'
        
            [~,origin]=max(kernel);
            
        case 'ctr'
            
            origin = ceil( (length(kernel)+1)/2 );
            
        otherwise
            error 'Unrecognized option for "origin"'
    end
    
end

%%


kernel=kernel(:);
causal=kernel(origin:end);
anticausal=kernel(1:origin-1);

lenkernel=length(kernel);
lencausal=length(causal);
lenanticausal=length(anticausal);



if ~isequal(extraprule,'circ')
    


  extraleft=floor((lencausal-1)/CtrlPointSep);
  extraright=floor(lenanticausal/CtrlPointSep);

  numCtrlPoints=numCtrlPoints+extraleft+extraright;

  T=cell(1,numCtrlPoints);

  len=CtrlPointSep*(numCtrlPoints-1)+lenkernel;
  prototype=col0s(len);
  prototype(1:lenkernel)=kernel;


  T=rawMatrix(prototype, CtrlPointSep,numCtrlPoints);
  
  
  
    aa=extraleft*CtrlPointSep+origin;
    bb=aa+(numCtrlPoints-extraleft-extraright-1)*CtrlPointSep;
  
   if isequal(extraprule,'rep')


     xx=col1s(numCtrlPoints); 
     xx(extraleft+2:end)=0;


     yy=col1s(numCtrlPoints); 
     yy(1:end-(extraright)-1)=0;


     xx=T*xx;     yy=T*yy;
     T=T(:,extraleft+1 : end-extraright);
    
     T(:,1)=xx; T(:,end)=yy;    


   elseif isequal(extraprule,'zero') %ZERO-PADDED (TEOPLITZ) END CONDTIONS

      T=T(:,extraleft+1 : end-extraright);


   elseif isequal(extraprule,'mirror') %MIRROR END CONDTIONS

       
     Tc=T(:,extraleft+1 : end-extraright);  
       
     mod1b=@(i,N) mod(i-1,N)+1; %1-based index modulus
     IndexMap=@(i,N) round( (1-abs(  (mod1b(i,2*N) -(N+.5)  )/(N+.5) ) )*(N+.5));
       
     colAxis=(1:numCtrlPoints)-extraleft;
     
     nn=size(Tc,2);
     mappedCols=IndexMap(colAxis,nn);
    
     V=bsxfun(@eq,  mappedCols.' , (1:nn) );
    
     T=T*V;


   end


     T=T(aa:bb , :);



else %CIRCULANT END CONDITIONS

    L=CtrlPointSep*(numCtrlPoints-1)+1;
      

                %   prototype=col0s(L); 
                %      p2=prototype;
                % 
                %   prototype(1:lencausal)=causal;
                %     p2(end+1-lenanticausal:end)=anticausal;
                % 
                %   prototype=prototype+p2;  


       
        mod1b=@(t) mod(t-1,L)+1;
        
        prototype=accumarray(mod1b(1-lenanticausal:lencausal).', kernel(:),[L,1]);
        


      T=rawMatrix(prototype, CtrlPointSep,numCtrlPoints);
  

  
end

T=sparse(T);



function c=col0s(nn)

    c=sparse(nn,1);
    %c=zeros(nn,1);


function c=col1s(nn)

    c=ones(nn,1);
    
    
function T=rawMatrix(prototype, CtrlPointSep,numCtrlPoints)

    N=length(prototype);
    mod1b=@(t) mod(t-1,N)+1;
  
    [ii,jj,ss]=find(prototype(:));
    
    nn=length(ii);
    
    II=repmat(ii,1,numCtrlPoints);
       II=mod1b(bsxfun(@plus,II,(0:numCtrlPoints-1)*CtrlPointSep));
    JJ=repmat(1:numCtrlPoints,nn,1);   
    SS=repmat(ss,1,numCtrlPoints);
    
 
    T=sparse(II(:),JJ(:),SS(:));
