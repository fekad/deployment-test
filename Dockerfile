FROM jupyter/tensorflow-notebook:eb149a8c333a
LABEL maintainer="Adam Fekete <adam.fekete@kcl.ac.uk>"

RUN pip install --quiet \
    ase \
    git+https://github.com/raghakot/keras-vis.git \
    # Install facets which does not have a pip or conda package at the moment
 && git clone --depth 1 https://github.com/PAIR-code/facets.git /tmp/facets \
 && jupyter nbextension install /tmp/facets/facets-dist/ --sys-prefix \
 && rm -rf /tmp/facets \
 && fix-permissions $CONDA_DIR  \
 && fix-permissions /home/$NB_USER

# Switch back to jovyan to avoid accidental container runs as root
USER $NB_UID