#' fabric report
#'
#' @param toc whether to render table of content.
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
#' @param ... additional parameters to pass to \code{html_document_base}.
#'
#' @export
fullpage_document <- function(
                              toc = FALSE,
                              centered = TRUE,
                              background = NULL,
                              navigation = FALSE,
                              navigationPosition = "right",
                              slidesNavigation = FALSE,
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
                              ...) {

  add_graphic <- function(name, graphic) {
    if (!is.null(graphic)) {
      graphic_path <- rmarkdown::pandoc_path_arg(graphic)
      args <<- c(args, rmarkdown::pandoc_variable_arg(name, graphic_path))
    }
  }

  add_multiple <- function(name, x){
    sapply(background, function(x, y){
      args <<- c(args, rmarkdown::pandoc_variable_arg(y, x))
    }, name)
  }

  js_bool <- function(x) ifelse(isTRUE(x), "true", "false")

  # arguments
  args <- c()
  if(!is.null(background)) add_multiple("background", background) # bg

  # toc
  args <- c(args, rmarkdown::pandoc_toc_args(toc = toc, toc_depth = 1)) # toc
  args <- c(args, rmarkdown::pandoc_variable_arg("navigation", js_bool(navigation))) # navigation
  args <- c(args, rmarkdown::pandoc_variable_arg("navigationPosition", navigationPosition)) # position
  args <- c(args, rmarkdown::pandoc_variable_arg("slidesNavigation", js_bool(slidesNavigation))) # slide nav
  args <- c(args, rmarkdown::pandoc_variable_arg("centered", js_bool(centered))) # slide nav

  # template
  default_template <- system.file(
    "rmarkdown/templates/fullpage/resources/default.html",
    package = "reporter"
  )

  args <- c(args, "--template", rmarkdown::pandoc_path_arg(default_template))
  args <- c(args, rmarkdown::pandoc_highlight_args(highlight, default = "pygments"))

  # fullpage css - js
  fp_src <- system.file("fullPage-2.9.4", package = "reporter")
  fp_path <- rmarkdown::pandoc_path_arg(fp_src)
  args <- c(args, "--variable", paste0("fullpage-url=", fp_path))

  # jQuery
  jq_src <- system.file("jQuery-1.11.1", package = "reporter")
  jq_path <- rmarkdown::pandoc_path_arg(jq_src)
  args <- c(args, "--variable", paste0("jquery-url=", jq_path))

  # custom
  cust_src <- system.file("rmarkdown/templates/fullpage/resources", package = "reporter")
  cust_path <- rmarkdown::pandoc_path_arg(cust_src)
  args <- c(args, "--variable", paste0("custom-url=", cust_path))

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
                                                ...))
}
