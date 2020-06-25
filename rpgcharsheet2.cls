\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{rpgcharsheet2}[2016/12/29]

\LoadClass{article}

\RequirePackage[margin=1cm,footskip=0.25in,letterpaper]{geometry}
\RequirePackage[group-separator={,}]{siunitx}
\RequirePackage{mathptmx}
\RequirePackage{anyfontsize}
\RequirePackage{tabularx}
\RequirePackage{amssymb}
\RequirePackage{booktabs}
\RequirePackage{dashrule}
\RequirePackage{etex}
\RequirePackage{cancel}
\RequirePackage[table]{xcolor}
\RequirePackage{color}
\RequirePackage{calc}
\RequirePackage{ifthen}
\RequirePackage{etoolbox}
\RequirePackage{array}
\RequirePackage{stringstrings}
\RequirePackage{pgf}
\RequirePackage{ragged2e}
\RequirePackage{pdftexcmds}
\RequirePackage{suffix}
\RequirePackage{xparse}
\RequirePackage{soul}
\DeclareOption* {\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax

%%%% modified counter commands %%%%

%% IfCounter
\newcommand*\IfCounter[1]{%
	\ifcsname c@#1\endcsname%
	\expandafter\@firstoftwo%
	\else%
	\expandafter\@secondoftwo%
	\fi%
}

\def\NewCount#1{\newcount{#1}}
\def\NewCounter#1{%
	\IfCounter{#1}{}{%
		\newcounter{#1}%
	}%
}
\def\AddToCounter#1#2{%
	\NewCounter{#1}%
	\addtocounter{#1}{#2}%
}
\def\SetCounter#1#2{%
	\NewCounter{#1}%
	\setcounter{#1}{#2}}%
\def\StepCounter#1{%
	\NewCounter{#1}%
	\stepcounter{#1}}%

%% Function Name Normalization %%
\def\NewLength#1{\newlength{#1}}
\def\SetLength#1#2{\setlength{#1}{#2}}
\def\AddToLength#1#2{\addtolength{#1}{#2}}


%%%% Output Formatting %%%%
%% List Printing
\NewDocumentCommand{\PrintList}{O{, } O{} m}{% Option 1 is list separator (Default ', '), Option 2 is inserted before the very last item of the list (e.g. 'and')
	\edef\@PrintList{}%
	\edef\@@PrintList{}%
	\edef\@PrintListLast{}%
	\renewcommand{\do}[1]{%
		\let\@@PrintList\@PrintList%
		\edef\@PrintListLast{##1}%
		\listadd{\@PrintList}{##1}%
	}\dolistloop{#3}%
	\renewcommand{\do}[1]{%
		##1#1%
	}\dolistloop{\@@PrintList}%
	\ifthenelse{\equal\@@PrintList{}}{}{#2}\@PrintListLast%
}
\NewDocumentCommand{\PrintCSVList}{O{, } O{} m}{% Option 1 is list separator (Default ', '), Option 2 is inserted before the very last item of the list (e.g. 'and')
	\edef\@PrintList{}%
	\edef\@@PrintList{}%
	\edef\@PrintLListLast{}%
	\renewcommand{\do}[1]{%
		\let\@@PrintList\@PrintList%
		\edef\@PrintLListLast{##1}%
		\listadd{\@PrintList}{##1}%
	}\docsvlist{#3}%
	\renewcommand{\do}[1]{%
		##1#1%
	}\dolistloop{\@@PrintList}%
	\ifthenelse{\equal\@@PrintList{}}{}{#2}\@PrintLListLast%
}

%% Printing weights
\newcommand\PrintWeight[1]{%
	\pgfmathsetmacro\@outWeight{#1}%
	\pgfmathprintnumber[precision=1,fixed]{\@outWeight}
}


\newcommand\lfont{\fontsize{4}{4}\selectfont\scshape}


\def\attributes#1#2#3{%
	\count@#1
	\NewCount\xCount\xCount=#1
	\@for\tmp:=#3\do{%
		\put(\xCount,#2){\framebox(15,9){\tmp}}%
		\advance\xCount18
	}
}

\def\plusattributes#1#2#3#4{%
	\NewCount\xCount
	\xCount=#1
	\NewCount\plusCount
	\NewCount\tmpCount
	\@for\tmp:=#3\do{%
		\plusCount=0
		\advance\plusCount by #4
		\advance\plusCount by -15
		\tmpCount=\xCount
		\advance\tmpCount by \number\plusCount
		\put(\xCount,#2){\makebox(\plusCount,9){\tiny +}}
		\put(\tmpCount,#2){\framebox(15,9){\tmp}}
		\advance\xCount by #4
	}
}

\def\equalattributes#1#2#3#4{%
	\NewCount\xCount
	\xCount=#1
	\NewCount\plusCount
	\NewCount\tmpCount
	\NewCount\mytotalCount
	\mytotalCount=0
	\NewCount\firstCount
	\firstCount=0
	
	% Just to skip the first box
	\plusCount=0
	\advance\plusCount by #4
	\advance\plusCount by -15
	\tmpCount=\xCount
	\advance\tmpCount by \number\plusCount
	\advance\xCount by #4
	
	\@for\tmp:=#3\do{%
		\plusCount=0
		\advance\plusCount by #4
		\advance\plusCount by -15
		\tmpCount=\xCount
		\advance\tmpCount by \number\plusCount
		\ifnum\number\firstCount=0 
			\put(\xCount,#2){\makebox(\plusCount,9){\tiny =}}
		\else
			\put(\xCount,#2){\makebox(\plusCount,9){\tiny +}}
		\fi
		\put(\tmpCount,#2){\framebox(15,9){$\tmp$}}
		\advance\xCount by #4
		\ifthenelse{\equal{\tmp}{}}{\def\tmp{0}}{}
		\advance\mytotalCount by \tmp
		\advance\firstCount by 1
	}
	
	%% reset to give the first box
	\xCount=#1
	\plusCount=0
	\advance\plusCount by #4
	\advance\plusCount by -15
	\tmpCount=\xCount
	\advance\tmpCount by \number\plusCount
	\put(\tmpCount,#2){\framebox(15,9){$\number\mytotalCount$}}
	\advance\xCount by #4
}

\def\specialequalattributes#1#2#3#4#5{%
  \NewCount\xCount
  \xCount=#1
  \NewCount\plusCount
  \NewCount\tmpCount
  \global\NewCount#5
  #5=0
  \NewCount\firstCount
  \firstCount=0

  % Just to skip the first box
  \plusCount=0
  \advance\plusCount by #4
  \advance\plusCount by -15
  \tmpCount=\xCount
  \advance\tmpCount by \number\plusCount
  % \put(\xCount,#2){\makebox(\plusCount,9){\tiny +}}
  % \put(\tmpCount,#2){\framebox(15,9){\tmp}}
  \advance\xCount by #4

  \@for\tmp:=#3\do{%
    \plusCount=0
    \advance\plusCount by #4
    \advance\plusCount by -15
    \tmpCount=\xCount
    \advance\tmpCount by \number\plusCount
    \ifnum\number\firstCount=0 
    \put(\xCount,#2){\makebox(\plusCount,9){\tiny =}}
    \else
    \put(\xCount,#2){\makebox(\plusCount,9){\tiny +}}
    \fi
    \put(\tmpCount,#2){\framebox(15,9){\tmp}}
    \advance\xCount by #4
	\ifthenelse{\equal{\tmp}{}}{\def\tmp{0}}{}
    \advance#5 by \tmp
    \advance\firstCount by 1
  }

  %% reset to give the first box
  \xCount=#1
  \plusCount=0
  \advance\plusCount by #4
  \advance\plusCount by -15
  \tmpCount=\xCount
  \advance\tmpCount by \number\plusCount
  \put(\tmpCount,#2){\framebox(15,9){\the#5}}
  \advance\xCount by #4
}
\newcommand\PlusMinus[1]{\ifthenelse{\value{#1}>0}{+\arabic{#1}}{\arabic{#1}}}
\newcommand\CleanPM[1]{\ifthenelse{\value{#1}=0}{}{\PlusMinus{#1}}}

%% Attribute box dimensions
\NewCount\boxwidth\boxwidth=15
\NewCount\boxheight\boxheight=9

\def\StretchAttributes#1#2#3#4{%
\NewCount\xCount
\xCount=#1
\NewCount\stretchCount
\stretchCount=#3
\advance\stretchCount by -#1
\NewCount\noofentriesCount
\noofentriesCount=0
\@for\tmp:=#4\do{%
  \advance\noofentriesCount1
}
\advance\noofentriesCount-1
\advance\stretchCount-\boxwidth
\divide\stretchCount by \number\noofentriesCount
\NewCount\plusCount
\NewCount\tmpCount
\@for\tmp:=#4\do{%
  \ifnum\number\xCount=#1
  \plusCount=0
  \else
  \plusCount=0
  \advance\plusCount by \stretchCount
  \advance\plusCount by -15
  \fi
  \tmpCount=\xCount
  \advance\tmpCount by \number\plusCount
  \put(\tmpCount,#2){\framebox(\boxwidth,\boxheight){\tmp}}
  \ifnum\number\plusCount=0
  \advance\xCount by \boxwidth
  \else
  \advance\xCount by \stretchCount
  \fi
}}


\NewCount\labelheight
\labelheight=3
\NewCount\labelwidth
\labelwidth=\number\boxwidth
\advance\labelwidth4

\def\stretchlabels#1#2#3#4{%
\NewCount\xCount
\xCount=#1
\NewCount\stretchCount
\stretchCount=#3
\advance\stretchCount by -#1
\NewCount\noofentriesCount
\noofentriesCount=0
\@for\tmp:=#4\do{%
  \advance\noofentriesCount1
}
\advance\noofentriesCount-1
\advance\stretchCount-\boxwidth
\divide\stretchCount by \number\noofentriesCount
\NewCount\plusCount
\NewCount\tmpCount
\@for\tmp:=#4\do{%
  \ifnum\number\xCount=#1
  \plusCount=0
  \else
  \plusCount=0
  \advance\plusCount by \stretchCount
  \advance\plusCount by -15
  \fi
  \tmpCount=\xCount
  \advance\tmpCount by \number\plusCount
  \NewCount\leftabitCount
  \leftabitCount=\tmpCount
  \advance\leftabitCount by -2  \put(\leftabitCount,#2){\parbox[b][\number\labelheight\unitlength][c]{\number\labelwidth\unitlength}{\centering\lfont \tmp}}
  \ifnum\number\plusCount=0
  \advance\xCount by \boxwidth
  \else
  \advance\xCount by \stretchCount
  \fi
}}

\def\attributelabels#1#2#3{%
\Count@#1
\NewCount\xCount\xCount=#1
\NewCount\tmpCount
\@for\tmp:=#3\do{%
  \tmpCount=\xCount
  \advance\tmpCount-4
\put(\tmpCount,#2){\parbox[b][9\unitlength][b]{24\unitlength}{\lfont\centering\tmp}}%
\advance\xCount18
}}

\def\stretchequalattributes#1#2#3#4{%
  \NewCount\xCount
  \xCount=#1
  \NewCount\stretchCount
  \stretchCount=#3
  \advance\stretchCount by -#1
  \NewCount\firstCount
  \firstCount=0
  \NewCount\noofentriesCount
  \noofentriesCount=0
  \@for\tmp:=#4\do{%
    \advance\noofentriesCount1
  }
  % \advance\noofentriesCount-1
  \advance\stretchCount-\boxwidth
  \divide\stretchCount by \number\noofentriesCount %stretchCount completed
  \NewCount\plusCount
  \NewCount\tmpCount
  \NewCount\totalCount\totalCount=0

  \ifnum\number\xCount=#1
  \plusCount=0
  \else
  \plusCount=0
  \advance\plusCount by \stretchCount
  \advance\plusCount by -15
  \fi
  \tmpCount=\xCount
  \advance\tmpCount by \number\plusCount
  \ifnum\number\plusCount=0
  \advance\xCount by \boxwidth
  \else
  \advance\xCount by \stretchCount
  \fi
  \advance\firstCount1
  % \advance\totalCount by \numberfoo

  \@for\tmp:=#4\do{%
    \ifnum\number\xCount=#1
    \plusCount=0
    \else
    \plusCount=0
    \advance\plusCount by \stretchCount
    \advance\plusCount by -15
    \fi
    \tmpCount=\xCount
    \advance\tmpCount by \number\plusCount
    \ifnum\number\firstCount=0
    \else
    \put(\tmpCount,#2){\framebox(\boxwidth,\boxheight){\tmp}}
    \fi
    \ifnum\number\firstCount=1 
    \put(\xCount,#2){\makebox(\plusCount,9){\tiny =}}
    \else
    \ifnum\number\firstCount=0
    \else
    \put(\xCount,#2){\makebox(\plusCount,9){\tiny +}}
    \fi
    \fi
    \ifnum\number\plusCount=0
    \advance\xCount by \boxwidth
    \else
    \advance\xCount by \stretchCount
    \fi
    \advance\firstCount1
	\ifthenelse{\equal{\tmp}{}}{\def\tmp{0}}{}
    \advance\totalCount by \number\tmp
  }
  \put(#1,#2){\framebox(\boxwidth,\boxheight){\number\totalCount}}
}

\def\attributelabels#1#2#3{%
\Count@#1
\NewCount\xCount\xCount=#1
\NewCount\tmpCount
\@for\tmp:=#3\do{%
  \tmpCount=\xCount
  \advance\tmpCount-4
\put(\tmpCount,#2){\parbox[b][9\unitlength][b]{24\unitlength}{\lfont\centering\tmp}}%
\advance\xCount18
}}


\def\scaleattributelabels#1#2#3#4{%
\NewCount\xCount
\xCount=#1
\NewCount\plusCount
\NewCount\tmpCount
\@for\tmp:=#3\do{%
  \plusCount=0
  \advance\plusCount by #4
  \advance\plusCount by -15
  \tmpCount=\xCount
  \advance\tmpCount by \number\plusCount
  \advance\tmpCount by -1
\put(\tmpCount,#2){\parbox[b][9\unitlength][c]{17\unitlength}{\lfont\centering\tmp}}
  \advance\xCount by #4
}}

\def\titlebox#1#2#3#4#5{
  \NewCount\yCount\yCount#2
  \NewCount\hCount\hCount=10
  \NewCount\wCount\wCount=#3
  \NewCount\downabitCount
  \downabitCount=#2
  \advance\downabitCount-1
  \put(#1,\downabitCount){\setlength\fboxsep{0pt}\colorbox{gray!40}{\makebox(#3,11){}}}%
  \advance\yCount1
  \put(#1,\yCount){\makebox(#3,\hCount){\color{black}{\uppercase{#4}}}}
  \advance\hCount-7
  \advance\yCount-1
  \put(#1,\yCount){\makebox(#3,\hCount){\color{black}{\tiny\scshape #5}}}
}

\newcommand\singletitlebox[5]{
  % \put(#1,#2){\framebox(#3,#4){\uppercase{#5}}}
  \put(#1,#2){%
    \setlength\fboxsep{0pt}\colorbox{gray!40}{%
      \makebox(#3,#4){%
        \color{black}{\centering\uppercase{#5}}%
      }%
    }%
  }%
}
\def\scaleattributes#1#2#3#4{%
\NewCount\xCount
\xCount=#1
\NewCount\plusCount
\NewCount\tmpCount
\@for\tmp:=#3\do{%
  \plusCount=0
  \advance\plusCount by #4
  \advance\plusCount by -15
  \tmpCount=\xCount
  \advance\tmpCount by \number\plusCount
  \put(\tmpCount,#2){\framebox(15,9){\tmp}}
  \advance\xCount by #4
}}


\newcolumntype{A}[1]{@{}>{\centering\footnotesize}m{#1\unitlength}@{}}
\newcolumntype{B}[1]{@{}>{\footnotesize\scshape}m{#1\unitlength}@{}}
\newcolumntype{C}[1]{@{}>{\centering\footnotesize}p{#1\unitlength}@{}}
\newcolumntype{D}[1]{>{\itshape}p{#1\unitlength}}
\newcolumntype{E}[1]{@{}>{\lfont\raggedleft}b{#1\unitlength}@{}}
\newcolumntype{F}[1]{@{\hspace{-0.5ex}}>{\small\raggedleft}m{#1\unitlength}@{\hspace{0.5ex}}}


\newcommand{\Arabic}[1]{
	\num{\arabic{#1}}
}
\newcommand{\CleanArabic}[1]{
	\ifthenelse{\value{#1}=0}{}{\Arabic{#1}}
}

%As \patchcmd but takes a csname for first arg. Doesn't accept prefixes as patchcmd does.
\newrobustcmd*{\cspatchcmd}[1]{\expandafter\patchcmd\csname #1\endcsname}

%%%% Internal Coding Tools %%%%

%%List Insertion%%
\newcommand{\listinsert}[2]{
	\edef\@tmplistoneforlistinsert{}
	\edef\@tmplisttwoforlistinsert{}
	\forlistloop{\listinsert@s{#2}{\@tmplistoneforlistinsert}{\@tmplisttwoforlistinsert}}{#1}
	\edef#1{}
	\forlistloop{\listadd#1}{\@tmplistoneforlistinsert}
	\listadd#1{#2}
	\forlistloop{\listadd#1}{\@tmplisttwoforlistinsert}
}
\newcommand\listinsert@s[4]{
	\ifnumcomp{\pdfstrcmp{#4}{#1}}<{0}
	{\listadd#2{#4}}
	{\listadd#3{#4}}
}

\newcommand{\listcsinsert}[2]{
	\edef\@tmplistoneforlistinsert{}
	\edef\@tmplisttwoforlistinsert{}
	\forlistcsloop{\listinsert@s{#2}{\@tmplistoneforlistinsert}{\@tmplisttwoforlistinsert}}{#1}
	\csedef{#1}{}
	\forlistloop{\listcsadd{#1}}{\@tmplistoneforlistinsert}
	\listcsadd{#1}{#2}
	\forlistloop{\listcsadd{#1}}{\@tmplisttwoforlistinsert}
}

% Shortcut for entering csnames faster
\ProvideDocumentCommand{\cs}{m}{%
	\csname #1\endcsname%
}

% if False that should work in tables
\newcommand{\TableIfF}[1]{
	\if\relax \detokenize{#1}\relax%
	\expandafter\@gobble%
	\else%
	\expandafter\@firstofone%
	\fi%
}

%%Debug and Alerts%%
\edef\PrintDebug{}
\newcommand{\AddDebug}[1]{
	\gappto\PrintDebug{#1 \\}
}
\edef\PrintWarning{}
\newcommand\AddWarning[1]{
	\gappto\PrintWarning{#1; }
}

%%For Loop%%
\newcommand{\ForLoop}[5][1]{%
	\SetCounter{#2}{#3}%
	\ifthenelse{#4}{%
		#5%
		\AddToCounter{#2}{#1}%
		\ForLoop[#1]{#2}{\arabic{#2}}{#4}{#5}%
	}{}%
}%

%%Domath%%
\NewCounter{@DoMathCounter}
\NewDocumentCommand{\DoMath}{s m}{%
	\SetCounter{@DoMathCounter}{#2}%
	\IfBooleanTF #1 {%
	}{%
		\arabic{@DoMathCounter}%
	}%
}
\NewDocumentCommand{\MathPM}{m}{%
	\SetCounter{@DoMathCounter}{#1}%
	\ifthenelse{\value{@DoMathCounter} > 0} {%
		+\arabic{@DoMathCounter}%
	}{%
		\arabic{@DoMathCounter}%
	}%
}

%% Handy Loop/Temp variables
\NewCounter{@i}
\NewCounter{@j}
\NewCounter{@k}



%%%% Miscellaney %%%%

%%Blank Sheet Generator
\newcommand\blanksheet{
%	\renewcommand\arabic[1]{}
	\renewcommand{\Cleanarabic}[1]{}
	\renewcommand{\plusminus}[1]{}
	%\edef\input##1{}
	\edef\Initialize{}
%	\def\equalattributes##1##2##3##4{%
%		\NewCount\xCount
%		\xCount=##1
%		\NewCount\plusCount
%		\NewCount\tmpCount
%		\NewCount\mytotalCount
%		\mytotalCount=0
%		\NewCount\firstCount
%		\firstCount=0
%		
%		% Just to skip the first box
%		\plusCount=0
%		\advance\plusCount by ##4
%		\advance\plusCount by -15
%		\tmpCount=\xCount
%		\advance\tmpCount by \number\plusCount
%		\advance\xCount by ##4
%		
%		\@for\tmp:=##3\do{%
%			\plusCount=0
%			\advance\plusCount by ##4
%			\advance\plusCount by -15
%			\tmpCount=\xCount
%			\advance\tmpCount by \number\plusCount
%			\ifnum\number\firstCount=0 
%			\put(\xCount,##2){\makebox(\plusCount,9){\tiny =}}
%			\else
%			\put(\xCount,##2){\makebox(\plusCount,9){\tiny +}}
%			\fi
%			\put(\tmpCount,##2){\framebox(15,9){}}
%			\advance\xCount by ##4
%	
%			\advance\firstCount by 1
%		}
%		  \xCount=##1
%		  \plusCount=0
%		  \advance\plusCount by ##4
%		  \advance\plusCount by -15
%		  \tmpCount=\xCount
%		  \advance\tmpCount by \number\plusCount
%		  \put(\tmpCount,##2){\framebox(15,9){}}
%	}
}
%%adds lines to feats, etc. sections in blank sheet
\newcommand\lineemup{
\ForLoop{@i}{0}{\arabic{@i}<10}{
\listadd\Gearlist{\hline & \tabularnewline}
\listadd\storeditemslist{\hline &\tabularnewline}
}}