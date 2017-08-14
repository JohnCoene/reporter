#' fabric report
#'
#' @inheritParams rmarkdown::html_document
#'
#' @param center whether to center text horizontally and vertically.
#' @param background background colors, see details.
#' @param navigation whether to show navigation bar as small circles.
#' @param continuousVertical defines whether scrolling down in the last section or should scroll d
#'   own to the first one and if scrolling up in the first section should scroll up to the last one.
#' @param continuousHorizontal defines whether sliding right in the last slide should slide right
#'   to the first one or not, and if scrolling left in the first slide should slide left to the last one or not.
#' @param navigationPosition defines which position the navigation bar will be shown (if using one).
#'   defaults to \code{none}, also takes \code{left}, \code{right}.
#' @param slidesNavigation if set to \code{TRUE} it will show a navigation bar made up of small
#'   circles for each landscape slider on the site.
#' @param ... additional parameters to pass to \code{html_document_base}.
#'
#' @export
fullpage_document <- function(
                              toc = FALSE,
                              center = TRUE,
                              background = NULL,
                              navigation = FALSE,
                              continuousVertical = TRUE,
                              continuousHorizontal = TRUE,
                              navigationPosition = "none",
                              slidesNavigation = FALSE,
                              fig_width = 6.5,
                              fig_height = 4,
                              fig_retina = if (!fig_caption) 2,
                              fig_caption = FALSE,
                              keep_md = FALSE,
                              smart = TRUE,
                              self_contained = TRUE,
                              pandoc_args = NULL,
                              highlight = "default",
                              mathjax = "default",
                              includes = NULL,
                              css = NULL,
                              extra_dependencies = NULL,
                              ...) {

  if(!navigationPosition %in% c("left", "right", "none")) stop("wrong nevigation position")

  add_graphic <- function(name, graphic) {
    if (!is.null(graphic)) {
      graphic_path <- rmarkdown::pandoc_path_arg(graphic)
      args <<- c(args, rmarkdown::pandoc_variable_arg(name, graphic_path))
    }
  }

  add_multiple <- function(name, x){
    sapply(x, function(x, y){
      args <<- c(args, rmarkdown::pandoc_variable_arg(y, x))
    }, name)
  }

  js_bool <- function(x) ifelse(isTRUE(x), "true", "false")

  # arguments
  args <- c()
  if(!is.null(background)) add_multiple("background", background) # bg

  # header and footer
  args <- c(args, rmarkdown::includes_to_pandoc_args(includes))

  # toc
  args <- c(args, rmarkdown::pandoc_toc_args(toc = toc, toc_depth = 1)) # toc
  args <- c(args, rmarkdown::pandoc_variable_arg("navigation", js_bool(navigation))) # navigation
  args <- c(args, rmarkdown::pandoc_variable_arg("navigationPosition", navigationPosition)) # position
  args <- c(args, rmarkdown::pandoc_variable_arg("slidesNavigation", js_bool(slidesNavigation))) # slide nav
  args <- c(args, rmarkdown::pandoc_variable_arg("center", js_bool(center))) # center
  args <- c(args, rmarkdown::pandoc_variable_arg("continuousVertical", js_bool(continuousVertical))) # vert
  args <- c(args, rmarkdown::pandoc_variable_arg("continuousHorizontal", js_bool(continuousHorizontal))) # vert

  # template
  default_template <- system.file(
    "rmarkdown/templates/fullpage/resources/default.html",
    package = "reporter"
  )

  args <- c(args, "--template", rmarkdown::pandoc_path_arg(default_template))

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

  for (css_file in css)
    args <- c(args, "--css", rmarkdown::pandoc_path_arg(css_file))

  # highlight
  args <- c(args, rmarkdown::pandoc_highlight_args(highlight, default = "pygments"))

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
                                                extra_dependencies = extra_dependencies,
                                                ...))
}
