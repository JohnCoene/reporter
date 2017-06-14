#' fabric report
#'
#' @param toc whether to render table of content.
#' @param toc_depth depth of table of content, defaults to \code{2}.
#' @param toc_logo image to use in table of content.
#' @param toc_side side from which table of content should expand.
#' @param toc_btn table of content button color.
#' @param toc_bg table of content background, path to an image.
#' @param toc_color table of content text color, a material class.
#' @param container whether to use a container, defaults to \code{TRUE}.
#' @param toc_fixed whether to use a fixed table of content, defaults to \code{FALSE}.
#' @param banner banner image, optional.
#' @param fig_width,fig_height,fig_retina,fig_caption figure dimensions.
#' @param keep_md whether to keep markdown.
#' @param smart whether to use smart markdown, defaults to \code{TRUE}.
#' @param self_contained produce a standalone HTML file with no external dependencies, using data:
#' URIs to incorporate the contents of linked scripts, stylesheets, images, and videos.
#' Note that even for self contained documents MathJax is still loaded externally
#' (this is necessary because of it's size).
#' @param pandoc_args additional command line options to pass to pandoc.
#' @param mathjax include mathjax. The "default" option uses an https URL from a MathJax CDN.
#' The "local" option uses a local version of MathJax (which is copied into the output directory).
#' You can pass an alternate URL or pass NULL to exclude MathJax entirely.
#' @param highlight synthax highlighter, defaults to \code{pygment}.
#' @param extra_dependencies any additional dependencies, see \code{htmltools::htmlDependency}.
#' @param ... additional parameters to pass to \code{html_document_base}.
#'
#' @export
materialize_document <- function(
                            toc = FALSE,
                            toc_depth = 1,
                            toc_bg = NULL,
                            toc_logo = NULL,
                            toc_color = "black-text",
                            toc_side = "left",
                            toc_btn = "red",
                            toc_fixed = FALSE,
                            banner = NULL,
                            container = TRUE,
                            fig_width = 6.5,
                            fig_height = 4,
                            fig_retina = 2,
                            fig_caption = FALSE,
                            keep_md = FALSE,
                            smart = TRUE,
                            self_contained = TRUE,
                            pandoc_args = NULL,
                            mathjax = "default",
                            highlight = "default",
                            extra_dependencies = NULL,
                            ...) {

  add_graphic <- function(name, graphic) {
    if (!is.null(graphic)) {
      graphic_path <- rmarkdown::pandoc_path_arg(graphic)
      args <<- c(args, rmarkdown::pandoc_variable_arg(name, graphic_path))
    }
  }

  # arguments
  args <- c()

  # toc side
  args <- c(args, rmarkdown::pandoc_toc_args(toc = toc, toc_depth = toc_depth))
  args <- c(args, rmarkdown::pandoc_variable_arg("toc_side", toc_side))
  args <- c(args, rmarkdown::pandoc_variable_arg("toc_btn", toc_btn))
  args <- c(args, rmarkdown::pandoc_variable_arg("toc_color", toc_color))
  if(!is.null(toc_logo)) add_graphic("toc_logo", toc_logo)
  if(!is.null(toc_bg)) add_graphic("toc_bg", toc_bg)
  if(!is.null(banner)) add_graphic("banner", banner)
  if(isTRUE(toc_fixed)) args <- c(args, rmarkdown::pandoc_variable_arg("toc_fixed", "fixed"))

  # template
  default_template <- system.file(
    "rmarkdown/templates/materialize/resources/default.html",
    package = "reporter"
  )

  args <- c(args, "--template", rmarkdown::pandoc_path_arg(default_template))
  args <- c(args, rmarkdown::pandoc_highlight_args(highlight, default = "pygments"))

  # materialize css - js
  mat_src <- system.file("materialize-0.98.2", package = "reporter")
  mat_path <- rmarkdown::pandoc_path_arg(mat_src)
  args <- c(args, "--variable", paste0("materialize-url=", mat_path))

  # jQuery
  jq_src <- system.file("jQuery-2.1.4", package = "reporter")
  jq_path <- rmarkdown::pandoc_path_arg(jq_src)
  args <- c(args, "--variable", paste0("jquery-url=", jq_path))

  # custom
  cust_src <- system.file("rmarkdown/templates/materialize/resources", package = "reporter")
  cust_path <- rmarkdown::pandoc_path_arg(cust_src)
  args <- c(args, "--variable", paste0("custom-url=", cust_path))

  print(args)

  # container
  if(isTRUE(container)) args <- c(args, rmarkdown::pandoc_variable_arg("container", "container"))

  materialize_dependency <- function(){
    htmltools::htmlDependency(name = "materialize",
                              version = "0.98.2",
                              script = "js/materialize.min.js",
                              stylesheet = c("css/materialize.min.css"),
                              src = system.file("materialize-0.98.2", package = "reporter"))
  }

  extra_dependencies <<- append(extra_dependencies,
                                list(materialize_dependency()))

  rmarkdown::output_format(
    knitr = rmarkdown::knitr_options_html(fig_width, fig_height, fig_retina, keep_md),
    pandoc = rmarkdown::pandoc_options(to = "html",
                            from = rmarkdown::rmarkdown_format(ifelse(fig_caption,
                                                           "",
                                                           "-implicit_figures")),
                            args = args),
    keep_md = keep_md,
    clean_supporting = self_contained,
    base_format = rmarkdown::html_document_base(smart = smart,
                                     self_contained = self_contained,
                                     mathjax = mathjax,
                                     pandoc_args = pandoc_args,
                                     # dependency_resolver = resolver,
                                     extra_dependencies = list(extra_dependencies),
                                     ...))
}
