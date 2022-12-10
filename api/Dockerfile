FROM rstudio/plumber

LABEL maintainer="Diana"

RUN apt update -qq \
     && apt install --yes --no-install-recommends \
            r-cran-plumber

# create the application folder
RUN mkdir -p ~/app

# copy everything from the current directory into the container
COPY "/" "app/"
WORKDIR "app/" 

# open port 80 to traffic
EXPOSE 8000

# install plumber
RUN R -e "install.packages(c('plumber', 'data.table', 'tidyverse', 'jsonlite', 'lubridate'))"

ENTRYPOINT ["Rscript", "-e", \
     "pr <- plumber::plumb('/app/app.R'); pr$run(host='0.0.0.0', port=8000)"]

# when the container starts, start the server.R script
# ENTRYPOINT ["Rscript", "server.R"]