function h = imagescwithpcolor(varargin)
%  IMAGESCWITHPCOLOR produces a plot similar to imagesc but using the 
%  pcolor function (better for vector graphic exports)
%
%  H = IMAGESCWITHPCOLOR(VARARGIN)
%  Parameters: see IMAGESC
%  Returns: h = handle to the figure
%
%  Notes:
%      Draws a pcolor plot with the values of C at the cell centers
%      given by the locations in X and Y, using flat shading.
%      Inspired by cellCentPcolorFlat from Samuel A Isaacson (isaacson@math.bu.edu).
% 
%  Author: Louis Emmanuel Martinet [LEM] <louis.emmanuel.martinet@gmail.com>

clim = [];
xcoord = [];
ycoord = [];
switch (nargin),
  case 0,
    help imagescvector;
  case 1,
    grid = varargin{1};
  case 3,
    xcoord = varargin{1};
    ycoord = varargin{2};
    grid = varargin{3};    
  otherwise,

    % Determine if last input is clim
    if isequal(size(varargin{end}),[1 2])
      str = false(length(varargin),1);
      for n=1:length(varargin)
        str(n) = ischar(varargin{n});
      end
      str = find(str);
      if isempty(str) || (rem(length(varargin)-min(str),2)==0),
        clim = varargin{end};
        varargin(end) = []; % Remove last cell
      else
        clim = [];
      end
    else
      clim = [];
    end
    if length(varargin) > 1
        xcoord = varargin{1};
        ycoord = varargin{2};
    end
    grid = varargin{end};
end

if isempty(xcoord)
    xcoord = 1:size(grid, 2);
    ycoord = 1:size(grid, 1);
elseif any(size(xcoord) ~= size(ycoord))
    xcoord = xcoord';
end

xcoord = reshape(xcoord, 1, length(xcoord));
ycoord = reshape(ycoord, 1, length(ycoord));
if length(xcoord) > 1
    dx = xcoord(2)-xcoord(1);
else
    dx = 1;
end
if length(ycoord) > 1
    dy = ycoord(2)-ycoord(1);
else
    dy = 1;
end

% hack to get value at cell-center
dx = dx/2;
dy = dy/2;
x1 = [xcoord-dx xcoord(end)+dx];
y1 = [ycoord-dy ycoord(end)+dy];
C1 = grid([1:end end],[1:end end]);

hh = pcolor(x1, y1, C1); shading flat;
set(gca, 'ydir', 'reverse');

if ~isempty(clim)
    cax = ancestor(hh,'axes');
    caxis(cax, clim);
end

if nargout > 0
    h = hh;
end

end