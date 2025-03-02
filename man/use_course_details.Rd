% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/course.R
\name{use_course_details}
\alias{use_course_details}
\alias{create_download_url}
\title{Helpers to download and unpack a ZIP file}
\usage{
create_download_url(url)
}
\arguments{
\item{url}{a GitHub, DropBox, or Google Drive URL, as copied from a web
browser.}

\item{destdir}{Path to existing local directory where the ZIP file will be
stored. Defaults to current working directory, but note that \code{\link[=use_course]{use_course()}}
has different default behavior.}

\item{zipfile}{Path to local ZIP file.}
}
\description{
Details on the internal and helper functions that power \code{\link[=use_course]{use_course()}} and
\code{\link[=use_zip]{use_zip()}}. Only \code{create_download_url()} is exported.
}
\section{tidy_download()}{


\if{html}{\out{<div class="sourceCode">}}\preformatted{## function signature
tidy_download(url, destdir = getwd())

# as called inside use_course()
tidy_download(
  url, ## after post-processing with normalize_url()
  # conspicuous_place() = `getOption('usethis.destdir')` or desktop or home
  # directory or working directory
  destdir = destdir \%||\% conspicuous_place()
)
}\if{html}{\out{</div>}}

Special-purpose function to download a ZIP file and automatically determine
the file name, which often determines the folder name after unpacking.
Developed with DropBox and GitHub as primary targets, possibly via
shortlinks. Both platforms offer a way to download an entire folder or repo
as a ZIP file, with information about the original folder or repo transmitted
in the \code{Content-Disposition} header. In the absence of this header, a
filename is generated from the input URL. In either case, the filename is
sanitized. Returns the path to downloaded ZIP file, invisibly.

\code{tidy_download()} is setup to retry after a download failure. In an
interactive session, it asks for user's consent. All retries use a longer
connect timeout.
\subsection{DropBox}{

To make a folder available for ZIP download, create a shared link for it:
\itemize{
\item \url{https://help.dropbox.com/files-folders/share/view-only-access}
}

A shared link will have this form:

\if{html}{\out{<div class="sourceCode">}}\preformatted{https://www.dropbox.com/sh/12345abcde/6789wxyz?dl=0
}\if{html}{\out{</div>}}

Replace the \code{dl=0} at the end with \code{dl=1} to create a download link:

\if{html}{\out{<div class="sourceCode">}}\preformatted{https://www.dropbox.com/sh/12345abcde/6789wxyz?dl=1
}\if{html}{\out{</div>}}

You can use \code{create_download_url()} to do this conversion.

This download link (or a shortlink that points to it) is suitable as input
for \code{tidy_download()}. After one or more redirections, this link will
eventually lead to a download URL. For more details, see
\url{https://help.dropbox.com/files-folders/share/force-download} and
\url{https://help.dropbox.com/installs-integrations/sync-uploads/download-entire-folders}.
}

\subsection{GitHub}{

Click on the repo's "Clone or download" button, to reveal a "Download ZIP"
button. Capture this URL, which will have this form:

\if{html}{\out{<div class="sourceCode">}}\preformatted{https://github.com/r-lib/usethis/archive/main.zip
}\if{html}{\out{</div>}}

This download link (or a shortlink that points to it) is suitable as input
for \code{tidy_download()}. After one or more redirections, this link will
eventually lead to a download URL. Here are other links that also lead to
ZIP download, albeit with a different filenaming scheme (REF could be a
branch name, a tag, or a SHA):

\if{html}{\out{<div class="sourceCode">}}\preformatted{https://github.com/github.com/r-lib/usethis/zipball/HEAD
https://api.github.com/repos/r-lib/rematch2/zipball/REF
https://api.github.com/repos/r-lib/rematch2/zipball/HEAD
https://api.github.com/repos/r-lib/usethis/zipball/REF
}\if{html}{\out{</div>}}

You can use \code{create_download_url()} to create the "Download ZIP" URL from
a typical GitHub browser URL.
}

\subsection{Google Drive}{

To our knowledge, it is not possible to download a Google Drive folder as a
ZIP archive. It is however possible to share a ZIP file stored on Google
Drive. To get its URL, click on "Get the shareable link" (within the "Share"
menu). This URL doesn't allow for direct download, as it's designed to be
processed in a web browser first. Such a sharing link looks like:

\if{html}{\out{<div class="sourceCode">}}\preformatted{https://drive.google.com/open?id=123456789xxyyyzzz
}\if{html}{\out{</div>}}

To be able to get the URL suitable for direct download, you need to extract
the "id" element from the URL and include it in this URL format:

\if{html}{\out{<div class="sourceCode">}}\preformatted{https://drive.google.com/uc?export=download&id=123456789xxyyyzzz
}\if{html}{\out{</div>}}

Use \code{create_download_url()} to perform this transformation automatically.
}
}

\section{tidy_unzip()}{


Special-purpose function to unpack a ZIP file and (attempt to) create the
directory structure most people want. When unpacking an archive, it is easy
to get one more or one less level of nesting than you expected.

It's especially important to finesse the directory structure here: we want
the same local result when unzipping the same content from either GitHub or
DropBox ZIP files, which pack things differently. Here is the intent:
\itemize{
\item If the ZIP archive \code{foo.zip} does not contain a single top-level directory,
i.e. it is packed as "loose parts", unzip into a directory named \code{foo}.
Typical of DropBox ZIP files.
\item If the ZIP archive \code{foo.zip} has a single top-level directory (which, by
the way, is not necessarily called "foo"), unpack into said directory.
Typical of GitHub ZIP files.
}

Returns path to the directory holding the unpacked files, invisibly.

\strong{DropBox:}
The ZIP files produced by DropBox are special. The file list tends to contain
a spurious directory \code{"/"}, which we ignore during unzip. Also, if the
directory is a Git repo and/or RStudio Project, we unzip-ignore various
hidden files, such as \code{.RData}, \code{.Rhistory}, and those below \verb{.git/} and
\code{.Rproj.user}.
}

\examples{
\dontrun{
tidy_download("https://github.com/r-lib/rematch2/archive/main.zip")
}

\dontrun{
tidy_download("https://github.com/r-lib/rematch2/archive/main.zip")
tidy_unzip("rematch2-main.zip")
}
# GitHub
create_download_url("https://github.com/r-lib/usethis")
create_download_url("https://github.com/r-lib/usethis/issues")

# DropBox
create_download_url("https://www.dropbox.com/sh/12345abcde/6789wxyz?dl=0")

# Google Drive
create_download_url("https://drive.google.com/open?id=123456789xxyyyzzz")
create_download_url("https://drive.google.com/open?id=123456789xxyyyzzz/view")
}
\keyword{internal}
