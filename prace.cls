%%% Partnership for Advanced Computing in Europe 
%%%   www.prace-ri.eu
%%%
%%% LaTeX document class for a PRACE-RI whitepaper.
%%%
%%% (c) CSC - IT Center for Science Ltd.
%%%   author: Martti Louhivuori (martti.louhivuori@csc.fi)
%%%
%%% Requires: LaTeX2e
%%%           geometry, graphicx, ifthen, booktabs
%%%
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{prace}[2013/03/26 PRACE-RI Whitepaper class]

\DeclareOption{onecolumn}{\OptionNotUsed}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax

\LoadClass[a4paper]{article}

% A4: 210x297mm - 20mm margins
\RequirePackage{geometry}
\geometry{text={170mm,257mm}, centering}
\RequirePackage{graphicx}
\RequirePackage{ifthen}
\RequirePackage{booktabs}

% page numbering
\pagenumbering{arabic}
%\pagestyle{empty}
% default font
\renewcommand{\normalsize}{\fontsize{10}{11}\selectfont}

% default values
\def\projectname{}
\def\authortel{+0-000-000-0000}
\def\authorfax{+0-000-000-0000}
\def\authoremail{author@example.com}

% internal counters
\newcounter{praceauth}
\setcounter{praceauth}{0}
\renewcommand\thepraceauth{\alph{praceauth}}
\newcounter{praceaffi}
\setcounter{praceaffi}{0}
\renewcommand\thepraceaffi{\alph{praceaffi}}
\newcounter{pracetmp}
\setcounter{pracetmp}{0}
\renewcommand\thepracetmp{\alph{pracetmp}}

% project ID & author contact details
\newcommand\project[1]{\renewcommand\projectname{#1}}
\newcommand{\email}[1]{\renewcommand\authoremail{#1}}
\newcommand{\tel}[1]{\renewcommand\authortel{#1}}
\newcommand{\fax}[1]{\renewcommand\authorfax{#1}}

% tag corresponding author
\newif\if@iscorresponding
\@iscorrespondingfalse
\newif\if@hascorresponding
\@hascorrespondingfalse
\newcommand\corresponding[0]{\@iscorrespondingtrue\@hascorrespondingtrue}
% corresponding author footnote
\long\def\authorfootnote{%
	\def\thefootnote{\fnsymbol{footnote}}%
	\csname c@\@mpfn\endcsname 1\relax%
	\xdef\@thefnmark{\thempfn}%
	\@footnotetext}
% corresponding author contact detail footnote
\def\authorcontact{%
	\authorfootnote{Corresponding author.\\%
	\indent\hspace{1ex} 
	tel. \authortel{}\hspace{1ex}
	fax. \authorfax{}\hspace{1ex} 
	e-mail. \authoremail{}}
	}

% tmp flag
\newif\if@praceflag
\@praceflagfalse

% convert integers to letters
\def\csvitoalist{}
\newcommand\csvitoa[1]{
	\def\csvitoalist{}
	\@for\name:=#1\do{
		\setcounter{pracetmp}{\name}
		\if@praceflag
			\edef\csvitoalist{\csvitoalist,\thepracetmp}
		\else
			\edef\csvitoalist{\thepracetmp}
			\@praceflagtrue
		\fi}
	\@praceflagfalse
	\csvitoalist
	}

% store author definitions for later use
\def\authorlist{}
\def\tmpname{}
\renewcommand\author[2][a]{%
	%
	\def\alfalist{}
	\@for\name:=#1\do{
		\setcounter{pracetmp}{\name}
		\if@praceflag
			\edef\alfalist{\alfalist,\thepracetmp}
		\else
			\edef\alfalist{\thepracetmp}
			\@praceflagtrue
		\fi}
	\@praceflagfalse
	%
%	\def\alfalist{\csvitoa{#1}}
	%
	\def\tmpname{#2}
	\if@iscorresponding
		\edef\tmpname{\tmpname{}${}^{\alfalist{},*}$}
	\else
		\edef\tmpname{\tmpname{}${}^{\alfalist}$}
	\fi
	\ifnum \c@praceauth >\z@
		\edef\authorlist{\authorlist{}, \tmpname{}}
	\else
		\edef\authorlist{\tmpname{}}
	\fi
	\@iscorrespondingfalse
	\addtocounter{praceauth}{1}
}
% store affiliation definitions for later use
\def\affiliationlist{}
\newcommand\affiliation[2][a]{%
	\addtocounter{praceaffi}{1}
	\def\tmpname{{${}^{\thepraceaffi}$#2}}
	\ifnum \c@praceaffi >\@ne
		\edef\affiliationlist{\affiliationlist{},\tmpname{}}
	\else
		\edef\affiliationlist{\tmpname{}}
	\fi%
}
% output affiliation list
\newcommand\affiliationblock[0]{%
	\@for\name:=\affiliationlist\do{\name\\}}

% title block
\renewcommand{\maketitle}{%
  \newpage
	\noindent\begin{minipage}{3cm}
	\includegraphics[width=3cm]{prace-logo}
	\end{minipage}
	\begin{minipage}{11cm}
	\centering%
	Available on-line at www.prace-ri.eu\\\vspace{1em}
	{\large\bfseries Partnership for Advanced Computing in Europe}
	\end{minipage}
	\begin{minipage}{3cm}
	\end{minipage}\\
  \null
  \vskip 2em%
  \begin{center}%
  \let \footnote \thanks
    {\LARGE \@title \par}%
    \vskip 1.5em%
    {\large
      \lineskip .5em%
      \begin{tabular}[t]{c}%
        \authorlist
      \end{tabular}\par}%
    \vskip 1em%
		\affiliationblock
		\if@hascorresponding
			\authorcontact
		\else
			\@latex@warning{Corresponding author is undefined}
		\fi
  \end{center}%
  \par
  \vskip 1.5em%
}

% section heading formats
\def\section{\@startsection {section}{1}{\z@}%
	{-3.5ex \@plus -1ex \@minus -.2ex}%
	{2.3ex \@plus.2ex}%
	{\normalfont\normalsize\bfseries}}
\def\subsection{\@startsection{subsection}{2}{\z@}%
	{-3.25ex\@plus -1ex \@minus -.2ex}%
	{1.5ex \@plus .2ex}%
	{\normalfont\normalsize\itshape}}
\def\subsubsection{\@startsection{subsubsection}{3}{\z@}%
	{-3.25ex\@plus -1ex \@minus -.2ex}%
	{1.5ex \@plus .2ex}%
	{\normalfont\normalsize\itshape}}
% redefine section, figure etc. format
\def\thesection       {\arabic{section}.}
\def\thesubsection    {\thesection\arabic{subsection}.}
\def\thesubsubsection {\thesubsection\arabic{subsection}.}
\def\figurename{Fig.}
\def\tablename{Table}

% add horisontal lines before and after the abstract
\renewenvironment{abstract}%
	{\noindent\rule{\textwidth}{0.1pt}
	\small
	\noindent{\bfseries \abstractname}
	\quotation}%
	{\vspace{1em}\\{\small Project ID: \projectname}\\
	\noindent\rule{\textwidth}{0.1pt}}
% no indentation for quotations
\renewenvironment{quotation}%
	{\list{}{%
		\listparindent 0.0em
		\itemindent    \listparindent
		\rightmargin   \leftmargin
		\parsep        \z@ \@plus\p@}%
	\item\relax}
	{\endlist}

% add space either after table caption or before figure caption
\newif\if@withintable
\@withintablefalse
\newif\if@withinfigure
\@withinfigurefalse
\renewenvironment{figure}
	{\@withinfiguretrue\@float{figure}}
	{\end@float\@withinfigurefalse}
\renewenvironment{figure*}
	{\@withinfiguretrue\@dblfloat{figure}}
	{\end@dblfloat\@withinfigurefalse}
\renewenvironment{table}
	{\@withintabletrue\@float{table}}
	{\end@float\@withintablefalse}
\renewenvironment{table*}
	{\@withintabletrue\@dblfloat{table}}
	{\end@dblfloat\@withintablefalse}
\setlength\abovecaptionskip{10\p@}
\setlength\belowcaptionskip{10\p@}
\long\def\@makecaption#1#2{%
	\if@withinfigure
		\vskip\abovecaptionskip
	\fi
	{\small #1. #2\par}
	\if@withintable
		\vskip\belowcaptionskip
	\fi}

% ref.number in References
\def\@biblabel#1{\indent#1.}

