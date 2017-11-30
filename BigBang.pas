Program BigBang;

Uses
	crt,
	gl, glut,			//OpenGL libraries
	Physics, Points;

//Global constants
Const
	amount	=	600;
	ps		=	2;
	PP 		= 	500;

//Global variables
Var
	p		: 	array[1..600] of MatPoint;
	i, j	: 	word;
	kc		: 	real;
	Eo		: 	extended;
	bufer	: 	string;

Procedure glWrite(
	x, y	:	real;
	Font	:	Pointer;
	Text	:	string);
Var
	i		:	word;
begin
	glRasterPos2f(x, y);
	for i:=1 to length(text) do glutBitmapCharacter(Font, Integer(Text[i]))
end;


Procedure draw; cdecl;
begin
	glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT);
	glPointSize(ps);
	glEnable(GL_POINT_SMOOTH);
	
	for i:=1 to amount do p[i].Show_mod;
	glColor3f(1, 1, 1);
	glWrite(0.2, 0.2, GLUT_BITMAP_9_BY_15, 'Press "Esc" for exit');
	
	if allowwall
		then
			begin
				glWrite(
					0.2, 0.4,
					GLUT_BITMAP_9_BY_15,
					'Press "Spacebar" for explosion'
					);
				str(Eo/amount:6:2, bufer);
				glWrite(
					0.2, 0.6,
					GLUT_BITMAP_9_BY_15,
					'Average speed: '+bufer+' m/s'
					);
			end;
	glFlush
end;

Procedure refresh; cdecl;
Var
	Sx		:	real;
	Sy		:	real;
	delta_x	:	real;
	delta_y	:	real;
	l		:	real;
	bufer	:	real;
begin
	Eo:=0;
	for i:=1 to amount do
		begin
			Sx:=0; Sy:=0;
			for j:=1 to amount do
				if i<>j
					then
						begin
							delta_x	:=	p[j].GetX - p[i].GetX;
							delta_y	:=	p[j].GetY - p[i].GetY;
							l		:=	sqrt(sqr(delta_x) + sqr(delta_y));
							
							bufer	:=	KG/l/l/l*p[j].GetMass;
							Sx		:=	Sx + bufer*(delta_x);
							Sy		:=	Sy + bufer*(delta_y)
						end;
			p[i].GetAcceleration(Sx, Sy); //main place where we can change particles' destination
			for j:=1 to amount do p[j].MakeStep;
			if allowwall then Eo:=Eo + sqrt(sqr(p[i].GetVx) + sqr(p[i].GetVy))
		end;
	glutPostRedisplay
end;

Procedure kbd(
	key		:	byte;
	x, y	:	longint
	); cdecl;
Var
	i	:	word;
begin
	case key of
			27	: 	halt;
			32	: 	allowwall:=false;
			9	: 	p[amount].Init_DL(
						KR, KR,		//x, y
						1, 0, 0,	//r, g, b
						1e12,		//mass
						0, 0		//Vx, Vy
						);
			119	: 	for i:=1 to amount-1 do p[i].Vy:=p[i].Vy + 1e2;
			97	:  	for i:=1 to amount-1 do p[i].Vx:=p[i].Vx - 1e2;
			115	: 	for i:=1 to amount-1 do p[i].Vy:=p[i].Vy - 1e2;
			100	: 	for i:=1 to amount-1 do p[i].Vx:=p[i].Vx + 1e2;
	end
end;

Var
	red		:	real;
	green	:	real;
	blue	:	real;
	fi		:	real;
Begin
	ClrScr;
	Randomize;
	
	allowwall:=true;
	writeln	('BigBang imitation.');
	write	('Do you want to set colors? (Enter - yes, Space - no)');
	case readkey of
		#13:
			begin
				writeln;
				write('Red   (%): '); readln(red);
				write('Green (%): '); readln(green);
				write('Blue  (%): '); readln(blue);
				
				for i:=1 to amount do
				begin
					p[i]:=MatPoint.Create;
					kc:=random;
					fi:=random*2*pi;
					p[i].Init_DL(
						KR - random*200*cos(fi), 	//x
						KR - random*200*sin(fi), 	//y
						random*red/100,   			//r
						random*green/100, 			//g
						random*blue/100,  			//b
						kc*KM,
						0*kc*sin(random*pi*2),      //Vx
						0*kc*cos(random*pi*2));     //Vy

				end
			end;
		#32:
			for i:=1 to amount do
				begin
					p[i]	:=	MatPoint.Create;
					kc		:=	random;
					fi		:=	random*pi*2;
					p[i].Init_DL(
						KR - random*2*PP*cos(fi) + PP, 			//x
						KR - random*2*PP*sin(fi) + PP, 			//y
						kc*1,									//r
						kc*1,									//g
						1,										//b
						kc*KM,									//mass
						sin(random*pi*2)*sqr(p[i].GetVx + 1),	//Vx
						cos(random*pi*2)*sqr(p[i].GetVy + 1))	//Vy
				end
	end;
	KG:=6.67;
	KG:=KG/KR/KR/KR*KM*KT*KT;
	
 	glutInit(@argc, argv);
	glutInitWindowSize(1200, 600);
	glutInitWindowPosition(30, 30);
	glutInitDisplayMode(GLUT_SINGLE or GLUT_RGB);
	glutCreateWindow('Big Bang');
	
	glClearColor(0, 0, 0, 0);
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
	
	glOrtho(0, 12, 0, 6, -1, 1);
	
	glutDisplayFunc(@draw);
	glutIdleFunc(@refresh);
	glutKeyboardFunc(@kbd);
	glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT);

	glutMainLoop();
	for i:=1 to amount do p[i].Destroy
End.
