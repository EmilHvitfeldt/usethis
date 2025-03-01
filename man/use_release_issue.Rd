% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/release.R
\name{use_release_issue}
\alias{use_release_issue}
\title{Create a release checklist in a GitHub issue}
\usage{
use_release_issue(version = NULL)
}
\arguments{
\item{version}{Optional version number for release. If unspecified, you can
make an interactive choice.}
}
\description{
When preparing to release a package to CRAN there are quite a few steps that
need to be performed, and some of the steps can take multiple hours. This
function creates a checklist in a GitHub issue to:
\itemize{
\item Help you keep track of where you are in the process
\item Feel a sense of satisfaction as you progress towards final submission
\item Help watchers of your package stay informed.
}

The checklist contains a generic set of steps that we've found to be helpful,
based on the type of release ("patch", "minor", or "major"). You're
encouraged to edit the issue to customize this list to meet your needs.
If you want to consistently add extra bullets for every release, you can
include your own custom bullets by providing a (unexported) a
\code{release_bullets()} function that returns a character vector.
(For historical reasons, \code{release_questions()} is also supported).
}
\examples{
\dontrun{
use_release_issue("2.0.0")
}
}
