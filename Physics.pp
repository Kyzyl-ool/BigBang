Unit Physics;
{$mode objfpc}

Interface
Uses Points;
Const
	KT 	=	1e-1;
	KR 	=	100;
	KM 	=	1e4;
	dt 	=	5e-1;
	k	=	1e-5;
	
Var
	KG			:	real;
	allowwall	:	boolean;

Procedure DrawCircle(
	cr, cg, cb	:	real;
	cx, cy		:	real;
	r			:	real
	);

Type MatPoint = class(Point)
	Public
		m		:	real;
		Vx, Vy	:	real;
		ax, ay	:	real;
					
		Constructor Create;
		Destructor Destroy; override;
					
		Procedure Init_DL(
			ix, iy		:	real;
			ir, ig, ib	:	real;
			im			:	real;
			iVx, iVy	:	real
			);
		Procedure GetAcceleration(
			iax, iay	:	real
			);
		Procedure MakeStep;
		Procedure Show_mod;
		Function GetVx	:	real;
		Function GetVy	:	real;
		Function GetX	:	real;
		Function GetY	:	real;
		Function GetMass:	real;
end;

Implementation
Uses
	gl, glut;

Procedure DrawCircle(
	cr, cg, cb	:	real;
	cx, cy		:	real;
	r			:	real
	);
Var
	alpha	: real;
begin
	glBegin(GL_LINE_LOOP);
	glColor3f(cr, cg, cb);
	alpha:=0;
	while alpha <= 2*pi do
		begin
			glVertex2f(
				cx + cos(alpha)*r,
				cy + sin(alpha)*r
				);
			alpha:=alpha + 0.01
		end;
	glEnd
end;

Constructor MatPoint.Create;
begin
	inherited
end;

Destructor MatPoint.Destroy;
begin
	inherited
end;

Procedure MatPoint.MakeStep;
begin
	if allowwall then
		if sqr(k*x) + sqr(k*y) > 0.00001 then begin Vx:=-Vx; Vy:=-Vy; end;

	Vx	:=	Vx	+	ax*dt;
	Vy	:=	Vy	+	ay*dt;
	x	:=	x	+	Vx*dt;
	y	:=	y	+	Vy*dt;
end;

Procedure MatPoint.Show_mod;
begin
	glBegin(GL_POINTS);
		glColor3f(r, g, b);
		glVertex2f(k*x + 6, k*y + 3);
	glEnd;
	//writeln(k*x+0.5:6:2, ' ', k*y+0.5:6:2);
end;

Procedure MatPoint.Init_DL(
	ix, iy		:	real;
	ir, ig, ib	:	real;
	im			:	real;
	iVx, iVy	:	real
	);
begin
	inherited Init(ix/KR, iy/KR, ir, ig, ib);
	m	:=	im 	/ KM;
	Vx	:=	iVx / KR * KT;
	Vy	:=	iVy / KR * KT
end;

Procedure MatPoint.GetAcceleration(iax, iay: real);
begin
	ax:=iax;
	ay:=iay
end;

Function MatPoint.GetVx: real;
begin
	GetVx:=Vx
end;

Function MatPoint.GetVy: real;
begin
	GetVy:=Vy
end;

Function MatPoint.GetX: real;
begin
	GetX:=x
end;

Function MatPoint.GetY: real;
begin
	GetY:=y;
end;

Function MatPoint.GetMass: real;
begin
	GetMass:=m;
end;

end.
