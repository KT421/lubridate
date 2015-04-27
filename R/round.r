#' Round date-times down.
#'
#' \code{floor_date} takes a date-time object and rounds it down to the nearest integer 
#' value of the specified time unit. Users can specify whether to round down to 
#' the nearest second, minute, hour, day, week, month, quarter, or year.
#'
#' By convention the boundary for a month is the first second of the month. Thus
#' \code{floor_date(ymd("2000-03-01"), "month")} gives "2000-03-01 UTC".
#' @export floor_date
#' @param x a vector of date-time objects 
#' @param unit a character string specifying the time unit to be rounded to. Should be one of 
#'   "second", "minute", "hour", "day", "week", "month", "quarter", or "year."
#' @return x with the appropriate units floored
#' @seealso \code{\link{ceiling_date}}, \code{\link{round_date}}
#' @keywords manip chron
#' @examples
#' x <- as.POSIXct("2009-08-03 12:01:59.23")
#' floor_date(x, "second")
#' # "2009-08-03 12:01:59 CDT"
#' floor_date(x, "minute")
#' # "2009-08-03 12:01:00 CDT"
#' floor_date(x, "hour")
#' # "2009-08-03 12:00:00 CDT"
#' floor_date(x, "day")
#' # "2009-08-03 CDT"
#' floor_date(x, "week")
#' # "2009-08-02 CDT"
#' floor_date(x, "month")
#' # "2009-08-01 CDT"
#' floor_date(x, "quarter")
#' # "2009-07-01 CDT"
#' floor_date(x, "year")
#' # "2009-01-01 CST"
floor_date <- function(x, unit = c("second", "minute", "hour", "day", "week", "month", "year", "quarter")) {
  unit <- match.arg(unit)
  
  new <- switch(unit,
    second = update(x, seconds = floor(second(x))),
    minute = update(x, seconds = 0),
    hour =   update(x, minutes = 0, seconds = 0),
    day =    update(x, hours = 0, minutes = 0, seconds = 0),
    week =   update(x, wdays = 1, hours = 0, minutes = 0, seconds = 0),
    month =  update(x, mdays = 1, hours = 0, minutes = 0, seconds = 0),
    quarter = update(x, months = ((month(x)-1)%/%3)*3+1, mdays = 1, hours = 0, minutes = 0, seconds = 0),
    year =   update(x, ydays = 1, hours = 0, minutes = 0, seconds = 0)
  )
  new
}


#' Round date-times up.
#'
#' \code{ceiling_date} takes a date-time object and rounds it up to the nearest
#' integer value of the specified time unit. Users can specify whether to round
#' up to the nearest second, minute, hour, day, week, month, quarter, or year.
#'
#' By convention, the boundary for a month is the first second of the next
#' month. Thus \code{ceiling_date(ymd("2000-03-01"), "month")} gives "2000-03-01 UTC".
#' @export ceiling_date
#' @param x a vector of date-time objects 
#' @param unit a character string specifying the time unit to be rounded to. Should be one of 
#'   "second", "minute", "hour", "day", "week", "month", "quarter", or "year."
#' @return x with the appropriate units rounded up
#' @seealso \code{\link{floor_date}}, \code{\link{round_date}}
#' @keywords manip chron
#' @examples
#' x <- as.POSIXct("2009-08-03 12:01:59.23")
#' ceiling_date(x, "second")
#' # "2009-08-03 12:02:00 CDT"
#' ceiling_date(x, "minute")
#' # "2009-08-03 12:02:00 CDT"
#' ceiling_date(x, "hour")
#' # "2009-08-03 13:00:00 CDT"
#' ceiling_date(x, "day")
#' # "2009-08-04 CDT"
#' ceiling_date(x, "week")
#' # "2009-08-09 CDT"
#' ceiling_date(x, "month")
#' # "2009-09-01 CDT"
#' ceiling_date(x, "quarter")
#' # "2009-10-01 CDT"
#' ceiling_date(x, "year")
#' # "2010-01-01 CST"
  
ceiling_date <- function(x, unit = c("second", "minute", "hour", "day", "week", "month", "year", "quarter")) {
	unit <- match.arg(unit)
	if(!length(x)) return(x)
  
  if (unit == "second") {
    second(x) <- ceiling(second(x))
    return(x)
  }
  
	y <- floor_date(x - dseconds(1), unit)
	
	switch(unit,
		minute = minute(y) <- minute(y) + 1,
		hour =   hour(y) <- hour(y) + 1,
		day =    yday(y) <- yday(y) + 1,
		week =   week(y) <- week(y) + 1,
		month =  month(y) <- month(y) + 1,
		quarter = month(y) <- month(y) + 3,
		year =   year(y) <- year(y) + 1
	)
	reclass_date(y, x)
}



#' Rounding for date-times.
#'
#' \code{round_date} takes a date-time object and rounds it to the nearest
#' integer value of the specified time unit. Users can specify whether to round
#' to the nearest second, minute, hour, day, week, month, quarter, or year.
#'
#' By convention, the boundary for a month is the first second of the next
#' month. Thus \code{round_date(ymd("2000-03-01"), "month")} gives "2000-03-01 UTC".
#' @export round_date
#' @param x a vector of date-time objects 
#' @param unit a character string specifying the time unit to be rounded to. Should be one of 
#'   "second", "minute", "hour", "day", "week", "month", "quarter", or "year."
#' @return x with the appropriate units rounded
#' @seealso \code{\link{floor_date}}, \code{\link{ceiling_date}}
#' @keywords manip chron
#' @examples
#' x <- as.POSIXct("2009-08-03 12:01:59.23")
#' round_date(x, "second")
#' # "2009-08-03 12:01:59 CDT"
#' round_date(x, "minute")
#' # "2009-08-03 12:02:00 CDT"
#' round_date(x, "hour")
#' # "2009-08-03 12:00:00 CDT"
#' round_date(x, "day")
#' # "2009-08-04 CDT"
#' round_date(x, "week")
#' # "2009-08-02 CDT"
#' round_date(x, "month")
#' # "2009-08-01 CDT"
#' round_date(x, "quarter")
#' # "2009-07-01 CDT"
#' round_date(x, "year")
#' # "2010-01-01 CST"
round_date <- function(x, unit = c("second", "minute", "hour", "day", "week", "month", "year", "quarter")) {

  if(!length(x)) return(x)
  
  unit <- match.arg(unit)
  
  above <- unclass(as.POSIXct(ceiling_date(x, unit)))
  mid <- unclass(as.POSIXct(x))
  below <- unclass(as.POSIXct(floor_date(x, unit)))

  wabove <- (above - mid) < (mid - below)
  new <- below
  new[wabove] <- above[wabove]
  new <- .POSIXct(new, tz = tz(x))
  
  reclass_date(new, x)
}


parse_unit_spec <- function(unitspec) {
  parts <- strsplit(unitspec, " ")[[1]]
  if (length(parts) == 1) {
    mult <- 1
    unit <- unitspec
  } else {
    mult <- as.numeric(parts[[1]])
    unit <- parts[[2]]
  }
  
  unit <- gsub("s$", "", unit)
  unit <- match.arg(unit, 
    c("second","minute","hour","day", "week", "month", "year"))
  
  list(unit = unit, mult = mult)
}
