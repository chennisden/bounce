\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{bounce}[2021/05/27 Article class with predefined theorem-style environments]

% 	- kvoptions (for creating key-value commands and class format)
\RequirePackage{kvoptions}

%   - xinttools (for zapping away spaces)
\RequirePackage{xinttools}

% Declared options:
%   - theme (red, blue, green, purple are the options)
%       The theme option will control the color scheme
%       of the document.
%       If you are trying to write a collection of handouts for high school
%       math competitions, we recommend you use a consistent color scheme.
%       The authors suggest that red, blue, green, and purple correspond to
%       algebra, combo, geometry, and number theory.
%   - showsol
%       solutions attached to exercises and pset problems are always present
%       in the source code, but only shown when showsol is called
%   - breakbox
%       if this is true, the prosol box becomess breakable

\DeclareStringOption[]{theme}
\DeclareBoolOption[false]{showsol} % whether solutions are shown
\DeclareBoolOption[false]{breakbox} % whether prosol box can break or not
\DeclareBoolOption[false]{book} % whether this is a book or not
\ProcessKeyvalOptions*

% Zap spaces from \bounce@theme so [theme=red] parses the same as [theme = red]
\edef\bounce@theme{\expandafter\xintZapSpaces\expandafter\bounce@theme}

% throw exception if \bounce@theme doesn't match any of red, blue, green, purple.
% uses package ifallfalse by bounce providers that checks for this
\RequirePackage{ifallfalse}

\def\allorchecks{}

\AtBeginDocument{
    \begin{allfalse}{\bounce@theme}{
        \ClassError{bounce}{Invalid or no theme passed in}{Valid themes are red, blue, green, purple, cyan, and custom.}
    }
        \orcheck{red}
        \orcheck{blue}
        \orcheck{green}
        \orcheck{purple}

        \orcheck{cyan}

        \orcheck{custom}
    \end{allfalse}
}

%   - solprint
%       This is a package written by the providers of bounce.cls.
%       It is responsible for printing the solutions associated with the examples and pset at the end of the document.
%       You will not find it on CTAN.
\ifbounce@showsol
\RequirePackage[showsol]{solprint}
\else
\RequirePackage{solprint}
\fi

% Base class is scrartcl or scrbook
\ifbounce@book
    \LoadClass[openany]{scrbook}
\else
    \LoadClass{scrartcl}
\fi

% Require the following packages:

% 	- geometry (for page sizing)
\RequirePackage{geometry}

% 	- The standard AMS typesetting packages
\RequirePackage{amsmath}
\RequirePackage{amsthm}
\RequirePackage{amsfonts}

%   - tikz (draw diagrams natively in TeX)
\RequirePackage{tikz}

% 	- tikz libraries
\usetikzlibrary{calc} % allows coordinate calculation

% 	- asymptote (for larger geometry diagrams)
\RequirePackage{asymptote}

%%%%%%%
%FONTS%
%%%%%%%

% Set default text and math fonts
\RequirePackage{newpxtext, newpxmath}

% Declare fonts
\DeclareRobustCommand{\cmbright}{\fontfamily{cmbr}\selectfont} % cmbright font
\DeclareRobustCommand{\notofont}{\fontfamily{NotoSans-TLF}\selectfont} % noto sans font
\DeclareRobustCommand{\robotofont}{\fontfamily{RobotoSlab-TLF}\selectfont} % roboto sans font
\DeclareRobustCommand{\cabin}{\fontfamily{Cabin-TLF}\selectfont} % cabin font
\DeclareRobustCommand{\merri}{\fontfamily{MerriwthrSans-OsF}\selectfont} % merriweather sans font
\DeclareRobustCommand{\step}{\fontfamily{STEP-TLF}\selectfont} % step font
\DeclareRobustCommand{\newpxtext}{\fontfamily{zpltlf}\selectfont} % newpx text font
\DeclareRobustCommand{\nimbus}{\fontfamily{NimbusSans}\selectfont} % nimbus sans

% Symbol packages

% Used for card suit symbols (club, spade, diamond, heart)
\RequirePackage{pifont}

%%%%%%%%
%COLORS%
%%%%%%%%

% 	- xcolor (for colors in the document)
\PassOptionsToPackage{HTML}{xcolor}
\RequirePackage[HTML]{xcolor}

% Color pallete:
%   Primary - used for section, problem, outline of theorem boxes
%   light - used for background of theorem boxes

% Takes in [optionally] base theme for symbol inheritance, palette name, palette color, HTML color code
%   Ex: \palettecolor{red}{primary}{696969}
%     The first line defines the color redprimarycolor,
%     The second line defines the command \@redprimary (so \@primary actually has something to refer to)
%     The third line defines \@primary in this example,
%     The fourth line defines \@primarycolor

\newcommand\palettecolor[4][]{
    \definecolor{#2#3 color}{HTML}{#4}
    \expandafter\def\csname @#2#3\endcsname{\color{#2#3 color}}
    \expandafter\def\csname @#3\endcsname{\csname @\bounce@theme #3\endcsname}
    \expandafter\def\csname @#3color\endcsname{\bounce@theme #3 color}
    
    \if\relax\detokenize{#1}\else
        \begin{allfalse}{#1}{
            \ClassError{bounce}{Invalid base theme passed in}{Valid base themes are red, blue, green, and purple.}
        }
            \orcheck{red}
            \orcheck{blue}
            \orcheck{green}
            \orcheck{purple}
        \end{allfalse}

        \expandafter\def\csname @#2sec\endcsname{\csname @#1sec\endcsname}
        \expandafter\def\csname @#2prob\endcsname{\csname @#1prob\endcsname}
    \fi
}

% Define base color palettes

\palettecolor{red}{primary}{b40a14}
\palettecolor{red}{light}{fce8e8}

\palettecolor{blue}{primary}{060d96}
\palettecolor{blue}{light}{dce6fb}

\palettecolor{green}{primary}{067612}
\palettecolor{green}{light}{e1ffe6}

\palettecolor{purple}{primary}{50245a}
\palettecolor{purple}{light}{f5ebfa}

% Additional color palettes

\palettecolor[blue]{cyan}{primary}{187199}
\palettecolor[blue]{cyan}{light}{e6f0fa}

% Set your own palette
% User-end command
% #1 is base theme,
% #2 is HTML code of primary, and
% #3 is HTML code of secondary.

\def\setpalette#1#2#3{
    \ifnum\pdfstrcmp{\bounce@theme}{custom}=0
        \begin{allfalse}{#1}{
            \ClassError{bounce}{Invalid base theme passed in to \protect\setpalette}{Valid base themes are red, blue, green, and purple.}
        }
            \orcheck{red}
            \orcheck{blue}
            \orcheck{green}
            \orcheck{purple}
        \end{allfalse}

        \palettecolor[#1]{custom}{primary}{#2}
        \palettecolor[#1]{custom}{light}{#3}
    \else
        \ClassError{bounce}{You may only define a custom palette if you are using the theme "custom."}{}
    \fi
}

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
    linkcolor=\@primarycolor,
    urlcolor=\@primarycolor,
}

% Set up page margins: 1 inch on each side
% Must be loaded after hyperref
\geometry{margin = 1in}

\newcommand{\toc}{ % Custom short table of contents command
\newpage    
\tableofcontents
\newpage
}

\ifbounce@book

    \setcounter{tocdepth}{1} % allows part, chapter, and section (depths -1, 0, and 1) to show up

\else

    \setcounter{tocdepth}{2} % allows section and subsection (depths 1 and 2) to show up
    % part (-1) and chapter (0) should not be used in the document

    % Change toc styles

    \DeclareTOCStyleEntry[
        entryformat = {\notofont\hypersetup{linkcolor=\@primarycolor}\bfseries}, % must use hypersetup to manipulate color
    ]{tocline}{section}

    \DeclareTOCStyleEntry[
        entryformat = {\newpxtext\hypersetup{linkcolor=black}}, % must use hypersetup to manipulate color
        pagenumberformat = {\newpxtext},
    ]{tocline}{subsection}

\fi

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%TITLE AND SECTION FORMATTING%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%   - bubblepage
%       This is a package written by the providers of bounce.cls.
%       It is responsible for adding bubbles to the title page.
%       You will not find it on CTAN.

% We hook this to the beginning of the document in order for
% setpalette to work.

\AtBeginDocument{
    \extractcolorspecs{\bounce@theme primary color}{\bubble@tempmodel}{\bubble@tempcolor} % gets color code in whatever the default color model is 
    \convertcolorspec{\bubble@tempmodel}{\bubble@tempcolor}{HTML}{\bubble@color}

    \RequirePackage[model = HTML, color = \bubble@color]{bubblepage}
}

\addtokomafont{title}{\cabin\bfseries}
\addtokomafont{author}{\cabin\@primary\bfseries}
\addtokomafont{date}{\cabin}

% set up section symbols for each theme

\def\@redsec{\ding{168}} % Lets red section symbol be club
\def\@bluesec{\ding{170}} % Lets blue section symbol be heart
\def\@greensec{\ding{169}} % Lets green section symbol be diamond
\def\@purplesec{\ding{171}} % Lets purple section symbol be spade

% section symbol is defined based on bounce theme, csname expands \bounce@theme and thus correctly references one of the four above sections
\def\@secsymb{\csname @\bounce@theme sec\endcsname}

% Create part and chapter id for nameref (so part and chapter counters can be reset without causing issues)

\newcounter{partid}\setcounter{partid}{0}
\newcounter{chapterid}\setcounter{chapterid}{0}

% Create refs to part and chapter names

\RequirePackage{nameref}

\ifbounce@book % Set up part and chapter if book exists

\fi

\addtokomafont{section}{\notofont}
\ifbounce@book % Have section symbol if article, no section symbol if book
    \renewcommand*\sectionformat{\thesection\hspace{0.8em}}
\else
    \renewcommand*\sectionformat{\@primary\@secsymb\,\thesection\hspace{0.8em}}
\fi

\addtokomafont{subsection}{\notofont}
\renewcommand*\subsectionformat{\@primary\thesubsection\hspace{0.9em}}

\addtokomafont{subsubsection}{\notofont}
\renewcommand*\subsubsectionformat{\@primary\thesubsubsection\hspace{0.9em}}

%%%%%%%%%
%HEADERS%
%%%%%%%%%

% set chapter name on even page and section name on odd page if book

\ifbounce@book
    \RequirePackage[headsepline = 0.8pt]{scrlayer-scrpage}
    \setkomafont{pageheadfoot}{\nimbus}
    \setkomafont{headsepline}{\@primary}
    \lehead{\thepage}
    \rehead{Part \thepart.~~{\@primary\nameref{part\thepartid}}}
    \lohead{Chapter \thechapter.~~{\@primary\nameref{chapter\thechapterid}}}
    \rohead{\thepage}
    \lefoot{}
    \refoot{}
    \lofoot{}
    \rofoot{}
\fi

%%%%%%%%%%%%%%
%ENVIRONMENTS%
%%%%%%%%%%%%%%

% 	- tcolorbox (for boxes)
\RequirePackage{tcolorbox}
\tcbuselibrary{skins} % We need the "enhanced" skin to have box titles
\tcbuselibrary{breakable} % allows tcolorbox to break between pages

%   - Lazy in-text environments
%       - exercise (later in code)
%       - lemma
%       - claim
%       - remark

\newenvironment{lazy}[1] % general lazy env, just change title
{
    \vspace{1.5mm}
    \noindent{\notofont\@primary\bfseries #1.}\hspace{1.5mm}\ignorespaces
}
{
    \vspace{1.5mm}
}

%   - lemma (keep a counter)

\newcounter{lemma}[section]
\setcounter{lemma}{0}

\newenvironment{lemma}{
    \stepcounter{lemma}
    \begin{lazy}{Lemma \thesection.\thelemma}
}
{
    \end{lazy}
}

%   - claim (no counter)

\newenvironment{claim}{
    \begin{lazy}{Claim}
}
{
    \end{lazy}
}
%   - remark (no counter)

\newenvironment{remark}{
    \begin{lazy}{Remark}
}
{
    \end{lazy}
}

%   - Theorem

\newcounter{theo}[section] % creates counter "theorem" that resets every time \section is called

\newenvironment{theo}[1][]{
    \stepcounter{theo}

    \begin{tcolorbox}[
        skin = enhanced,
        attach boxed title to top left = {xshift = 4mm, yshift = -3.3mm, yshifttext = -2.5mm,},
        colback = \@lightcolor,
        colframe = \@primarycolor,
        colbacktitle = \@primarycolor,
        title = {Theorem \thesection.\thetheo\if\relax\detokenize{#1}\else{} {(#1)}\fi},
        fonttitle = \notofont\color{white}\bfseries,
    ]
}
{
    \end{tcolorbox}
}

\safesolify[Proof of]{theo}{theo}{\thesection.\thetheo}

%   - Definition

\newcounter{defi}[section] % creates counter "definition" that resets every time \section is called

\newenvironment{defi}[1][]
{
    \stepcounter{defi}

    \begin{tcolorbox}[
        skin = enhanced,
        attach boxed title to top left = {xshift = 4mm, yshift = -3.3mm, yshifttext = -2.5mm,},
        colback = white,
        colframe = \@primarycolor,
        colbacktitle = \@primarycolor,
        title = {Definition \thesection.\thedefi\if\relax\detokenize{#1}\else{} ({#1})\fi},
        fonttitle = \notofont\color{white}\bfseries,
    ]
}
{
    \end{tcolorbox}
}

%   - Example

% counters

\newcounter{exam}[section]
\setcounter{exam}{0}

\newenvironment{exam}[1][]
{
    \stepcounter{exam}
    \vspace{7mm}
    \vspace*{-3mm}
    \begin{tcolorbox}[
        skin = enhanced,
        frame hidden,
        detach title, % removes title from normal position, stores value in \tcbtitle
        before upper=\tcbtitle\hspace{1.5mm}, % put title at top
        opacityback = 0,
        overlay = {
            \draw [ultra thick, \@primarycolor, line cap = round] ($(current bounding box.south west)+(6,-0.3)$)--($(current bounding box.south west)+(0.3,-0.3)$) to[out = 180, in = -90] (current bounding box.south west) -- (current bounding box.north west) to[out = 90, in = 180] ($(current bounding box.north west) + (0.3,0.3)$);
            \draw [ultra thick, \@primarycolor, ->] ($(current bounding box.north west) + (0.3,0.3)$) -- ($(current bounding box.north west) + (15,0.3)$);
        },
        colframe = \@primarycolor,
        title = Example \thesection.\theexam\if\relax\detokenize{#1}\else{} {(#1)}\fi.,
        fonttitle = \notofont\@primary\bfseries,
        top = -1pt,
        bottom = -2pt,
    ]
    \raggedright\ignorespaces
}
{
    \end{tcolorbox}
    \vspace{4mm}
}

%   - Exercise

% counters

\newcounter{exer}[section]
\setcounter{exer}{0}

% Example/Exercise box

% example/exercise wrapper

\newenvironment{exerbox}{
    \vspace{7mm}
    \vspace*{-3mm}
    \begin{tcolorbox}[
        skin = enhanced,
        frame hidden,
        opacityback = 0,
        overlay = {
            \draw [ultra thick, \@primarycolor, line cap = round] ($(current bounding box.south east)+(-6,-0.3)$)--($(current bounding box.south east)+(-0.3,-0.3)$) to[out = 0, in = 270] (current bounding box.south east) -- (current bounding box.north east) to[out = 90, in = 0] ($(current bounding box.north east) + (-0.3,0.3)$);
            \draw [ultra thick, \@primarycolor, ->] ($(current bounding box.north east) + (-0.3,0.3)$) -- ($(current bounding box.north west) + (0,0.3)$);
        },
        colframe = \@primarycolor,
        top = -4pt,
        bottom = -2pt,
    ]
        \raggedright
}
{
    \end{tcolorbox}
    \vspace{4mm}
}

% lazy exercise environment
% We use \lazy instead of \begin{lazy} and \endlazy instead of \end{lazy}
% because of verbatim

\newenvironment{exer}[1][]
{
    \stepcounter{exer}
    \lazy{Exercise \thesection.\theexer\if\relax\detokenize{#1}\else{} (#1)\fi}
}
{
    \endlazy
}

\safesolify{exer}{exer}{\thesection.\theexer}

%   - Walkthrough

\newenvironment{walk}[1][]{
    \vspace{7mm}
    \vspace*{-3mm}
    \begin{tcolorbox}[
        skin = enhanced,
        frame hidden,
        detach title, % removes title from normal position, stores value in \tcbtitle
        before upper={\tcbtitle\hspace{1.5mm}}, % put title at top
        opacityback = 0,
        overlay = {
            \draw [ultra thick, \@primarycolor, ->] ($(current bounding box.south west)+(0.3,-0.3)$)--($(current bounding box.south west)+(10,-0.3)$);
            \draw [ultra thick, \@primarycolor, line cap = round] ($(current bounding box.south west)+(0.3,-0.3)$) to[out = 180, in = -90] (current bounding box.south west) -- (current bounding box.north west) to[out = 90, in = 180] ($(current bounding box.north west) + (0.3,0.3)$) -- ($(current bounding box.north west) + (0.3,0.3)$) -- ($(current bounding box.north west) + (4,0.3)$);
        },
        colframe = \@primarycolor,
        title = Walkthrough\if\relax\detokenize{#1}\else{} {#1}\fi.,
        fonttitle = \notofont\@primary\bfseries,
        top = 0pt,
        bottom = -2pt,
    ]    
}
{
    \end{tcolorbox}
    \vspace{4mm}
}

%   - Proof/Solution box

\newenvironment{prosol}[2][]{
    \vspace{0.2mm}
    \begin{tcolorbox}[
        enhanced, % allows us to use certain other keys
        breakable = \ifbounce@breakbox true\else false\fi,
        frame hidden, % gets rid of default frame so we can draw our own
        opacityback = 0, % makes background have 0 opacity, hence transparent
        overlay unbroken = {
            \draw [ultra thick, \@primarycolor, line cap = round] ($(interior.south west)+(0.5,-0.3)$)--($(interior.south west)+(0.3,-0.3)$) to[out = 180, in = -90] (interior.south west) -- (interior.north west) to[out = 90, in = 180] ($(interior.north west) + (0.3,0.3)$) -- ($(interior.north west) + (0.5,0.3)$);
        },
        overlay first = {
            \draw [ultra thick, \@primarycolor, line cap = round] (interior.south west) -- (interior.north west) to[out = 90, in = 180] ($(interior.north west) + (0.3,0.3)$) -- ($(interior.north west) + (0.5,0.3)$);
        },
        overlay last = {
            \draw [ultra thick, \@primarycolor, line cap = round] ($(interior.south west)+(0.5,-0.3)$)--($(interior.south west)+(0.3,-0.3)$) to[out = 180, in = -90] (interior.south west) -- (interior.north west) -- (interior.north west);
        },
        overlay middle = {
            \draw [ultra thick, \@primarycolor] (interior.south west) -- (interior.north west);
        },
        attach boxed title to top left = {xshift = 5.5mm},
        colframe = \@primarycolor,
        colbacktitle = white,
        title = {\MakeUppercase #2}\if\relax\detokenize{#1}\else{} {#1}\fi.,
        fonttitle = \notofont\@primary\bfseries,
        top = 0.1cm,
        bottom = 0cm,
    ]
        \raggedright    
}
{
    \end{tcolorbox}
    \vspace{4mm}
}

% proof

\newenvironment{pro}[1][]
{
    \prosol[#1]{proof}
}
{
    \endprosol
}

% solution

\newenvironment{sol}[1][]
{
    \prosol[#1]{solution}
}
{
    \endprosol
}

%   - Pset quote
\newcommand{\psetquote}[2]{
    \begin{flushright}
    \begin{tcolorbox}[
        enhanced,
        frame hidden,
        opacityback = 0,
        width = 8cm,
        overlay = {
            \draw [ultra thick, \@primarycolor, line cap = round] ($(current bounding box.north west)+(-0.3,-0.6)$) -- ($(current bounding box.north west)+(-0.3,-0.3)$) to[out = 90, in = 180] ($(current bounding box.north west)+(0.3,0.3)$) -- ($(current bounding box.north west)+(1.2, 0.3)$);
            \draw [ultra thick, \@primarycolor, line cap = round] ($(current bounding box.south east)+(-1.2,-0.3)$) -- ($(current bounding box.south east)+(-0.3,-0.3)$) to[out = 0, in = 270] ($(current bounding box.south east)+(0.3,0.3)$) -- ($(current bounding box.south east)+(0.3,0.6)$);
        },
        left = 0.2cm,
        right = 0.2cm,
        top = 0.1cm,
        bottom = 0.1cm,
    ]
        ``#1''

        \vspace{5mm}

        \hfill{\@primary #2}
    \end{tcolorbox}
    \end{flushright}
    \vspace{3mm}
}


% problem environments
% We use the package prob

\ifbounce@book
    \RequirePackage[numbered, numbering = chapter]{prob}
\else
    \RequirePackage[numbered, points]{prob}
\fi

% sets up prob and req environments for solprint
% book has to be safe because in book, prob only takes one optional argument
% also, no required problems exist in book because we use no points
% (and thus the concept of required problems is a little silly.) 

\ifbounce@book

    \safesolify{prob}{Problem}{\theproblem}
    
\else

    \solify{prob}{Problem}{\theproblem}
    \solify{req}{Problem}{\theproblem}

\fi

% set up problem symbols for each theme
%   same as section symbol (though we define it this way)
%   so that we can change it easily whenever desired.

\def\@redprob{\@redsec}
\def\@blueprob{\@bluesec}
\def\@greenprob{\@greensec}
\def\@purpleprob{\@purplesec}

% define colors and symbols based on theme
% we do not redefine probcolor because the default is black

\reqcolor{\@primarycolor}

\probsymb{\csname @\bounce@theme prob\endcsname}
\reqsymb{\ding{166}} % joker symbol

%%%%%%%%%%%%%%%
%MISCELLAENOUS%
%%%%%%%%%%%%%%%

% problems section

\newcommand\problems{\pagebreak\section{Problems}}

% emphasis commandsR

\renewcommand{\emph}[1]{{\@primary\bfseries #1}} % changes color to primary and bolds in text mode

\newcommand{\ansbold}[1]{{\@primary\mathbf{#1}}} % changes color to primary and bolds in text mode
% intended use is to highlight answers