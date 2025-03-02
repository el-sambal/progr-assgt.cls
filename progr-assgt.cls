% progr-assgt.cls, author: Aron Hardeman

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{progr-assgt}[2020/02/02 kjh]

\PassOptionsToClass{11pt}{article}
\ProcessOptions\relax
\LoadClass{article}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BEGIN user-redefinable commands %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% colors
\newcommand\subtitlecolor{teal!70!black}
\newcommand\sectbgcolor{yellow!50}
\newcommand\secttextcolor{black}
\newcommand\sectshadowcolor{gray!60}
\newcommand\fancyheaderframecolor{orange!30}
\newcommand\fancyheaderbgcolor{yellow!4}
\newcommand\fancyheadershadowcolor{red!30!gray}
\newcommand\tcexamplehorizbordercolor{gray!70}
\newcommand\tcexampleoutervertbordercolor{orange!70}
\newcommand\tcexampleinnervertbordercolor{yellow!70}
\newcommand\tcexamplebgcolor{yellow!10}
\newcommand\labelitemicolor{orange}
\newcommand\labelitemiicolor{orange!40!yellow}
\newcommand\labelitemiiicolor{orange}
\newcommand\labelitemivcolor{orange!40!yellow}

% lengths
\newlength\titletop\setlength\titletop{5.2pt}
\newlength\titlemiddle\setlength\titlemiddle{1.95em}
\newlength\titlebottom\setlength\titlebottom{13mm}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  END user-redefinable commands  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% misc
\RequirePackage[english]{babel}
\RequirePackage{xcolor}
\RequirePackage{amsmath}
\RequirePackage{amssymb}
\RequirePackage{enumitem}
\RequirePackage{microtype}
\RequirePackage{parskip}
\RequirePackage{listings}
\RequirePackage{marvosym} % symbols for `note` and `alert` envs
\RequirePackage{eso-pic}  % for logo and fancy header
\RequirePackage[skins,listings]{tcolorbox}
\RequirePackage[colorlinks=true]{hyperref}

% page geometry
\RequirePackage{geometry}
\geometry{a4paper,left=20mm,right=20mm,top=30mm,bottom=25mm}

% font
\RequirePackage[T1]{fontenc}
\RequirePackage{mlmodern}

% logo in top-left corner of page
\newsavebox{\logo}
\savebox{\logo}{\includegraphics[width=4.5cm]{figs/logo.pdf}}
\AddToShipoutPicture{\put(\LenToUnit{0.9cm},\LenToUnit{\paperheight-1.8cm}){\usebox\logo}}

% progr-assgt uses \title, \subtitle, \headertitle and \headersubtitle,
% instead of \title, \author and \date.
\def\title#1{\gdef\@title{#1}}
\def\@title{\@latex@error{No \noexpand\title is given}\@ehc}
\def\subtitle#1{\gdef\@subtitle{#1}}
\def\@subtitle{\@latex@error{No \noexpand\subtitle is given}\@ehc}
\def\headertitle#1{\gdef\@headertitle{#1}}
\def\@headertitle{\@latex@error{No \noexpand\headertitle is given}\@ehc}
\def\headersubtitle#1{\gdef\@headersubtitle{#1}}
\def\@headersubtitle{\@latex@error{No \noexpand\headersubtitle is given}\@ehc}

% fancy \maketitle
\def\maketitle{%
  \null\vspace\titletop
  \begin{center}
    \centering
    \huge\ttfamily
    \@title\\
    \vspace\titlemiddle
    \color{\subtitlecolor}\large \@subtitle
  \end{center}
  \vspace\titlebottom}

% fancy header
\RequirePackage{lastpage}
\pagestyle{empty}
\AddToShipoutPicture{\put(\LenToUnit{10.5cm},\LenToUnit{\paperheight-2cm}){%
  \ifnum\value{page}=1%
  \else%
  \begin{tcolorbox}[
      enhanced,
      colframe=\fancyheaderframecolor,
      colback=\fancyheaderbgcolor,
      sharp corners,
      drop fuzzy shadow=\fancyheadershadowcolor]
    \ttfamily\bfseries \@headertitle\\
    \@headersubtitle\ \ --\ \ Page \thepage\ of \pageref*{LastPage}
  \end{tcolorbox}%
  \fi}}

% redefinition of \section, \section*
\RequirePackage{needspace}
\def\section{\secdef\boxsect\sboxsectwr}
\def\boxsect[#1]#2{%
  \needspace{4cm}%
  \vspace{4mm}%
  % now a \ref{} link points to the right place
  \refstepcounter{section}%
  \sboxsect{\thesection. #2}%
  \addcontentsline{toc}{section}{\protect\numberline\thesection#2}}
\def\sboxsectwr#1{%
  \needspace{4cm}%
  \vspace{4mm}%
  \sboxsect{#1}}
\def\sboxsect#1{%
  \begin{tcolorbox}[%
      enhanced,%
      spread sidewards,%
      sharp corners,%
      colback=\sectbgcolor,%
      colframe=\sectbgcolor,%
      fuzzy shadow={0mm}{-1mm}{0mm}{0.1mm}{\sectshadowcolor}]%
    \hspace{14mm}\textcolor{\secttextcolor}{\Large\textbf{\texttt{#1}}}%
  \end{tcolorbox}%
  \vspace{2mm}}

% environments {alert}, {note}
\newenvironment{alert}{%
  \begin{tcolorbox}[
      enhanced,
      left skip=13mm,
      sharp corners,
      colback=orange!5,
      colframe=orange!90!black,
      parbox=false,
      overlay={\node[anchor=north west,outer sep=2pt]
        at ([xshift=-15mm]frame.north west)
        {\color{orange!80}\scalebox3{\Radioactivity}};}]
    \textbf{Alert!}\\[0.3em]
}{\end{tcolorbox}}
\newenvironment{note}{%
  \begin{tcolorbox}[
      enhanced,
      left skip=13mm,
      sharp corners,
      colback=gray!8,
      colframe=gray,
      parbox=false,
      overlay={\node[anchor=north west,outer sep=2pt] at
        ([xshift=-15mm]frame.north west)
        {\color{gray!70!black}\scalebox3{\PointingHand}};}]
    \textbf{Note.}\\[0.3em]
}{\end{tcolorbox}}

% side-by-side test case box
\newcommand\tcexample[3][0.5]{%
  \begin{tcolorbox}[
      enhanced,
      skin=enhanced,
      sidebyside,
      sidebyside align=top,
      lefthand ratio=#1,
      frame hidden,
      borderline horizontal={1mm}{0mm}{\tcexamplehorizbordercolor,dotted},
      borderline vertical={1mm}{0mm}{\tcexampleoutervertbordercolor},
      borderline vertical={1mm}{1mm}{\tcexampleinnervertbordercolor},
      colback=\tcexamplebgcolor]
    \textbf{Input}:\\[0.2em]
    {\ttfamily #2}
    \tcblower
    \textbf{Output}:\\[0.2em]
    {\ttfamily #3}
  \end{tcolorbox}}

% {itemize} bullets
\renewcommand\labelitemi{$\textcolor{\labelitemicolor}{\pmb\rightarrow}$}
\renewcommand\labelitemii{$\textcolor{\labelitemiicolor}{\pmb\rightarrow}$}
\renewcommand\labelitemiii{$\textcolor{\labelitemiiicolor}{\pmb\rightarrow}$}
\renewcommand\labelitemiv{$\textcolor{\labelitemivcolor}{\pmb\rightarrow}$}

% syntax highlighting
\lstdefinestyle{cstyle}{
  language=C,
  basicstyle=\ttfamily,
  backgroundcolor=\color{gray!15},
  commentstyle=\color{orange},
  keywordstyle=\bfseries\color{red},
  tabsize=4,
  stringstyle=\color{purple},
  keepspaces=true,
  showstringspaces=false,
  frame=lines}
\lstdefinestyle{nostyle}{
  basicstyle=\ttfamily,
  backgroundcolor=\color{gray!15},
  keepspaces=true,
  showstringspaces=false}
