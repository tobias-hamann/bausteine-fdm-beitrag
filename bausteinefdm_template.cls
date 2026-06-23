\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{bausteinefdm_template}[2026/06/22 Bausteine FDM article template]

\LoadClass[10pt,a4paper]{article}

\RequirePackage[a4paper,top=2.5cm,right=2.5cm,bottom=2cm,left=2.5cm]{geometry}
\RequirePackage{fontspec}
\RequirePackage[english]{babel}
\RequirePackage{microtype}
\RequirePackage{setspace}
\RequirePackage{amsmath,amssymb}
\RequirePackage{xcolor}
\RequirePackage{graphicx}
\RequirePackage{csquotes}
\RequirePackage{booktabs}
\RequirePackage{longtable}
\RequirePackage{listings}
\RequirePackage{caption}
\RequirePackage{etoolbox}
\RequirePackage{expl3}
\RequirePackage{xparse}
\RequirePackage{hyperref}
\RequirePackage{lineno}
\RequirePackage{comment}
\RequirePackage[
  backend=biber,
  style=authoryear,
  maxcitenames=2,
  maxbibnames=99
]{biblatex}

\IfFontExistsTF{Aptos}{\setmainfont{Aptos}}{\setmainfont{Arial}}
\onehalfspacing
\setlength{\parindent}{0pt}
\setlength{\parskip}{0pt}

\definecolor{bausteinecaption}{HTML}{44546A}
\hypersetup{
  colorlinks=true,
  linkcolor=black,
  citecolor=black,
  urlcolor=black,
  pdfborder={0 0 0}
}

\captionsetup{
  font={small,it},
  labelfont={small,it},
  textfont={small,it},
  labelformat=simple,
  labelsep=colon,
  justification=raggedright,
  singlelinecheck=false,
  skip=6pt
}

\makeatletter
\renewcommand\section{\@startsection{section}{1}{\z@}%
  {-24pt \@plus -4pt \@minus -2pt}%
  {12pt \@plus 2pt}%
  {\normalfont\fontsize{12}{14}\selectfont\bfseries}}
\renewcommand\subsection{\@startsection{subsection}{2}{\z@}%
  {-18pt \@plus -3pt \@minus -2pt}%
  {6pt \@plus 1pt}%
  {\normalfont\fontsize{12}{14}\selectfont}}
\renewcommand\subsubsection{\@startsection{subsubsection}{3}{\z@}%
  {-18pt \@plus -3pt \@minus -2pt}%
  {6pt \@plus 1pt}%
  {\normalfont\fontsize{12}{14}\selectfont}}
\makeatother

\newif\iffinal
\finaltrue

\makeatletter
\newcommand{\subtitle}[1]{\gdef\@subtitle{#1}}
\newcommand{\corresponding}[1]{\gdef\@corresponding{#1}}

\subtitle{}
\corresponding{}
\makeatother

\ExplSyntaxOn
\seq_new:N \g_bausteine_affiliations_seq
\seq_new:N \g_bausteine_author_names_seq
\seq_new:N \g_bausteine_author_citation_names_seq
\seq_new:N \g_bausteine_author_affils_seq
\seq_new:N \g_bausteine_author_emails_seq
\seq_new:N \g_bausteine_author_orcids_seq
\seq_new:N \g_bausteine_author_contribs_seq
\prop_new:N \g_bausteine_affiliation_labels_prop
\prop_new:N \l_bausteine_tmp_prop
\tl_new:N \l_bausteine_affiliation_label_tl
\int_new:N \g_bausteine_affiliation_int
\tl_new:N \g_bausteine_corresponding_tl
\tl_new:N \g_bausteine_article_year_tl
\tl_new:N \g_bausteine_article_issue_title_tl
\tl_new:N \g_bausteine_article_issue_number_tl
\tl_new:N \g_bausteine_article_pages_tl
\tl_new:N \g_bausteine_article_doi_tl
\tl_new:N \l_bausteine_affiliation_labels_tl
\tl_new:N \l_bausteine_affiliation_id_tl

\cs_generate_variant:Nn \prop_get:NnNTF { NVNTF }

\cs_new_protected:Npn \bausteine_parse_keyvals:n #1
  {
    \prop_clear:N \l_bausteine_tmp_prop
    \keyval_parse:NNn \bausteine_parse_key:n \bausteine_parse_key_value:nn {#1}
  }
\cs_new_protected:Npn \bausteine_parse_key:n #1
  { \prop_put:Nnn \l_bausteine_tmp_prop {#1} {} }
\cs_new_protected:Npn \bausteine_parse_key_value:nn #1#2
  { \prop_put:Nnn \l_bausteine_tmp_prop {#1} {#2} }

\cs_new_protected:Npn \bausteine_affiliation:n #1
  {
    \bausteine_parse_keyvals:n {#1}
    \prop_get:NnN \l_bausteine_tmp_prop {id} \l_tmpa_tl
    \tl_trim_spaces:N \l_tmpa_tl
    \int_gincr:N \g_bausteine_affiliation_int
    \prop_gput:NVx \g_bausteine_affiliation_labels_prop \l_tmpa_tl
      { \int_to_roman:n { \g_bausteine_affiliation_int } }
    \prop_get:NnN \l_bausteine_tmp_prop {organization} \l_tmpb_tl
    \prop_get:NnN \l_bausteine_tmp_prop {suborganisation} \l_tmpc_tl
    \prop_get:NnN \l_bausteine_tmp_prop {city} \l_tmpd_tl
    \seq_gput_right:Nx \g_bausteine_affiliations_seq
      {
        \exp_not:N \textsuperscript
          { \int_to_roman:n { \g_bausteine_affiliation_int } }
        ~\tl_use:N \l_tmpb_tl
        \tl_if_blank:VF \l_tmpc_tl {,~\tl_use:N \l_tmpc_tl}
        \tl_if_blank:VF \l_tmpd_tl {,~\tl_use:N \l_tmpd_tl}
      }
  }

\cs_new:Npn \bausteine_label_for_id:n #1
  {
    \prop_if_in:NnTF \g_bausteine_affiliation_labels_prop {#1}
      { \prop_item:Nn \g_bausteine_affiliation_labels_prop {#1} }
      {#1}
  }

\cs_new_protected:Npn \bausteine_set_affil_labels:n #1
  {
    \tl_clear:N \l_bausteine_affiliation_labels_tl
    \clist_set:Nn \l_tmpa_clist {#1}
    \clist_map_inline:Nn \l_tmpa_clist
      {
        \tl_set:Nn \l_bausteine_affiliation_id_tl {##1}
        \tl_trim_spaces:N \l_bausteine_affiliation_id_tl
        \tl_if_empty:NF \l_bausteine_affiliation_labels_tl
          { \tl_put_right:Nn \l_bausteine_affiliation_labels_tl {,~} }
        \prop_get:NVNTF \g_bausteine_affiliation_labels_prop
          \l_bausteine_affiliation_id_tl
          \l_bausteine_affiliation_label_tl
          { \tl_put_right:NV \l_bausteine_affiliation_labels_tl \l_bausteine_affiliation_label_tl }
          { \tl_put_right:NV \l_bausteine_affiliation_labels_tl \l_bausteine_affiliation_id_tl }
      }
  }
\cs_generate_variant:Nn \bausteine_set_affil_labels:n { V }

\cs_new_protected:Npn \bausteine_author:n #1
  {
    \bausteine_parse_keyvals:n {#1}
    \prop_get:NnN \l_bausteine_tmp_prop {given-names} \l_tmpa_tl
    \prop_get:NnN \l_bausteine_tmp_prop {surname} \l_tmpb_tl
    \prop_get:NnN \l_bausteine_tmp_prop {affiliation} \l_tmpc_tl
    \prop_get:NnN \l_bausteine_tmp_prop {email} \l_tmpd_tl
    \prop_get:NnN \l_bausteine_tmp_prop {orcid} \l_tmpe_tl
    \prop_get:NnN \l_bausteine_tmp_prop {contribution} \l_tmpf_tl
    \bausteine_set_affil_labels:V \l_tmpc_tl
    \seq_gput_right:Nx \g_bausteine_author_names_seq
      { \tl_use:N \l_tmpb_tl , \c_space_tl \tl_use:N \l_tmpa_tl }
    \seq_gput_right:Nx \g_bausteine_author_citation_names_seq
      { \tl_use:N \l_tmpb_tl , \c_space_tl \tl_use:N \l_tmpa_tl }
    \seq_gput_right:NV \g_bausteine_author_affils_seq \l_bausteine_affiliation_labels_tl
    \seq_gput_right:NV \g_bausteine_author_emails_seq \l_tmpd_tl
    \seq_gput_right:NV \g_bausteine_author_orcids_seq \l_tmpe_tl
    \seq_gput_right:NV \g_bausteine_author_contribs_seq \l_tmpf_tl
    \tl_if_blank:VF \l_tmpd_tl
      {
        \tl_if_blank:VT \g_bausteine_corresponding_tl
          { \tl_gset:NV \g_bausteine_corresponding_tl \l_tmpd_tl }
      }
  }

\cs_new_protected:Npn \bausteine_article_metadata:n #1
  {
    \bausteine_parse_keyvals:n {#1}
    \prop_get:NnN \l_bausteine_tmp_prop {year} \l_tmpa_tl
    \prop_get:NnN \l_bausteine_tmp_prop {issue-title} \l_tmpb_tl
    \prop_get:NnN \l_bausteine_tmp_prop {issue-number} \l_tmpc_tl
    \prop_get:NnN \l_bausteine_tmp_prop {pages} \l_tmpd_tl
    \prop_get:NnN \l_bausteine_tmp_prop {doi} \l_tmpe_tl
    \tl_gset:NV \g_bausteine_article_year_tl \l_tmpa_tl
    \tl_gset:NV \g_bausteine_article_issue_title_tl \l_tmpb_tl
    \tl_gset:NV \g_bausteine_article_issue_number_tl \l_tmpc_tl
    \tl_gset:NV \g_bausteine_article_pages_tl \l_tmpd_tl
    \tl_gset:NV \g_bausteine_article_doi_tl \l_tmpe_tl
  }

\NewDocumentCommand{\affiliation}{m}{\bausteine_affiliation:n{#1}}
\RenewDocumentCommand{\author}{m}{\bausteine_author:n{#1}}
\NewDocumentCommand{\articlemetadata}{m}{\bausteine_article_metadata:n{#1}}

\cs_new:Npn \bausteine_print_authors:
  {
    \seq_map_indexed_inline:Nn \g_bausteine_author_names_seq
      {
        ##2\textsuperscript{\seq_item:Nn \g_bausteine_author_affils_seq {##1}}
        \tl_if_blank:eF { \seq_item:Nn \g_bausteine_author_orcids_seq {##1} }
          {~(ORCID~\seq_item:Nn \g_bausteine_author_orcids_seq {##1})}
        \int_compare:nNnTF {##1} < { \seq_count:N \g_bausteine_author_names_seq }
          {,~}
          {}
      }
  }

\cs_new:Npn \bausteine_print_affiliations:
  {
    \seq_use:Nn \g_bausteine_affiliations_seq { \par }
  }

\cs_new:Npn \bausteine_print_corresponding:
  {
    \tl_if_blank:VF \g_bausteine_corresponding_tl
      { \href{mailto:\tl_use:N \g_bausteine_corresponding_tl}{\tl_use:N \g_bausteine_corresponding_tl} }
  }
\cs_new:Npn \bausteine_print_citation_authors:
  {
    \seq_use:Nn \g_bausteine_author_citation_names_seq {,~}
  }
\NewDocumentCommand{\bausteineprintauthors}{}{\bausteine_print_authors:}
\NewDocumentCommand{\bausteineprintaffiliations}{}{\bausteine_print_affiliations:}
\NewDocumentCommand{\bausteineprintcorresponding}{}{\bausteine_print_corresponding:}
\NewDocumentCommand{\bausteineprintcitationauthors}{}{\bausteine_print_citation_authors:}
\NewExpandableDocumentCommand{\bausteinearticleyear}{}{\tl_use:N \g_bausteine_article_year_tl}
\NewExpandableDocumentCommand{\bausteinearticleissuetitle}{}{\tl_use:N \g_bausteine_article_issue_title_tl}
\NewExpandableDocumentCommand{\bausteinearticleissuenumber}{}{\tl_use:N \g_bausteine_article_issue_number_tl}
\NewExpandableDocumentCommand{\bausteinearticlepages}{}{\tl_use:N \g_bausteine_article_pages_tl}
\NewExpandableDocumentCommand{\bausteinearticledoi}{}{\tl_use:N \g_bausteine_article_doi_tl}
\ExplSyntaxOff

\newcommand{\printcorrespondingauthor}{\bausteineprintcorresponding}

\AtBeginDocument{%
  \InputIfFileExists{metadata/article.tex}{}{}%
  \InputIfFileExists{metadata/authors.tex}{}{}%
}

\makeatletter
\renewcommand{\maketitle}{%
  \begingroup
  \thispagestyle{plain}%
  {\fontsize{28}{32}\selectfont\bfseries\@title\par}%
  \vspace{24pt}%
  \ifx\@subtitle\@empty\else
    {\fontsize{14}{18}\selectfont\@subtitle\par}%
    \vspace{24pt}%
  \fi
  {\bausteineprintauthors\par}%
  \vspace{6pt}%
  {\bausteineprintaffiliations\par}%
  \ifx\@corresponding\@empty\else
    \vspace{6pt}%
    {\small Corresponding author: \@corresponding\par}%
  \fi
  \vspace{24pt}%
  \endgroup
}
\makeatother

\renewenvironment{abstract}
  {\par\vspace{24pt}{\fontsize{12}{14}\selectfont\bfseries Abstract\par}\vspace{12pt}\small}
  {\par\vspace{12pt}\normalsize}

\AtEndDocument{%
  \clearpage
  \section*{Acknowledgements}
  \InputIfFileExists{acknowledgements.tex}{}{}
  \printbibliography[title={References}]
}

\endinput
