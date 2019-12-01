FROM ubuntu:18.04

# Install prerequisite packages
RUN apt-get update \
 && apt-get install -yq --no-install-recommends \
      jupyter-notebook python3-pip python3-setuptools

# Install Python library
RUN pip3 install aliyun-python-sdk-core-v3 \
 && pip3 install oss2 \
 && pip3 install fileupload \
 && pip3 install ipywidgets \
 && pip3 install pandas \
 && pip3 install Pillow

# Enable Jupyter library
RUN jupyter nbextension install --py fileupload \
 && jupyter nbextension enable --py fileupload \
 && jupyter nbextension enable --py widgetsnbextension --sys-prefix

# User configuration
ARG USERNAME=jupyter
RUN useradd -m -s /bin/bash ${USERNAME}
USER ${USERNAME}

# Jupyter configuration
RUN jupyter notebook --generate-config \
 && mkdir -p /home/${USERNAME}/jupyter-working \
 && sed -i.back \
    -e "s:^#c.NotebookApp.token = .*$:c.NotebookApp.token = '':" \
    -e "s:^#c.NotebookApp.ip = .*$:c.NotebookApp.ip = '0.0.0.0':" \
    -e "s:^#c.NotebookApp.open_browser = .*$:c.NotebookApp.open_browser = False:" \
    -e "s:^#c.NotebookApp.password = .*$:c.NotebookApp.password = 'alieaters':" \
    -e "s:^#c.NotebookApp.notebook_dir = .*$:c.NotebookApp.notebook_dir = '/home/${USERNAME}/jupyter-working':" \
    /home/${USERNAME}/.jupyter/jupyter_notebook_config.py

# Expose container ports
EXPOSE 8888

# Boot process
CMD jupyter notebook --port 8888 --ip=0.0.0.0 --allow-root --NotebookApp.token=''
