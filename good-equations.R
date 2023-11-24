# include a specific formula, for example:
# my_formula <- list(
#   x = quote(runif(1, -1, 2) * x_i^2 - sin(y_i^2)),
#   y = quote(runif(1, -1, 2) * y_i^3 - cos(x_i^2) * y_i^4)
# )
# my_formula <- list(
#   y = quote(runif(1, -1, 4) * x_i^3 + cos(y_i^2)),
#   x = quote(runif(1, -1, 4) * y_i^7 + sin(y_i^6) * cos(x_i^9))
# )
# my_formula <- list(
#   # x = quote(runif(1, -1, 2) * x_i^2 - sin(y_i^2)),
#   y = quote(runif(1, -1, 20) * (y_i^3 + 3*y_i*(x_i^2) + (3*x_i*(y_i^2)) + x_i^3 )),
#   # y = quote(runif(1, -1, 2) * (  y_i^4 + (4*y_i*(x_i^3)) + (4*x_i*(y_i^3)) + (6*(x_i^2)*(y_i^2)) + x_i^4 )  )
#   # y = quote(runif(1, -1, 20) * sqrt(y_i^3 + x_i^3))
# )


# my_formula <- list(
#   y = quote(runif(1, -1, 2) * ( (((1+sqrt(5))/2)^y_i) / (sqrt(5))) + cos(x_i^6)* y_i^9 ),
#   x = quote(runif(1, -1, 2) * ((((1+sqrt(5))/2)^x_i) / (sqrt(5))) - sin(y_i^6)* x_i^9)
# )

# my_formula <- list(
#   y = quote(runif(1, -1, 2) * ( (((1+sqrt(5))/2)^x_i ) / (sqrt(5)) ) + sin(sqrt(x_i^3)) ),
#   x = quote(runif(1, -1, 2) * ((((1+sqrt(5))/2)^y_i) / (sqrt(5))) - sin(x_i^3))
# )

# For kidney plot ---------------------------------------------------------

# for (n in 1:10001) {
#   x[[n]] = (1+sqrt(n)/(n+1)) / sqrt(n) + sin(sqrt(n^3))
#   y[[n]] = (1+sqrt(n)/(n+1)) / sqrt(n) + cos(sqrt(n^3))
#   # z[[n]] = log(n)
# }
# x[[n]] = (sqrt((log(1/n^7))^2) + sin(sqrt(n^5)))
# y[[n]] = cos(log((1 + 1/n) * sin(n^9) + sqrt(n^8)))
# 
# my_formula <- list(
# y = quote(runif(1, -1, 2) * ( (((1+sqrt(5))/2)^x_i ) / (sqrt(5)) ) + sin(sqrt(y_i^7)) *y_i^3 ),
# x = quote(runif(1, -1, 2) * ((((1+sqrt(5))/2)^y_i) / (sqrt(5))) - sin(sqrt(y_i^3)))
# )