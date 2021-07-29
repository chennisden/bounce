\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{bounce}[2021/05/27 User-ready article class building off of bouncecore]

\RequirePackage{kvoptions}

% Declared options:
%
%   BOUNCE CORE
%
%   - palette (red, blue, green, purple, cyan are the options)
%
%       The palette option will control the color scheme
%       of the document.
%
%       Blue is the default option.
%
%       If you are trying to write a collection of handouts for high school
%       math competitions, we recommend you use a consistent color scheme.
%       The authors suggest that red, blue, green, and purple correspond to
%       algebra, combo, geometry, and number theory.
%
%   - suite (diamonds, clubs, hearts, spades, and global are the options)
%
%       The suite option will determine several symbols,
%       including the section and problem symbols.
%
%       Global is the default option.
%
%   BOUNCE ADDONS
%
%   - showsol
%
%       solutions attached to exercises and pset problems are always present
%       in the source code, but only shown when showsol is called
%
%   - breakbox
%
%       if this is true, the prosol box becomes breakable

% BOUNCE CORE OPTIONS

\DeclareStringOption[blue]{palette} % for colorpalette.sty
\DeclareStringOption[global]{suite} % for symbolsuite.sty

% BOUNCE ADDON OPTIONS

\DeclareBoolOption[false]{showsol} % whether solutions are shown
\DeclareBoolOption[false]{breakbox} % whether prosol box can break or not
\DeclareBoolOption[true]{points}
\ProcessKeyvalOptions*

% Set default text and math fonts
% Load at start because listadd and listremove need to be undefined

\RequirePackage{newpxtext, newpxmath}
\let\listadd\relax
\let\listremove\relax

% Default class

\LoadClass{scrartcl}

% Base colors

\RequirePackage{colorpalette}
\RequirePackage{symbolpalette}

\newpalettetheme{bounce}

\newpalette{bounce}{blue}

\addcolortotheme{bounce}{primary}
\addcolortotheme{bounce}{light}

\setpalettecolor{bounce}{blue}{primary}{060d96}
\setpalettecolor{bounce}{blue}{light}{dce6fb}

\newsuitetheme{bounce}

\newsuite{bounce}{global}

\addsymboltotheme{bounce}{section}
\addsymboltotheme{bounce}{prob}
\addsymboltotheme{bounce}{req}

\setsuitesymbol{bounce}{global}{section}{\faGlobe}
\setsuitesymbol{bounce}{global}{prob}{\adjustbox{Trim=4.3pt 2.6pt 4.3pt 0pt,width=1.3ex,margin=0.2ex 0ex 0.2ex 0ex}{\BlackPawnOnWhite}}
\setsuitesymbol{bounce}{global}{req}{\adjustbox{Trim=2.3pt 2.35pt 2.5pt 0pt,width=1.85ex,raise=-0.03ex,margin=0.14ex 0ex 0.14ex 0ex}{\BlackKnightOnWhite}}

% default active palette/suite
\activepalette{bounce}{blue}
\activesuite{bounce}{global}

%   - solprint
%       This is a package written by the providers of bounce.cls.
%       It is responsible for printing the solutions associated with the examples and pset at the end of the document.
\ifbounce@showsol
\RequirePackage[showsol]{solprint}
\else
\RequirePackage{solprint}
\fi

% Require the following packages:

% 	- The standard AMS typesetting packages
\RequirePackage{amsmath}
\RequirePackage{amsfonts}

%   - asymptote
\RequirePackage{asymptote}

%   - tikz (draw diagrams natively in TeX)
\RequirePackage{tikz}

% 	- tikz libraries
\usetikzlibrary{calc} % allows coordinate calculation

% Declare fonts
\DeclareRobustCommand{\cmbright}{\fontfamily{cmbr}\selectfont} % cmbright font
\DeclareRobustCommand{\notofont}{\fontfamily{NotoSans-TLF}\selectfont} % noto sans font
\DeclareRobustCommand{\robotofont}{\fontfamily{RobotoSlab-TLF}\selectfont} % roboto sans font
\DeclareRobustCommand{\cabin}{\fontfamily{Cabin-TLF}\selectfont} % cabin font
\DeclareRobustCommand{\merri}{\fontfamily{MerriwthrSans-OsF}\selectfont} % merriweather sans font
\DeclareRobustCommand{\step}{\fontfamily{STEP-TLF}\selectfont} % step font
\DeclareRobustCommand{\newpxtext}{\fontfamily{zpltlf}\selectfont} % newpx text font
\DeclareRobustCommand{\nimbus}{\fontfamily{NimbusSans}\selectfont} % nimbus sans
\DeclareRobustCommand{\inter}{\fontfamily{Inter-LF}\selectfont} % inter sans

% Symbol packages

% Used for card suit symbols (club, spade, diamond, heart)
\RequirePackage{pifont}

%%%%%%%%
%COLORS%
%%%%%%%%

\RequirePackage{bouncepalette}[prob, req] % extends bouncecore's palette

%%%%%%%%%%%%%%%%%%%
%TABLE OF CONTENTS%
%%%%%%%%%%%%%%%%%%%

% 	- hyperref (for internal and external links)
%       we load it here just because we need to reference colors
\RequirePackage{hyperref}
\hypersetup{
    colorlinks, % colors links instead of using boxes
    % boxes are gross
    citecolor=black,
    filecolor=black,
    linkcolor=\getcolor{bounce}{primary},
    urlcolor=\getcolor{bounce}{primary},
}

% Set up page margins: 1 inch on each side
% Must be loaded after hyperref
\RequirePackage{geometry}

\newcommand{\toc}{ % Custom short table of contents command
\newpage    
\tableofcontents
\newpage
}

\setcounter{tocdepth}{2} % allows section and subsection (depths 1 and 2) to show up
% part (-1) and chapter (0) should not be used in the document

% Change toc styles

\DeclareTOCStyleEntry[
    entryformat = {\notofont\hypersetup{linkcolor=\getcolor{bounce}{primary}}\bfseries}, % must use hypersetup to manipulate color
]{tocline}{section}

\DeclareTOCStyleEntry[
    entryformat = {\newpxtext\hypersetup{linkcolor=black}}, % must use hypersetup to manipulate color
    pagenumberformat = {\newpxtext},
]{tocline}{subsection}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%TITLE AND SECTION FORMATTING%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%   - bubblepage
%       It is responsible for adding bubbles to the title page.
%       It is also in this directory.

% We hook this to the beginning of the document in order for
% getcolor to work.

\AtBeginDocument{
    \extractcolorspecs{\getcolor{bounce}{primary}}{\bubble@tempmodel}{\bubble@tempcolor} % gets color code in whatever the default color model is 
    \convertcolorspec{\bubble@tempmodel}{\bubble@tempcolor}{HTML}{\bubble@color}

    \RequirePackage[model = HTML, color = \bubble@color]{bubblepage}
}

\addtokomafont{title}{\cabin\bfseries}
\addtokomafont{author}{\cabin\applycolor{bounce}{primary}\bfseries}
\addtokomafont{date}{\cabin}

% set up section symbols for each theme

\def\@redsec{\ding{168}} % Lets red section symbol be club
\def\@bluesec{\ding{170}} % Lets blue section symbol be heart
\def\@greensec{\ding{169}} % Lets green section symbol be diamond
\def\@purplesec{\ding{171}} % Lets purple section symbol be spade

\let\sectionfont\notofont

\addtokomafont{section}{\sectionfont}
\renewcommand*\sectionformat{\applycolor{bounce}{primary}\printsymbol{bounce}{section}\,\thesection\hspace{0.8em}}

\addtokomafont{subsection}{\sectionfont}
\renewcommand*\subsectionformat{\applycolor{bounce}{primary}\thesubsection\hspace{0.9em}}

\addtokomafont{subsubsection}{\sectionfont}
\renewcommand*\subsubsectionformat{\applycolor{bounce}{primary}\thesubsubsection\hspace{0.9em}}

%%%%%%%%%%%%%%
%ENVIRONMENTS%
%%%%%%%%%%%%%%

\RequirePackage{bouncebox}
\ifbounce@breakbox
    \renewcommand\bounceboxbreakable{true}
\fi

% Numbering can be changed (so if you want to extend this to book, it will be easier to do so)

\def\envnumbering{section}

%   - Lazy in-text environments
%       - exercise (later in code)
%       - lemma
%       - claim
%       - remark

%   - lemma (keep a counter)

\newcounter{lemma}[\envnumbering]
\setcounter{lemma}{0}

\newenvironment{lemma}{
    \stepcounter{lemma}
    \begin{lazy}{Lemma \csname the\envnumbering\endcsname.\thelemma.}
}
{
    \end{lazy}
}

%   - claim (no counter)

\newenvironment{claim}{
    \begin{lazy}{Claim.}
}
{
    \end{lazy}
}
%   - remark (no counter)

\newenvironment{remark}{
    \begin{lazy}{Remark.}
}
{
    \end{lazy}
}

%   - Theorem

\newcounter{theo}[\envnumbering] % creates counter "theorem" that resets every time \section is called

\newenvironment{theo}[1][]{
    \stepcounter{theo}
    \begin{bouncepopclosed}{Theorem \csname the\envnumbering\endcsname.\thetheo\if\relax\detokenize{#1}\relax\else{} {(#1)}\fi.}{\notofont\color{white}\bfseries}{\getcolor{bounce}{primary}}{\getcolor{bounce}{light}}
}
{
    \end{bouncepopclosed}
}

\safesolify[Proof of]{theo}{Theorem}{\csname the\envnumbering\endcsname.\thetheo}

%   - Definition

\newcounter{defi}[\envnumbering] % creates counter "definition" that resets every time \section is called

\newenvironment{defi}[1][]
{
    \stepcounter{defi}
    \begin{bouncepopclosed}{Definition \csname the\envnumbering\endcsname.\thedefi\if\relax\detokenize{#1}\relax\else{} ({#1})\fi.}{\notofont\color{white}\bfseries}{\getcolor{bounce}{primary}}{white}    
}
{
    \end{bouncepopclosed}
}

%   - Example

% counters

\newcounter{exam}[\envnumbering]
\setcounter{exam}{0}

\newenvironment{exam}[1][]
{
    \stepcounter{exam}
    \begin{bounceupleftbox}{Example \csname the\envnumbering\endcsname.\theexam\if\relax\detokenize{#1}\relax\else{} {(#1)}\fi.}{\notofont\applycolor{bounce}{primary}\bfseries}{\getcolor{bounce}{primary}}
}
{
    \end{bounceupleftbox}
}

\RequirePackage{fontawesome}

\newenvironment{warn}
{
    \begin{bounceupleftbox}{\faWarning~Warning}{\notofont\applycolor{bounce}{primary}\bfseries}{\getcolor{bounce}{primary}}
}
{
    \end{bounceupleftbox}
}

%   - Exercise

% counters

\newcounter{exer}[\envnumbering]
\setcounter{exer}{0}

% Example/Exercise box

% example/exercise wrapper

\newenvironment{exerbox}{
    \begin{bounceuprightbox}{}{}{\getcolor{bounce}{primary}}
}
{
    \end{bounceuprightbox}
}

% lazy exercise environment
% We use \lazy instead of \begin{lazy} and \endlazy instead of \end{lazy}
% because of verbatim

\newenvironment{exer}[1][]
{
    \stepcounter{exer}
    \lazy{Exercise \csname the\envnumbering\endcsname.\theexer\if\relax\detokenize{#1}\relax\else{} (#1)\fi}
}
{
    \endlazy
}

\safesolify{exer}{Exercise}{\csname the\envnumbering\endcsname.\theexer}

%   - Walkthrough

\newenvironment{walk}[1][]{
    \begin{bouncedownrightbox}{Walkthrough\if\relax\detokenize{#1}\relax\else{} {#1}\fi.}{\notofont\applycolor{bounce}{primary}\bfseries}{\getcolor{bounce}{primary}}
}
{    
    \end{bouncedownrightbox}
}

% proof

\newenvironment{pro}[1][]
{
    \begin{bouncepopopen}{Proof\if\relax\detokenize{#1}\relax\else{} {#1}\fi.}{\notofont\applycolor{bounce}{primary}\bfseries}{\getcolor{bounce}{primary}}
}
{
    \end{bouncepopopen}
}

% solution

\newenvironment{sol}[1][]
{
    \begin{bouncepopopen}{Solution\if\relax\detokenize{#1}\relax\else{} {#1}\fi.}{\notofont\applycolor{bounce}{primary}\bfseries}{\getcolor{bounce}{primary}}
}
{
    \end{bouncepopopen}
}

%   - Pset quote

\newcommand\psetquote[2]{
    \vspace{-4mm}
    \begin{flushright}
        \begin{bouncecornerhalfwidthbox}{}{}{\getcolor{bounce}{primary}}
            ``#1''

            \vspace{5mm}
    
            \hfill{\applycolor{bounce}{primary} #2}
        \end{bouncecornerhalfwidthbox}
    \end{flushright}
}

% problem environments
% We use the package prob

\ifbounce@points
    \RequirePackage[numbered, points]{prob}
\else
    \RequirePackage[numbered]{prob}
\fi

% sets up prob and req environments for solprint
% nopoint has to be safe because in nopoint, prob only takes one optional argument
% also, no required problems exist in nopoint because we use no points
% (and thus the concept of required problems is a little silly.) 

\ifbounce@points

    \solify{prob}{Problem}{\theproblem}
    \solify{req}{Problem}{\theproblem}

\else

    \safesolify{prob}{Problem}{\theproblem}

\fi

\reqcolor{\getcolor{bounce}{primary}}

\probsymb{\printsymbol{bounce}{prob}}
\reqsymb{\printsymbol{bounce}{req}}

%%%%%%%%%%%%%%%
%MISCELLAENOUS%
%%%%%%%%%%%%%%%

% problems section

\newcommand\problems{\pagebreak\section{Problems}}

% emphasis commandsR

\renewcommand{\emph}[1]{{\applycolor{bounce}{primary}\bfseries #1}} % changes color to primary and bolds in text mode

\newcommand{\ansbold}[1]{{\applycolor{bounce}{primary}\mathbf{#1}}} % changes color to primary and bolds in text mode
% intended use is to highlight answers