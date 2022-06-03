# How to deploy mljar/mercury app inside a conda env, inside a container

FROM continuumio/miniconda3

## PARAMETERS ---------------------

ARG port_mercury=8000
ARG local_path_nb=./notebooks
ARG env_name=myenv

ENV docker_path_nb= /app/notebooks/




## IMPORT ---------------

### Make sure the container expose port where mercury is deploy:
EXPOSE ${port_mercury}

### Copy the content of the ${local_path_nb} to the image:
COPY ${path_nb} ${docker_path_nb}
WORKDIR /app/mercury

### Copy the entrypoint shell file in the WORKDIR
COPY ./entrypoint.sh .




## BUILD ---------------

### Add conda-forge channel to upload and install mljar/mercury:
RUN conda config --add channels conda-forge && \
	conda create --name ${env_name} python==3.7.1 mljar-mercury

### Make RUN commands use the new environment ${env_name}:
SHELL ["conda", "run", "-n", ${env_name}, "/bin/bash", "-c"]

### Run the mljar-mercury server when container is started:
ENTRYPOINT ["conda", "run", "--no-capture-output", "-n", "/bin/bash", "./entrypoint.sh"]