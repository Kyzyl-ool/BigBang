Unit Points;
{$mode objfpc}

Interface

Type Point = class
	Public
		x, y	:	real;
		r, g, b	:	real;
		visible	:	boolean;
		
		Constructor Create;
		Destructor Destroy; override;
				
		Procedure Init(
			ix, iy		:	real;
			ir, ig, ib	:	real
			);
		Procedure Move(tox, toy: real);
		Procedure Show;
 end;

Implementation
Uses gl;

Constructor Point.Create;
begin
	inherited
end;

Destructor Point.Destroy;
begin
	inherited
end;

Procedure Point.Init(ix, iy, ir, ig, ib: real);
begin
	x 		:=	ix;
	y 		:=	iy;
	r 		:=	ir;
	g 		:=	ig;
	b 		:=	ib;
	visible	:=	true;
end;

Procedure Point.Move(tox, toy: real);
begin
	x := tox;
	y := toy;
end;

Procedure Point.Show;
begin
	if visible
		then
			begin
				glBegin(GL_POINTS);
					glColor3f(r, g, b);
					glVertex2f(x, y);
				glEnd
			end
end;

end.
