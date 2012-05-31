#
# Makes table headers scroll until they reach the top, then stick there when scrolled further. Once the table
# scrolls out of view completely, the header scrolls out of view, too.
# Adapted from https://bitbucket.org/cmcqueen1975/htmlfloatingtableheader/wiki/Home
#
# Can be applied to all <table> tags. Will make the complete header stick.

$ = jQuery

stickyHeaders = {}

# prepare a cloned header to be positioned once scrolling starts
stickyHeaders._create = () ->
  @element.wrap("<div class=\"divTableWithFloatingHeader\" style=\"position:relative\"></div>");

  originalHeader = $("thead", @element)
  clonedHeader = originalHeader.clone();
  originalHeader.before(clonedHeader)

  clonedHeader.addClass("tableFloatingHeader");
  clonedHeader.css(
    position: "fixed",
    top: "0px",
    left : @element.offset().left,
    visibility: "hidden"
  )

  originalHeader.addClass("tableFloatingHeaderOriginal");

  @_updateHeaders()
  $(window).scroll => do @_updateHeaders
  $(window).resize => do @_updateHeaders

# show cloned header if necessary and position it
stickyHeaders._updateHeaders = () ->
  $("div.divTableWithFloatingHeader").each () ->
    originalHeaderRow = $(".tableFloatingHeaderOriginal", this);
    floatingHeaderRow = $(".tableFloatingHeader", this);
    offset = $(this).offset();
    scrollTop = $(window).scrollTop()

    if ((scrollTop > offset.top) && (scrollTop < offset.top + $(this).height()))

      # show cloned header at top of screen
      floatingHeaderRow.css("visibility", "visible")
      #floatingHeaderRow.css(
      #  "top",
      #  Math.min(scrollTop - offset.top,
      #  $(this).height() - floatingHeaderRow.height()) + "px"
      #);

      # copy cell widths from original header
      $("th", floatingHeaderRow).each (index) ->
        cellWidth = $("th", originalHeaderRow).eq(index).css('width')
        $(this).css('width', cellWidth)

      # copy row width from whole table
      floatingHeaderRow.css("width", $(this).css("width"))
    else
      floatingHeaderRow.css("visibility", "hidden");
      floatingHeaderRow.css("top", "0px");

# export our widget and bridge it to the un-namespaced method
$.widget('bk.stickyheaders', stickyHeaders)
$.widget.bridge('stickyheaders', $.bk.stickyheaders)