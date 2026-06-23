\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{bausteinefdm}[2026/06/22 Bausteine Forschungsdatenmanagement article style]

\LoadClass{bausteinefdm_template}

\RequirePackage{fancyhdr}
\RequirePackage{tikz}
\RequirePackage{ragged2e}
\RequirePackage{ccicons}

\IfFontExistsTF{Roboto}
  {%
    \setmainfont{Roboto}%
    \setsansfont{Roboto}%
  }
  {%
    \RequirePackage[sfdefault]{roboto}%
    \renewcommand{\familydefault}{\sfdefault}%
  }

\definecolor{bfdmblue}{HTML}{2E6EAA}
\definecolor{bfdmbluebox}{HTML}{4A82B7}
\definecolor{bfdmtext}{HTML}{000000}

\hypersetup{
  colorlinks=true,
  linkcolor=bfdmblue,
  citecolor=bfdmblue,
  urlcolor=bfdmblue,
  pdfborder={0 0 0}
}

\singlespacing
\setlength{\parindent}{0pt}
\setlength{\parskip}{6pt}
\setlength{\headheight}{18pt}
\setlength{\headsep}{18pt}
\geometry{bottom=34mm,footskip=11mm}

\renewcommand{\linenumbers}{}
\renewcommand{\nolinenumbers}{}

\makeatletter
\date{}

\newcommand{\bausteinecitationtitle}{%
  \begingroup
  \let\\\space
  \@title
  \endgroup
}
\newcommand{\bausteineissue}{%
  \bausteinearticleissuetitle
  \ifx\bausteinearticleissuenumber\@empty\else
    ~Nr.~\bausteinearticleissuenumber
  \fi
}
\newcommand{\bausteinecitation}{%
  \bausteineprintcitationauthors.
  \space\bausteinearticleyear.
  \space\bausteinecitationtitle.
  \space Bausteine Forschungsdatenmanagement.
  \space\bausteineissue:
  \space S.
  \space\bausteinearticlepages
  \space DOI:
  \space\begingroup
  \edef\bausteinedoiurl{http://doi.org/\bausteinearticledoi}%
  \expandafter\href\expandafter{\bausteinedoiurl}{\bausteinearticledoi}%
  \endgroup.%
}
\makeatother

\pagestyle{fancy}
\fancyhf{}
\renewcommand{\headrulewidth}{0pt}
\renewcommand{\footrulewidth}{0pt}
\fancyhead[L]{%
  \raisebox{2.1mm}[0pt][0pt]{%
  \begingroup
  \setlength{\fboxsep}{0pt}%
  \hspace*{-\dimexpr 1in+\oddsidemargin-2.5mm\relax}%
  \colorbox{bfdmbluebox}{%
    \makebox[23mm][r]{%
      \rule[-1.3mm]{0pt}{5.2mm}%
      \color{white}\bfseries\thepage\hspace{1.7mm}%
    }%
  }%
  \hspace{2mm}{\fontsize{11}{13}\selectfont\textcolor{bfdmblue}{DINI/nestor - Bausteine Forschungsdatenmanagement}}%
  \endgroup
  }%
}
\fancyfoot[L]{%
  \href{https://creativecommons.org/licenses/by/4.0/deed.de}{%
    \textcolor{bfdmblue}{\fontsize{11}{11}\selectfont\ccLogo\hspace{1.5pt}\ccAttribution}%
  }%
}

\captionsetup{
  font=small,
  labelfont=bf,
  textfont=normalfont,
  labelformat=simple,
  labelsep=colon,
  justification=raggedright,
  singlelinecheck=false,
  skip=8pt
}

\makeatletter
\renewcommand\section{\@startsection{section}{1}{\z@}%
  {-28pt \@plus -4pt \@minus -2pt}%
  {12pt \@plus 2pt}%
  {\normalfont\fontsize{16}{19}\selectfont\bfseries\color{bfdmtext}}}
\renewcommand\subsection{\@startsection{subsection}{2}{\z@}%
  {-20pt \@plus -3pt \@minus -2pt}%
  {8pt \@plus 1pt}%
  {\normalfont\fontsize{13}{16}\selectfont\bfseries\color{bfdmtext}}}
\renewcommand\subsubsection{\@startsection{subsubsection}{3}{\z@}%
  {-18pt \@plus -3pt \@minus -2pt}%
  {6pt \@plus 1pt}%
  {\normalfont\fontsize{11}{14}\selectfont\bfseries\color{bfdmtext}}}

\renewcommand{\maketitle}{%
  \begingroup
  \thispagestyle{empty}%
  \vspace*{26mm}%
  \begin{center}
    {\fontsize{17}{22}\selectfont Bausteine Forschungsdatenmanagement\par}
    \vspace{2pt}
    {\fontsize{13}{16}\selectfont Empfehlungen und Erfahrungsberichte für die Praxis von\par
     Forschungsdatenmanager*innen\par}
    \vspace{18mm}
    {\fontsize{20}{25}\selectfont\bfseries\@title\par}
    \ifx\@subtitle\@empty\else
      \vspace{8pt}
      {\fontsize{14}{18}\selectfont\bfseries\@subtitle\par}
    \fi
    \vspace{22mm}
    {\fontsize{15}{18}\selectfont\bausteineprintauthors\par}
    \vspace{5mm}
    {\fontsize{15}{18}\selectfont\bausteinearticleyear\par}
    \vfill
    {\bfseries Zitiervorschlag\par}
    \vspace{8pt}
    {\small
      \bausteinecitation\par
    }
    \vspace{12pt}
    {\small Dieser Beitrag steht unter einer\par
      \textcolor{bfdmblue}{Creative Commons Namensnennung 4.0 International Lizenz (CC BY 4.0).}\par}
  \end{center}
  \vfill
  {\small\bausteineprintaffiliations\par}
  \clearpage
  \endgroup
}
\makeatother

\renewenvironment{abstract}
  {%
    \section*{Abstract}%
    \small
  }
  {%
    \par\normalsize\vspace{20pt}
  }

\endinput
