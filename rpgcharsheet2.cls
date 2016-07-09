\NeedsTeXFormat{LaTeX2e}

\ProvidesClass{rpgcharsheet2}[2013/02/23]

\LoadClass{article}

\RequirePackage[margin=1cm,footskip=0.25in,letterpaper]{geometry}

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




%%%% Output Formatting %%%%
%
\DeclareDocumentCommand{\printlist}{O{, } O{} m}{%
	\edef\@printlist{}%
	\edef\@@printlist{}%
	\edef\@printlistlast{}
	\renewcommand{\do}[1]{%
		\let\@@printlist\@printlist%
		\edef\@printlistlast{##1}%
		\listadd{\@printlist}{##1}%
	}\dolistloop{#3}%
	\renewcommand{\do}[1]{%
		##1#1%
	}\dolistloop{\@@printlist}%
	\ifthenelse{\equal\@@printlist{}}{}{#2}\@printlistlast%
}

%\newcommand{\printlist}[1]{
%\renewcommand{\do}[1]{
%##1, }\dolistloop{#1}}

\newcommand\lfont{\fontsize{4}{4}\selectfont\scshape}

\def\attributes#1#2#3{%
\count@#1
\newcount\xcount\xcount=#1
\@for\tmp:=#3\do{%
\put(\xcount,#2){\framebox(15,9){\tmp}}%
\advance\xcount18
}}

\def\plusattributes#1#2#3#4{%
\newcount\xcount
\xcount=#1
\newcount\pluscount
\newcount\tmpcount
\@for\tmp:=#3\do{%
  \pluscount=0
  \advance\pluscount by #4
  \advance\pluscount by -15
  \tmpcount=\xcount
  \advance\tmpcount by \number\pluscount
  \put(\xcount,#2){\makebox(\pluscount,9){\tiny +}}
  \put(\tmpcount,#2){\framebox(15,9){\tmp}}
  \advance\xcount by #4
}}

\def\equalattributes#1#2#3#4{%
  \newcount\xcount
  \xcount=#1
  \newcount\pluscount
  \newcount\tmpcount
  \newcount\mytotalcount
  \mytotalcount=0
  \newcount\firstcount
  \firstcount=0

  % Just to skip the first box
  \pluscount=0
  \advance\pluscount by #4
  \advance\pluscount by -15
  \tmpcount=\xcount
  \advance\tmpcount by \number\pluscount
  \advance\xcount by #4

  \@for\tmp:=#3\do{%
    \pluscount=0
    \advance\pluscount by #4
    \advance\pluscount by -15
    \tmpcount=\xcount
    \advance\tmpcount by \number\pluscount
    \ifnum\number\firstcount=0 
    \put(\xcount,#2){\makebox(\pluscount,9){\tiny =}}
    \else
    \put(\xcount,#2){\makebox(\pluscount,9){\tiny +}}
    \fi
    \put(\tmpcount,#2){\framebox(15,9){$\tmp$}}
    \advance\xcount by #4
	\ifthenelse{\equal{\tmp}{}}{\def\tmp{0}}{}
    \advance\mytotalcount by \tmp
    \advance\firstcount by 1
  }

  %% reset to give the first box
  \xcount=#1
  \pluscount=0
  \advance\pluscount by #4
  \advance\pluscount by -15
  \tmpcount=\xcount
  \advance\tmpcount by \number\pluscount
  \put(\tmpcount,#2){\framebox(15,9){$\number\mytotalcount$}}
  \advance\xcount by #4
}

\def\specialequalattributes#1#2#3#4#5{%
  \newcount\xcount
  \xcount=#1
  \newcount\pluscount
  \newcount\tmpcount
  \global\newcount#5
  #5=0
  \newcount\firstcount
  \firstcount=0

  % Just to skip the first box
  \pluscount=0
  \advance\pluscount by #4
  \advance\pluscount by -15
  \tmpcount=\xcount
  \advance\tmpcount by \number\pluscount
  % \put(\xcount,#2){\makebox(\pluscount,9){\tiny +}}
  % \put(\tmpcount,#2){\framebox(15,9){\tmp}}
  \advance\xcount by #4

  \@for\tmp:=#3\do{%
    \pluscount=0
    \advance\pluscount by #4
    \advance\pluscount by -15
    \tmpcount=\xcount
    \advance\tmpcount by \number\pluscount
    \ifnum\number\firstcount=0 
    \put(\xcount,#2){\makebox(\pluscount,9){\tiny =}}
    \else
    \put(\xcount,#2){\makebox(\pluscount,9){\tiny +}}
    \fi
    \put(\tmpcount,#2){\framebox(15,9){\tmp}}
    \advance\xcount by #4
	\ifthenelse{\equal{\tmp}{}}{\def\tmp{0}}{}
    \advance#5 by \tmp
    \advance\firstcount by 1
  }

  %% reset to give the first box
  \xcount=#1
  \pluscount=0
  \advance\pluscount by #4
  \advance\pluscount by -15
  \tmpcount=\xcount
  \advance\tmpcount by \number\pluscount
  \put(\tmpcount,#2){\framebox(15,9){\the#5}}
  \advance\xcount by #4
}
\newcommand\plusminus[1]{\ifthenelse{\value{#1}>0}{+\arabic{#1}}{\arabic{#1}}}

%% Attribute box dimensions
\newcount\boxwidth\boxwidth=15
\newcount\boxheight\boxheight=9

\def\stretchattributes#1#2#3#4{%
\newcount\xcount
\xcount=#1
\newcount\stretchcount
\stretchcount=#3
\advance\stretchcount by -#1
\newcount\noofentriescount
\noofentriescount=0
\@for\tmp:=#4\do{%
  \advance\noofentriescount1
}
\advance\noofentriescount-1
\advance\stretchcount-\boxwidth
\divide\stretchcount by \number\noofentriescount
\newcount\pluscount
\newcount\tmpcount
\@for\tmp:=#4\do{%
  \ifnum\number\xcount=#1
  \pluscount=0
  \else
  \pluscount=0
  \advance\pluscount by \stretchcount
  \advance\pluscount by -15
  \fi
  \tmpcount=\xcount
  \advance\tmpcount by \number\pluscount
  \put(\tmpcount,#2){\framebox(\boxwidth,\boxheight){\tmp}}
  \ifnum\number\pluscount=0
  \advance\xcount by \boxwidth
  \else
  \advance\xcount by \stretchcount
  \fi
}}


\newcount\labelheight
\labelheight=3
\newcount\labelwidth
\labelwidth=\number\boxwidth
\advance\labelwidth4

\def\stretchlabels#1#2#3#4{%
\newcount\xcount
\xcount=#1
\newcount\stretchcount
\stretchcount=#3
\advance\stretchcount by -#1
\newcount\noofentriescount
\noofentriescount=0
\@for\tmp:=#4\do{%
  \advance\noofentriescount1
}
\advance\noofentriescount-1
\advance\stretchcount-\boxwidth
\divide\stretchcount by \number\noofentriescount
\newcount\pluscount
\newcount\tmpcount
\@for\tmp:=#4\do{%
  \ifnum\number\xcount=#1
  \pluscount=0
  \else
  \pluscount=0
  \advance\pluscount by \stretchcount
  \advance\pluscount by -15
  \fi
  \tmpcount=\xcount
  \advance\tmpcount by \number\pluscount
  \newcount\leftabitcount
  \leftabitcount=\tmpcount
  \advance\leftabitcount by -2  \put(\leftabitcount,#2){\parbox[b][\number\labelheight\unitlength][c]{\number\labelwidth\unitlength}{\centering\lfont \tmp}}
  \ifnum\number\pluscount=0
  \advance\xcount by \boxwidth
  \else
  \advance\xcount by \stretchcount
  \fi
}}

\def\attributelabels#1#2#3{%
\count@#1
\newcount\xcount\xcount=#1
\newcount\tmpcount
\@for\tmp:=#3\do{%
  \tmpcount=\xcount
  \advance\tmpcount-4
\put(\tmpcount,#2){\parbox[b][9\unitlength][b]{24\unitlength}{\lfont\centering\tmp}}%
\advance\xcount18
}}

\def\stretchequalattributes#1#2#3#4{%
  \newcount\xcount
  \xcount=#1
  \newcount\stretchcount
  \stretchcount=#3
  \advance\stretchcount by -#1
  \newcount\firstcount
  \firstcount=0
  \newcount\noofentriescount
  \noofentriescount=0
  \@for\tmp:=#4\do{%
    \advance\noofentriescount1
  }
  % \advance\noofentriescount-1
  \advance\stretchcount-\boxwidth
  \divide\stretchcount by \number\noofentriescount %stretchcount completed
  \newcount\pluscount
  \newcount\tmpcount
  \newcount\totalcount\totalcount=0

  \ifnum\number\xcount=#1
  \pluscount=0
  \else
  \pluscount=0
  \advance\pluscount by \stretchcount
  \advance\pluscount by -15
  \fi
  \tmpcount=\xcount
  \advance\tmpcount by \number\pluscount
  \ifnum\number\pluscount=0
  \advance\xcount by \boxwidth
  \else
  \advance\xcount by \stretchcount
  \fi
  \advance\firstcount1
  % \advance\totalcount by \numberfoo

  \@for\tmp:=#4\do{%
    \ifnum\number\xcount=#1
    \pluscount=0
    \else
    \pluscount=0
    \advance\pluscount by \stretchcount
    \advance\pluscount by -15
    \fi
    \tmpcount=\xcount
    \advance\tmpcount by \number\pluscount
    \ifnum\number\firstcount=0
    \else
    \put(\tmpcount,#2){\framebox(\boxwidth,\boxheight){\tmp}}
    \fi
    \ifnum\number\firstcount=1 
    \put(\xcount,#2){\makebox(\pluscount,9){\tiny =}}
    \else
    \ifnum\number\firstcount=0
    \else
    \put(\xcount,#2){\makebox(\pluscount,9){\tiny +}}
    \fi
    \fi
    \ifnum\number\pluscount=0
    \advance\xcount by \boxwidth
    \else
    \advance\xcount by \stretchcount
    \fi
    \advance\firstcount1
	\ifthenelse{\equal{\tmp}{}}{\def\tmp{0}}{}
    \advance\totalcount by \number\tmp
  }
  \put(#1,#2){\framebox(\boxwidth,\boxheight){\number\totalcount}}
}

\def\attributelabels#1#2#3{%
\count@#1
\newcount\xcount\xcount=#1
\newcount\tmpcount
\@for\tmp:=#3\do{%
  \tmpcount=\xcount
  \advance\tmpcount-4
\put(\tmpcount,#2){\parbox[b][9\unitlength][b]{24\unitlength}{\lfont\centering\tmp}}%
\advance\xcount18
}}


\def\scaleattributelabels#1#2#3#4{%
\newcount\xcount
\xcount=#1
\newcount\pluscount
\newcount\tmpcount
\@for\tmp:=#3\do{%
  \pluscount=0
  \advance\pluscount by #4
  \advance\pluscount by -15
  \tmpcount=\xcount
  \advance\tmpcount by \number\pluscount
  \advance\tmpcount by -1
\put(\tmpcount,#2){\parbox[b][9\unitlength][c]{17\unitlength}{\lfont\centering\tmp}}
  \advance\xcount by #4
}}

\def\titlebox#1#2#3#4#5{
  \newcount\ycount\ycount#2
  \newcount\hcount\hcount=10
  \newcount\wcount\wcount=#3
  \newcount\downabitcount
  \downabitcount=#2
  \advance\downabitcount-1
  \put(#1,\downabitcount){\setlength\fboxsep{0pt}\colorbox{gray!40}{\makebox(#3,11){}}}%
  \advance\ycount1
  \put(#1,\ycount){\makebox(#3,\hcount){\color{black}{\uppercase{#4}}}}
  \advance\hcount-7
  \advance\ycount-1
  \put(#1,\ycount){\makebox(#3,\hcount){\color{black}{\tiny\scshape #5}}}
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
\newcount\xcount
\xcount=#1
\newcount\pluscount
\newcount\tmpcount
\@for\tmp:=#3\do{%
  \pluscount=0
  \advance\pluscount by #4
  \advance\pluscount by -15
  \tmpcount=\xcount
  \advance\tmpcount by \number\pluscount
  \put(\tmpcount,#2){\framebox(15,9){\tmp}}
  \advance\xcount by #4
}}


\newcolumntype{A}[1]{@{}>{\centering\footnotesize}m{#1\unitlength}@{}}
\newcolumntype{B}[1]{@{}>{\footnotesize\scshape}m{#1\unitlength}@{}}
\newcolumntype{D}[1]{>{\itshape}p{#1\unitlength}}
\newcolumntype{E}[1]{@{}>{\lfont\raggedleft}b{#1\unitlength}@{}}
\newcolumntype{F}[1]{@{\hspace{-0.5ex}}>{\small\raggedleft}m{#1\unitlength}@{\hspace{0.5ex}}}

\newcommand{\cleanarabic}[1]{
\ifthenelse{\arabic{#1}=0}{}{\arabic{#1}}}



%%%% Internal Coding Tools %%%%
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
	\ifnumcomp{\pdf@strcmp{#4}{#1}}<{0}
	{\listadd#2{#4}}
	{\listadd#3{#4}}
}




%%For Loop%%

\newcommand{\forloop}[5][1]%
{%
\setcounter{#2}{#3}%
\ifthenelse{#4}%
	{%
	#5%
	\addtocounter{#2}{#1}%
	\forloop[#1]{#2}{\value{#2}}{#4}{#5}%
	}%
% Else
	{%
	}%
}%


%%Domath%%
	\newcounter{@domathcounter}
	\DeclareDocumentCommand{\domath}{s m}{%
		\setcounter{@domathcounter}{#2}%
		\IfBooleanTF #1 {\plusminus{@domathcounter}} {\arabic{@domathcounter}}}
%	\newcommand{\domath}[1]{\begingroup\setcounter{@domathcounter}{#1}\arabic{@domathcounter}\let\the@domathcounter\relax\endgroup}
%	\WithSuffix\newcommand\domath*[1]{\begingroup\setcounter{@domathcounter}{#1}\value{@domathcounter}\let\the@domathcounter\relax\endgroup}


%%%% Ability Scores %%%%



\let\abilityscores\@empty
\forcsvlist{\listadd\abilityscores}{str, dex, con, int, wis, cha}

\renewcommand{\do}[1]{
\newcounter{char#1count}
\newcounter{char#1basecount}
\newcounter{char#1enhcount}
\newcounter{char#1misccount}
\newcounter{char#1tmpcount}
\newcounter{char#1modcount}
\expandafter\newcommand\csname char#1\endcsname[1]{
  \setcounter{char#1basecount}{0}
  \setcounter{char#1basecount}{##1}
}
}\dolistloop{\abilityscores}
\newcounter{charcmdabilitymodcount}

\newcommand{\strenh}[1]{
\ifnum#1>\value{charstrenhcount}
\setcounter{charstrenhcount}{#1}\fi
\ifnum0=\value{charstrenhcount}
\setcounter{charstrenhcount}{#1}\fi
}
\newcommand{\dexenh}[1]{
\ifnum#1>\value{chardexenhcount}
\setcounter{chardexenhcount}{#1}\fi
\ifnum0=\value{chardexenhcount}
\setcounter{chardexenhcount}{#1}\fi
}
\newcommand{\conenh}[1]{
\ifnum#1>\value{charconenhcount}
\setcounter{charconenhcount}{#1}\fi
\ifnum0=\value{charconenhcount}
\setcounter{charconenhcount}{#1}\fi
}
\newcommand{\intenh}[1]{
\ifnum#1>\value{charintenhcount}
\setcounter{charintenhcount}{#1}\fi
\ifnum0=\value{charintenhcount}
\setcounter{charintenhcount}{#1}\fi
}
\newcommand{\wisenh}[1]{
\ifnum#1>\value{charwisenhcount}
\setcounter{charwisenhcount}{#1}\fi
\ifnum0=\value{charwisenhcount}
\setcounter{charwisenhcount}{#1}\fi
}
\newcommand{\chaenh}[1]{
\ifnum#1>\value{charchaenhcount}
\setcounter{charchaenhcount}{#1}\fi
\ifnum0=\value{charchaenhcount}
\setcounter{charchaenhcount}{#1}\fi
}



%%%% Feats, Class & Race Features %%%%



\let\charfeatslist\@empty
\let\charracefeatureslist\@empty
\let\charclassfeatureslist\@empty
\let\charlimiteduselist\@empty
\newcommand\addfeat[1]{\listadd\charfeatslist{#1}}
\newcommand\addclassfeature[1]{\listadd\charclassfeatureslist{#1}}
\newcommand\addracefeature[1]{\listadd\charracefeatureslist{#1}}
\newcommand\addlimiteduse[2]{
\listadd{\charlimiteduselist}{{#1} & {#2} & }
}




%%%% Skills %%%%



% Define skills list
\let\skillslist\@empty
\forcsvlist{\listadd\skillslist}{acrobatics, appraise, bluff, climb, craftone, crafttwo, craftthree, diplomacy, disabledevice, disguise, escapeartist, fly, handleanimal, heal, intimidate, knowledgearcana, knowledgedungeoneering, knowledgeengineering, knowledgegeography, knowledgehistory, knowledgelocal, knowledgenature, knowledgenobility, knowledgeplanes, knowledgereligion, linguistics, perception, performone, performtwo, performthree, professionone, professiontwo, ride, sensemotive, sleightofhand, spellcraft, stealth, survival, swim, usemagicdevice}

\renewcommand\do[1]{
\expandafter\newcommand\csname char#1name\endcsname{Optional}
}\docsvlist{craftone,crafttwo,craftthree,professionone,professiontwo,performone,performtwo}

\let\armorcheckskillslist\@empty
\forcsvlist{\listadd\armorcheckskillslist}{acrobatics, climb, disabledevice, escapeartist, fly, ride, sleightofhand, stealth, swim}

\renewcommand{\do}[1]{
\newcounter{char#1count}
\newcounter{char#1classskillcount}
\newcounter{char#1rankscount}
\newcounter{char#1misccount}
}\dolistloop{\skillslist}
\newcounter{tmpskilltotalcount}
\setcounter{tmpskilltotalcount}{0}
\newcounter{tmpistrained}
\setcounter{tmpistrained}{0}
\newcounter{tmptrainedvalue}
\setcounter{tmptrainedvalue}{0}

\newcommand\isclassskill[1]{
\ifthenelse{\equal{#1}{knowledgeall}}
{
\renewcommand\do[1]{
\isclassskill{knowledge##1}
}\docsvlist{arcana, dungeoneering, engineering, history, geography, history, local, nature, nobility, planes, religion}
}
{\ifthenelse{\equal{#1}{craft}}
{\renewcommand\do[1]{
\isclassskill{craft##1}
}\docsvlist{one, two, three}}
{\ifthenelse{\equal{#1}{profession}}
{\renewcommand\do[1]{
\isclassskill{profession##1}
}\docsvlist{one, two}}
{\ifthenelse{\equal{#1}{perform}}
{\renewcommand\do[1]{
\isclassskill{perform##1}
}\docsvlist{one, two}}
{\setcounter{char#1classskillcount}{1}}}
}}
}

\newcommand\addranks[2]{
\addtocounter{char#1rankscount}{#2}}

\newcommand\skillcalculate[4]{
  \setcounter{tmpskilltotalcount}{\value{#2}+\value{#3}+\value{#4}}
  \plusminus{tmpskilltotalcount} & $=$ #1 & $\arabic{#2}$ & $+$ & $\arabic{#3}$ &  $+$ & $\arabic{#4}$ \tabularnewline\cline{3-3}\cline{5-5}\cline{7-7}\cline{9-9}
}

\newcommand\classskillbox[1]{
  \ifthenelse{\value{#1} = 1}{$\cancel{\square}$}{$\square$}
}
\newcommand\skill[3]{
	\ifnum\value{char#1rankscount}=0
	\setcounter{tmpistrained}{0}
	\else\setcounter{tmpistrained}{1}\fi
	\setcounter{tmptrainedvalue}{\value{tmpistrained} * \value{char#1classskillcount} * 3}
	\setcounter{tmpskilltotalcount}{\value{char#3modcount}+\value{char#1rankscount}+\value{char#1misccount}+\value{tmptrainedvalue}}
	  \classskillbox{char#1classskillcount} &  #2\ifinlist{#1}{\armorcheckskillslist}{$\dagger$}{} & \arabic{tmpskilltotalcount} & $=$ \capitalize{#3} & $\arabic{char#3modcount}$ & $+$ & $\arabic{char#1rankscount}$ &  $+$ & $\arabic{tmptrainedvalue}$ & $+$ & $\arabic{char#1misccount}$ \tabularnewline\cline{3-3}\cline{5-5}\cline{7-7}\cline{9-9}\cline{11-11}
}

\newcommand\trainskill[3]{
	\ifnum\value{char#1rankscount}=0
	\setcounter{tmpistrained}{0}
	\else\setcounter{tmpistrained}{1}\fi
	\setcounter{tmptrainedvalue}{\value{tmpistrained} * \value{char#1classskillcount} * 3}
	\setcounter{tmpskilltotalcount}{\value{char#3modcount}+\value{char#1rankscount}+\value{char#1misccount}+\value{tmptrainedvalue}}
	  \classskillbox{char#1classskillcount} &  #2\ifinlist{#1}{\armorcheckskillslist}{$\dagger$}{}* & \arabic{tmpskilltotalcount} & $=$ \capitalize{#3} & $\arabic{char#3modcount}$ & $+$ & $\arabic{char#1rankscount}$ &  $+$ & $\arabic{tmptrainedvalue}$ & $+$ & $\arabic{char#1misccount}$ \tabularnewline\cline{3-3}\cline{5-5}\cline{7-7}\cline{9-9}\cline{11-11}
}



%%%% Items %%%%



\let\gearlist\@empty
\newcommand\gearitem[3][1]{%
  \addtolength{\totalgearweight}{#1 pt * #3}%
	\listadd{\gearlist}{#2\ifnum #1 > 1{ (#1)}\fi & \domath{#1 * #3}~lbs.}
}
\newcommand\subgearitem[3][1]{
\listadd{\gearlist}{---#2\ifnum #1 > 1{ (#1)} & (\domath{#1 * #3}~lbs.) \tabularnewline}
}

\let\storeditemslist\@empty
\newcommand\storeditem[3][1]{
  \addtolength{\totalstoredweight}{#1 pt * #3}%
	\listadd{\storeditemslist}{#2\ifnum #1 > 1{ (#1)}\fi & \domath{#1 * #3}~lbs.}
}
\newcommand\substoreditem[3][1]{
\listadd{\storeditemslist}{---#2\ifnum #1 > 1{ (#1)} & (\domath{#1 * #3}~lbs.) \tabularnewline}
}

\newcommand\weapontable[9]{
  \put(#1,#2){\begin{tabular}[b]{A{15}A{25}A{65}A{45}A{25}A{25}}
      \multicolumn{3}{A{105}}{\itshape #3} & #4 & #5 &#6 \tabularnewline\hline
      \multicolumn{3}{A{105}}{\tiny\scshape WEAPON} &\tiny\scshape  attack bonus &\tiny\scshape damage &\tiny\scshape  critical  \tabularnewline
      \itshape #7 &  #8 & \multicolumn{4}{A{160}}{#9}  \tabularnewline\hline
	\tiny\scshape type & \tiny\scshape range &\multicolumn{4}{A{160}} {\tiny\scshape ammunition \& notes } \tabularnewline
    \end{tabular}}
}
\newcommand\defaultweapontable[2]{
  \put(#1,#2){\begin{tabular}[b]{A{15}A{25}A{65}A{45}A{25}A{25}}
      \multicolumn{3}{A{105}}{} & & & \tabularnewline\hline
      \multicolumn{3}{A{105}}{\tiny\scshape WEAPON} &\tiny\scshape  attack bonus &\tiny\scshape damage &\tiny\scshape  critical  \tabularnewline
      \itshape  &   & \multicolumn{4}{A{160}}{}  \tabularnewline\hline
	\tiny\scshape type & \tiny\scshape range &\multicolumn{4}{A{160}} {\tiny\scshape ammunition \& notes } \tabularnewline
    \end{tabular}}
}
\newcommand\weapononetable{
\defaultweapontable{0}{200}
}\newcommand\weapontwotable{
\defaultweapontable{0}{150}
}\newcommand\weaponthreetable{
\defaultweapontable{0}{100}
}
\newcommand\weapononename{}
\newcommand\weaponone[7]{
\renewcommand\weapononename{#1}
\renewcommand\weapononetable{
\weapontable{0}{200}{#1}{#2}{#3}{#4}{#5}{#6}{#7}}
}
\newcommand\weapontwoname{}
\newcommand\weapontwo[7]{
\renewcommand\weapontwoname{#1}
\renewcommand\weapontwotable{
\weapontable{0}{150}{#1}{#2}{#3}{#4}{#5}{#6}{#7}}
}
\newcommand\weaponthreename{}
\newcommand\weaponthree[7]{
\renewcommand\weaponthreename{#1}
\renewcommand\weaponthreetable{
\weapontable{0}{100}{#1}{#2}{#3}{#4}{#5}{#6}{#7}}
}
\newcommand\weapon[7]{
\ifthenelse{\equal{\weapononename}{}}
{\weaponone{#1}{#2}{#3}{#4}{#5}{#6}{#7}}
{\ifthenelse{\equal{\weapontwoname}{}}
{\weapontwo{#1}{#2}{#3}{#4}{#5}{#6}{#7}}
{\ifthenelse{\equal{\weaponthreename}{}}
{\weaponthree{#1}{#2}{#3}{#4}{#5}{#6}{#7}}
{\weaponone{#1}{#2}{#3}{#4}{#5}{#6}{#7}
}}}}

%% Autocalculate attack bonus
\newcounter{totalattackbonuscount}
\newcounter{tmpindexcount}
\newcounter{tmpvaluecount}

\newcommand\autoweaponone[9]{
\renewcommand\weapononename{#1}
\renewcommand\weapononetable{
\setcounter{totalattackbonuscount}{\value{charbabcount}+\value{char#9modcount}+\value{charsizemodcount}+\value{char#8miscmodcount}+\value{char#8tmpmodcount}+#2}
\weapontable{0}{200}{#1}{\forloop{tmpindexcount}{0}{\value{tmpindexcount}<\value{chariteratedattackscount}}{\setcounter{tmpvaluecount}{\value{totalattackbonuscount}-5*\value{tmpindexcount}}\hspace{-3pt}\ifthenelse{\value{tmpindexcount}=0}{}{/}\hspace{-3pt}\plusminus{tmpvaluecount}
}}{#3}{#4}{#5}{#6}{#7}}
}

\newcommand\autoweapontwo[9]{
\renewcommand\weapontwoname{#1}
\renewcommand\weapontwotable{
\setcounter{totalattackbonuscount}{\value{charbabcount}+\value{char#9modcount}+\value{charsizemodcount}+\value{char#8miscmodcount}+\value{char#8tmpmodcount}+#2}
\weapontable{0}{150}{#1}{\forloop{tmpindexcount}{0}{\value{tmpindexcount}<\value{chariteratedattackscount}}{\setcounter{tmpvaluecount}{\value{totalattackbonuscount}-5*\value{tmpindexcount}}\hspace{-3pt}\ifthenelse{\value{tmpindexcount}=0}{}{/}\hspace{-3pt}\plusminus{tmpvaluecount}
}}{#3}{#4}{#5}{#6}{#7}}
}

\newcommand\autoweaponthree[9]{
\renewcommand\weaponthreename{#1}
\renewcommand\weaponthreetable{
\setcounter{totalattackbonuscount}{\value{charbabcount}+\value{char#9modcount}+\value{charsizemodcount}+\value{char#8miscmodcount}+\value{char#8tmpmodcount}+#2}
\weapontable{0}{100}{#1}{\forloop{tmpindexcount}{0}{\value{tmpindexcount}<\value{chariteratedattackscount}}{\setcounter{tmpvaluecount}{\value{totalattackbonuscount}-5*\value{tmpindexcount}}\hspace{-3pt}\ifthenelse{\value{tmpindexcount}=0}{}{/}\hspace{-3pt}\plusminus{tmpvaluecount}
}}{#3}{#4}{#5}{#6}{#7}}
}

\newcommand\autoweapon[9]{
\ifthenelse{\equal{\weapononename}{}}
{\autoweaponone{#1}{#2}{#3}{#4}{#5}{#6}{#7}{#8}{#9}}
{\ifthenelse{\equal{\weapontwoname}{}}
{\autoweapontwo{#1}{#2}{#3}{#4}{#5}{#6}{#7}{#8}{#9}}
{\ifthenelse{\equal{\weaponthreename}{}}
{\autoweaponthree{#1}{#2}{#3}{#4}{#5}{#6}{#7}{#8}{#9}}
{\autoweaponone{#1}{#2}{#3}{#4}{#5}{#6}{#7}{#8}{#9}
}}}}



\newcounter{totalacitemsspellfailure}
\newcounter{charmaxdexarmorcount}
\setcounter{charmaxdexarmorcount}{100}
\newcounter{charmaxdexshieldcount}
\setcounter{charmaxdexshieldcount}{100}
\newcounter{charmaxdexbonuscount}
\setcounter{charmaxdexbonuscount}{100}
\newcounter{chardextoACcount}

\newcommand\armor[2]{
  \put(#1,#2){\begin{tabular}[b]{A{15}A{25}A{65}A{45}A{25}A{25}}
      \multicolumn{3}{A{105}}{} &  &  & \tabularnewline\hline
      \multicolumn{3}{A{105}}{\tiny\scshape ARMOR} &\tiny\scshape armor bonus &\tiny\scshape max dex &\tiny\scshape  check penalty \tabularnewline
      \itshape  &   & \multicolumn{4}{A{160}}{}  \tabularnewline\hline
	\tiny\scshape spell failure & \tiny\scshape type &\multicolumn{4}{A{160}} {\tiny\scshape notes } \tabularnewline
    \end{tabular}
}}

\newcommand\addarmor[9]{
	\addarmorbonus{#2}
	\renewcommand{\do}[1]{
		\miscbonus{##1}{#4}
	}\dolistloop{\armorcheckskillslist}
	\addtocounter{totalacitemsspellfailure}{#5}
		\ifthenelse{\equal{#3}{}}{}{\setcounter{charmaxdexarmorcount}{#3}}
		\ifthenelse{\value{charmaxdexarmorcount}<\value{charmaxdexbonuscount}}
		{\setcounter{charmaxdexbonuscount}{\value{charmaxdexarmorcount}}}{}
	\armoritem{#1}{#9}{#7}
	\renewcommand\armor[2]{
		\put(##1,##2){\begin{tabular}[b]{A{15}A{25}A{65}A{45}A{25}A{25}}
      		\multicolumn{3}{A{105}}{\itshape #1} & #2 & #3 &#4 \tabularnewline\hline
		\multicolumn{3}{A{105}}{\tiny\scshape ARMOR} &\tiny\scshape armor bonus &\tiny\scshape max dex &\tiny\scshape  check penalty \tabularnewline
      		\itshape #5\% &  #6 & \multicolumn{4}{A{160}}{#8}  \tabularnewline\hline
		\tiny\scshape spell failure & \tiny\scshape type &\multicolumn{4}{A{160}} {\tiny\scshape notes } \tabularnewline
    		\end{tabular}}}
}


\newcommand\shield[2]{
  \put(#1,#2){\begin{tabular}[b]{A{15}A{25}A{65}A{45}A{25}A{25}}
      \multicolumn{3}{A{105}}{} &  &  & \tabularnewline\hline
      \multicolumn{3}{A{105}}{\tiny\scshape shield} &\tiny\scshape shield bonus &\tiny\scshape max dex &\tiny\scshape  check penalty \tabularnewline
      \itshape  &  \multicolumn{5}{A{185}}{}  \tabularnewline\hline
	\tiny\scshape spell failure & & \multicolumn{4}{A{160}} {\tiny\scshape notes } \tabularnewline
    \end{tabular}
}}

\newcommand\addshield[8]{
	\addshieldbonus{#2}
	\renewcommand{\do}[1]{
		\miscbonus{##1}{#4}
	}\dolistloop{\armorcheckskillslist}
	\addtocounter{totalacitemsspellfailure}{#5}
		\ifthenelse{\equal{#3}{}}{}{\setcounter{charmaxdexshieldcount}{#3}}
		\ifthenelse{\value{charmaxdexshieldcount}<\value{charmaxdexbonuscount}}
		{\setcounter{charmaxdexbonuscount}{\value{charmaxdexshieldcount}}}{}
	\gearitem{Shield}{#7}
	\renewcommand\shield[2]{
		\put(##1,##2){\begin{tabular}[b]{A{15}A{25}A{65}A{45}A{25}A{25}}
      		\multicolumn{3}{A{105}}{\itshape #1} & #2 & #3 &#4 \tabularnewline\hline
		\multicolumn{3}{A{105}}{\tiny\scshape SHIELD} &\tiny\scshape shield bonus &\tiny\scshape max dex &\tiny\scshape  check penalty \tabularnewline
      		\itshape #5\% &  \multicolumn{4}{A{160}}{#8}  \tabularnewline\hline
		\tiny\scshape spell failure & &\multicolumn{4}{A{160}} {\tiny\scshape notes } \tabularnewline
    		\end{tabular}}
}}

\let\itemslotnames\@empty
\forcsvlist{\listadd{\itemslotnames}}{armor, belt, body, chest, eyes, feet, hands, head, headband, neck, ringone, ringtwo, shoulders, wrists}

\renewcommand{\do}[1]{
	\expandafter\newcommand\csname iteminslot#1isname\endcsname{}
	\expandafter\newcommand\csname iteminslot#1description\endcsname{}
	\expandafter\newlength\csname iteminslot#1weight\endcsname
	\expandafter\newcommand \csname#1item\endcsname[3]{
		\expandafter\renewcommand\csname iteminslot#1isname\endcsname{\itshape ##1}
		\expandafter\renewcommand\csname iteminslot#1description\endcsname{##2}
		\setlength{\csname iteminslot#1weight\endcsname}{##3pt}
		\addtolength{\wornitemsweight}{##3pt}
	}
}\dolistloop{\itemslotnames}

\newcommand{\ringitem}[3]{
\ifthenelse{\not\equal{\iteminslotringoneisname}{}\and\equal{\iteminslotringtwoisname}{}}
{\ringtwoitem{#1}{#2}{#3}}
{\ringoneitem{#1}{#2}{#3}}}

%%money
\renewcommand{\do}[1]{
\newcounter{char#1count}
\newcounter{char#1weightlesscount}
\newcounter{char#1storedcount}
\expandafter\newcommand\csname store#1\endcsname[1]{\addtocounter{char#1storedcount}{##1}}

}\docsvlist{platinum, gold, silver, copper}
\expandafter\newcommand\csname addplatinum\endcsname{\@ifstar\@@addplatinum\@addplatinum}
\expandafter\newcommand\csname @addplatinum\endcsname[1]{\addtocounter{charplatinumcount}{#1}}
\expandafter\newcommand\csname @@addplatinum\endcsname[1]{\addtocounter{charplatinumweightlesscount}{#1}}
\expandafter\newcommand\csname addgold\endcsname{\@ifstar\@@addgold\@addgold}
\expandafter\newcommand\csname @addgold\endcsname[1]{\addtocounter{chargoldcount}{#1}}
\expandafter\newcommand\csname @@addgold\endcsname[1]{\addtocounter{chargoldweightlesscount}{#1}}
\expandafter\newcommand\csname addsilver\endcsname{\@ifstar\@@addsilver\@addsilver}
\expandafter\newcommand\csname @addsilver\endcsname[1]{\addtocounter{charsilvercount}{#1}}
\expandafter\newcommand\csname @@addsilver\endcsname[1]{\addtocounter{charsilverweightlesscount}{#1}}
\expandafter\newcommand\csname addcopper\endcsname{\@ifstar\@@addcopper\@addcopper}
\expandafter\newcommand\csname @addcopper\endcsname[1]{\addtocounter{charcoppercount}{#1}}
\expandafter\newcommand\csname @@addcopper\endcsname[1]{\addtocounter{charcopperweightlesscount}{#1}}

%%Weight
\newlength{\totalgearweight}
\newlength{\totalstoredweight}
\newlength{\wornitemsweight}
\newlength{\currencyweight}
\newlength{\totalcarriedweight}
\newlength{\outputlength}
%\newcommand\printweight[1]{\strip@pt#1}
\newcommand\printweight[1]{%
\pgfmathsetmacro\outputlength{round(10*#1)/10.0}%
\outputlength}

\newcommand{\calculateweights}{
\setlength{\currencyweight}{.02pt*\value{charplatinumcount}+.02pt*\value{chargoldcount}+.02pt*\value{charsilvercount}+.02pt*\value{charcoppercount}}
\setlength{\totalcarriedweight}{\totalgearweight+\currencyweight+\wornitemsweight}
}


%%Carrying Capacity
\newcounter{charheavyloadcount}
\newcounter{charmediumloadcount}
\newcounter{charlightloadcount}
\newcounter{charstrcarryingmiscmodcount}
\newcounter{charstrcarryingcount}
\newcounter{charliftloadcount}
\newcounter{chardragloadcount}

\newcounter{tmpheavyloadcount}
\newcounter{carryingcapacitymultipliercount}
\setcounter{carryingcapacitymultipliercount}{1}
\newcounter{tmpstr}
\newcommand\setheavyload[1]{%
\ifthenelse{\value{#1}>19}{%
	\setcounter{tmpstr}{\value{#1}-10}%
	\setheavyload{tmpstr}
	\addtocounter{tmpheavyloadcount}{\value{tmpheavyloadcount}}
	\addtocounter{tmpheavyloadcount}{\value{tmpheavyloadcount}}
	}{%
	\setcounter{tmpstr}{\value{#1}}
	\forloop{@i}{0}{\value{@i}<10}{
	\ifthenelse{\value{tmpstr}>0}{\addtocounter{tmpheavyloadcount}{10}\addtocounter{tmpstr}{-1}}{}}
	\forloop{@i}{0}{\value{@i}<2}{
	\ifthenelse{\value{tmpstr}>0}{\addtocounter{tmpheavyloadcount}{15}\addtocounter{tmpstr}{-1}}{}}
	\ifthenelse{\value{tmpstr}>0}{\addtocounter{tmpheavyloadcount}{20}\addtocounter{tmpstr}{-1}}{}
	\forloop{@i}{0}{\value{@i}<2}{
	\ifthenelse{\value{tmpstr}>0}{\addtocounter{tmpheavyloadcount}{25}\addtocounter{tmpstr}{-1}}{}}
	\forloop{@i}{0}{\value{@i}<2}{
	\ifthenelse{\value{tmpstr}>0}{\addtocounter{tmpheavyloadcount}{30}\addtocounter{tmpstr}{-1}}{}}
	\ifthenelse{\value{tmpstr}>0}{\addtocounter{tmpheavyloadcount}{40}\addtocounter{tmpstr}{-1}}{}
	\ifthenelse{\value{tmpstr}>0}{\addtocounter{tmpheavyloadcount}{50}\addtocounter{tmpstr}{-1}}{}
	}
}
\newcommand\calculateloads{
\setcounter{charstrcarryingcount}{\value{charstrcount}+\value{charstrcarryingmiscmodcount}}
\setheavyload{charstrcarryingcount}
\setcounter{charheavyloadcount}{\value{tmpheavyloadcount}*\value{carryingcapacitymultipliercount}}
\setcounter{charmediumloadcount}{\value{charheavyloadcount}*2/3}
\setcounter{charlightloadcount}{\value{charheavyloadcount}/3}
\setcounter{charliftloadcount}{\value{charheavyloadcount}*2}
\setcounter{chardragloadcount}{\value{charheavyloadcount}*5}
}

\newcounter{charencumberancelevelcount}
\newcounter{charencumberedmaxdexcount}
\setcounter{charencumberedmaxdexcount}{100}
\newcounter{charencumberedcheckpenaltycount}
\newcounter{charencumberedspeedreductioncount}
\newlength\loadaslength

\newcommand\checkencumberance{
\setlength\loadaslength{1pt*\value{charlightloadcount}}
\ifthenelse{\lengthtest{\totalcarriedweight<\loadaslength}}{ 
	\setcounter{charencumberancelevelcount}{1}}{
\setlength\loadaslength{1pt*\value{charmediumloadcount}}
\ifthenelse{\lengthtest{\totalcarriedweight<\loadaslength}}{
\setcounter{charencumberancelevelcount}{2}
\setcounter{charencumberedcheckpenaltycount}{-3}
\setcounter{charencumberedmaxdexcount}{3}
\setcounter{charencumberedspeedreductioncount}{\value{charspeedreduciblecount}}}{
\setlength\loadaslength{1pt*\value{charheavyloadcount}}
\ifthenelse{\lengthtest{\totalcarriedweight<\loadaslength}}{
\setcounter{charencumberancelevelcount}{3}
\setcounter{charencumberedcheckpenaltycount}{-6}
\setcounter{charencumberedmaxdexcount}{1}
\setcounter{charencumberedspeedreductioncount}{\value{charspeedreduciblecount}}}{
\setcounter{charencumberancelevelcount}{4}
\setcounter{charencumberedcheckpenaltycount}{-10}
\setcounter{charencumberedmaxdexcount}{0}
\setcounter{charencumberedspeedreductioncount}{\value{charspeedreduciblecount}}}}}
\ifthenelse{\value{charencumberedmaxdexcount}<\value{charmaxdexbonuscount}}
{\setcounter{charmaxdexbonuscount}{\value{charencumberedmaxdexcount}}}{}
\renewcommand{\do}[1]{
	\miscbonus{##1}{\value{charencumberedcheckpenaltycount}}
}\dolistloop{\armorcheckskillslist}
}

\newcommand\encumberancebox[1]{
  \ifthenelse{#1 = \value{charencumberancelevelcount}}{$\cancel{\square}$}{$\square$}
}




%%%% Spells %%%%



\let\cantrips\@empty
\let\firstspells\@empty
\let\secondspells\@empty
\let\thirdspells\@empty
\let\fourthspells\@empty
\let\fifthspells\@empty
\let\sixthspells\@empty
\let\seventhspells\@empty
\let\eighthspells\@empty
\let\ninthspells\@empty


\def\newcantrip #1|#2|#3|#4|#5|#6|#7|#8|#9|{ %
	\listadd{\cantrips}{#1}
	\def\lastargs ##1|##2|##3|{
		\expandafter\def\csname #1\endcsname{0& & & #1: #2 & #3 #4 & ##1 & #7 & ##2 & ##3\\\hline}
		\expandafter\def\csname spell#1header\endcsname{
		\noindent{\bf\large#1}
		\\\textit{#3} #4
		\\\textbf{Casting Time} #5
		\\\textbf{Components} #6
		\\\textbf{Range} #7
		\\\textbf{#8} #9
		\\\textbf{Duration} ##1
		\\\textbf{Saving Throw} ##2; \textbf{Spell Resistance} ##3
		}
	}
	\lastargs
}
\def\newfirstspell #1|#2|#3|#4|#5|#6|#7|#8|#9|{ %
	\listadd{\firstspells}{#1}
	\def\lastargs ##1|##2|##3|{
		\expandafter\def\csname #1\endcsname{1& & & #1: #2 & #3 #4 & ##1 & #7 & ##2 & ##3\\\hline}
		\expandafter\def\csname spell#1header\endcsname{
		\noindent{\bf\large#1}
		\\\textit{#3} #4
		\\\textbf{Casting Time} #5
		\\\textbf{Components} #6
		\\\textbf{Range} #7
		\\\textbf{#8} #9
		\\\textbf{Duration} ##1
		\\\textbf{Saving Throw} ##2; \textbf{Spell Resistance} ##3
		}
	}
	\lastargs
}
\def\newsecondspell #1|#2|#3|#4|#5|#6|#7|#8|#9|{ %
	\listadd{\secondspells}{#1}
	\def\lastargs ##1|##2|##3|{
		\expandafter\def\csname #1\endcsname{2& & & #1: #2 & #3 #4 & ##1 & #7 & ##2 & ##3\\\hline}
		\expandafter\def\csname spell#1header\endcsname{
		\noindent{\bf\large#1}
		\\\textit{#3} #4
		\\\textbf{Casting Time} #5
		\\\textbf{Components} #6
		\\\textbf{Range} #7
		\\\textbf{#8} #9
		\\\textbf{Duration} ##1
		\\\textbf{Saving Throw} ##2; \textbf{Spell Resistance} ##3
		}
	}
	\lastargs
}
\def\newthirdspell #1|#2|#3|#4|#5|#6|#7|#8|#9|{ %
	\listadd{\thirdspells}{#1}
	\def\lastargs ##1|##2|##3|{
		\expandafter\def\csname #1\endcsname{3& & & #1: #2 & #3 #4 & ##1 & #7 & ##2 & ##3\\\hline}
		\expandafter\def\csname spell#1header\endcsname{
		\noindent{\bf\large#1}
		\\\textit{#3} #4
		\\\textbf{Casting Time} #5
		\\\textbf{Components} #6
		\\\textbf{Range} #7
		\\\textbf{#8} #9
		\\\textbf{Duration} ##1
		\\\textbf{Saving Throw} ##2; \textbf{Spell Resistance} ##3
		}
	}
	\lastargs
}
\def\newfourthspell #1|#2|#3|#4|#5|#6|#7|#8|#9|{ %
	\listadd{\fourthspells}{#1}
	\def\lastargs ##1|##2|##3|{
		\expandafter\def\csname #1\endcsname{4& & & #1: #2 & #3 #4 & ##1 & #7 & ##2 & ##3\\\hline}
		\expandafter\def\csname spell#1header\endcsname{
		\noindent{\bf\large#1}
		\\\textit{#3} #4
		\\\textbf{Casting Time} #5
		\\\textbf{Components} #6
		\\\textbf{Range} #7
		\\\textbf{#8} #9
		\\\textbf{Duration} ##1
		\\\textbf{Saving Throw} ##2; \textbf{Spell Resistance} ##3
		}
	}
	\lastargs
}
\def\newfifthspell #1|#2|#3|#4|#5|#6|#7|#8|#9|{ %
	\listadd{\fifthspells}{#1}
	\def\lastargs ##1|##2|##3|{
		\expandafter\def\csname #1\endcsname{5& & & #1: #2 & #3 #4 & ##1 & #7 & ##2 & ##3\\\hline}
		\expandafter\def\csname spell#1header\endcsname{
		\noindent{\bf\large#1}
		\\\textit{#3} #4
		\\\textbf{Casting Time} #5
		\\\textbf{Components} #6
		\\\textbf{Range} #7
		\\\textbf{#8} #9
		\\\textbf{Duration} ##1
		\\\textbf{Saving Throw} ##2; \textbf{Spell Resistance} ##3
		}
	}
	\lastargs
}
\def\newsixthspell #1|#2|#3|#4|#5|#6|#7|#8|#9|{ %
	\listadd{\sixthspells}{#1}
	\def\lastargs ##1|##2|##3|{
		\expandafter\def\csname #1\endcsname{6& & & #1: #2 & #3 #4 & ##1 & #7 & ##2 & ##3\\\hline}
		\expandafter\def\csname spell#1header\endcsname{
		\noindent{\bf\large#1}
		\\\textit{#3} #4
		\\\textbf{Casting Time} #5
		\\\textbf{Components} #6
		\\\textbf{Range} #7
		\\\textbf{#8} #9
		\\\textbf{Duration} ##1
		\\\textbf{Saving Throw} ##2; \textbf{Spell Resistance} ##3
		}
	}
	\lastargs
}
\def\newseventhspell #1|#2|#3|#4|#5|#6|#7|#8|#9|{ %
	\listadd{\seventhspells}{#1}
	\def\lastargs ##1|##2|##3|{
		\expandafter\def\csname #1\endcsname{7& & & #1: #2 & #3 #4 & ##1 & #7 & ##2 & ##3\\\hline}
		\expandafter\def\csname spell#1header\endcsname{
		\noindent{\bf\large#1}
		\\\textit{#3} #4
		\\\textbf{Casting Time} #5
		\\\textbf{Components} #6
		\\\textbf{Range} #7
		\\\textbf{#8} #9
		\\\textbf{Duration} ##1
		\\\textbf{Saving Throw} ##2; \textbf{Spell Resistance} ##3
		}
	}
	\lastargs
}
\def\neweighthspell #1|#2|#3|#4|#5|#6|#7|#8|#9|{ %
	\listadd{\eighthspells}{#1}
	\def\lastargs ##1|##2|##3|{
		\expandafter\def\csname #1\endcsname{8& & & #1: #2 & #3 #4 & ##1 & #7 & ##2 & ##3\\\hline}
		\expandafter\def\csname spell#1header\endcsname{
		\noindent{\bf\large#1}
		\\\textit{#3} #4
		\\\textbf{Casting Time} #5
		\\\textbf{Components} #6
		\\\textbf{Range} #7
		\\\textbf{#8} #9
		\\\textbf{Duration} ##1
		\\\textbf{Saving Throw} ##2; \textbf{Spell Resistance} ##3
		}
	}
	\lastargs
}
\def\newninthspell #1|#2|#3|#4|#5|#6|#7|#8|#9|{ %
	\listadd{\ninthspells}{#1}
	\def\lastargs ##1|##2|##3|{
		\expandafter\def\csname #1\endcsname{9& & & #1: #2 & #3 #4 & ##1 & #7 & ##2 & ##3\\\hline}
		\expandafter\def\csname spell#1header\endcsname{
		\noindent{\bf\large#1}
		\\\textit{#3} #4
		\\\textbf{Casting Time} #5
		\\\textbf{Components} #6
		\\\textbf{Range} #7
		\\\textbf{#8} #9
		\\\textbf{Duration} ##1
		\\\textbf{Saving Throw} ##2; \textbf{Spell Resistance} ##3
		}
	}
	\lastargs
}

\newcommand\spelldescription[2]{
\expandafter\newcommand\csname spell#1description\endcsname{#2}
}
\newcommand{\charspellcastingclassone}{}
\newcommand{\charspellcastingclassoneability}{}
\newcounter{charCLonecount}
\newcounter{charspellcastingclassonemaxspelllevelcount}
\setcounter{charspellcastingclassonemaxspelllevelcount}{-1}
\newcommand{\charspellcastingclasstwo}{}
\newcommand{\charspellcastingclasstwoability}{}
\newcounter{charCLtwocount}
\newcounter{charspellcastingclasstwomaxspelllevelcount}
\setcounter{charspellcastingclasstwomaxspelllevelcount}{-1}

\newcommand{\newspellcastingone}[4][9]{
\setcounter{charspellcastingclassonemaxspelllevelcount}{#1}
\renewcommand{\charspellcastingclassone}{#2}
\renewcommand{\charspellcastingclassoneability}{#4}
\setcounter{charCLonecount}{#3}
}
\newcommand{\newspellcastingtwo}[4][9]{
\setcounter{charspellcastingclasstwomaxspelllevelcount}{#1}
\renewcommand{\charspellcastingclasstwo}{#2}
\renewcommand{\charspellcastingclasstwoability}{#4}
\setcounter{charCLtwocount}{#3}
}
\newcommand{\newspellcasting}[4][9]{
\ifthenelse{\equal{\charspellcastingclassone}{}}
{\newspellcastingone[#1]{#2}{#3}{#4}}
{\newspellcastingtwo[#1]{#2}{#3}{#4}}
}

\newcounter{savedctmpcount}

\newcommand{\saveDCone}[1]{
\ifthenelse{\equal{\charspellcastingclassone}{}}{}{
\ifthenelse{#1>\value{charspellcastingclassonemaxspelllevelcount}}{}{
\setcounter{savedctmpcount}{10+#1+\value{char\charspellcastingclassoneability modcount}}
\arabic{savedctmpcount}}}}

\newcommand{\saveDCtwo}[1]{
\ifthenelse{\equal{\charspellcastingclasstwo}{}}{}{
\ifthenelse{#1>\value{charspellcastingclasstwomaxspelllevelcount}}{}{
\setcounter{savedctmpcount}{10+#1+\value{char\charspellcastingclasstwoability modcount}}
\arabic{savedctmpcount}}}}

\newcounter{@i}
\forloop{@i}{0}{\value{@i}<10}{
\newcounter{charabilityspellslotsone\arabic{@i}count}
\newcounter{charabilityspellslotstwo\arabic{@i}count}
\newcounter{charclassspellslotsone\arabic{@i}count}
\newcounter{charclassspellslotstwo\arabic{@i}count}
\newcounter{charbonusspellslotsone\arabic{@i}count}
\newcounter{charbonusspellslotstwo\arabic{@i}count}
\newcounter{chartotalspellslotsone\arabic{@i}count}
\newcounter{chartotalspellslotstwo\arabic{@i}count}
}

\newcommand{\computespellslots}{
\ifthenelse{\equal{\charspellcastingclassoneability}{}}{}{
\forloop{@i}{1}{\value{@i}<10}{
\ifthenelse{\value{@i}>\value{charspellcastingclassonemaxspelllevelcount}}{}{
\setcounter{charabilityspellslotsone\arabic{@i}count}{(\value{char\charspellcastingclassoneability modcount}+4-\value{@i})/4}
}}}
\ifthenelse{\equal{\charspellcastingclasstwoability}{}}{}{
\forloop{@i}{1}{\value{@i}<10}{
\ifthenelse{\value{@i}>\value{charspellcastingclasstwomaxspelllevelcount}}{}{
\setcounter{charabilityspellslotstwo\arabic{@i}count}{(\value{char\charspellcastingclasstwoability modcount}+4-\value{@i})/4}
}}}
\forloop{@i}{0}{\value{@i}<10}{
\setcounter{chartotalspellslotsone\arabic{@i}count}{\arabic{charclassspellslotsone\arabic{@i}count}+\arabic{charbonusspellslotsone\arabic{@i}count}+\arabic{charabilityspellslotsone\arabic{@i}count}}
\setcounter{chartotalspellslotstwo\arabic{@i}count}{\arabic{charclassspellslotstwo\arabic{@i}count}+\arabic{charbonusspellslotstwo\arabic{@i}count}+\arabic{charabilityspellslotstwo\arabic{@i}count}}}}

\newcommand{\addspellslotsone}[2]{
\addtocounter{charclassspellslotsone#1count}{#2}}
\newcommand{\addspellslotstwo}[2]{
\addtocounter{charclassspellslotstwo#1count}{#2}}
\newcommand{\setspellslotsone}[2]{
\setcounter{charclassspellslotsone#1count}{#2}}
\newcommand{\setspellslotstwo}[2]{
\setcounter{charclassspellslotstwo#1count}{#2}}

\newcommand{\addspellslots}[2]{
\ifthenelse{\equal{\charspellcastingclasstwo}{}}{\addspellslotsone{#1}{#2}}{\addspellslotstwo{#1}{#2}}}

% Range
\newcounter{charspellrangeclosecount}
\newcounter{charspellrangemediumcount}
\newcounter{charspellrangelongcount}
\newcommand{\calculatespellrange}[1]{
\setcounter{charspellrangeclosecount}{25+\value{charCL#1count}/2*5}
\setcounter{charspellrangemediumcount}{100+\value{charCL#1count}*10}
\setcounter{charspellrangelongcount}{400+\value{charCL#1count}*40}}

%Magic Specializations
\renewcommand{\do}[1]{
\expandafter\newcommand\csname spellspecialization#1\endcsname{}
\expandafter\newcommand\csname spellspecialization#1type\endcsname{Specialization}
\expandafter\newcommand\csname addspellspecialization#1\endcsname[2][Specialization]{
\expandafter\renewcommand\csname spellspecialization#1type\endcsname{##1}
\expandafter\renewcommand\csname spellspecialization#1\endcsname{##2}}
}\docsvlist{one, two, three}
\newcommand\addspellspecialization[2][Specialization]{
\ifthenelse{\equal{\spellspecializationone}{}}{\addspellspecializationone[#1]{#2}}{
\ifthenelse{\equal{\spellspecializationtwo}{}}{\addspellspecializationtwo[#1]{#2}}{
\adspellspecializationthree[#1]{#2}}}
}
\renewcommand{\do}[1]{
\expandafter\newcommand\csname spellprohibition#1\endcsname{}
\expandafter\newcommand\csname spellprohibition#1type\endcsname{prohibition}
\expandafter\newcommand\csname addspellprohibition#1\endcsname[2][prohibition]{
\expandafter\renewcommand\csname spellprohibition#1type\endcsname{##1}
\expandafter\renewcommand\csname spellprohibition#1\endcsname{##2}}
}\docsvlist{one, two}
\newcommand\addspellprohibition[2][prohibition]{
\ifthenelse{\equal{\spellprohibitionone}{}}{\addspellprohibitionone[#1]{#2}}{
\adspellprohibitiontwo[#1]{#2}}
}

%Spellcasting Notes
\let\spellcastingnoteslist\@empty
\newcommand{\addspellcastingnote}[1]{
\listadd{\spellcastingnoteslist}{#1}}




%%%% Character Name & Description %%%%



\newcommand\charname{}
\newcommand\charlevel{}
\newcommand\charplayername{}
\newcommand\charalignment{}
\newcommand\chardiety{}
\newcommand\charrace{}
\newcommand\charhomeland{}
\newcommand\charsize{}
\newcommand\chargender{}
\newcommand\charage{}
\newcommand\charheight{}
\newcommand\charweight{}
\newcommand\charhair{}
\newcommand\chareyes{}



%%%% Miscellaney %%%%



%%Blank Sheet Generator
\newcommand\blanksheet{
\renewcommand{\trainskill}[3]{\skill{##1}{##2}{##3}}
%\renewcommand\arabic[1]{}
%\edef\cleanarabic##1{}
%\edef\plusminus##1{}
%\edef\input##1{}
%\edef\initialize{}
\def\equalattributes##1##2##3##4{%
	\newcount\xcount
	\xcount=##1
	\newcount\pluscount
	\newcount\tmpcount
	\newcount\mytotalcount
	\mytotalcount=0
	\newcount\firstcount
	\firstcount=0
	
	% Just to skip the first box
	\pluscount=0
	\advance\pluscount by ##4
	\advance\pluscount by -15
	\tmpcount=\xcount
	\advance\tmpcount by \number\pluscount
	\advance\xcount by ##4
	
	\@for\tmp:=##3\do{%
		\pluscount=0
		\advance\pluscount by ##4
		\advance\pluscount by -15
		\tmpcount=\xcount
		\advance\tmpcount by \number\pluscount
		\ifnum\number\firstcount=0 
		\put(\xcount,##2){\makebox(\pluscount,9){\tiny =}}
		\else
		\put(\xcount,##2){\makebox(\pluscount,9){\tiny +}}
		\fi
		\put(\tmpcount,##2){\framebox(15,9){}}
		\advance\xcount by ##4

		\advance\firstcount by 1
	}
	  \xcount=##1
	  \pluscount=0
	  \advance\pluscount by ##4
	  \advance\pluscount by -15
	  \tmpcount=\xcount
	  \advance\tmpcount by \number\pluscount
	  \put(\tmpcount,##2){\framebox(15,9){}}
}
\def\printdamagereduction{}
%\renewcommand\skill[3]{
%	\classskillbox{0} &  ##2\ifinlist{##1}{\armorcheckskillslist}{$\dagger$}{} &  & $=$ \capitalize{##3} & & $+$ &  &  $+$ &  & $+$ &  \tabularnewline\cline{3-3}\cline{5-5}\cline{7-7}\cline{9-9}\cline{11-11}
%}
}
%%Adds lines to feats, etc. sections in blank sheet
\newcommand\lineemup{
\newcounter{i}
\forloop{@i}{0}{\value{@i}<10}{
\listadd\gearlist{\hline & \tabularnewline}
\listadd\storeditemslist{\hline &\tabularnewline}
}}

%% Health counter
\newcounter{charhpcount}

%% Miscellaneous Bonus
\newcommand\miscbonus[2]{
\addtocounter{char#1misccount}{#2}}

\newcounter{charspellresistancecount}
\newcounter{charinitiativemisccount}

%%Conditional Modifiers
\let\conditionalskillsmodlist\@empty
\let\conditionalattackmodlist\@empty
\let\conditionaldefmodlist\@empty

\newcommand{\addconditionalskillmod}[1]{
\listadd\conditionalskillsmodlist{#1}}
\newcommand{\addconditionalattackmod}[1]{
\listadd\conditionalattackmodlist{#1}}
\newcommand{\addconditionaldefmod}[1]{
\listadd\conditionaldefmodlist{#1}}

%% Languages
\let\charlanguageslist\@empty
\newcommand{\addcharlanguage}[1]{
\listinsert{\charlanguageslist}{#1}
}




\newcounter{chararmorbonuscount}
\newcounter{charshieldbonuscount}
\newcounter{charnaturalarmormodcount}
\newcounter{chardodgemodcount}
	\def\adddodgebonus#1{\addtocounter{chardodgemodcount}{#1}\addtocounter{charCMDmiscmodcount}{#1}}
\newcounter{charsizemodcount}
\newcounter{chardeflectionmodcount}
\newcounter{charACmiscmodcount}
\newcounter{chartouchmiscmodcount}
\newcounter{charflatfootedmiscmodcount}

\newcommand{\addarmorbonus}[1]{\ifthenelse{\arabic{chararmorbonuscount}<#1}{\setcounter{chararmorbonuscount}{#1}}{}}
\newcommand{\addshieldbonus}[1]{\ifthenelse{\arabic{charshieldbonuscount}<#1}{\setcounter{charshieldbonuscount}{#1}}{}}


\newcounter{charresistancemodcount}
\newcommand{\resistancebonus}[1]{\ifthenelse{\arabic{charresistancemodcount}<#1}{\setcounter{charresistancemodcount}{#1}}{}}

\newcounter{charbabcount}

\renewcommand{\do}[1]{
\newcounter{char#1count}
\newcounter{char#1misccount}
\newcounter{char#1tmpcount}
}\docsvlist{fortitude, reflex, will}

\newcounter{charmeleemiscmodcount}
\newcounter{charmeleetmpmodcount}
\newcounter{charrangedmiscmodcount}
\newcounter{charrangedtmpmodcount}
\newcounter{charCMBmiscmodcount}
\newcounter{charCMBtmpmodcount}
\newcounter{charCMDmiscmodcount}
\newcounter{charCMDtmpmodcount}
\newcounter{charCMDbasecount}

\newcounter{charspeedreduciblecount}
\setcounter{charspeedreduciblecount}{1}
\renewcommand{\do}[1]{
\newcounter{char#1speedcount}
\newcounter{char#1speedsqcount}
}\docsvlist{base, fly, swim, burrow, climb}

\newcommand{\charspeed}[1]{
\setcounter{charbasespeedcount}{#1}
}

\newcounter{charmaneuverabilitycount}
\newcommand{\addflyspeed}[2]{
\setcounter{charflyspeedcount}{#1}
\setcounter{charmaneuverabilitycount}{#2}
}
\newcommand{\addclimbspeed}[1]{
\setcounter{charclimbspeedcount}{#1}
}
\newcommand{\addburrowspeed}[1]{
\setcounter{charburrowspeedcount}{#1}
}
\newcounter{charspeedenhmodcount}
\newcommand{\speedenh}[1]{\ifthenelse{\arabic{charspeedenhmodcount}<#1}{\setcounter{charspeedenhmodcount}{#1}}{}}

\newcommand{\speedinitialize}{
\renewcommand{\do}[1]{
\ifthenelse{\value{char##1speedcount}=0}{}{\addtocounter{char##1speedcount}{\value{charspeedenhmodcount}}}
\setcounter{char##1speedsqcount}{(\value{char##1speedcount})/5}
}\docsvlist{base, fly, swim, burrow, climb}
\miscbonus{fly}{\value{charmaneuverabilitycount}}
\miscbonus{fly}{\value{charsizemodcount}}
\miscbonus{fly}{\value{charsizemodcount}}
}

\newcounter{charresistfirecount}
\newcounter{charresistcoldcount}
\newcounter{charresistelectricitycount}
\newcounter{charresistacidcount}
\newcounter{charresistsoniccount}

\newcommand{\resist}[2]{
\ifinlist{#1}{\charimmunitylist}{}{
\ifnum\value{charresist#1count}<#2
\setcounter{charresist#1count}{#2}\fi
}}

\newcommand{\printresistances}{
\renewcommand{\do}[1]{
\ifthenelse{\value{charresist##1count}=0}{\hspace{-3.5pt}}{##1 \arabic{charresist##1count};\hspace{-1pt}}
}\docsvlist{fire,cold,electricity,acid,sonic}}

\edef\charimmunitylist{}
\newcommand{\immune}[1]{
\ifinlist{#1}{\charimmunitylist}{}
\listadd{\charimmunitylist}{#1}
\ifltxcounter{charresist#1count}
{\setcounter{charresist#1count}{0}}
{}
}

\newcommand{\newDRtype}[2]{
\expandafter\newcommand\csname DRis#1type\endcsname {#2}
\newcounter{charDR#1count}
\listadd{\DRtypeslist}{#1}}

\newDRtype{coldiron}{Cold Iron}
\newDRtype{adamantine}{Adamantine}
\newDRtype{silver}{Silver}
\newDRtype{bludgeoning}{Bludgeoning}
\newDRtype{piercing}{Piercing}
\newDRtype{slashing}{Slashing}
\newDRtype{good}{Good}
\newDRtype{evil}{Evil}
\newDRtype{lawful}{Lawful}
\newDRtype{chaotic}{Chaotic}
\newDRtype{magic}{Magic}
\newDRtype{blank}{--}

\newcommand{\addDR}[2]{
\ifthenelse{#2 > \arabic{charDR#1count}}{
\setcounter{charDR#1count}{#2}}{}
}

\newcommand{\printdamagereduction}{
\renewcommand{\do}[1]{
\ifthenelse{\arabic{charDR##1count} = 0}{\hspace{-3.5pt}}{\arabic{charDR##1count}/{\csname DRis##1type\endcsname};\hspace{-1pt}}
}\dolistloop{\DRtypeslist}
}

\newcommand{\computeabilityscores}{
\renewcommand{\do}[1]{
\setcounter{char##1count}{\value{char##1basecount}}
\addtocounter{char##1count}{\value{char##1enhcount}}
\addtocounter{char##1count}{\value{char##1misccount}}
\addtocounter{char##1count}{\value{char##1tmpcount}}
\setcounter{char##1modcount}{0}
\setcounter{char##1modcount}{(\value{char##1count}-10)/\real{2}}
}\dolistloop{\abilityscores}
}

\newcounter{chariteratedattackscount}

\newcommand{\initialize}{
\computeabilityscores
\setcounter{charcmdabilitymodcount}{\value{charstrmodcount}+\value{chardexmodcount}}
\speedinitialize
\setcounter{chariteratedattackscount}{(\value{charbabcount}-1)/5+1}
\computespellslots
\calculateloads
\calculateweights
\checkencumberance
\setcounter{chardextoACcount}{\minof{\value{chardexmodcount}}{\value{charmaxdexbonuscount}}}
}


\newcounter{charspecialsizemodcount}
\newcommand\finesize{
\renewcommand{\charsize}{Fine}
\setcounter{charsizemodcount}{8}
\setcounter{charspecialsizemodcount}{-8}
}
\newcommand\diminutivesize{
\renewcommand{\charsize}{Diminutive}
\setcounter{charsizemodcount}{4}
\setcounter{charspecialsizemodcount}{-4}
}
\newcommand\tinysize{
\renewcommand{\charsize}{Tiny}
\setcounter{charsizemodcount}{2}
\setcounter{charspecialsizemodcount}{-2}
}
\newcommand\smallsize{
\renewcommand{\charsize}{Small}
\setcounter{charsizemodcount}{1}
\setcounter{charspecialsizemodcount}{-1}
}
\newcommand\mediumsize{
\renewcommand{\charsize}{Medium}
\setcounter{charsizemodcount}{0}
\setcounter{charspecialsizemodcount}{0}
}
\newcommand\largesize{
\renewcommand{\charsize}{Large}
\setcounter{charsizemodcount}{-1}
\setcounter{charspecialsizemodcount}{1}
}
\newcommand\hugesize{
\renewcommand{\charsize}{Huge}
\setcounter{charsizemodcount}{-2}
\setcounter{charspecialsizemodcount}{2}
}
\newcommand\gargantuansize{
\renewcommand{\charsize}{Gargantuan}
\setcounter{charsizemodcount}{-4}
\setcounter{charspecialsizemodcount}{4}
}
\newcommand\colossalsize{
\renewcommand{\charsize}{Colossal}
\setcounter{charsizemodcount}{-8}
\setcounter{charspecialsizemodcount}{8}
\edef\@emptylist{}
\printlist{\@emptylist}
}